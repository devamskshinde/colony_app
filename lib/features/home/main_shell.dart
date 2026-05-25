import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../core/theme/app_gradients.dart';
import '../../core/config/remote_config.dart';
import '../../services/analytics_service.dart';
import '../../shared/providers/app_providers.dart';

/// Main Shell — Bottom navigation with real backend data
class MainShell extends ConsumerStatefulWidget {
  const MainShell({super.key});

  @override
  ConsumerState<MainShell> createState() => _MainShellState();
}

class _MainShellState extends ConsumerState<MainShell> {
  int _currentIndex = 0;

  void _onTabTapped(int index) {
    if (index == 2) {
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
    final configAsync = ref.watch(remoteConfigProvider);
    final config = configAsync.whenOrNull(data: (c) => c) ?? RemoteConfig.defaults();

    final hasRadar = config.isFeatureEnabled('feature_radar', 'free');
    final hasGroups = config.isFeatureEnabled('feature_groups', 'free');
    final hasChat = config.isFeatureEnabled('feature_chat', 'free');
    final hasDiscovery = config.isFeatureEnabled('feature_discovery', 'free');

    return Scaffold(
      backgroundColor: AppColors.bgPrimary,
      body: _buildBody(),
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
                if (hasRadar) _buildNavItem(1, Icons.radar_outlined, Icons.radar, 'Radar'),
                _buildStoriesButton(),
                if (hasGroups) _buildNavItem(3, Icons.group_outlined, Icons.group, 'Groups'),
                if (hasChat) _buildNavItem(4, Icons.chat_bubble_outline, Icons.chat_bubble, 'Chat'),
                if (hasDiscovery) _buildNavItem(5, Icons.explore_outlined, Icons.explore, 'Discover'),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBody() {
    switch (_currentIndex) {
      case 0: return _buildHomeFeed();
      case 1: return _buildRadarTab();
      case 3: return _buildEmptyState(Icons.group_outlined, 'Groups', 'Join local communities', AppColors.colonyPurple);
      case 4: return _buildEmptyState(Icons.chat_bubble_outline, 'Messages', 'Your conversations will appear here', AppColors.colonyPink);
      case 5: return _buildEmptyState(Icons.explore_outlined, 'Discover', 'Explore your neighborhood', AppColors.colonyBlue);
      default: return _buildHomeFeed();
    }
  }

  // ─── Home Feed — real profile data from backend ───────────
  Widget _buildHomeFeed() {
    final profileAsync = ref.watch(userProfileProvider);

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
                  child: Text('Colony', style: AppTypography.headlineLarge.copyWith(color: Colors.white)),
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

          // Profile card from backend
          profileAsync.when(
            loading: () => const Padding(
              padding: EdgeInsets.all(32),
              child: Center(child: CircularProgressIndicator(color: AppColors.colonyPurple)),
            ),
            error: (e, _) => Padding(
              padding: const EdgeInsets.all(32),
              child: Column(
                children: [
                  const Icon(Icons.wifi_off, size: 48, color: AppColors.textMuted),
                  const SizedBox(height: 12),
                  Text('Could not load profile', style: AppTypography.bodyMedium.copyWith(color: AppColors.textMuted)),
                  const SizedBox(height: 8),
                  TextButton(
                    onPressed: () => ref.invalidate(userProfileProvider),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            ),
            data: (profile) {
              if (profile == null) {
                return Padding(
                  padding: const EdgeInsets.all(32),
                  child: Column(
                    children: [
                      Container(
                        width: 80, height: 80,
                        decoration: BoxDecoration(
                          gradient: AppGradients.primaryGradient,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.person, size: 40, color: Colors.white),
                      ),
                      const SizedBox(height: 16),
                      Text('Welcome to Colony!', style: AppTypography.titleLarge),
                      const SizedBox(height: 8),
                      Text('Complete your profile to get started', style: AppTypography.bodyMedium.copyWith(color: AppColors.textSecondary)),
                    ],
                  ),
                );
              }

              final name = profile['display_name'] ?? 'User';
              final username = profile['username'] ?? '';
              final score = profile['colony_score'] ?? 0;
              final tier = profile['subscription_tier'] ?? 'free';

              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 16),
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppColors.surfaceLight,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: AppColors.borderLight),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 56, height: 56,
                      decoration: BoxDecoration(
                        gradient: AppGradients.primaryGradient,
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Text(name[0].toUpperCase(), style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.w700)),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(name, style: AppTypography.titleMedium),
                          if (username.isNotEmpty)
                            Text('@$username', style: AppTypography.bodySmall.copyWith(color: AppColors.textMuted)),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              _buildBadge(tier),
                              const SizedBox(width: 8),
                              Icon(Icons.star, size: 14, color: AppColors.colonyAmber),
                              const SizedBox(width: 4),
                              Text('$score', style: AppTypography.labelSmall.copyWith(color: AppColors.colonyAmber)),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),

          const SizedBox(height: 24),

          // Section header
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Text('Nearby People', style: AppTypography.titleMedium),
                const Spacer(),
                Text('Refresh', style: AppTypography.bodySmall.copyWith(color: AppColors.colonyPurple)),
              ],
            ),
          ),
          const SizedBox(height: 12),

          // Nearby users from backend
          Expanded(
            child: ref.watch(nearbyUsersProvider).when(
              loading: () => const Center(child: CircularProgressIndicator(color: AppColors.colonyPurple)),
              error: (e, _) => Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.wifi_off, size: 48, color: AppColors.textMuted),
                    const SizedBox(height: 12),
                    Text('Could not load nearby people', style: AppTypography.bodyMedium.copyWith(color: AppColors.textMuted)),
                    const SizedBox(height: 8),
                    TextButton(
                      onPressed: () => ref.invalidate(nearbyUsersProvider),
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              ),
              data: (users) {
                if (users.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.people_outline, size: 48, color: AppColors.textMuted),
                        const SizedBox(height: 12),
                        Text('No one nearby yet', style: AppTypography.bodyMedium.copyWith(color: AppColors.textMuted)),
                        const SizedBox(height: 8),
                        Text('Check back later or expand your radius', style: AppTypography.bodySmall.copyWith(color: AppColors.textMuted)),
                      ],
                    ),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: users.length,
                  itemBuilder: (context, index) {
                    final user = users[index] as Map<String, dynamic>;
                    final name = user['display_name'] ?? 'Unknown';
                    final username = user['username'] ?? '';
                    final distance = user['distance_km'];
                    final userTier = user['subscription_tier'] ?? 'free';

                    return Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppColors.surfaceLight,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: AppColors.borderLight),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 48, height: 48,
                            decoration: BoxDecoration(
                              gradient: AppGradients.primaryGradient,
                              shape: BoxShape.circle,
                            ),
                            child: Center(
                              child: Text(name[0].toUpperCase(), style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(name, style: AppTypography.bodyLarge.copyWith(fontWeight: FontWeight.w600)),
                                if (username.isNotEmpty)
                                  Text('@$username', style: AppTypography.bodySmall.copyWith(color: AppColors.textMuted)),
                              ],
                            ),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              if (distance != null)
                                Text('${distance.toStringAsFixed(1)} km', style: AppTypography.labelSmall.copyWith(color: AppColors.colonyTeal)),
                              const SizedBox(height: 4),
                              _buildBadge(userTier),
                            ],
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  // ─── Radar Tab — real nearby users with distance ──────────
  Widget _buildRadarTab() {
    final nearbyAsync = ref.watch(nearbyUsersProvider);

    return SafeArea(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text('Radar', style: AppTypography.headlineLarge),
          ),
          // Radar visualization
          Container(
            width: 200, height: 200,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.colonyTeal.withValues(alpha: 0.3), width: 2),
            ),
            child: Center(
              child: Container(
                width: 120, height: 120,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.colonyTeal.withValues(alpha: 0.2), width: 1),
                ),
                child: Center(
                  child: Container(
                    width: 60, height: 60,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.colonyTeal.withValues(alpha: 0.1),
                    ),
                    child: const Icon(Icons.my_location, color: AppColors.colonyTeal, size: 28),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          nearbyAsync.when(
            loading: () => const CircularProgressIndicator(color: AppColors.colonyTeal),
            error: (e, _) => Text('Could not load nearby users', style: AppTypography.bodyMedium.copyWith(color: AppColors.textMuted)),
            data: (users) => Text('${users.length} people nearby', style: AppTypography.titleMedium.copyWith(color: AppColors.colonyTeal)),
          ),
          const SizedBox(height: 24),
          Expanded(
            child: nearbyAsync.when(
              loading: () => const SizedBox(),
              error: (_, __) => const SizedBox(),
              data: (users) => ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: users.length,
                itemBuilder: (context, index) {
                  final user = users[index] as Map<String, dynamic>;
                  return _buildNearbyUserCard(user);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNearbyUserCard(Map<String, dynamic> user) {
    final name = user['display_name'] ?? 'Unknown';
    final distance = user['distance_km'];

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.surfaceLight,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Container(
            width: 8, height: 8,
            decoration: const BoxDecoration(color: AppColors.colonyTeal, shape: BoxShape.circle),
          ),
          const SizedBox(width: 12),
          Expanded(child: Text(name, style: AppTypography.bodyMedium)),
          if (distance != null)
            Text('${distance.toStringAsFixed(1)} km', style: AppTypography.bodySmall.copyWith(color: AppColors.colonyTeal)),
        ],
      ),
    );
  }

  Widget _buildEmptyState(IconData icon, String title, String subtitle, Color color) {
    return SafeArea(
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 64, color: color),
            const SizedBox(height: 16),
            Text(title, style: AppTypography.headlineMedium.copyWith(color: AppColors.textPrimary)),
            const SizedBox(height: 8),
            Text(subtitle, style: AppTypography.bodyMedium.copyWith(color: AppColors.textSecondary)),
            const SizedBox(height: 16),
            Text('Coming soon — backend endpoint needed', style: AppTypography.bodySmall.copyWith(color: AppColors.textMuted)),
          ],
        ),
      ),
    );
  }

  Widget _buildBadge(String tier) {
    final isPremium = tier == 'premium' || tier == 'premium_plus';
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        gradient: isPremium ? AppGradients.primaryGradient : null,
        color: isPremium ? null : AppColors.surfaceMedium,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        isPremium ? 'PRO' : tier.toUpperCase(),
        style: AppTypography.labelSmall.copyWith(
          color: isPremium ? Colors.white : AppColors.textMuted,
          fontSize: 10,
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
            Icon(isActive ? activeIcon : inactiveIcon, color: isActive ? AppColors.colonyPurple : AppColors.textMuted, size: 24),
            const SizedBox(height: 2),
            Text(label, style: AppTypography.labelSmall.copyWith(color: isActive ? AppColors.colonyPurple : AppColors.textMuted, fontSize: 10)),
          ],
        ),
      ),
    );
  }

  Widget _buildStoriesButton() {
    return GestureDetector(
      onTap: () => _onTabTapped(2),
      child: Container(
        width: 48, height: 48,
        decoration: const BoxDecoration(
          gradient: LinearGradient(colors: [AppColors.colonyPurple, AppColors.colonyPink]),
          shape: BoxShape.circle,
        ),
        child: const Icon(Icons.add, color: Colors.white, size: 28),
      ),
    );
  }
}
