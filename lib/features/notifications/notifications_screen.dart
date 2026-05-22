import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../services/analytics_service.dart';
import '../../shared/widgets/colony_avatar.dart';
import '../../shared/widgets/colony_gradient_background.dart';

/// Notifications Screen
class NotificationsScreen extends ConsumerStatefulWidget {
  const NotificationsScreen({super.key});

  @override
  ConsumerState<NotificationsScreen> createState() =>
      _NotificationsScreenState();
}

class _NotificationsScreenState extends ConsumerState<NotificationsScreen> {
  @override
  void initState() {
    super.initState();
    AnalyticsService.trackScreen('notifications');
  }

  @override
  Widget build(BuildContext context) {
    return ColonyGradientBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: const Text('Notifications'),
          actions: [
            TextButton(
              onPressed: () {},
              child: Text(
                'Mark all read',
                style: AppTypography.bodyMedium.copyWith(
                  color: AppColors.colonyViolet,
                ),
              ),
            ),
          ],
        ),
        body: ListView.builder(
          itemCount: 15,
          itemBuilder: (context, index) => _buildNotificationTile(index),
        ),
      ),
    );
  }

  Widget _buildNotificationTile(int index) {
    final isUnread = index < 3;
    final type = _notificationTypes[index % _notificationTypes.length];

    return Container(
      color: isUnread
          ? AppColors.colonyPurple.withValues(alpha: 0.05)
          : null,
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        leading: ColonyAvatar(
          size: AvatarSize.sm,
          isOnline: index.isEven,
          name: 'User $index',
        ),
        title: RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: 'User $index ',
                style: AppTypography.labelLarge.copyWith(
                  fontWeight: isUnread ? FontWeight.w700 : FontWeight.w500,
                ),
              ),
              TextSpan(
                text: type['action'] as String?,
                style: AppTypography.bodyMedium.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
        subtitle: Text(
          '${index + 1}h ago',
          style: AppTypography.bodySmall.copyWith(
            color: AppColors.textMuted,
          ),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (type['hasImage'] == true)
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: AppColors.surfaceLight,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.image_outlined,
                    color: AppColors.textMuted, size: 20),
              ),
            if (isUnread) ...[
              const SizedBox(width: 8),
              Container(
                width: 8,
                height: 8,
                decoration: const BoxDecoration(
                  color: AppColors.colonyPurple,
                  shape: BoxShape.circle,
                ),
              ),
            ],
          ],
        ),
        onTap: () {
          AnalyticsService.trackEvent('notification_tap', properties: {
            'notification_id': 'notif_$index',
            'type': type['type'],
          });
        },
      ),
    );
  }

  static const _notificationTypes = [
    {'type': 'like', 'action': 'liked your post', 'hasImage': true},
    {'type': 'comment', 'action': 'commented on your post', 'hasImage': true},
    {'type': 'follow', 'action': 'started following you', 'hasImage': false},
    {'type': 'mention', 'action': 'mentioned you in a comment', 'hasImage': false},
    {'type': 'group', 'action': 'invited you to a group', 'hasImage': false},
    {'type': 'story', 'action': 'viewed your story', 'hasImage': false},
    {'type': 'like', 'action': 'and 12 others liked your post', 'hasImage': true},
    {'type': 'tag', 'action': 'tagged you in a post', 'hasImage': true},
  ];
}
