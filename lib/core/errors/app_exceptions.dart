/// Colony App Exceptions
/// Custom exception hierarchy for clean error handling
class AppException implements Exception {
  final String message;
  final String? code;
  final dynamic originalError;

  const AppException({
    required this.message,
    this.code,
    this.originalError,
  });

  @override
  String toString() => 'AppException: $message${code != null ? ' ($code)' : ''}';
}

/// Network-related exceptions
class NetworkException extends AppException {
  const NetworkException({
    super.message = 'No internet connection',
    super.code = 'NETWORK_ERROR',
    super.originalError,
  });
}

/// Server errors (4xx, 5xx)
class ServerException extends AppException {
  final int statusCode;

  const ServerException({
    required this.statusCode,
    super.message = 'Server error occurred',
    super.code = 'SERVER_ERROR',
    super.originalError,
  });
}

/// Authentication errors
class AuthException extends AppException {
  const AuthException({
    super.message = 'Authentication failed',
    super.code = 'AUTH_ERROR',
    super.originalError,
  });
}

/// Token expired
class TokenExpiredException extends AppException {
  const TokenExpiredException({
    super.message = 'Session expired, please login again',
    super.code = 'TOKEN_EXPIRED',
    super.originalError,
  });
}

/// Validation errors
class ValidationException extends AppException {
  final Map<String, String>? fieldErrors;

  const ValidationException({
    super.message = 'Validation failed',
    super.code = 'VALIDATION_ERROR',
    this.fieldErrors,
    super.originalError,
  });
}

/// Cache / storage errors
class CacheException extends AppException {
  const CacheException({
    super.message = 'Cache error',
    super.code = 'CACHE_ERROR',
    super.originalError,
  });
}

/// Location errors
class LocationException extends AppException {
  const LocationException({
    super.message = 'Location access denied',
    super.code = 'LOCATION_ERROR',
    super.originalError,
  });
}

/// Timeout errors
class TimeoutException extends AppException {
  const TimeoutException({
    super.message = 'Request timed out',
    super.code = 'TIMEOUT',
    super.originalError,
  });
}

/// Feature disabled
class FeatureDisabledException extends AppException {
  const FeatureDisabledException({
    super.message = 'This feature is currently unavailable',
    super.code = 'FEATURE_DISABLED',
    super.originalError,
  });
}

/// Rate limited
class RateLimitException extends AppException {
  const RateLimitException({
    super.message = 'Too many requests, please try again later',
    super.code = 'RATE_LIMITED',
    super.originalError,
  });
}
