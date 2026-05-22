import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../services/analytics_service.dart';
import '../../shared/widgets/colony_card.dart';
import '../../shared/widgets/colony_gradient_background.dart';

/// Groups Screen — Local community groups
class GroupsScreen extends ConsumerStatefulWidget {
  const GroupsScreen({super.key});

  @override
  ConsumerState<GroupsScreen> createState() => _GroupsScreenState();
}

class _GroupsScreenState extends ConsumerState<GroupsScreen> {
  @override
  void initState() {
    super.initState();
    AnalyticsService.trackScreen('groups');
  }

  @override
  Widget build(BuildContext context) {
    return ColonyGradientBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: const Text('Groups'),
          actions: [
            IconButton(
              icon: const Icon(Icons.add_circle_outline),
              onPressed: () {},
            ),
          ],
        ),
        body: ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: 10,
          itemBuilder: (context, index) => _buildGroupCard(index),
        ),
      ),
    );
  }

  Widget _buildGroupCard(int index) {
    final memberCount = (index + 1) * 12;

    return ColonyCard(
      margin: const EdgeInsets.only(bottom: 12),
      onTap: () {
        AnalyticsService.trackEvent('group_open', properties: {
          'group_id': 'group_$index',
        });
      },
      child: Row(
        children: [
          // Group avatar
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppColors.colonyPurple.withValues(alpha: 0.8),
                  AppColors.colonyPink.withValues(alpha: 0.8),
                ],
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Center(
              child: Text(
                'G${index + 1}',
                style: AppTypography.titleLarge.copyWith(
                  color: Colors.white,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),

          // Group info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _groupNames[index % _groupNames.length],
                  style: AppTypography.labelLarge,
                ),
                const SizedBox(height: 4),
                Text(
                  '$memberCount members · ${index.isEven ? 'Public' : 'Private'}',
                  style: AppTypography.bodySmall.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'Active ${index + 1}h ago',
                  style: AppTypography.bodySmall.copyWith(
                    color: AppColors.textMuted,
                  ),
                ),
              ],
            ),
          ),

          // Join / Joined button
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              gradient: index < 3
                  ? const LinearGradient(
                      colors: [AppColors.colonyPurple, AppColors.colonyPink])
                  : null,
              color: index >= 3 ? AppColors.surfaceLight : null,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              index < 3 ? 'Joined' : 'Join',
              style: AppTypography.labelSmall.copyWith(
                color: index < 3 ? Colors.white : AppColors.textSecondary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  static const _groupNames = [
    'Andheri West Locals',
    'Mumbai Foodies',
    'Bandra Meetups',
    'Colony Developers',
    'Fitness Mumbai',
    'Pet Parents India',
    'Mumbai Cyclists',
    'Book Club India',
    'Photography Walks',
    'Street Food Hunters',
  ];
}
