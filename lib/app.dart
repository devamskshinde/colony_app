import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/theme/app_theme.dart';
import 'features/auth/screens/splash_screen.dart';
import 'features/auth/screens/onboarding_screen.dart';
import 'features/auth/screens/phone_screen.dart';
import 'features/auth/screens/otp_screen.dart';
import 'features/auth/screens/profile_setup_screen.dart';
import 'features/home/main_shell.dart';

/// Colony App — Root widget
class ColonyApp extends ConsumerWidget {
  const ColonyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
      title: 'Colony',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.dark,
      initialRoute: '/splash',
      routes: {
        '/splash': (context) => const SplashScreen(),
        '/onboarding': (context) => const OnboardingScreen(),
        '/auth/phone': (context) => const PhoneScreen(),
        '/auth/otp': (context) => const OtpScreen(),
        '/auth/setup': (context) => const ProfileSetupScreen(),
        '/home': (context) => const MainShell(),
      },
    );
  }
}
