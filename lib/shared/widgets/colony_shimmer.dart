import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_animations.dart';

/// ColonyShimmer — Dark shimmer loading placeholder
/// Purple-tinted shimmer sweep matching content shapes
class ColonyShimmer extends StatelessWidget {
  final double width;
  final double height;
  final double borderRadius;

  const ColonyShimmer({
    super.key,
    required this.width,
    required this.height,
    this.borderRadius = 8,
  });

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: AppColors.shimmerBase,
      highlightColor: AppColors.shimmerHighlight,
      period: AppAnimations.shimmerDuration,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: AppColors.shimmerBase,
          borderRadius: BorderRadius.circular(borderRadius),
        ),
      ),
    );
  }
}

/// Pre-built shimmer shapes for common content
class ColonyShimmerBox extends StatelessWidget {
  final double? width;
  final double? height;
  final double borderRadius;
  final BoxShape shape;

  const ColonyShimmerBox({
    super.key,
    this.width,
    this.height,
    this.borderRadius = 8,
    this.shape = BoxShape.rectangle,
  });

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: AppColors.shimmerBase,
      highlightColor: AppColors.shimmerHighlight,
      period: AppAnimations.shimmerDuration,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: AppColors.shimmerBase,
          shape: shape,
          borderRadius:
              shape == BoxShape.circle ? null : BorderRadius.circular(borderRadius),
        ),
      ),
    );
  }
}

/// Shimmer for text lines
class ColonyShimmerText extends StatelessWidget {
  final double width;
  final double height;

  const ColonyShimmerText({
    super.key,
    this.width = 120,
    this.height = 14,
  });

  @override
  Widget build(BuildContext context) {
    return ColonyShimmerBox(
      width: width,
      height: height,
      borderRadius: 4,
    );
  }
}

/// Shimmer for post card
class ColonyShimmerPost extends StatelessWidget {
  const ColonyShimmerPost({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header row
          const Row(
            children: [
              ColonyShimmerBox(width: 40, height: 40, shape: BoxShape.circle),
              SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ColonyShimmerText(width: 100, height: 12),
                  SizedBox(height: 6),
                  ColonyShimmerText(width: 60, height: 10),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),
          // Image placeholder
          ColonyShimmerBox(
            width: double.infinity,
            height: 200,
            borderRadius: 12,
          ),
          const SizedBox(height: 12),
          // Action bar
          Row(
            children: [
              const ColonyShimmerBox(width: 60, height: 28, borderRadius: 14),
              const SizedBox(width: 12),
              const ColonyShimmerBox(width: 60, height: 28, borderRadius: 14),
              const SizedBox(width: 12),
              const ColonyShimmerBox(width: 60, height: 28, borderRadius: 14),
            ],
          ),
        ],
      ),
    );
  }
}
