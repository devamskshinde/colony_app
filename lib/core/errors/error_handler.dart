import 'package:dio/dio.dart';
import 'app_exceptions.dart';

/// Global Error Handler
/// Converts raw errors into AppExceptions
class ErrorHandler {
  ErrorHandler._();

  static AppException handle(dynamic error) {
    if (error is AppException) return error;

    if (error is DioException) return _handleDioError(error);

    return AppException(
      message: error.toString(),
      originalError: error,
    );
  }

  static AppException _handleDioError(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return const TimeoutException();

      case DioExceptionType.connectionError:
        return const NetworkException();

      case DioExceptionType.badResponse:
        return _handleResponseError(error.response);

      case DioExceptionType.cancel:
        return const AppException(
          message: 'Request cancelled',
          code: 'CANCELLED',
        );

      default:
        return AppException(
          message: error.message ?? 'Unknown error',
          originalError: error,
        );
    }
  }

  static AppException _handleResponseError(Response? response) {
    if (response == null) {
      return const ServerException(statusCode: 0, message: 'No response');
    }

    switch (response.statusCode) {
      case 400:
        return _parseValidationErrors(response);
      case 401:
        return const TokenExpiredException();
      case 403:
        return const AuthException(message: 'Access denied');
      case 404:
        return const ServerException(
          statusCode: 404,
          message: 'Resource not found',
        );
      case 409:
        return const ServerException(
          statusCode: 409,
          message: 'Conflict',
        );
      case 429:
        return const RateLimitException();
      case 500:
      case 502:
      case 503:
        return ServerException(
          statusCode: response.statusCode!,
          message: 'Server error, please try again',
        );
      default:
        return ServerException(
          statusCode: response.statusCode!,
          message: response.statusMessage ?? 'Server error',
        );
    }
  }

  static AppException _parseValidationErrors(Response response) {
    try {
      final data = response.data;
      if (data is Map<String, dynamic> && data.containsKey('errors')) {
        final errors = Map<String, String>.from(
          (data['errors'] as Map).map((k, v) => MapEntry(k.toString(), v.toString())),
        );
        return ValidationException(
          message: data['message'] ?? 'Validation failed',
          fieldErrors: errors,
        );
      }
      return ValidationException(
        message: data['message'] ?? 'Invalid request',
      );
    } catch (_) {
      return const ValidationException();
    }
  }

  /// User-friendly error message
  static String userMessage(AppException exception) {
    switch (exception) {
      case NetworkException():
        return 'No internet connection. Showing cached content.';
      case TimeoutException():
        return 'Request timed out. Please try again.';
      case TokenExpiredException():
        return 'Session expired. Please login again.';
      case AuthException():
        return 'Authentication error. Please login again.';
      case ServerException():
        return 'Something went wrong. Please try again.';
      case ValidationException():
        return exception.message;
      case LocationException():
        return 'Location access needed for nearby features.';
      case FeatureDisabledException():
        return 'This feature is currently unavailable.';
      case RateLimitException():
        return 'Too many requests. Please wait a moment.';
      case CacheException():
        return 'Unable to load cached data.';
      default:
        return 'Something went wrong. Please try again.';
    }
  }
}
