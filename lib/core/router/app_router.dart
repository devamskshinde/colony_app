import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../features/auth/screens/splash_screen.dart';
import '../../features/auth/screens/onboarding_screen.dart';
import '../../features/auth/screens/phone_screen.dart';
import '../../features/auth/screens/otp_screen.dart';
import '../../features/auth/screens/profile_setup_screen.dart';
import '../../features/home/main_shell.dart';
import '../../features/home/home_screen.dart';
import '../../features/radar/radar_screen.dart';
import '../../features/groups/groups_screen.dart';
import '../../features/chat/chat_list_screen.dart';
import '../../features/profile/profile_screen.dart';
import '../../features/discovery/discovery_screen.dart';
import '../../features/notifications/notifications_screen.dart';
import '../../features/settings/settings_screen.dart';
import '../../features/stories/stories_screen.dart';
import '../../features/auth/providers/auth_provider.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();
final _shellNavigatorKey = GlobalKey<NavigatorState>();

/// Custom page transitions
CustomTransitionPage<void> _fadeTransition(Widget child) {
  return CustomTransitionPage<void>(
    child: child,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      return FadeTransition(opacity: animation, child: child);
    },
  );
}

CustomTransitionPage<void> _slideTransition(Widget child) {
  return CustomTransitionPage<void>(
    child: child,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      final tween = Tween(begin: const Offset(1.0, 0.0), end: Offset.zero)
          .chain(CurveTween(curve: Curves.easeInOutCubic));
      return SlideTransition(
        position: animation.drive(tween),
        child: child,
      );
    },
  );
}

CustomTransitionPage<void> _slideUpTransition(Widget child) {
  return CustomTransitionPage<void>(
    child: child,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      final tween = Tween(begin: const Offset(0.0, 1.0), end: Offset.zero)
          .chain(CurveTween(curve: Curves.easeInOutCubic));
      return SlideTransition(
        position: animation.drive(tween),
        child: child,
      );
    },
  );
}

final goRouterProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authProvider);

  return GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: '/splash',
    debugLogDiagnostics: true,
    routes: [
      // ─── Auth Flow ───────────────────────────────────────
      GoRoute(
        path: '/splash',
        pageBuilder: (context, state) => _fadeTransition(const SplashScreen()),
      ),
      GoRoute(
        path: '/onboarding',
        pageBuilder: (context, state) => _fadeTransition(const OnboardingScreen()),
      ),
      GoRoute(
        path: '/auth/phone',
        pageBuilder: (context, state) => _slideTransition(const PhoneScreen()),
      ),
      GoRoute(
        path: '/auth/otp',
        pageBuilder: (context, state) => _slideTransition(const OtpScreen()),
      ),
      GoRoute(
        path: '/auth/setup',
        pageBuilder: (context, state) => _slideUpTransition(const ProfileSetupScreen()),
      ),

      // ─── Stories (full screen) ───────────────────────────
      GoRoute(
        path: '/stories',
        pageBuilder: (context, state) => _fadeTransition(const StoriesScreen()),
      ),

      // ─── Notifications ───────────────────────────────────
      GoRoute(
        path: '/notifications',
        pageBuilder: (context, state) => _slideTransition(const NotificationsScreen()),
      ),

      // ─── Settings ────────────────────────────────────────
      GoRoute(
        path: '/settings',
        pageBuilder: (context, state) => _slideTransition(const SettingsScreen()),
      ),

      // ─── Profile (other user) ────────────────────────────
      GoRoute(
        path: '/profile/:userId',
        pageBuilder: (context, state) {
          final userId = state.pathParameters['userId'];
          return _slideTransition(ProfileScreen(userId: userId));
        },
      ),

      // ─── Main Shell (bottom nav) ─────────────────────────
      ShellRoute(
        navigatorKey: _shellNavigatorKey,
        builder: (context, state, child) => MainShell(child: child),
        routes: [
          GoRoute(
            path: '/home',
            pageBuilder: (context, state) => _fadeTransition(const HomeScreen()),
            routes: [
              GoRoute(
                path: 'feed',
                pageBuilder: (context, state) => _fadeTransition(const HomeScreen()),
              ),
              GoRoute(
                path: 'radar',
                pageBuilder: (context, state) => _fadeTransition(const RadarScreen()),
              ),
              GoRoute(
                path: 'groups',
                pageBuilder: (context, state) => _fadeTransition(const GroupsScreen()),
              ),
              GoRoute(
                path: 'chat',
                pageBuilder: (context, state) => _fadeTransition(const ChatListScreen()),
              ),
              GoRoute(
                path: 'discover',
                pageBuilder: (context, state) => _fadeTransition(const DiscoveryScreen()),
              ),
              GoRoute(
                path: 'profile',
                pageBuilder: (context, state) => _fadeTransition(const ProfileScreen()),
              ),
            ],
          ),
        ],
      ),
    ],
    redirect: (context, state) {
      final path = state.matchedLocation;
      final isAuthRoute = path.startsWith('/auth') || path == '/splash' || path == '/onboarding';
      final isAuthenticated = authState.status == AuthStatus.authenticated;
      final needsProfile = authState.status == AuthStatus.needsProfile;

      // Splash always accessible
      if (path == '/splash') return null;

      // If needs profile, force profile setup
      if (needsProfile && path != '/auth/setup') return '/auth/setup';

      // If not authenticated and trying to access protected route
      if (!isAuthenticated && !needsProfile && !isAuthRoute) return '/auth/phone';

      // If authenticated and on auth route, go home
      if (isAuthenticated && isAuthRoute) return '/home';

      return null;
    },
  );
});
