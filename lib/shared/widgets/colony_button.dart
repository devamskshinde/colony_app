import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_gradients.dart';
import '../../core/theme/app_typography.dart';
import 'glassmorphic_container.dart';

/// ColonyButton — Premium gradient button with variants
enum ColonyButtonType { primary, secondary, ghost }

class ColonyButton extends StatefulWidget {
  final String text;
  final VoidCallback? onPressed;
  final ColonyButtonType type;
  final bool isLoading;
  final bool isExpanded;
  final IconData? icon;
  final double? width;
  final double height;
  final double borderRadius;

  const ColonyButton({
    super.key,
    required this.text,
    this.onPressed,
    this.type = ColonyButtonType.primary,
    this.isLoading = false,
    this.isExpanded = true,
    this.icon,
    this.width,
    this.height = 52,
    this.borderRadius = 16,
  });

  @override
  State<ColonyButton> createState() => _ColonyButtonState();
}

class _ColonyButtonState extends State<ColonyButton>
    with SingleTickerProviderStateMixin {
  double _scale = 1.0;

  void _onTapDown(TapDownDetails _) {
    setState(() => _scale = 0.97);
    HapticFeedback.lightImpact();
  }

  void _onTapUp(TapUpDetails _) {
    setState(() => _scale = 1.0);
  }

  void _onTapCancel() {
    setState(() => _scale = 1.0);
  }

  @override
  Widget build(BuildContext context) {
    final enabled = widget.onPressed != null && !widget.isLoading;

    return GestureDetector(
      onTapDown: enabled ? _onTapDown : null,
      onTapUp: enabled ? _onTapUp : null,
      onTapCancel: enabled ? _onTapCancel : null,
      onTap: enabled ? widget.onPressed : null,
      child: AnimatedScale(
        scale: _scale,
        duration: const Duration(milliseconds: 100),
        curve: Curves.easeOut,
        child: _buildButton(enabled),
      ),
    );
  }

  Widget _buildButton(bool enabled) {
    switch (widget.type) {
      case ColonyButtonType.primary:
        return _buildPrimaryButton(enabled);
      case ColonyButtonType.secondary:
        return _buildSecondaryButton(enabled);
      case ColonyButtonType.ghost:
        return _buildGhostButton(enabled);
    }
  }

  Widget _buildPrimaryButton(bool enabled) {
    return Container(
      width: widget.isExpanded ? double.infinity : widget.width,
      height: widget.height,
      decoration: BoxDecoration(
        gradient: enabled
            ? AppGradients.primaryGradient
            : LinearGradient(
                colors: [
                  AppColors.colonyPurple.withValues(alpha: 0.3),
                  AppColors.colonyPink.withValues(alpha: 0.3),
                ],
              ),
        borderRadius: BorderRadius.circular(widget.borderRadius),
        boxShadow: enabled
            ? [
                BoxShadow(
                  color: AppColors.colonyPurple.withValues(alpha: 0.4),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                ),
              ]
            : null,
      ),
      child: Center(child: _buildContent(Colors.white)),
    );
  }

  Widget _buildSecondaryButton(bool enabled) {
    return GlassmorphicContainer(
      width: widget.isExpanded ? double.infinity : widget.width,
      height: widget.height,
      borderRadius: widget.borderRadius,
      opacity: enabled ? 0.08 : 0.03,
      border: Border.all(
        color: enabled
            ? AppColors.colonyPurple.withValues(alpha: 0.5)
            : AppColors.borderLight,
        width: 1.5,
      ),
      child: Center(child: _buildContent(AppColors.textPrimary)),
    );
  }

  Widget _buildGhostButton(bool enabled) {
    return Container(
      width: widget.isExpanded ? double.infinity : widget.width,
      height: widget.height,
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(widget.borderRadius),
      ),
      child: Center(
        child: widget.isLoading
            ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: AppColors.colonyPurple,
                ),
              )
            : ShaderMask(
                shaderCallback: (bounds) => const LinearGradient(
                  colors: [AppColors.colonyPurple, AppColors.colonyPink],
                ).createShader(bounds),
                child: Text(
                  widget.text,
                  style: AppTypography.labelLarge.copyWith(color: Colors.white),
                ),
              ),
      ),
    );
  }

  Widget _buildContent(Color color) {
    if (widget.isLoading) {
      return SizedBox(
        width: 22,
        height: 22,
        child: CircularProgressIndicator(
          strokeWidth: 2.5,
          color: color,
        ),
      );
    }

    if (widget.icon != null) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(widget.icon, color: color, size: 20),
          const SizedBox(width: 8),
          Text(widget.text, style: AppTypography.labelLarge.copyWith(color: color)),
        ],
      );
    }

    return Text(widget.text, style: AppTypography.labelLarge.copyWith(color: color));
  }
}
