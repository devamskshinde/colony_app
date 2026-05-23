import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'core/theme/app_theme.dart';
import 'features/auth/screens/splash_screen.dart';
import 'features/auth/screens/onboarding_screen.dart';
import 'features/auth/screens/phone_screen.dart';
import 'features/auth/screens/otp_screen.dart';
import 'features/auth/screens/profile_setup_screen.dart';
import 'features/home/main_shell.dart';

/// Colony App — Root widget with GoRouter
class ColonyApp extends ConsumerWidget {
  const ColonyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = GoRouter(
      initialLocation: '/splash',
      routes: [
        GoRoute(
          path: '/splash',
          pageBuilder: (context, state) => CustomTransitionPage(
            child: const SplashScreen(),
            transitionsBuilder: (context, animation, secondaryAnimation, child) {
              return FadeTransition(opacity: animation, child: child);
            },
          ),
        ),
        GoRoute(
          path: '/onboarding',
          builder: (context, state) => const OnboardingScreen(),
        ),
        GoRoute(
          path: '/auth/phone',
          builder: (context, state) => const PhoneScreen(),
        ),
        GoRoute(
          path: '/auth/otp',
          builder: (context, state) => const OtpScreen(),
        ),
        GoRoute(
          path: '/auth/setup',
          builder: (context, state) => const ProfileSetupScreen(),
        ),
        GoRoute(
          path: '/home',
          builder: (context, state) => const MainShell(),
        ),
      ],
    );

    return MaterialApp.router(
      title: 'Colony',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.dark,
      routerConfig: router,
    );
  }
}
