import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../core/utils/date_utils.dart';
import '../../services/analytics_service.dart';
import '../../shared/widgets/colony_avatar.dart';
import '../../shared/widgets/colony_gradient_background.dart';
import '../../shared/widgets/colony_shimmer.dart';

/// Chat List Screen — All conversations
class ChatListScreen extends ConsumerStatefulWidget {
  const ChatListScreen({super.key});

  @override
  ConsumerState<ChatListScreen> createState() => _ChatListScreenState();
}

class _ChatListScreenState extends ConsumerState<ChatListScreen> {
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    AnalyticsService.trackScreen('chat_list');
    Future.delayed(const Duration(milliseconds: 800), () {
      if (mounted) setState(() => _isLoading = false);
    });
  }

  @override
  Widget build(BuildContext context) {
    return ColonyGradientBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: const Text('Messages'),
          actions: [
            IconButton(
              icon: const Icon(Icons.edit_outlined),
              onPressed: () {},
            ),
          ],
        ),
        body: _isLoading
            ? ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: 8,
                itemBuilder: (_, __) => const Padding(
                  padding: EdgeInsets.only(bottom: 12),
                  child: Row(
                    children: [
                      ColonyShimmerBox(
                          width: 48, height: 48, shape: BoxShape.circle),
                      SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ColonyShimmerText(width: 120),
                            SizedBox(height: 6),
                            ColonyShimmerText(width: 180),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              )
            : ListView.builder(
                itemCount: 15,
                itemBuilder: (context, index) => _buildConversationTile(index),
              ),
      ),
    );
  }

  Widget _buildConversationTile(int index) {
    final unread = index < 3;

    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      leading: ColonyAvatar(
        size: AvatarSize.md,
        isOnline: index.isEven,
        name: 'Contact $index',
      ),
      title: Text(
        'Contact $index',
        style: AppTypography.labelLarge.copyWith(
          fontWeight: unread ? FontWeight.w700 : FontWeight.w500,
        ),
      ),
      subtitle: Text(
        'Hey, are you coming to the meetup tonight?',
        style: AppTypography.bodySmall.copyWith(
          color: unread ? AppColors.textSecondary : AppColors.textMuted,
          fontWeight: unread ? FontWeight.w500 : FontWeight.w400,
        ),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      trailing: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            ColonyDateUtils.timeAgo(
              DateTime.now().subtract(Duration(hours: index + 1)),
            ),
            style: AppTypography.bodySmall.copyWith(
              color: unread ? AppColors.colonyPurple : AppColors.textMuted,
            ),
          ),
          if (unread) ...[
            const SizedBox(height: 4),
            Container(
              width: 20,
              height: 20,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [AppColors.colonyPurple, AppColors.colonyPink],
                ),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  '${index + 1}',
                  style: AppTypography.labelSmall.copyWith(
                    color: Colors.white,
                    fontSize: 10,
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
      onTap: () {
        AnalyticsService.trackEvent('chat_open', properties: {
          'conversation_id': 'conv_$index',
        });
      },
    );
  }
}
