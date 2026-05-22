import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

/// Colony App Typography System
/// Primary: Plus Jakarta Sans | Secondary: Space Grotesk (numbers/stats)
class AppTypography {
  AppTypography._();

  static TextStyle get _baseJakarta => GoogleFonts.plusJakartaSans();
  static TextStyle get _baseSpaceGrotesk => GoogleFonts.spaceGrotesk();

  // ─── Display Styles ─────────────────────────────────────────
  static TextStyle get displayLarge => _baseJakarta.copyWith(
        fontSize: 32,
        fontWeight: FontWeight.w800,
        height: 1.2,
        letterSpacing: -0.5,
      );

  static TextStyle get displayMedium => _baseJakarta.copyWith(
        fontSize: 28,
        fontWeight: FontWeight.w700,
        height: 1.25,
        letterSpacing: -0.3,
      );

  // ─── Headline Styles ────────────────────────────────────────
  static TextStyle get headlineLarge => _baseJakarta.copyWith(
        fontSize: 24,
        fontWeight: FontWeight.w700,
        height: 1.3,
      );

  static TextStyle get headlineMedium => _baseJakarta.copyWith(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        height: 1.35,
      );

  // ─── Title Styles ───────────────────────────────────────────
  static TextStyle get titleLarge => _baseJakarta.copyWith(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        height: 1.4,
      );

  static TextStyle get titleMedium => _baseJakarta.copyWith(
        fontSize: 16,
        fontWeight: FontWeight.w500,
        height: 1.45,
      );

  // ─── Body Styles ────────────────────────────────────────────
  static TextStyle get bodyLarge => _baseJakarta.copyWith(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        height: 1.5,
      );

  static TextStyle get bodyMedium => _baseJakarta.copyWith(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        height: 1.5,
      );

  static TextStyle get bodySmall => _baseJakarta.copyWith(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        height: 1.5,
      );

  // ─── Label Styles ───────────────────────────────────────────
  static TextStyle get labelLarge => _baseJakarta.copyWith(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        height: 1.4,
      );

  static TextStyle get labelSmall => _baseJakarta.copyWith(
        fontSize: 11,
        fontWeight: FontWeight.w500,
        height: 1.4,
        letterSpacing: 0.5,
      );

  // ─── Number/Stats Styles (Space Grotesk) ────────────────────
  static TextStyle get numberLarge => _baseSpaceGrotesk.copyWith(
        fontSize: 32,
        fontWeight: FontWeight.w700,
        height: 1.2,
      );

  static TextStyle get numberMedium => _baseSpaceGrotesk.copyWith(
        fontSize: 24,
        fontWeight: FontWeight.w600,
        height: 1.25,
      );

  static TextStyle get numberSmall => _baseSpaceGrotesk.copyWith(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        height: 1.3,
      );

  // ─── Semantic Helpers ───────────────────────────────────────
  static TextStyle primary(TextStyle base) =>
      base.copyWith(color: AppColors.textPrimary);

  static TextStyle secondary(TextStyle base) =>
      base.copyWith(color: AppColors.textSecondary);

  static TextStyle muted(TextStyle base) =>
      base.copyWith(color: AppColors.textMuted);

  static TextStyle accent(TextStyle base) =>
      base.copyWith(color: AppColors.textAccent);

  static TextStyle gradient(TextStyle base) => base.copyWith(
        foreground: Paint()
          ..shader = const LinearGradient(
            colors: [AppColors.colonyPurple, AppColors.colonyPink],
          ).createShader(const Rect.fromLTWH(0, 0, 200, 50)),
      );
}
