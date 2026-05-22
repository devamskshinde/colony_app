import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_gradients.dart';
import '../../core/theme/app_typography.dart';
import '../../services/analytics_service.dart';
import '../../shared/widgets/colony_avatar.dart';
import '../../shared/widgets/colony_gradient_background.dart';
import '../../shared/widgets/glassmorphic_container.dart';

/// Radar Screen — Discover nearby people
class RadarScreen extends ConsumerStatefulWidget {
  const RadarScreen({super.key});

  @override
  ConsumerState<RadarScreen> createState() => _RadarScreenState();
}

class _RadarScreenState extends ConsumerState<RadarScreen>
    with TickerProviderStateMixin {
  late AnimationController _pulseController;
  late AnimationController _rotateController;
  double _radius = 5.0;

  @override
  void initState() {
    super.initState();
    AnalyticsService.trackScreen('radar');

    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();

    _rotateController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat();
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _rotateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ColonyGradientBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: const Text('Radar'),
          actions: [
            IconButton(
              icon: const Icon(Icons.tune),
              onPressed: _showFilterSheet,
            ),
          ],
        ),
        body: Column(
          children: [
            // Radar visualization
            Expanded(
              child: Center(
                child: SizedBox(
                  width: 300,
                  height: 300,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      // Pulse rings
                      ...List.generate(3, (i) {
                        return AnimatedBuilder(
                          animation: _pulseController,
                          builder: (context, child) {
                            final delay = i * 0.3;
                            final value =
                                (_pulseController.value + delay) % 1.0;
                            return Container(
                              width: 150 + (value * 150),
                              height: 150 + (value * 150),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: AppColors.colonyTeal.withValues(
                                    alpha: (1 - value) * 0.3,
                                  ),
                                  width: 1,
                                ),
                              ),
                            );
                          },
                        );
                      }),

                      // Center radar circle
                      Container(
                        width: 150,
                        height: 150,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: AppGradients.radarGradient.scale(0.3),
                          border: Border.all(
                            color: AppColors.colonyTeal.withValues(alpha: 0.5),
                            width: 2,
                          ),
                        ),
                      ),

                      // Rotating sweep line
                      AnimatedBuilder(
                        animation: _rotateController,
                        builder: (context, child) {
                          return Transform.rotate(
                            angle: _rotateController.value * 2 * pi,
                            child: Container(
                              width: 150,
                              height: 2,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    AppColors.colonyTeal.withValues(alpha: 0),
                                    AppColors.colonyTeal,
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),

                      // Center icon
                      Container(
                        width: 48,
                        height: 48,
                        decoration: const BoxDecoration(
                          gradient: AppGradients.radarGradient,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.person_search,
                          color: Colors.white,
                          size: 24,
                        ),
                      ),

                      // Nearby users (random positions)
                      ..._buildNearbyUsers(),
                    ],
                  ),
                ),
              ),
            ),

            // Radius slider
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Row(
                children: [
                  Text('${_radius.toStringAsFixed(1)} km',
                      style: AppTypography.labelLarge),
                  Expanded(
                    child: Slider(
                      value: _radius,
                      min: 0.5,
                      max: 50,
                      onChanged: (val) => setState(() => _radius = val),
                    ),
                  ),
                ],
              ),
            ),

            // Nearby list
            Container(
              height: 200,
              padding: const EdgeInsets.only(top: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Text('Nearby', style: AppTypography.titleMedium),
                  ),
                  const SizedBox(height: 8),
                  Expanded(
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: 8,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          child: GlassmorphicContainer(
                            width: 120,
                            borderRadius: 16,
                            padding: const EdgeInsets.all(12),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                ColonyAvatar(
                                  size: AvatarSize.md,
                                  isOnline: index.isEven,
                                  name: 'Nearby ${index + 1}',
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'User ${index + 1}',
                                  style: AppTypography.labelLarge,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                Text(
                                  '${(index + 1) * 0.3}km away',
                                  style: AppTypography.bodySmall.copyWith(
                                    color: AppColors.textMuted,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 100),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildNearbyUsers() {
    final random = Random(42);
    return List.generate(6, (i) {
      final angle = random.nextDouble() * 2 * pi;
      final distance = 30.0 + random.nextDouble() * 50;
      final x = cos(angle) * distance;
      final y = sin(angle) * distance;

      return Transform.translate(
        offset: Offset(x, y),
        child: ColonyAvatar(
          size: AvatarSize.sm,
          isOnline: i.isEven,
          name: 'U${i + 1}',
        ),
      );
    });
  }

  void _showFilterSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        decoration: const BoxDecoration(
          color: AppColors.bgQuaternary,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Radar Settings', style: AppTypography.titleLarge),
            const SizedBox(height: 16),
            Text('Search Radius', style: AppTypography.labelLarge),
            Slider(
              value: _radius,
              min: 0.5,
              max: 50,
              onChanged: (val) {
                setState(() => _radius = val);
              },
            ),
            Center(
              child: Text('${_radius.toStringAsFixed(1)} km',
                  style: AppTypography.bodyMedium),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
