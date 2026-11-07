import 'package:flutter/material.dart';
import '../theme/weman_colors.dart';

enum WemanCardVariant { standard, voltAccent, outlined, dark }

/// WEMAN Soft-Texture Card Component
/// Features tactile elevation profiles, 24px border radius, and signature Volt-Green styling.
class WemanCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry? margin;
  final VoidCallback? onTap;
  final WemanCardVariant variant;
  final double borderRadius;
  final double? width;
  final double? height;
  final Color? backgroundColor;

  const WemanCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(20.0),
    this.margin,
    this.onTap,
    this.variant = WemanCardVariant.standard,
    this.borderRadius = 24.0,
    this.width,
    this.height,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    Color cardColor;
    Border? border;
    List<BoxShadow> shadows = [];
    Gradient? gradient;

    switch (variant) {
      case WemanCardVariant.standard:
        cardColor = backgroundColor ?? WemanColors.cardBg;
        border = Border.all(
            color: WemanColors.outlineVariant.withValues(alpha: 0.5), width: 1);
        shadows = [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            offset: const Offset(0, 4),
            blurRadius: 16.0,
          ),
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            offset: const Offset(0, 1),
            blurRadius: 4.0,
          ),
        ];
        break;

      case WemanCardVariant.voltAccent:
        cardColor = backgroundColor ?? WemanColors.cardBg;
        border = Border.all(
            color: WemanColors.voltGreen.withValues(alpha: 0.8), width: 1.5);
        gradient = LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            WemanColors.voltGreen.withValues(alpha: 0.08),
            WemanColors.cardBg,
          ],
        );
        shadows = [
          BoxShadow(
            color: WemanColors.voltGreen.withValues(alpha: 0.12),
            offset: const Offset(0, 6),
            blurRadius: 20.0,
          ),
        ];
        break;

      case WemanCardVariant.outlined:
        cardColor = backgroundColor ?? Colors.transparent;
        border = Border.all(color: WemanColors.outlineVariant, width: 1.2);
        shadows = [];
        break;

      case WemanCardVariant.dark:
        cardColor = backgroundColor ?? WemanColors.darkCard;
        border = Border.all(color: WemanColors.darkSurfaceBorder, width: 1);
        shadows = [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.4),
            offset: const Offset(0, 4),
            blurRadius: 12.0,
          ),
        ];
        break;
    }

    Widget cardWidget = Container(
      width: width,
      height: height,
      margin: margin,
      decoration: BoxDecoration(
        color: cardColor,
        gradient: gradient,
        borderRadius: BorderRadius.circular(borderRadius),
        border: border,
        boxShadow: shadows,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius),
        child: Padding(
          padding: padding,
          child: child,
        ),
      ),
    );

    if (onTap != null) {
      return Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(borderRadius),
          child: cardWidget,
        ),
      );
    }

    return cardWidget;
  }
}
