import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_gradients.dart';
import 'colony_shimmer.dart';

/// ColonyAvatar — Gradient-bordered avatar with status indicators
enum AvatarSize { xs, sm, md, lg, xl, xxl }

class ColonyAvatar extends StatelessWidget {
  final String? imageUrl;
  final String? name;
  final AvatarSize size;
  final bool isOnline;
  final bool hasStory;
  final bool isVerified;
  final bool isGrayedOut;
  final VoidCallback? onTap;

  const ColonyAvatar({
    super.key,
    this.imageUrl,
    this.name,
    this.size = AvatarSize.md,
    this.isOnline = false,
    this.hasStory = false,
    this.isVerified = false,
    this.isGrayedOut = false,
    this.onTap,
  });

  double get _diameter => switch (size) {
        AvatarSize.xs => 24,
        AvatarSize.sm => 36,
        AvatarSize.md => 48,
        AvatarSize.lg => 64,
        AvatarSize.xl => 96,
        AvatarSize.xxl => 128,
      };

  double get _borderWidth => switch (size) {
        AvatarSize.xs => 1.5,
        AvatarSize.sm => 2,
        AvatarSize.md => 2.5,
        AvatarSize.lg => 3,
        AvatarSize.xl => 3.5,
        AvatarSize.xxl => 4,
      };

  double get _indicatorSize => switch (size) {
        AvatarSize.xs => 6,
        AvatarSize.sm => 8,
        AvatarSize.md => 10,
        AvatarSize.lg => 12,
        AvatarSize.xl => 14,
        AvatarSize.xxl => 16,
      };

  double get _badgeSize => switch (size) {
        AvatarSize.xs => 0,
        AvatarSize.sm => 12,
        AvatarSize.md => 14,
        AvatarSize.lg => 16,
        AvatarSize.xl => 20,
        AvatarSize.xxl => 24,
      };

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        width: _diameter + _borderWidth * 2 + 4,
        height: _diameter + _borderWidth * 2 + 4,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            // Avatar with gradient border
            Container(
              width: _diameter + _borderWidth * 2,
              height: _diameter + _borderWidth * 2,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: hasStory
                    ? AppGradients.storyGradient
                    : const LinearGradient(
                        colors: [AppColors.borderLight, AppColors.borderLight],
                      ),
              ),
              padding: EdgeInsets.all(_borderWidth),
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.bgSecondary,
                ),
                clipBehavior: Clip.antiAlias,
                child: ColorFiltered(
                  colorFilter: isGrayedOut
                      ? const ColorFilter.matrix([
                          0.2126, 0.7152, 0.0722, 0, 0,
                          0.2126, 0.7152, 0.0722, 0, 0,
                          0.2126, 0.7152, 0.0722, 0, 0,
                          0, 0, 0, 1, 0,
                        ])
                      : const ColorFilter.mode(
                          Colors.transparent, BlendMode.dst),
                  child: imageUrl != null
                      ? CachedNetworkImage(
                          imageUrl: imageUrl!,
                          fit: BoxFit.cover,
                          placeholder: (_, __) => ColonyShimmer(
                            width: _diameter,
                            height: _diameter,
                            borderRadius: _diameter / 2,
                          ),
                          errorWidget: (_, __, ___) => _buildPlaceholder(),
                        )
                      : _buildPlaceholder(),
                ),
              ),
            ),

            // Online indicator
            if (isOnline)
              Positioned(
                right: 0,
                bottom: 0,
                child: Container(
                  width: _indicatorSize,
                  height: _indicatorSize,
                  decoration: BoxDecoration(
                    color: AppColors.online,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: AppColors.bgPrimary,
                      width: 2,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.online.withValues(alpha: 0.5),
                        blurRadius: 6,
                      ),
                    ],
                  ),
                ),
              ),

            // Verified badge
            if (isVerified && _badgeSize > 0)
              Positioned(
                right: -2,
                top: -2,
                child: Container(
                  width: _badgeSize,
                  height: _badgeSize,
                  decoration: const BoxDecoration(
                    color: AppColors.colonyBlue,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.check,
                    color: Colors.white,
                    size: _badgeSize * 0.65,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildPlaceholder() {
    final initials = name != null && name!.isNotEmpty
        ? name!.trim().split(' ').take(2).map((e) => e[0]).join().toUpperCase()
        : '?';

    return Container(
      width: _diameter,
      height: _diameter,
      decoration: const BoxDecoration(
        gradient: AppGradients.primaryGradient,
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Text(
          initials,
          style: TextStyle(
            color: Colors.white,
            fontSize: _diameter * 0.38,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}
