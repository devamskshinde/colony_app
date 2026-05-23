import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_gradients.dart';
import '../../../core/theme/app_typography.dart';
import '../../../services/analytics_service.dart';
import '../providers/auth_provider.dart';

/// Splash Screen — Colony branding with animated blobs
class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _logoController;
  late AnimationController _blobController;
  late Animation<double> _logoScale;
  late Animation<double> _logoOpacity;

  @override
  void initState() {
    super.initState();
    AnalyticsService.trackScreen('splash');

    // Logo animation
    _logoController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );
    _logoScale = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(parent: _logoController, curve: Curves.elasticOut),
    );
    _logoOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _logoController,
        curve: const Interval(0.0, 0.5, curve: Curves.easeIn),
      ),
    );

    // Blob animation
    _blobController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    )..repeat();

    // Start logo animation
    _logoController.forward();

    // Check session after delay
    _checkSession();

    // Safety: if stuck for 8 seconds, force navigate to onboarding
    Future.delayed(const Duration(seconds: 8), () {
      if (!mounted) return;
      final authState = ref.read(authProvider);
      if (authState.status == AuthStatus.initial ||
          authState.status == AuthStatus.loading) {
        context.go('/onboarding');
      }
    });
  }

  Future<void> _checkSession() async {
    await Future.delayed(const Duration(milliseconds: 2500));
    if (!mounted) return;

    try {
      final authNotifier = ref.read(authProvider.notifier);
      await authNotifier.checkSession();
    } catch (e) {
      // If session check fails entirely, treat as unauthenticated
      debugPrint('Session check error: $e');
    }

    if (!mounted) return;

    final authState = ref.read(authProvider);
    if (authState.status == AuthStatus.authenticated) {
      context.go('/home');
    } else if (authState.status == AuthStatus.needsProfile) {
      context.go('/auth/setup');
    } else {
      context.go('/onboarding');
    }
  }

  @override
  void dispose() {
    _logoController.dispose();
    _blobController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgPrimary,
      body: Stack(
        children: [
          // Animated blobs
          ..._buildAnimatedBlobs(),

          // Logo
          Center(
            child: AnimatedBuilder(
              animation: _logoController,
              builder: (context, child) {
                return Opacity(
                  opacity: _logoOpacity.value,
                  child: Transform.scale(
                    scale: _logoScale.value,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Lettermark
                        Container(
                          width: 88,
                          height: 88,
                          decoration: BoxDecoration(
                            gradient: AppGradients.primaryGradient,
                            borderRadius: BorderRadius.circular(24),
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.colonyPurple.withValues(alpha: 0.4),
                                blurRadius: 30,
                                offset: const Offset(0, 10),
                              ),
                            ],
                          ),
                          child: Center(
                            child: Text(
                              'C',
                              style: AppTypography.displayLarge.copyWith(
                                color: Colors.white,
                                fontSize: 48,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),

                        // Colony text
                        Text(
                          'Colony',
                          style: AppTypography.displayLarge.copyWith(
                            color: AppColors.textPrimary,
                            fontSize: 36,
                          ),
                        ),
                        const SizedBox(height: 8),

                        // Tagline
                        Text(
                          'Your neighborhood, alive',
                          style: AppTypography.bodyMedium.copyWith(
                            color: AppColors.textMuted,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildAnimatedBlobs() {
    return [
      // Purple blob
      AnimatedBuilder(
        animation: _blobController,
        builder: (context, child) {
          return Positioned(
            top: -80 + sin(_blobController.value * 2 * pi) * 30,
            right: -60 + cos(_blobController.value * 2 * pi) * 20,
            child: Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    AppColors.colonyPurple.withValues(alpha: 0.15),
                    AppColors.colonyPurple.withValues(alpha: 0.0),
                  ],
                ),
              ),
            ),
          );
        },
      ),
      // Pink blob
      AnimatedBuilder(
        animation: _blobController,
        builder: (context, child) {
          return Positioned(
            bottom: -100 + cos(_blobController.value * 2 * pi) * 40,
            left: -80 + sin(_blobController.value * 2 * pi) * 25,
            child: Container(
              width: 350,
              height: 350,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    AppColors.colonyPink.withValues(alpha: 0.1),
                    AppColors.colonyPink.withValues(alpha: 0.0),
                  ],
                ),
              ),
            ),
          );
        },
      ),
      // Blue blob
      AnimatedBuilder(
        animation: _blobController,
        builder: (context, child) {
          return Positioned(
            top: MediaQuery.of(context).size.height * 0.4 +
                sin(_blobController.value * 2 * pi + 1) * 50,
            left: MediaQuery.of(context).size.width * 0.3 +
                cos(_blobController.value * 2 * pi + 1) * 30,
            child: Container(
              width: 250,
              height: 250,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    AppColors.colonyBlue.withValues(alpha: 0.08),
                    AppColors.colonyBlue.withValues(alpha: 0.0),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    ];
  }
}
