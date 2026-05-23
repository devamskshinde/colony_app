import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../services/analytics_service.dart';
import '../../shared/providers/app_providers.dart';
import '../../shared/widgets/animated_blob.dart';

/// Main Shell — Bottom navigation for the home screen
class MainShell extends ConsumerStatefulWidget {
  const MainShell({super.key});

  @override
  ConsumerState<MainShell> createState() => _MainShellState();
}

class _MainShellState extends ConsumerState<MainShell> {
  int _currentIndex = 0;

  void _onTabTapped(int index) {
    if (index == 2) {
      // Stories button - placeholder for now
      HapticFeedback.lightImpact();
      return;
    }
    HapticFeedback.lightImpact();
    setState(() => _currentIndex = index);
    AnalyticsService.trackScreen(_tabNames[index]);
  }

  static const _tabNames = ['home', 'radar', 'stories', 'groups', 'chat', 'discover'];

  @override
  Widget build(BuildContext context) {
    final config = ref.watch(remoteConfigProvider);

    final hasRadar = config.isFeatureEnabled('feature_radar', 'free');
    final hasGroups = config.isFeatureEnabled('feature_groups', 'free');
    final hasChat = config.isFeatureEnabled('feature_chat', 'free');
    final hasDiscovery = config.isFeatureEnabled('feature_discovery', 'free');

    return Scaffold(
      body: ColonyMeshBackground(
        child: _buildBody(),
      ),
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

  Widget _buildBody() {
    switch (_currentIndex) {
      case 0:
        return _buildHomeFeed();
      case 1:
        return _buildRadarPlaceholder();
      case 3:
        return _buildGroupsPlaceholder();
      case 4:
        return _buildChatPlaceholder();
      case 5:
        return _buildDiscoverPlaceholder();
      default:
        return _buildHomeFeed();
    }
  }

  Widget _buildHomeFeed() {
    return SafeArea(
      child: Column(
        children: [
          // App bar
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: [
                ShaderMask(
                  shaderCallback: (bounds) => const LinearGradient(
                    colors: [AppColors.colonyPurple, AppColors.colonyPink],
                  ).createShader(bounds),
                  child: Text(
                    'Colony',
                    style: AppTypography.headlineLarge.copyWith(color: Colors.white),
                  ),
                ),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.notifications_outlined, color: AppColors.textPrimary),
                  onPressed: () {},
                ),
                IconButton(
                  icon: const Icon(Icons.chat_bubble_outline, color: AppColors.textPrimary),
                  onPressed: () => _onTabTapped(4),
                ),
              ],
            ),
          ),
          // Stories bar
          SizedBox(
            height: 100,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: 8,
              itemBuilder: (context, index) {
                if (index == 0) {
                  return Padding(
                    padding: const EdgeInsets.only(right: 12),
                    child: Column(
                      children: [
                        Container(
                          width: 60,
                          height: 60,
                          decoration: BoxDecoration(
                            color: AppColors.surfaceLight,
                            shape: BoxShape.circle,
                            border: Border.all(color: AppColors.borderLight, width: 2),
                          ),
                          child: const Icon(Icons.add, color: AppColors.colonyPurple, size: 28),
                        ),
                        const SizedBox(height: 6),
                        Text('Your Story', style: AppTypography.labelSmall.copyWith(color: AppColors.textSecondary)),
                      ],
                    ),
                  );
                }
                return Padding(
                  padding: const EdgeInsets.only(right: 12),
                  child: Column(
                    children: [
                      Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          gradient: index.isOdd ? const LinearGradient(colors: [AppColors.colonyPurple, AppColors.colonyPink]) : null,
                          color: index.isEven ? AppColors.surfaceLight : null,
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: Text('U$index', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text('User $index', style: AppTypography.labelSmall.copyWith(color: AppColors.textSecondary)),
                    ],
                  ),
                );
              },
            ),
          ),
          // Feed placeholder
          const Expanded(
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.dynamic_feed_outlined, size: 48, color: AppColors.textMuted),
                  SizedBox(height: 12),
                  Text('Your feed will appear here', style: TextStyle(color: AppColors.textMuted)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRadarPlaceholder() {
    return const SafeArea(
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.radar, size: 64, color: AppColors.colonyTeal),
            SizedBox(height: 16),
            Text('Radar', style: TextStyle(color: AppColors.textPrimary, fontSize: 24, fontWeight: FontWeight.w700)),
            SizedBox(height: 8),
            Text('Find people nearby', style: TextStyle(color: AppColors.textSecondary)),
          ],
        ),
      ),
    );
  }

  Widget _buildGroupsPlaceholder() {
    return const SafeArea(
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.group_outlined, size: 64, color: AppColors.colonyPurple),
            SizedBox(height: 16),
            Text('Groups', style: TextStyle(color: AppColors.textPrimary, fontSize: 24, fontWeight: FontWeight.w700)),
            SizedBox(height: 8),
            Text('Join local communities', style: TextStyle(color: AppColors.textSecondary)),
          ],
        ),
      ),
    );
  }

  Widget _buildChatPlaceholder() {
    return const SafeArea(
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.chat_bubble_outline, size: 64, color: AppColors.colonyPink),
            SizedBox(height: 16),
            Text('Messages', style: TextStyle(color: AppColors.textPrimary, fontSize: 24, fontWeight: FontWeight.w700)),
            SizedBox(height: 8),
            Text('Your conversations will appear here', style: TextStyle(color: AppColors.textSecondary)),
          ],
        ),
      ),
    );
  }

  Widget _buildDiscoverPlaceholder() {
    return const SafeArea(
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.explore_outlined, size: 64, color: AppColors.colonyBlue),
            SizedBox(height: 16),
            Text('Discover', style: TextStyle(color: AppColors.textPrimary, fontSize: 24, fontWeight: FontWeight.w700)),
            SizedBox(height: 8),
            Text('Explore your neighborhood', style: TextStyle(color: AppColors.textSecondary)),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem(int index, IconData inactiveIcon, IconData activeIcon, String label) {
    final isActive = _currentIndex == index;

    return GestureDetector(
      onTap: () => _onTabTapped(index),
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: isActive ? AppColors.colonyPurple.withValues(alpha: 0.1) : Colors.transparent,
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
          gradient: LinearGradient(colors: [AppColors.colonyPurple, AppColors.colonyPink]),
          shape: BoxShape.circle,
        ),
        child: const Icon(Icons.add, color: Colors.white, size: 28),
      ),
    );
  }
}
