import 'package:flutter/material.dart';
import '../theme/weman_colors.dart';
import '../theme/weman_typography.dart';

class WemanAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String? title;
  final bool showBrandLogo;
  final Widget? leading;
  final List<Widget>? actions;
  final bool isDark;
  final String? locationBadge;

  const WemanAppBar({
    super.key,
    this.title,
    this.showBrandLogo = true,
    this.leading,
    this.actions,
    this.isDark = false,
    this.locationBadge,
  });

  @override
  Size get preferredSize => const Size.fromHeight(64.0);

  @override
  Widget build(BuildContext context) {
    Color bg = isDark ? WemanColors.darkBackground : WemanColors.surface;
    Color fg = isDark ? Colors.white : WemanColors.onSurface;

    Widget titleWidget;
    if (showBrandLogo) {
      titleWidget = Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: WemanColors.voltGreen,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              'WEMAN',
              style: WemanTypography.headlineMedium.copyWith(
                color: WemanColors.onSurface,
                fontWeight: FontWeight.w900,
                letterSpacing: 1.2,
              ),
            ),
          ),
          if (locationBadge != null) ...[
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                color: isDark
                    ? WemanColors.darkCard
                    : WemanColors.surfaceContainerHigh,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.location_on,
                      size: 12, color: WemanColors.primary),
                  const SizedBox(width: 4),
                  Text(
                    locationBadge!,
                    style: WemanTypography.labelSmall.copyWith(
                      color: fg,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      );
    } else {
      titleWidget = Text(
        title ?? '',
        style: WemanTypography.headlineMedium.copyWith(
          color: fg,
          fontWeight: FontWeight.w700,
        ),
      );
    }

    return AppBar(
      backgroundColor: bg,
      elevation: 0,
      centerTitle: false,
      leading: leading,
      title: titleWidget,
      actions: actions ??
          [
            IconButton(
              icon: Icon(Icons.notifications_none_rounded, color: fg),
              onPressed: () {},
            ),
            const SizedBox(width: 8),
          ],
    );
  }
}
