import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/theme/app_theme.dart';
import 'features/auth/auth_screen.dart';
import 'features/home/main_shell.dart';
import 'features/chat/chat_list_screen.dart';
import 'features/notifications/notifications_screen.dart';
import 'features/settings/settings_screen.dart';
import 'features/profile/profile_screen.dart';

/// Colony App — Root widget with routing
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
      initialRoute: '/auth',
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case '/auth':
            return _buildRoute(const AuthScreen(), settings);
          case '/home':
            return _buildRoute(const MainShell(), settings);
          case '/chat':
            return _buildRoute(const ChatListScreen(), settings);
          case '/notifications':
            return _buildRoute(const NotificationsScreen(), settings);
          case '/settings':
            return _buildRoute(const SettingsScreen(), settings);
          case '/profile':
            final userId = settings.arguments as String?;
            return _buildRoute(ProfileScreen(userId: userId), settings);
          default:
            return _buildRoute(const AuthScreen(), settings);
        }
      },
    );
  }

  MaterialPageRoute _buildRoute(Widget page, RouteSettings settings) {
    return MaterialPageRoute(
      builder: (_) => page,
      settings: settings,
    );
  }
}
