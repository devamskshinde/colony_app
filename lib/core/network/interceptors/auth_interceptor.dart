import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../constants/storage_keys.dart';
import '../../constants/api_constants.dart';

/// Auth Interceptor
/// Attaches JWT tokens and handles refresh on 401
class AuthInterceptor extends Interceptor {
  final FlutterSecureStorage _storage = const FlutterSecureStorage();
  bool _isRefreshing = false;
  final List<_PendingRequest> _pendingRequests = [];

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final token = await _storage.read(key: StorageKeys.accessToken);
    if (token != null && token.isNotEmpty) {
      options.headers[ApiConstants.authHeader] = 'Bearer $token';
    }

    // Add timestamp for security
    options.headers[ApiConstants.timestampHeader] =
        DateTime.now().millisecondsSinceEpoch.toString();

    handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    // Only attempt token refresh if the original request had an auth header
    // (unauthenticated endpoints like send-otp should never trigger refresh)
    final hadAuthHeader = err.requestOptions.headers[ApiConstants.authHeader] != null;

    if (err.response?.statusCode == 401 && hadAuthHeader) {
      if (!_isRefreshing) {
        _isRefreshing = true;
        try {
          final newToken = await _refreshToken();
          if (newToken != null) {
            // Retry original request
            final opts = err.requestOptions;
            opts.headers[ApiConstants.authHeader] = 'Bearer $newToken';
            final response = await Dio().fetch(opts);

            // Retry pending requests
            for (final pending in _pendingRequests) {
              pending.requestOptions.headers[ApiConstants.authHeader] =
                  'Bearer $newToken';
              final pendingResponse = await Dio().fetch(pending.requestOptions);
              pending.handler.resolve(pendingResponse);
            }
            _pendingRequests.clear();

            handler.resolve(response);
            return;
          }
        } catch (_) {
          // Refresh failed — clear tokens
          await _clearTokens();
        } finally {
          _isRefreshing = false;
        }
      } else {
        // Queue request while refreshing
        _pendingRequests.add(_PendingRequest(
          requestOptions: err.requestOptions,
          handler: handler,
        ));
        return;
      }
    }
    handler.next(err);
  }

  Future<String?> _refreshToken() async {
    final refreshToken = await _storage.read(key: StorageKeys.refreshToken);
    if (refreshToken == null) return null;

    try {
      final dio = Dio();
      final response = await dio.post(
        '${ApiConstants.baseUrl}${ApiConstants.refreshToken}',
        data: {'refresh_token': refreshToken},
      );

      if (response.statusCode == 200) {
        final newAccess = response.data['access_token'];
        final newRefresh = response.data['refresh_token'];

        await _storage.write(key: StorageKeys.accessToken, value: newAccess);
        if (newRefresh != null) {
          await _storage.write(key: StorageKeys.refreshToken, value: newRefresh);
        }
        return newAccess;
      }
    } catch (_) {}
    return null;
  }

  Future<void> _clearTokens() async {
    await _storage.delete(key: StorageKeys.accessToken);
    await _storage.delete(key: StorageKeys.refreshToken);
    await _storage.delete(key: StorageKeys.isLoggedIn);
  }
}

class _PendingRequest {
  final RequestOptions requestOptions;
  final ErrorInterceptorHandler handler;

  _PendingRequest({
    required this.requestOptions,
    required this.handler,
  });
}
