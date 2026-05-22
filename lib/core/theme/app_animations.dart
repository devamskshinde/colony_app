import 'package:flutter/animation.dart';

/// Colony App Animation Constants
/// Consistent timing and curves for fluid UI
class AppAnimations {
  AppAnimations._();

  // ─── Duration Constants ─────────────────────────────────────
  static const Duration fastDuration = Duration(milliseconds: 150);
  static const Duration normalDuration = Duration(milliseconds: 300);
  static const Duration slowDuration = Duration(milliseconds: 500);
  static const Duration extraSlowDuration = Duration(milliseconds: 800);

  // ─── Curves ─────────────────────────────────────────────────
  static const Curve elasticCurve = Curves.elasticOut;
  static const Curve smoothCurve = Curves.easeInOutCubic;
  static const Curve bounceCurve = Curves.bounceOut;
  static const Curve snappyCurve = Curves.easeOutExpo;
  static const Curve gentleCurve = Curves.easeInOut;

  // ─── Spring Physics ─────────────────────────────────────────
  static const SpringDescription springLight = SpringDescription(
    mass: 1,
    stiffness: 100,
    damping: 10,
  );

  static const SpringDescription springMedium = SpringDescription(
    mass: 1,
    stiffness: 180,
    damping: 15,
  );

  static const SpringDescription springHeavy = SpringDescription(
    mass: 1,
    stiffness: 300,
    damping: 20,
  );

  // ─── Scale Constants ────────────────────────────────────────
  static const double pressScale = 0.97;
  static const double tapScale = 0.98;
  static const double hoverScale = 1.02;
  static const double popScale = 1.05;

  // ─── Stagger Delays ─────────────────────────────────────────
  static Duration staggerDelay(int index, {int baseMs = 50}) =>
      Duration(milliseconds: baseMs * index);

  // ─── Repeat Patterns ────────────────────────────────────────
  static const Duration pulseDuration = Duration(milliseconds: 1500);
  static const Duration shimmerDuration = Duration(milliseconds: 1200);
  static const Duration rippleDuration = Duration(milliseconds: 600);
  static const Duration breatheDuration = Duration(milliseconds: 3000);
}
