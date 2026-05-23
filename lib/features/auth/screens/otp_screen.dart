import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../services/analytics_service.dart';
import '../providers/auth_provider.dart';

/// OTP Verification Screen — 6 individual input boxes with timer
class OtpScreen extends ConsumerStatefulWidget {
  const OtpScreen({super.key});

  @override
  ConsumerState<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends ConsumerState<OtpScreen>
    with TickerProviderStateMixin {
  final List<TextEditingController> _controllers =
      List.generate(6, (_) => TextEditingController());
  final List<FocusNode> _focusNodes =
      List.generate(6, (_) => FocusNode());
  late AnimationController _shakeController;
  late AnimationController _successController;
  Timer? _timer;
  int _secondsRemaining = 60;
  bool _hasError = false;
  bool _isSuccess = false;

  @override
  void initState() {
    super.initState();
    AnalyticsService.trackScreen('auth_otp');
    _shakeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _successController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _startTimer();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusNodes[0].requestFocus();
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _shakeController.dispose();
    _successController.dispose();
    for (final c in _controllers) {
      c.dispose();
    }
    for (final f in _focusNodes) {
      f.dispose();
    }
    super.dispose();
  }

  void _startTimer() {
    _secondsRemaining = 60;
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_secondsRemaining > 0) {
        setState(() => _secondsRemaining--);
      } else {
        timer.cancel();
      }
    });
  }

  void _onDigitChanged(int index, String value) {
    if (value.length == 1) {
      // Move to next field
      if (index < 5) {
        _focusNodes[index + 1].requestFocus();
      } else {
        _focusNodes[index].unfocus();
        _verifyOtp();
      }
    }
    if (_hasError) {
      setState(() => _hasError = false);
    }
  }

  void _onKeyPress(int index, KeyEvent event) {
    if (event is KeyDownEvent &&
        event.logicalKey == LogicalKeyboardKey.backspace &&
        _controllers[index].text.isEmpty &&
        index > 0) {
      _controllers[index - 1].clear();
      _focusNodes[index - 1].requestFocus();
    }
  }

  String get _otpCode =>
      _controllers.map((c) => c.text).join();

  void _verifyOtp() {
    final code = _otpCode;
    if (code.length != 6) return;

    setState(() {});
    AnalyticsService.trackEvent('otp_verify_attempt');
    ref.read(authProvider.notifier).verifyOtp(code);
  }

  void _resendOtp() {
    if (_secondsRemaining > 0) return;
    ref.read(authProvider.notifier).resendOtp();
    _startTimer();
    AnalyticsService.trackEvent('otp_resend');
  }

  void _showError() {
    setState(() {
      _hasError = true;
    });
    _shakeController.forward(from: 0);
    HapticFeedback.heavyImpact();
    // Clear fields after animation
    Future.delayed(const Duration(milliseconds: 600), () {
      if (mounted) {
        for (final c in _controllers) {
          c.clear();
        }
        _focusNodes[0].requestFocus();
      }
    });
  }

  void _showSuccess() {
    setState(() => _isSuccess = true);
    _successController.forward();
    HapticFeedback.heavyImpact();
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);

    // Listen for auth state changes
    ref.listen<AuthState>(authProvider, (prev, next) {
      if (next.status == AuthStatus.authenticated) {
        _showSuccess();
        Future.delayed(const Duration(milliseconds: 1200), () {
          if (context.mounted) context.go('/home');
        });
      } else if (next.status == AuthStatus.needsProfile) {
        _showSuccess();
        Future.delayed(const Duration(milliseconds: 1200), () {
          if (context.mounted) context.go('/auth/setup');
        });
      } else if (next.status == AuthStatus.error) {
        _showError();
        ref.read(authProvider.notifier).clearError();
      }
    });

    final phone = authState.phone ?? '';
    final maskedPhone = phone.length > 6
        ? '${phone.substring(0, phone.length - 4)}****'
        : phone;

    return Scaffold(
      backgroundColor: AppColors.bgPrimary,
      body: ColonyMeshBackground(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Back button
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: IconButton(
                    icon: const Icon(Icons.arrow_back_ios,
                        color: AppColors.textPrimary),
                    onPressed: () {
                      ref.read(authProvider.notifier).resetToPhone();
                      context.go('/auth/phone');
                    },
                  ),
                ),
                const Spacer(flex: 1),

                // Title
                Text(
                  'Verify your number',
                  style: AppTypography.headlineLarge,
                )
                    .animate()
                    .fadeIn(duration: 400.ms)
                    .slideX(begin: -0.1, end: 0),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Text(
                      'Enter the code sent to $maskedPhone',
                      style: AppTypography.bodyMedium.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(width: 8),
                    GestureDetector(
                      onTap: () {
                        ref.read(authProvider.notifier).resetToPhone();
                        context.go('/auth/phone');
                      },
                      child: Text(
                        'Edit',
                        style: AppTypography.bodyMedium.copyWith(
                          color: AppColors.colonyViolet,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                )
                    .animate()
                    .fadeIn(duration: 400.ms, delay: 100.ms),

                const SizedBox(height: 48),

                // OTP boxes
                AnimatedBuilder(
                  animation: _shakeController,
                  builder: (context, child) {
                    final shake = _shakeController.value;
                    final offset = shake < 0.5
                        ? (shake * 2) * 12
                        : ((1 - shake) * 2) * -12;
                    return Transform.translate(
                      offset: Offset(offset, 0),
                      child: child,
                    );
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: List.generate(6, (index) {
                      return _buildOtpBox(index);
                    }),
                  ),
                )
                    .animate()
                    .fadeIn(duration: 500.ms, delay: 200.ms)
                    .slideY(begin: 0.2, end: 0),

                const SizedBox(height: 16),

                // Error/success message
                if (_hasError)
                  Center(
                    child: Text(
                      'Invalid code. Please try again.',
                      style: AppTypography.bodySmall.copyWith(
                        color: AppColors.error,
                      ),
                    ),
                  ).animate().fadeIn(duration: 200.ms).shakeX(hz: 4),

                if (_isSuccess)
                  Center(
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.check_circle,
                            color: AppColors.success, size: 20),
                        const SizedBox(width: 8),
                        Text(
                          'Verified!',
                          style: AppTypography.bodyMedium.copyWith(
                            color: AppColors.success,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ).animate().fadeIn(duration: 300.ms).scale(
                      begin: const Offset(0.8, 0.8),
                      curve: Curves.elasticOut),

                const SizedBox(height: 32),

                // Timer / Resend
                Center(
                  child: _secondsRemaining > 0
                      ? Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            SizedBox(
                              width: 24,
                              height: 24,
                              child: CircularProgressIndicator(
                                value: _secondsRemaining / 60,
                                strokeWidth: 2,
                                backgroundColor: AppColors.surfaceMedium,
                                valueColor:
                                    const AlwaysStoppedAnimation(
                                        AppColors.colonyPurple),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Text(
                              'Resend in 0:${_secondsRemaining.toString().padLeft(2, '0')}',
                              style: AppTypography.bodyMedium.copyWith(
                                color: AppColors.textMuted,
                              ),
                            ),
                          ],
                        )
                      : GestureDetector(
                          onTap: _resendOtp,
                          child: Text(
                            'Resend OTP',
                            style: AppTypography.bodyMedium.copyWith(
                              color: AppColors.colonyViolet,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                )
                    .animate()
                    .fadeIn(duration: 400.ms, delay: 300.ms),

                const Spacer(flex: 3),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildOtpBox(int index) {
    final hasValue = _controllers[index].text.isNotEmpty;
    final isError = _hasError;
    final isSuccess = _isSuccess;

    return Container(
      width: 50,
      height: 60,
      decoration: BoxDecoration(
        color: hasValue
            ? (isSuccess
                ? AppColors.success.withValues(alpha: 0.15)
                : AppColors.colonyPurple.withValues(alpha: 0.15))
            : AppColors.surfaceMedium,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isError
              ? AppColors.error
              : hasValue
                  ? (isSuccess
                      ? AppColors.success
                      : AppColors.colonyPurple)
                  : _focusNodes[index].hasFocus
                      ? AppColors.colonyPurple.withValues(alpha: 0.5)
                      : AppColors.borderDark,
          width: _focusNodes[index].hasFocus || hasValue ? 2 : 1,
        ),
        boxShadow: _focusNodes[index].hasFocus
            ? [
                BoxShadow(
                  color: AppColors.colonyPurple.withValues(alpha: 0.2),
                  blurRadius: 12,
                  spreadRadius: 0,
                ),
              ]
            : null,
      ),
      child: KeyboardListener(
        focusNode: FocusNode(),
        onKeyEvent: (event) => _onKeyPress(index, event),
        child: TextField(
          controller: _controllers[index],
          focusNode: _focusNodes[index],
          keyboardType: TextInputType.number,
          textAlign: TextAlign.center,
          maxLength: 1,
          style: AppTypography.headlineMedium.copyWith(
            color: isSuccess ? AppColors.success : AppColors.textPrimary,
          ),
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
          ],
          decoration: const InputDecoration(
            border: InputBorder.none,
            counterText: '',
            contentPadding: EdgeInsets.zero,
          ),
          onChanged: (value) => _onDigitChanged(index, value),
        ),
      ),
    )
        .animate(delay: Duration(milliseconds: 50 * index))
        .fadeIn(duration: 300.ms)
        .scale(begin: const Offset(0.8, 0.8), curve: Curves.elasticOut);
  }
}
