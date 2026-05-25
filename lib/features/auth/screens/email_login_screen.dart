import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../services/analytics_service.dart';
import '../../../shared/widgets/colony_button.dart';
import '../../../shared/widgets/colony_text_field.dart';
import '../../../shared/widgets/animated_blob.dart';
import '../providers/auth_provider.dart';

/// Email Login Screen — login or register with email + password
class EmailLoginScreen extends ConsumerStatefulWidget {
  const EmailLoginScreen({super.key});

  @override
  ConsumerState<EmailLoginScreen> createState() => _EmailLoginScreenState();
}

class _EmailLoginScreenState extends ConsumerState<EmailLoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _nameController = TextEditingController();
  bool _isRegister = false;
  bool _obscurePassword = true;
  String _errorText = '';

  @override
  void initState() {
    super.initState();
    AnalyticsService.trackScreen('auth_email_login');
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  bool get _isValid {
    final email = _emailController.text.trim();
    final password = _passwordController.text;
    if (email.isEmpty || !email.contains('@')) return false;
    if (password.length < 8) return false;
    if (_isRegister && _nameController.text.trim().length < 2) return false;
    return true;
  }

  void _submit() {
    if (!_isValid) return;
    setState(() => _errorText = '');
    HapticFeedback.lightImpact();

    final email = _emailController.text.trim();
    final password = _passwordController.text;

    if (_isRegister) {
      final displayName = _nameController.text.trim();
      ref.read(authProvider.notifier).registerEmail(
        email: email,
        password: password,
        displayName: displayName,
      );
    } else {
      ref.read(authProvider.notifier).loginEmail(
        email: email,
        password: password,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);

    ref.listen<AuthState>(authProvider, (prev, next) {
      if (next.status == AuthStatus.authenticated) {
        context.go('/home');
      } else if (next.status == AuthStatus.needsProfile) {
        context.go('/auth/setup');
      } else if (next.status == AuthStatus.error && next.errorMessage != null) {
        setState(() => _errorText = next.errorMessage!);
        ref.read(authProvider.notifier).clearError();
      }
    });

    return Scaffold(
      backgroundColor: AppColors.bgPrimary,
      body: ColonyMeshBackground(
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Back button
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: IconButton(
                    icon: const Icon(Icons.arrow_back_ios, color: AppColors.textPrimary),
                    onPressed: () => context.go('/auth/phone'),
                  ),
                ),
                const SizedBox(height: 40),

                // Title
                Text(
                  _isRegister ? 'Create account' : 'Welcome back',
                  style: AppTypography.headlineLarge,
                ).animate().fadeIn(duration: 400.ms).slideX(begin: -0.1, end: 0),
                const SizedBox(height: 8),
                Text(
                  _isRegister
                      ? 'Sign up with your email'
                      : 'Sign in with your email',
                  style: AppTypography.bodyMedium.copyWith(color: AppColors.textSecondary),
                ).animate().fadeIn(duration: 400.ms, delay: 100.ms),
                const SizedBox(height: 40),

                // Name field (register only)
                if (_isRegister) ...[
                  ColonyTextField(
                    controller: _nameController,
                    labelText: 'Display Name',
                    hintText: 'Your name',
                    textInputAction: TextInputAction.next,
                    onChanged: (_) => setState(() {}),
                  ).animate().fadeIn(duration: 400.ms),
                  const SizedBox(height: 16),
                ],

                // Email field
                ColonyTextField(
                  controller: _emailController,
                  labelText: 'Email',
                  hintText: 'you@example.com',
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
                  onChanged: (_) => setState(() {}),
                ).animate().fadeIn(duration: 400.ms, delay: 150.ms),
                const SizedBox(height: 16),

                // Password field
                ColonyTextField(
                  controller: _passwordController,
                  labelText: 'Password',
                  hintText: 'Min 8 characters',
                  obscureText: _obscurePassword,
                  textInputAction: TextInputAction.done,
                  onChanged: (_) => setState(() {}),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscurePassword ? Icons.visibility_off : Icons.visibility,
                      color: AppColors.textMuted,
                    ),
                    onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                  ),
                  onSubmitted: (_) => _submit(),
                ).animate().fadeIn(duration: 400.ms, delay: 200.ms),

                // Error text
                if (_errorText.isNotEmpty) ...[
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      const Icon(Icons.error_outline, size: 16, color: AppColors.error),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(_errorText, style: AppTypography.bodySmall.copyWith(color: AppColors.error)),
                      ),
                    ],
                  ).animate().fadeIn(duration: 200.ms).shakeX(duration: 300.ms, hz: 4),
                ],

                const SizedBox(height: 24),

                // Submit button
                ColonyButton(
                  text: _isRegister ? 'Create Account' : 'Sign In',
                  onPressed: _isValid ? _submit : null,
                  isLoading: authState.isLoading,
                ).animate().fadeIn(duration: 400.ms, delay: 300.ms),

                const SizedBox(height: 24),

                // Toggle login/register
                Center(
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        _isRegister = !_isRegister;
                        _errorText = '';
                      });
                    },
                    child: RichText(
                      text: TextSpan(
                        text: _isRegister
                            ? 'Already have an account? '
                            : "Don't have an account? ",
                        style: AppTypography.bodyMedium.copyWith(color: AppColors.textMuted),
                        children: [
                          TextSpan(
                            text: _isRegister ? 'Sign in' : 'Sign up',
                            style: AppTypography.bodyMedium.copyWith(
                              color: AppColors.colonyViolet,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Or use phone
                Center(
                  child: GestureDetector(
                    onTap: () => context.go('/auth/phone'),
                    child: Text(
                      'Or login with phone number',
                      style: AppTypography.bodyMedium.copyWith(
                        color: AppColors.textMuted,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
