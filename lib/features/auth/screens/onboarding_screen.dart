import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_gradients.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/theme/app_animations.dart';
import '../../../services/analytics_service.dart';
import '../../../shared/widgets/colony_button.dart';
import '../../../shared/widgets/animated_blob.dart';

/// Onboarding Screen — 3 slides with parallax
class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    AnalyticsService.trackScreen('onboarding');
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgPrimary,
      body: ColonyMeshBackground(
        child: SafeArea(
          child: Column(
            children: [
              // Skip button
              Align(
                alignment: Alignment.topRight,
                child: Padding(
                  padding: const EdgeInsets.only(top: 8, right: 16),
                  child: TextButton(
                    onPressed: () => context.go('/auth/phone'),
                    child: Text(
                      'Skip',
                      style: AppTypography.bodyMedium.copyWith(
                        color: AppColors.textMuted,
                      ),
                    ),
                  ),
                ),
              ),

              // Page view
              Expanded(
                child: PageView(
                  controller: _pageController,
                  onPageChanged: (page) {
                    setState(() => _currentPage = page);
                    HapticFeedback.lightImpact();
                  },
                  children: [
                    _buildPage(
                      icon: Icons.radar,
                      title: 'Meet people in\nyour 5km world',
                      subtitle:
                          'Colony shows you real people around you — not strangers from across the city',
                      gradientColors: [
                        AppColors.colonyPurple,
                        AppColors.colonyViolet,
                      ],
                    ),
                    _buildPage(
                      icon: Icons.chat_bubble_rounded,
                      title: 'Stories, chats, events\nall hyperlocal',
                      subtitle:
                          "What's happening 2 streets away? Colony always knows",
                      gradientColors: [
                        AppColors.colonyPink,
                        AppColors.colonyPurple,
                      ],
                    ),
                    _buildPage(
                      icon: Icons.explore,
                      title: 'The heartbeat of\nyour neighborhood',
                      subtitle:
                          'From the new café down the road to your future best friend — it\'s all here',
                      gradientColors: [
                        AppColors.colonyBlue,
                        AppColors.colonyPurple,
                      ],
                    ),
                  ],
                ),
              ),

              // Page indicators
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(3, (index) {
                  final isActive = index == _currentPage;
                  return AnimatedContainer(
                    duration: AppAnimations.normalDuration,
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    width: isActive ? 32 : 8,
                    height: 8,
                    decoration: BoxDecoration(
                      gradient: isActive ? AppGradients.primaryGradient : null,
                      color: isActive ? null : AppColors.surfaceMedium,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  );
                }),
              ),
              const SizedBox(height: 32),

              // Get Started button
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: ColonyButton(
                  text: 'Get Started',
                  onPressed: () => context.go('/auth/phone'),
                ),
              ),
              const SizedBox(height: 16),

              // Sign in link
              Padding(
                padding: const EdgeInsets.only(bottom: 24),
                child: GestureDetector(
                  onTap: () => context.go('/auth/phone'),
                  child: RichText(
                    text: TextSpan(
                      text: 'Already have an account? ',
                      style: AppTypography.bodyMedium.copyWith(
                        color: AppColors.textMuted,
                      ),
                      children: [
                        TextSpan(
                          text: 'Sign in',
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
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPage({
    required IconData icon,
    required String title,
    required String subtitle,
    required List<Color> gradientColors,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Icon container
          Container(
            width: 160,
            height: 160,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: gradientColors.map((c) => c.withValues(alpha: 0.2)).toList(),
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              shape: BoxShape.circle,
              border: Border.all(
                color: gradientColors.first.withValues(alpha: 0.3),
                width: 2,
              ),
            ),
            child: Icon(
              icon,
              size: 72,
              color: gradientColors.first,
            ),
          )
              .animate()
              .fadeIn(duration: 600.ms, delay: 200.ms)
              .scale(begin: const Offset(0.8, 0.8), curve: Curves.elasticOut, duration: 800.ms),
          const SizedBox(height: 48),

          // Title
          Text(
            title,
            textAlign: TextAlign.center,
            style: AppTypography.headlineLarge.copyWith(
              color: AppColors.textPrimary,
              height: 1.3,
            ),
          )
              .animate()
              .fadeIn(duration: 500.ms, delay: 400.ms)
              .slideY(begin: 0.3, end: 0, curve: Curves.easeOut),
          const SizedBox(height: 16),

          // Subtitle
          Text(
            subtitle,
            textAlign: TextAlign.center,
            style: AppTypography.bodyLarge.copyWith(
              color: AppColors.textSecondary,
              height: 1.5,
            ),
          )
              .animate()
              .fadeIn(duration: 500.ms, delay: 600.ms)
              .slideY(begin: 0.2, end: 0, curve: Curves.easeOut),
        ],
      ),
    );
  }
}
