import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import 'colony_button.dart';

/// ColonyDialog — Premium dark dialog
class ColonyDialog extends StatelessWidget {
  final String? title;
  final String? message;
  final Widget? content;
  final String? primaryAction;
  final String? secondaryAction;
  final VoidCallback? onPrimary;
  final VoidCallback? onSecondary;
  final IconData? icon;
  final Color? iconColor;

  const ColonyDialog({
    super.key,
    this.title,
    this.message,
    this.content,
    this.primaryAction,
    this.secondaryAction,
    this.onPrimary,
    this.onSecondary,
    this.icon,
    this.iconColor,
  });

  static Future<bool?> confirm(
    BuildContext context, {
    required String title,
    required String message,
    String confirmText = 'Confirm',
    String cancelText = 'Cancel',
  }) {
    return showDialog<bool>(
      context: context,
      builder: (_) => ColonyDialog(
        title: title,
        message: message,
        primaryAction: confirmText,
        secondaryAction: cancelText,
        onPrimary: () => Navigator.pop(context, true),
        onSecondary: () => Navigator.pop(context, false),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: AppColors.bgTertiary,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Icon
            if (icon != null) ...[
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: (iconColor ?? AppColors.colonyPurple).withValues(alpha: 0.15),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  icon,
                  color: iconColor ?? AppColors.colonyPurple,
                  size: 28,
                ),
              ),
              const SizedBox(height: 16),
            ],

            // Title
            if (title != null) ...[
              Text(
                title!,
                style: AppTypography.titleLarge,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
            ],

            // Message
            if (message != null) ...[
              Text(
                message!,
                style: AppTypography.bodyMedium.copyWith(
                  color: AppColors.textSecondary,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
            ],

            // Custom content
            if (content != null) ...[
              content!,
              const SizedBox(height: 24),
            ],

            // Actions
            if (primaryAction != null || secondaryAction != null)
              Row(
                children: [
                  if (secondaryAction != null)
                    Expanded(
                      child: ColonyButton(
                        text: secondaryAction!,
                        type: ColonyButtonType.secondary,
                        onPressed: onSecondary ?? () => Navigator.pop(context),
                      ),
                    ),
                  if (secondaryAction != null && primaryAction != null)
                    const SizedBox(width: 12),
                  if (primaryAction != null)
                    Expanded(
                      child: ColonyButton(
                        text: primaryAction!,
                        onPressed: onPrimary ?? () => Navigator.pop(context),
                      ),
                    ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
