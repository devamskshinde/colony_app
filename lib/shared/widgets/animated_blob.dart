import 'dart:math';
import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';

/// AnimatedBlob — Organic morphing background decoration
/// Slowly morphs and moves with semi-transparent purple/pink
class AnimatedBlob extends StatefulWidget {
  final double size;
  final Color? color1;
  final Color? color2;
  final Duration duration;
  final Offset? position;

  const AnimatedBlob({
    super.key,
    this.size = 300,
    this.color1,
    this.color2,
    this.duration = const Duration(seconds: 8),
    this.position,
  });

  @override
  State<AnimatedBlob> createState() => _AnimatedBlobState();
}

class _AnimatedBlobState extends State<AnimatedBlob>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    )..repeat(reverse: true);

    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final c1 = widget.color1 ?? AppColors.colonyPurple.withValues(alpha: 0.15);
    final c2 = widget.color2 ?? AppColors.colonyPink.withValues(alpha: 0.1);

    return Positioned(
      top: widget.position?.dy,
      left: widget.position?.dx,
      child: AnimatedBuilder(
        animation: _animation,
        builder: (context, child) {
          return Transform.scale(
            scale: 0.8 + (_animation.value * 0.3),
            child: Transform.rotate(
              angle: _animation.value * pi * 0.2,
              child: Container(
                width: widget.size,
                height: widget.size,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [c1, c2, c2.withValues(alpha: 0)],
                    stops: const [0.0, 0.5, 1.0],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

/// Stack of mesh blobs for rich background
class ColonyMeshBackground extends StatelessWidget {
  final Widget child;

  const ColonyMeshBackground({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Top-right purple blob
        const AnimatedBlob(
          size: 400,
          color1: Color(0x207C3AED),
          color2: Color(0x107C3AED),
          position: Offset(100, -100),
          duration: Duration(seconds: 10),
        ),
        // Bottom-left pink blob
        const AnimatedBlob(
          size: 350,
          color1: Color(0x18EC4899),
          color2: Color(0x08EC4899),
          position: Offset(-100, 400),
          duration: Duration(seconds: 12),
        ),
        // Center teal blob
        const AnimatedBlob(
          size: 250,
          color1: Color(0x1014B8A6),
          color2: Color(0x0514B8A6),
          position: Offset(200, 250),
          duration: Duration(seconds: 14),
        ),
        child,
      ],
    );
  }
}
