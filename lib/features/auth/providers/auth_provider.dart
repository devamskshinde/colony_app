import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/errors/app_exceptions.dart';
import '../../../core/security/secure_storage.dart';
import '../../../core/constants/storage_keys.dart';
import '../../../shared/providers/app_providers.dart';
import '../../../services/analytics_service.dart';
import '../services/auth_api_service.dart';

// ─── Auth API Service Provider ──────────────────────────────────
final authApiServiceProvider = Provider<AuthApiService>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return AuthApiService(apiClient);
});

// ─── Auth State ─────────────────────────────────────────────────
enum AuthStatus { initial, loading, authenticated, unauthenticated, error, otpSent, needsProfile }

class AuthState {
  final AuthStatus status;
  final String? errorMessage;
  final String? phone;
  final String? otpId;
  final int cooldownSeconds;
  final Map<String, dynamic>? user;
  final bool isLoading;

  const AuthState({
    this.status = AuthStatus.initial,
    this.errorMessage,
    this.phone,
    this.otpId,
    this.cooldownSeconds = 0,
    this.user,
    this.isLoading = false,
  });

  AuthState copyWith({
    AuthStatus? status,
    String? errorMessage,
    String? phone,
    String? otpId,
    int? cooldownSeconds,
    Map<String, dynamic>? user,
    bool? isLoading,
  }) {
    return AuthState(
      status: status ?? this.status,
      errorMessage: errorMessage,
      phone: phone ?? this.phone,
      otpId: otpId ?? this.otpId,
      cooldownSeconds: cooldownSeconds ?? this.cooldownSeconds,
      user: user ?? this.user,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

// ─── Auth Notifier ──────────────────────────────────────────────
class AuthNotifier extends Notifier<AuthState> {
  @override
  AuthState build() => const AuthState();

  SecureStorage get _storage => ref.read(secureStorageProvider);
  AuthApiService get _api => ref.read(authApiServiceProvider);

  /// Check if user has valid session (for splash screen)
  Future<void> checkSession() async {
    final refreshToken = await _storage.read(StorageKeys.refreshToken);
    if (refreshToken == null) {
      state = state.copyWith(status: AuthStatus.unauthenticated);
      return;
    }

    try {
      final response = await _api.refreshToken(refreshToken);
      await _storage.saveTokens(
        accessToken: response.accessToken,
        refreshToken: response.refreshToken ?? refreshToken,
      );
      final userId = await _storage.getUserId();
      state = state.copyWith(
        status: AuthStatus.authenticated,
        user: {'id': userId},
      );
      AnalyticsService.trackEvent('session_restored');
    } catch (e) {
      await _storage.clearTokens();
      state = state.copyWith(status: AuthStatus.unauthenticated);
    }
  }

  /// Send OTP to phone number
  Future<void> sendOtp(String phone) async {
    state = state.copyWith(isLoading: true, errorMessage: null, phone: phone);
    AnalyticsService.trackEvent('otp_send_attempt', properties: {'phone': phone});

    try {
      final response = await _api.sendOtp(phone);
      state = state.copyWith(
        isLoading: false,
        status: AuthStatus.otpSent,
        otpId: response.otpId,
        cooldownSeconds: response.cooldownSeconds,
      );
      AnalyticsService.trackEvent('otp_sent');
    } on AppException catch (e) {
      state = state.copyWith(
        isLoading: false,
        status: AuthStatus.error,
        errorMessage: e.message,
      );
      AnalyticsService.trackError('otp_send_failed', properties: {'error': e.message});
    }
  }

  /// Verify OTP
  Future<void> verifyOtp(String otp) async {
    if (state.phone == null || state.otpId == null) return;

    state = state.copyWith(isLoading: true, errorMessage: null);
    AnalyticsService.trackEvent('otp_verify_attempt');

    try {
      final response = await _api.verifyOtp(
        phone: state.phone!,
        otp: otp,
        otpId: state.otpId!,
      );

      if (response.accessToken != null) {
        await _storage.saveTokens(
          accessToken: response.accessToken!,
          refreshToken: response.refreshToken ?? '',
        );
      }

      if (response.isNewUser) {
        state = state.copyWith(
          isLoading: false,
          status: AuthStatus.needsProfile,
          user: response.user,
        );
        AnalyticsService.trackEvent('otp_verified_new_user');
      } else {
        if (response.user != null && response.user!['id'] != null) {
          await _storage.saveUserId(response.user!['id'] as String);
        }
        state = state.copyWith(
          isLoading: false,
          status: AuthStatus.authenticated,
          user: response.user,
        );
        ref.read(isLoggedInProvider.notifier).setLoggedIn(true);
        if (response.user?['id'] != null) {
          ref.read(currentUserIdProvider.notifier).setUserId(response.user!['id'] as String);
        }
        AnalyticsService.trackEvent('otp_verified_existing_user');
      }
    } on AppException catch (e) {
      state = state.copyWith(
        isLoading: false,
        status: AuthStatus.error,
        errorMessage: e.message,
      );
      AnalyticsService.trackError('otp_verify_failed', properties: {'error': e.message});
    }
  }

  /// Setup profile for new users
  Future<void> setupProfile({
    required String displayName,
    required String dateOfBirth,
    required String gender,
    String? bio,
    List<String>? interests,
    String? avatarUrl,
  }) async {
    state = state.copyWith(isLoading: true, errorMessage: null);

    try {
      final response = await _api.setupProfile(
        displayName: displayName,
        dateOfBirth: dateOfBirth,
        gender: gender,
        bio: bio,
        interests: interests,
        avatarUrl: avatarUrl,
      );

      if (response.accessToken != null) {
        await _storage.saveTokens(
          accessToken: response.accessToken!,
          refreshToken: response.refreshToken ?? '',
        );
      }

      if (response.user != null && response.user!['id'] != null) {
        await _storage.saveUserId(response.user!['id'] as String);
      }

      state = state.copyWith(
        isLoading: false,
        status: AuthStatus.authenticated,
        user: response.user,
      );
      ref.read(isLoggedInProvider.notifier).setLoggedIn(true);
      AnalyticsService.trackEvent('profile_setup_complete');
    } on AppException catch (e) {
      state = state.copyWith(
        isLoading: false,
        status: AuthStatus.error,
        errorMessage: e.message,
      );
    }
  }

  /// Logout
  Future<void> logout() async {
    await _api.logout();
    await _storage.clearTokens();
    state = const AuthState(status: AuthStatus.unauthenticated);
    ref.read(isLoggedInProvider.notifier).setLoggedIn(false);
    ref.read(currentUserIdProvider.notifier).setUserId(null);
    AnalyticsService.trackEvent('logout');
  }

  /// Resend OTP
  Future<void> resendOtp() async {
    if (state.phone != null) {
      await sendOtp(state.phone!);
    }
  }

  /// Clear error
  void clearError() {
    state = state.copyWith(errorMessage: null);
  }

  /// Set cooldown
  void setCooldown(int seconds) {
    state = state.copyWith(cooldownSeconds: seconds);
  }

  /// Reset to phone entry
  void resetToPhone() {
    state = const AuthState();
  }
}

// ─── Auth Provider ──────────────────────────────────────────────
final authProvider = NotifierProvider<AuthNotifier, AuthState>(AuthNotifier.new);
