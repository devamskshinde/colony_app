import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:dio/dio.dart';
import '../../constants/api_constants.dart';

/// Security Interceptor
/// Adds HMAC signature to every request for server verification
class SecurityInterceptor extends Interceptor {
  // In production, this would come from secure storage
  static const String _signingKey = 'colony_signing_key_placeholder';

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    final timestamp = options.headers[ApiConstants.timestampHeader] ??
        DateTime.now().millisecondsSinceEpoch.toString();

    // Build signature payload: method + path + timestamp + body hash
    final method = options.method.toUpperCase();
    final path = options.uri.path;
    final bodyHash = _hashBody(options.data);

    final payload = '$method$path$timestamp$bodyHash';
    final signature = _hmacSign(payload);

    options.headers[ApiConstants.signatureHeader] = signature;
    options.headers[ApiConstants.timestampHeader] = timestamp;

    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    // Verify response signature if present
    final serverSignature = response.headers.value('X-Response-Signature');
    if (serverSignature != null) {
      // In production, verify the signature
      // For now, we trust the response
    }
    handler.next(response);
  }

  String _hmacSign(String payload) {
    final key = utf8.encode(_signingKey);
    final bytes = utf8.encode(payload);
    final hmac = Hmac(sha256, key);
    final digest = hmac.convert(bytes);
    return digest.toString();
  }

  String _hashBody(dynamic data) {
    if (data == null) return '';
    try {
      final bodyStr = data is String ? data : jsonEncode(data);
      return sha256.convert(utf8.encode(bodyStr)).toString().substring(0, 16);
    } catch (_) {
      return '';
    }
  }
}
