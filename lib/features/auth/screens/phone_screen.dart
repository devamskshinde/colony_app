import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../services/analytics_service.dart';
import '../../../shared/widgets/animated_blob.dart';
import '../../../shared/widgets/colony_button.dart';
import '../../../shared/widgets/glassmorphic_container.dart';
import '../providers/auth_provider.dart';

/// Phone Number Entry Screen
class PhoneScreen extends ConsumerStatefulWidget {
  const PhoneScreen({super.key});

  @override
  ConsumerState<PhoneScreen> createState() => _PhoneScreenState();
}

class _PhoneScreenState extends ConsumerState<PhoneScreen>
    with SingleTickerProviderStateMixin {
  final _phoneController = TextEditingController();
  final _focusNode = FocusNode();
  late AnimationController _shakeController;
  String _errorText = '';
  bool _isValid = false;

  @override
  void initState() {
    super.initState();
    AnalyticsService.trackScreen('auth_phone');
    _shakeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _phoneController.addListener(_onPhoneChanged);
  }

  @override
  void dispose() {
    _phoneController.removeListener(_onPhoneChanged);
    _phoneController.dispose();
    _focusNode.dispose();
    _shakeController.dispose();
    super.dispose();
  }

  void _onPhoneChanged() {
    final digits = _phoneController.text.replaceAll(RegExp(r'\D'), '');
    final isValid = digits.length == 10 &&
        RegExp(r'^[6-9]').hasMatch(digits);
    if (isValid != _isValid) {
      setState(() => _isValid = isValid);
    }
    if (_errorText.isNotEmpty) {
      setState(() => _errorText = '');
    }
  }

  void _sendOtp() {
    final digits = _phoneController.text.replaceAll(RegExp(r'\D'), '');
    if (digits.length != 10) {
      _shakeAndError('Enter a valid 10-digit number');
      return;
    }
    if (!RegExp(r'^[6-9]').hasMatch(digits)) {
      _shakeAndError('Indian mobile numbers start with 6-9');
      return;
    }

    final phone = '+91$digits';
    ref.read(authProvider.notifier).sendOtp(phone);
  }

  void _shakeAndError(String message) {
    setState(() => _errorText = message);
    _shakeController.forward(from: 0);
    HapticFeedback.mediumImpact();
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);

    // Navigate on OTP sent
    ref.listen<AuthState>(authProvider, (prev, next) {
      if (next.status == AuthStatus.otpSent) {
        context.go('/auth/otp');
      }
      if (next.status == AuthStatus.error && next.errorMessage != null) {
        _shakeAndError(next.errorMessage!);
        ref.read(authProvider.notifier).clearError();
      }
    });

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
                    icon: const Icon(Icons.arrow_back_ios, color: AppColors.textPrimary),
                    onPressed: () => context.go('/onboarding'),
                  ),
                ),
                const Spacer(flex: 2),

                // Title
                Text(
                  "What's your number?",
                  style: AppTypography.headlineLarge,
                )
                    .animate()
                    .fadeIn(duration: 400.ms)
                    .slideX(begin: -0.1, end: 0, curve: Curves.easeOut),
                const SizedBox(height: 8),
                Text(
                  "We'll send a code to verify it's really you",
                  style: AppTypography.bodyMedium.copyWith(
                    color: AppColors.textSecondary,
                  ),
                )
                    .animate()
                    .fadeIn(duration: 400.ms, delay: 100.ms),
                const SizedBox(height: 40),

                // Phone input card
                AnimatedBuilder(
                  animation: _shakeController,
                  builder: (context, child) {
                    final shake = _shakeController.value;
                    final offset = shake < 0.5
                        ? (shake * 2) * 8
                        : ((1 - shake) * 2) * -8;
                    return Transform.translate(
                      offset: Offset(offset, 0),
                      child: child,
                    );
                  },
                  child: GlassmorphicContainer(
                    borderRadius: 20,
                    opacity: 0.06,
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Country prefix
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 8),
                              decoration: BoxDecoration(
                                color: AppColors.surfaceMedium,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text('🇮🇳', style: AppTypography.titleLarge),
                                  const SizedBox(width: 8),
                                  Text(
                                    '+91',
                                    style: AppTypography.titleMedium.copyWith(
                                      color: AppColors.textPrimary,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 12),
                            // Digit counter
                            Text(
                              '${_phoneController.text.replaceAll(RegExp(r'[^0-9]'), '').length}/10',
                              style: AppTypography.bodySmall.copyWith(
                                color: _isValid
                                    ? AppColors.colonyTeal
                                    : AppColors.textMuted,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),

                        // Phone input
                        TextField(
                          controller: _phoneController,
                          focusNode: _focusNode,
                          keyboardType: TextInputType.phone,
                          textInputAction: TextInputAction.done,
                          style: AppTypography.headlineMedium.copyWith(
                            color: AppColors.textPrimary,
                            letterSpacing: 2,
                          ),
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                            LengthLimitingTextInputFormatter(10),
                            _PhoneFormatter(),
                          ],
                          decoration: InputDecoration(
                            hintText: '98765 43210',
                            hintStyle: AppTypography.headlineMedium.copyWith(
                              color: AppColors.textMuted.withValues(alpha: 0.4),
                              letterSpacing: 2,
                            ),
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.zero,
                          ),
                          onSubmitted: (_) => _sendOtp(),
                        ),
                      ],
                    ),
                  )
                      .animate()
                      .fadeIn(duration: 500.ms, delay: 200.ms)
                      .slideY(begin: 0.2, end: 0, curve: Curves.easeOut),
                ),

                // Error text
                if (_errorText.isNotEmpty) ...[
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      const Icon(Icons.error_outline,
                          size: 16, color: AppColors.error),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          _errorText,
                          style: AppTypography.bodySmall.copyWith(
                            color: AppColors.error,
                          ),
                        ),
                      ),
                    ],
                  )
                      .animate()
                      .fadeIn(duration: 200.ms)
                      .shakeX(duration: 300.ms, hz: 4),
                ],

                const SizedBox(height: 24),

                // Continue button
                ColonyButton(
                  text: 'Continue',
                  onPressed: _isValid ? _sendOtp : null,
                  isLoading: authState.isLoading,
                )
                    .animate()
                    .fadeIn(duration: 400.ms, delay: 300.ms)
                    .slideY(begin: 0.2, end: 0),

                // Or login with email
                Center(
                  child: GestureDetector(
                    onTap: () => context.go('/auth/email'),
                    child: Text(
                      'Or login with email',
                      style: AppTypography.bodyMedium.copyWith(
                        color: AppColors.colonyViolet,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                )
                    .animate()
                    .fadeIn(duration: 400.ms, delay: 400.ms),

                const Spacer(flex: 2),

                // Terms
                Center(
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 24),
                    child: Text(
                      'By continuing you agree to our\nTerms of Service & Privacy Policy',
                      textAlign: TextAlign.center,
                      style: AppTypography.bodySmall.copyWith(
                        color: AppColors.textMuted,
                        height: 1.5,
                      ),
                    ),
                  ),
                )
                    .animate()
                    .fadeIn(duration: 500.ms, delay: 500.ms),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Phone number formatter: XXXXX XXXXX
class _PhoneFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final digits = newValue.text.replaceAll(RegExp(r'\D'), '');
    final buffer = StringBuffer();
    for (int i = 0; i < digits.length && i < 10; i++) {
      if (i == 5) buffer.write(' ');
      buffer.write(digits[i]);
    }
    final formatted = buffer.toString();
    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}
