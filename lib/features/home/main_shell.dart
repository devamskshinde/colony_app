import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';

import '../../services/analytics_service.dart';
import '../../shared/providers/app_providers.dart';

/// Main Shell — Bottom navigation with go_router ShellRoute
class MainShell extends ConsumerStatefulWidget {
  final Widget child;
  const MainShell({super.key, required this.child});

  @override
  ConsumerState<MainShell> createState() => _MainShellState();
}

class _MainShellState extends ConsumerState<MainShell> {
  int _currentIndex = 0;

  static const _tabs = [
    '/home/feed',
    '/home/radar',
    '/home/groups',
    '/home/chat',
    '/home/discover',
    '/home/profile',
  ];

  void _onTabTapped(int index) {
    if (index == 2) {
      // Stories button - open stories screen
      context.push('/stories');
      return;
    }
    HapticFeedback.lightImpact();
    setState(() => _currentIndex = index);
    context.go(_tabs[index]);
    AnalyticsService.trackScreen(_tabs[index].split('/').last);
  }

  int _indexFromPath(String path) {
    if (path.startsWith('/home/feed') || path == '/home') return 0;
    if (path.startsWith('/home/radar')) return 1;
    if (path.startsWith('/home/groups')) return 2;
    if (path.startsWith('/home/chat')) return 3;
    if (path.startsWith('/home/discover')) return 4;
    if (path.startsWith('/home/profile')) return 5;
    return 0;
  }

  @override
  Widget build(BuildContext context) {
    final config = ref.watch(remoteConfigProvider);
    final currentPath = GoRouterState.of(context).matchedLocation;
    _currentIndex = _indexFromPath(currentPath);

    // Check if features are enabled
    final hasRadar = config.isFeatureEnabled('feature_radar', 'free');
    final hasGroups = config.isFeatureEnabled('feature_groups', 'free');
    final hasChat = config.isFeatureEnabled('feature_chat', 'free');
    final hasDiscovery = config.isFeatureEnabled('feature_discovery', 'free');

    return Scaffold(
      body: widget.child,
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: AppColors.bgSecondary.withValues(alpha: 0.95),
          border: const Border(
            top: BorderSide(color: AppColors.borderDark, width: 0.5),
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildNavItem(0, Icons.home_outlined, Icons.home, 'Home'),
                if (hasRadar)
                  _buildNavItem(1, Icons.radar_outlined, Icons.radar, 'Radar'),
                _buildStoriesButton(),
                if (hasGroups)
                  _buildNavItem(3, Icons.group_outlined, Icons.group, 'Groups'),
                if (hasChat)
                  _buildNavItem(4, Icons.chat_bubble_outline, Icons.chat_bubble, 'Chat'),
                if (hasDiscovery)
                  _buildNavItem(5, Icons.explore_outlined, Icons.explore, 'Discover'),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(
      int index, IconData inactiveIcon, IconData activeIcon, String label) {
    final isActive = _currentIndex == index;

    return GestureDetector(
      onTap: () => _onTabTapped(index),
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: isActive
              ? AppColors.colonyPurple.withValues(alpha: 0.1)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isActive ? activeIcon : inactiveIcon,
              color: isActive ? AppColors.colonyPurple : AppColors.textMuted,
              size: 24,
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: AppTypography.labelSmall.copyWith(
                color: isActive ? AppColors.colonyPurple : AppColors.textMuted,
                fontSize: 10,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStoriesButton() {
    return GestureDetector(
      onTap: () => _onTabTapped(2),
      child: Container(
        width: 48,
        height: 48,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [AppColors.colonyPurple, AppColors.colonyPink],
          ),
          shape: BoxShape.circle,
        ),
        child: const Icon(
          Icons.add,
          color: Colors.white,
          size: 28,
        ),
      ),
    );
  }
}
