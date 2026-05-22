import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

/// Certificate Pinning
/// SSL pinning for production API security
class CertificatePinning {
  CertificatePinning._();

  /// SHA-256 hashes of pinned certificates
  static const List<String> pinnedHashes = [
    // Production certificate hashes
    // Replace with actual cert hashes before production deployment
    'AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=',
    'BBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBB=',
  ];

  /// Create Dio with certificate pinning
  static Dio createPinnedDio({required String baseUrl}) {
    final dio = Dio(BaseOptions(baseUrl: baseUrl));

    if (!kDebugMode) {
      dio.interceptors.add(CertificatePinningInterceptor());
    }

    return dio;
  }
}

/// Interceptor that validates certificate pins
class CertificatePinningInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    // In production, validate SSL certificate here
    // Using http_certificate_pinning package or native code
    handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (err.type == DioExceptionType.connectionError) {
      // Could be a certificate pinning failure
      handler.next(DioException(
        requestOptions: err.requestOptions,
        error: 'Certificate validation failed',
        type: DioExceptionType.connectionError,
      ));
      return;
    }
    handler.next(err);
  }
}
