import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_gradients.dart';
import '../../core/theme/app_typography.dart';
import '../../core/utils/validator_utils.dart';
import '../../services/analytics_service.dart';
import '../../shared/widgets/animated_blob.dart';
import '../../shared/widgets/colony_button.dart';
import '../../shared/widgets/colony_text_field.dart';

/// Auth Screen — Phone number login with OTP
class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen>
    with SingleTickerProviderStateMixin {
  final _phoneController = TextEditingController();
  final _otpController = TextEditingController();
  bool _otpSent = false;
  bool _isLoading = false;

  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    AnalyticsService.trackScreen('auth');
    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _fadeAnimation = CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeInOut,
    );
    _fadeController.forward();
  }

  @override
  void dispose() {
    _phoneController.dispose();
    _otpController.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  void _sendOtp() {
    final error = ValidatorUtils.validatePhone(_phoneController.text);
    if (error != null) return;

    setState(() {
      _isLoading = true;
    });

    // Simulate API call
    Future.delayed(const Duration(seconds: 1), () {
      if (mounted) {
        setState(() {
          _otpSent = true;
          _isLoading = false;
        });
        AnalyticsService.trackEvent('otp_sent');
      }
    });
  }

  void _verifyOtp() {
    final error = ValidatorUtils.validateOtp(_otpController.text);
    if (error != null) return;

    setState(() => _isLoading = true);

    Future.delayed(const Duration(seconds: 1), () {
      if (mounted) {
        AnalyticsService.trackEvent('otp_verified');
        // Navigate to home
        Navigator.pushReplacementNamed(context, '/home');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ColonyMeshBackground(
        child: SafeArea(
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Spacer(flex: 2),

                  // Logo / Title
                  Center(
                    child: ShaderMask(
                      shaderCallback: (bounds) =>
                          AppGradients.primaryGradient.createShader(bounds),
                      child: Text(
                        'Colony',
                        style: AppTypography.displayLarge.copyWith(
                          color: Colors.white,
                          fontSize: 48,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Center(
                    child: Text(
                      'Your neighborhood, connected',
                      style: AppTypography.bodyLarge.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ),

                  const Spacer(flex: 2),

                  // Phone Input
                  if (!_otpSent) ...[
                    Text(
                      'Enter your phone number',
                      style: AppTypography.headlineMedium,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'We\'ll send you a verification code',
                      style: AppTypography.bodyMedium.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 24),
                    ColonyTextField(
                      controller: _phoneController,
                      labelText: 'Phone Number',
                      hintText: '9876543210',
                      keyboardType: TextInputType.phone,
                      textInputAction: TextInputAction.done,
                      prefixIcon: Padding(
                        padding: const EdgeInsets.only(left: 16, right: 8),
                        child: Text('+91', style: AppTypography.bodyLarge),
                      ),
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        LengthLimitingTextInputFormatter(10),
                      ],
                      onSubmitted: (_) => _sendOtp(),
                    ),
                    const SizedBox(height: 24),
                    ColonyButton(
                      text: 'Send OTP',
                      onPressed: _sendOtp,
                      isLoading: _isLoading,
                    ),
                  ] else ...[
                    Text(
                      'Enter verification code',
                      style: AppTypography.headlineMedium,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Sent to +91 ${_phoneController.text}',
                      style: AppTypography.bodyMedium.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 24),
                    ColonyTextField(
                      controller: _otpController,
                      labelText: 'OTP Code',
                      hintText: '000000',
                      keyboardType: TextInputType.number,
                      textInputAction: TextInputAction.done,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        LengthLimitingTextInputFormatter(6),
                      ],
                      onSubmitted: (_) => _verifyOtp(),
                    ),
                    const SizedBox(height: 16),
                    Center(
                      child: GestureDetector(
                        onTap: () {
                          setState(() => _otpSent = false);
                        },
                        child: Text(
                          'Change number?',
                          style: AppTypography.bodyMedium.copyWith(
                            color: AppColors.colonyViolet,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    ColonyButton(
                      text: 'Verify & Login',
                      onPressed: _verifyOtp,
                      isLoading: _isLoading,
                    ),
                  ],

                  const Spacer(flex: 3),

                  // Terms
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 24),
                      child: Text(
                        'By continuing, you agree to our\nTerms of Service & Privacy Policy',
                        textAlign: TextAlign.center,
                        style: AppTypography.bodySmall.copyWith(
                          color: AppColors.textMuted,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
