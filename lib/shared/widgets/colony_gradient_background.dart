import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';

/// ColonyGradientBackground — Mesh gradient background
class ColonyGradientBackground extends StatelessWidget {
  final Widget child;
  final bool showMesh;

  const ColonyGradientBackground({
    super.key,
    required this.child,
    this.showMesh = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.bgPrimary,
      ),
      child: Stack(
        children: [
          if (showMesh) ...[
            // Purple mesh
            Positioned(
              top: -100,
              right: -50,
              child: Container(
                width: 400,
                height: 400,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      AppColors.colonyPurple.withValues(alpha: 0.08),
                      AppColors.colonyPurple.withValues(alpha: 0),
                    ],
                  ),
                ),
              ),
            ),
            // Pink mesh
            Positioned(
              bottom: -100,
              left: -50,
              child: Container(
                width: 350,
                height: 350,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      AppColors.colonyPink.withValues(alpha: 0.05),
                      AppColors.colonyPink.withValues(alpha: 0),
                    ],
                  ),
                ),
              ),
            ),
          ],
          child,
        ],
      ),
    );
  }
}
