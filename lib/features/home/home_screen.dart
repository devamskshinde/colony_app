import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../services/analytics_service.dart';
import '../../shared/widgets/colony_avatar.dart';
import '../../shared/widgets/colony_card.dart';
import '../../shared/widgets/colony_gradient_background.dart';
import '../../shared/widgets/colony_shimmer.dart';

/// Home Screen — Main feed with stories bar
class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  final _scrollController = ScrollController();
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    AnalyticsService.trackScreen('home');

    // Simulate loading
    Future.delayed(const Duration(seconds: 1), () {
      if (mounted) setState(() => _isLoading = false);
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ColonyGradientBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: ShaderMask(
            shaderCallback: (bounds) => const LinearGradient(
              colors: [AppColors.colonyPurple, AppColors.colonyPink],
            ).createShader(bounds),
            child: Text(
              'Colony',
              style: AppTypography.headlineLarge.copyWith(color: Colors.white),
            ),
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.notifications_outlined),
              onPressed: () => Navigator.pushNamed(context, '/notifications'),
            ),
            IconButton(
              icon: const Icon(Icons.chat_bubble_outline),
              onPressed: () => Navigator.pushNamed(context, '/chat'),
            ),
          ],
        ),
        body: _isLoading
            ? _buildLoadingState()
            : RefreshIndicator(
                onRefresh: _refresh,
                child: CustomScrollView(
                  controller: _scrollController,
                  slivers: [
                    // Stories Bar
                    SliverToBoxAdapter(child: _buildStoriesBar()),
                    // Feed
                    SliverList.builder(
                      itemCount: 10,
                      itemBuilder: (context, index) => _buildPostCard(index),
                    ),
                    const SliverToBoxAdapter(
                      child: SizedBox(height: 100),
                    ),
                  ],
                ),
              ),
      ),
    );
  }

  Widget _buildStoriesBar() {
    return SizedBox(
      height: 100,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: 10,
        itemBuilder: (context, index) {
          if (index == 0) {
            // Add story button
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
                      border: Border.all(
                        color: AppColors.borderLight,
                        width: 2,
                      ),
                    ),
                    child: const Icon(
                      Icons.add,
                      color: AppColors.colonyPurple,
                      size: 28,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Your Story',
                    style: AppTypography.labelSmall.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            );
          }

          return Padding(
            padding: const EdgeInsets.only(right: 12),
            child: Column(
              children: [
                ColonyAvatar(
                  size: AvatarSize.lg,
                  hasStory: index.isOdd,
                  isOnline: index.isEven,
                  name: 'User $index',
                ),
                const SizedBox(height: 4),
                Text(
                  'User $index',
                  style: AppTypography.labelSmall.copyWith(
                    color: AppColors.textSecondary,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildPostCard(int index) {
    return ColonyCard(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                ColonyAvatar(
                  size: AvatarSize.sm,
                  isOnline: index.isEven,
                  name: 'User $index',
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('User $index',
                          style: AppTypography.labelLarge),
                      Text('2h ago · Andheri West',
                          style: AppTypography.bodySmall.copyWith(
                            color: AppColors.textMuted,
                          )),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.more_vert, size: 20),
                  onPressed: () {},
                  color: AppColors.textMuted,
                ),
              ],
            ),
          ),

          // Image placeholder
          Container(
            height: 250,
            width: double.infinity,
            color: AppColors.surfaceLight,
            child: const Center(
              child: Icon(Icons.image_outlined,
                  color: AppColors.textMuted, size: 48),
            ),
          ),

          // Action bar
          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                _buildAction(Icons.favorite_border, '128'),
                const SizedBox(width: 16),
                _buildAction(Icons.chat_bubble_outline, '24'),
                const SizedBox(width: 16),
                _buildAction(Icons.send_outlined, '5'),
                const Spacer(),
                _buildAction(Icons.bookmark_border, ''),
              ],
            ),
          ),

          // Caption
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
            child: Text(
              'Exploring the streets of Mumbai! The energy here is unmatched.',
              style: AppTypography.bodyMedium,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAction(IconData icon, String count) {
    return GestureDetector(
      onTap: () {},
      child: Row(
        children: [
          Icon(icon, size: 22, color: AppColors.textSecondary),
          if (count.isNotEmpty) ...[
            const SizedBox(width: 4),
            Text(count, style: AppTypography.bodySmall),
          ],
        ],
      ),
    );
  }

  Widget _buildLoadingState() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: 3,
      itemBuilder: (context, index) => const Padding(
        padding: EdgeInsets.only(bottom: 16),
        child: ColonyShimmerPost(),
      ),
    );
  }

  Future<void> _refresh() async {
    await Future.delayed(const Duration(seconds: 1));
    AnalyticsService.trackEvent('feed_refresh');
  }
}
