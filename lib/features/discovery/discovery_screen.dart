import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../services/analytics_service.dart';
import '../../shared/widgets/colony_avatar.dart';
import '../../shared/widgets/colony_gradient_background.dart';

/// Discovery Screen — Explore trending content and people
class DiscoveryScreen extends ConsumerStatefulWidget {
  const DiscoveryScreen({super.key});

  @override
  ConsumerState<DiscoveryScreen> createState() => _DiscoveryScreenState();
}

class _DiscoveryScreenState extends ConsumerState<DiscoveryScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    AnalyticsService.trackScreen('discovery');
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ColonyGradientBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: const Text('Discover'),
          bottom: TabBar(
            controller: _tabController,
            tabs: const [
              Tab(text: 'Trending'),
              Tab(text: 'Nearby'),
              Tab(text: 'For You'),
            ],
          ),
        ),
        body: TabBarView(
          controller: _tabController,
          children: [
            _buildTrendingTab(),
            _buildNearbyTab(),
            _buildForYouTab(),
          ],
        ),
      ),
    );
  }

  Widget _buildTrendingTab() {
    return GridView.builder(
      padding: const EdgeInsets.all(8),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 2,
        mainAxisSpacing: 2,
      ),
      itemCount: 18,
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () {
            AnalyticsService.trackEvent('trending_post_tap');
          },
          child: Container(
            decoration: BoxDecoration(
              color: AppColors.surfaceLight,
              borderRadius: BorderRadius.circular(4),
            ),
            child: Stack(
              fit: StackFit.expand,
              children: [
                const Center(
                  child: Icon(Icons.image_outlined,
                      color: AppColors.textMuted, size: 32),
                ),
                Positioned(
                  bottom: 4,
                  left: 4,
                  child: Row(
                    children: [
                      const Icon(Icons.favorite,
                          color: Colors.white, size: 14),
                      const SizedBox(width: 2),
                      Text(
                        '${(index + 1) * 42}',
                        style: AppTypography.labelSmall.copyWith(
                          color: Colors.white,
                          fontSize: 10,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildNearbyTab() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: 12,
      itemBuilder: (context, index) {
        return ListTile(
          contentPadding: const EdgeInsets.symmetric(vertical: 4),
          leading: ColonyAvatar(
            size: AvatarSize.md,
            isOnline: index.isEven,
            name: 'Nearby ${index + 1}',
          ),
          title: Text('Nearby User ${index + 1}',
              style: AppTypography.labelLarge),
          subtitle: Text(
            '${(index + 1) * 0.5}km away · ${index * 3} mutual friends',
            style: AppTypography.bodySmall.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          trailing: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [AppColors.colonyPurple, AppColors.colonyPink],
              ),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text('Connect',
                style: AppTypography.labelSmall.copyWith(
                  color: Colors.white,
                )),
          ),
        );
      },
    );
  }

  Widget _buildForYouTab() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: 8,
      itemBuilder: (context, index) {
        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          height: 200,
          decoration: BoxDecoration(
            color: AppColors.surfaceLight,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.explore_outlined,
                    color: AppColors.textMuted, size: 48),
                const SizedBox(height: 8),
                Text('Recommended for you',
                    style: AppTypography.bodyMedium.copyWith(
                      color: AppColors.textSecondary,
                    )),
              ],
            ),
          ),
        );
      },
    );
  }
}
