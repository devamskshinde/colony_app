import 'package:flutter/material.dart';
import 'app_colors.dart';

/// Colony App Gradient Definitions
/// Rich gradients for premium dark UI feel
class AppGradients {
  AppGradients._();

  // ─── Primary Gradients ──────────────────────────────────────
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [AppColors.colonyPurple, AppColors.colonyPink],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient primaryHorizontal = LinearGradient(
    colors: [AppColors.colonyPurple, AppColors.colonyPink],
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  );

  static const LinearGradient primaryVertical = LinearGradient(
    colors: [AppColors.colonyPurple, AppColors.colonyPink],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  // ─── Radar Gradient ─────────────────────────────────────────
  static const LinearGradient radarGradient = LinearGradient(
    colors: [AppColors.colonyTeal, AppColors.colonyBlue],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // ─── Gold Gradient ──────────────────────────────────────────
  static const LinearGradient goldGradient = LinearGradient(
    colors: [AppColors.colonyAmber, AppColors.colonyRed],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // ─── Dark Gradient ──────────────────────────────────────────
  static const LinearGradient darkGradient = LinearGradient(
    colors: [AppColors.bgPrimary, AppColors.bgTertiary],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  // ─── Glass Gradient ─────────────────────────────────────────
  static const LinearGradient glassGradient = LinearGradient(
    colors: [
      Color(0x0DFFFFFF),
      Color(0x05FFFFFF),
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // ─── Time-based Gradients ───────────────────────────────────
  static const LinearGradient sunriseGradient = LinearGradient(
    colors: [Color(0xFFFF6B6B), Color(0xFFFFE66D)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient nightGradient = LinearGradient(
    colors: [AppColors.bgPrimary, Color(0x407C3AED)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  // ─── Story Gradient ─────────────────────────────────────────
  static const LinearGradient storyGradient = LinearGradient(
    colors: [AppColors.storyRingStart, AppColors.storyRingEnd],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // ─── Online Indicator Gradient ──────────────────────────────
  static const LinearGradient onlineGradient = LinearGradient(
    colors: [AppColors.colonyTeal, AppColors.colonyGreen],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  // ─── Mesh Gradient (for backgrounds) ────────────────────────
  static RadialGradient meshPurple = RadialGradient(
    center: const Alignment(-0.5, -0.5),
    radius: 1.5,
    colors: [
      AppColors.colonyPurple.withValues(alpha: 0.15),
      AppColors.colonyPurple.withValues(alpha: 0.0),
    ],
  );

  static RadialGradient meshPink = RadialGradient(
    center: const Alignment(0.5, 0.5),
    radius: 1.5,
    colors: [
      AppColors.colonyPink.withValues(alpha: 0.1),
      AppColors.colonyPink.withValues(alpha: 0.0),
    ],
  );

  static RadialGradient meshTeal = RadialGradient(
    center: const Alignment(0.0, 0.8),
    radius: 1.2,
    colors: [
      AppColors.colonyTeal.withValues(alpha: 0.08),
      AppColors.colonyTeal.withValues(alpha: 0.0),
    ],
  );
}
