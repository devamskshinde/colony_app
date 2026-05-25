import '../../../core/constants/api_constants.dart';
import '../../../core/network/api_client.dart';
import '../../../core/errors/app_exceptions.dart';

/// Auth API Service — all auth-related network calls
class AuthApiService {
  final ApiClient _apiClient;

  AuthApiService(this._apiClient);

  /// Send OTP to phone number
  Future<SendOtpResponse> sendOtp(String phone) async {
    try {
      final response = await _apiClient.post(
        ApiConstants.sendOtp,
        data: {'phone': phone},
      );
      return SendOtpResponse.fromJson(response.data as Map<String, dynamic>);
    } on AppException {
      rethrow;
    }
  }

  /// Verify OTP and get tokens
  Future<VerifyOtpResponse> verifyOtp({
    required String phone,
    required String otp,
    required String otpId,
  }) async {
    try {
      final response = await _apiClient.post(
        ApiConstants.verifyOtp,
        data: {'phone': phone, 'otp': otp, 'otpId': otpId},
      );
      return VerifyOtpResponse.fromJson(response.data as Map<String, dynamic>);
    } on AppException {
      rethrow;
    }
  }

  /// Setup profile for new users
  Future<SetupProfileResponse> setupProfile({
    required String displayName,
    required String dateOfBirth,
    required String gender,
    String? bio,
    List<String>? interests,
    String? avatarUrl,
  }) async {
    try {
      final response = await _apiClient.post(
        '/auth/setup-profile',
        data: {
          'displayName': displayName,
          'dateOfBirth': dateOfBirth,
          'gender': gender,
          if (bio != null) 'bio': bio,
          if (interests != null) 'interests': interests,
          if (avatarUrl != null) 'avatarUrl': avatarUrl,
        },
      );
      return SetupProfileResponse.fromJson(response.data as Map<String, dynamic>);
    } on AppException {
      rethrow;
    }
  }

  /// Refresh access token
  Future<TokenResponse> refreshToken(String refreshToken) async {
    try {
      final response = await _apiClient.post(
        ApiConstants.refreshToken,
        data: {'refreshToken': refreshToken},
      );
      return TokenResponse.fromJson(response.data as Map<String, dynamic>);
    } on AppException {
      rethrow;
    }
  }

  /// Logout
  Future<void> logout() async {
    try {
      await _apiClient.post(ApiConstants.logout);
    } catch (_) {
      // Logout should always succeed locally even if server fails
    }
  }

  /// Login with email + password
  Future<VerifyOtpResponse> loginEmail({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _apiClient.post(
        '/auth/login-email',
        data: {'email': email, 'password': password},
      );
      return VerifyOtpResponse.fromJson(response.data as Map<String, dynamic>);
    } on AppException {
      rethrow;
    }
  }

  /// Register with email + password
  Future<VerifyOtpResponse> registerEmail({
    required String email,
    required String password,
    required String displayName,
  }) async {
    try {
      final response = await _apiClient.post(
        '/auth/register-email',
        data: {
          'email': email,
          'password': password,
          'displayName': displayName,
        },
      );
      return VerifyOtpResponse.fromJson(response.data as Map<String, dynamic>);
    } on AppException {
      rethrow;
    }
  }
}

// ─── Response Models ────────────────────────────────────────────

class SendOtpResponse {
  final bool success;
  final String otpId;
  final int cooldownSeconds;

  SendOtpResponse({
    required this.success,
    required this.otpId,
    this.cooldownSeconds = 60,
  });

  factory SendOtpResponse.fromJson(Map<String, dynamic> json) {
    return SendOtpResponse(
      success: json['success'] as bool? ?? false,
      otpId: json['otpId'] as String? ?? '',
      cooldownSeconds: json['cooldownSeconds'] as int? ?? 60,
    );
  }
}

class VerifyOtpResponse {
  final bool success;
  final bool isNewUser;
  final String? accessToken;
  final String? refreshToken;
  final Map<String, dynamic>? user;

  VerifyOtpResponse({
    required this.success,
    required this.isNewUser,
    this.accessToken,
    this.refreshToken,
    this.user,
  });

  factory VerifyOtpResponse.fromJson(Map<String, dynamic> json) {
    return VerifyOtpResponse(
      success: json['success'] as bool? ?? false,
      isNewUser: json['isNewUser'] as bool? ?? false,
      accessToken: json['accessToken'] as String?,
      refreshToken: json['refreshToken'] as String?,
      user: json['user'] as Map<String, dynamic>?,
    );
  }
}

class SetupProfileResponse {
  final bool success;
  final String? accessToken;
  final String? refreshToken;
  final Map<String, dynamic>? user;

  SetupProfileResponse({
    required this.success,
    this.accessToken,
    this.refreshToken,
    this.user,
  });

  factory SetupProfileResponse.fromJson(Map<String, dynamic> json) {
    return SetupProfileResponse(
      success: json['success'] as bool? ?? false,
      accessToken: json['accessToken'] as String?,
      refreshToken: json['refreshToken'] as String?,
      user: json['user'] as Map<String, dynamic>?,
    );
  }
}

class TokenResponse {
  final String accessToken;
  final String? refreshToken;

  TokenResponse({required this.accessToken, this.refreshToken});

  factory TokenResponse.fromJson(Map<String, dynamic> json) {
    return TokenResponse(
      accessToken: json['accessToken'] as String? ?? '',
      refreshToken: json['refreshToken'] as String?,
    );
  }
}
