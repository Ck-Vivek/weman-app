import 'package:flutter/material.dart';
import '../theme/weman_colors.dart';
import '../theme/weman_typography.dart';

enum WemanButtonVariant { voltPrimary, dark, outlined, ghost }

class WemanButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final WemanButtonVariant variant;
  final Widget? icon;
  final bool isLoading;
  final double? width;
  final double height;
  final double borderRadius;

  const WemanButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.variant = WemanButtonVariant.voltPrimary,
    this.icon,
    this.isLoading = false,
    this.width,
    this.height = 54.0,
    this.borderRadius = 28.0,
  });

  @override
  Widget build(BuildContext context) {
    Color bg;
    Color fg;
    BorderSide? border;

    switch (variant) {
      case WemanButtonVariant.voltPrimary:
        bg = WemanColors.voltGreen;
        fg = WemanColors.onSurface;
        break;
      case WemanButtonVariant.dark:
        bg = WemanColors.onSurface;
        fg = Colors.white;
        break;
      case WemanButtonVariant.outlined:
        bg = Colors.transparent;
        fg = WemanColors.onSurface;
        border =
            const BorderSide(color: WemanColors.outlineVariant, width: 1.5);
        break;
      case WemanButtonVariant.ghost:
        bg = Colors.transparent;
        fg = WemanColors.onSurface;
        break;
    }

    Widget content = isLoading
        ? SizedBox(
            width: 24,
            height: 24,
            child: CircularProgressIndicator(
              strokeWidth: 2.5,
              valueColor: AlwaysStoppedAnimation<Color>(fg),
            ),
          )
        : Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (icon != null) ...[
                icon!,
                const SizedBox(width: 8),
              ],
              Text(
                text,
                style: WemanTypography.labelLarge.copyWith(
                  color: fg,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          );

    return SizedBox(
      width: width,
      height: height,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: bg,
          foregroundColor: fg,
          elevation: 0,
          shadowColor: Colors.transparent,
          side: border,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24),
        ),
        child: content,
      ),
    );
  }
}
