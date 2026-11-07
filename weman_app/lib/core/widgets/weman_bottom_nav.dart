import 'package:flutter/material.dart';
import '../theme/weman_colors.dart';
import '../theme/weman_typography.dart';

class WemanBottomNav extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const WemanBottomNav({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: WemanColors.cardBg.withValues(alpha: 0.95),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            offset: const Offset(0, -3),
            blurRadius: 16,
          ),
        ],
        border: const Border(
          top: BorderSide(color: WemanColors.surfaceContainerHigh, width: 1),
        ),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem(
                0,
                Icons.home_rounded,
                Icons.home_outlined,
                'Home',
              ),
              _buildNavItem(
                1,
                Icons.fitness_center_rounded,
                Icons.fitness_center_outlined,
                'Hub',
              ),
              _buildNavItem(
                2,
                Icons.play_circle_rounded,
                Icons.play_circle_outline_rounded,
                'Reels',
              ),
              _buildNavItem(
                3,
                Icons.explore_rounded,
                Icons.explore_outlined,
                'Explore',
              ),
              _buildNavItem(
                4,
                Icons.person_rounded,
                Icons.person_outline_rounded,
                'Profile',
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(
    int index,
    IconData selectedIcon,
    IconData unselectedIcon,
    String label,
  ) {
    final isSelected = currentIndex == index;
    return InkWell(
      onTap: () => onTap(index),
      borderRadius: BorderRadius.circular(20),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isSelected ? selectedIcon : unselectedIcon,
              size: 24,
              color: isSelected ? WemanColors.onSurface : WemanColors.textMuted,
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: WemanTypography.labelSmall.copyWith(
                color:
                    isSelected ? WemanColors.onSurface : WemanColors.textMuted,
                fontWeight: isSelected ? FontWeight.w800 : FontWeight.w500,
                fontSize: 11,
              ),
            ),
            const SizedBox(height: 2),
            // Stitch Active Volt Dot Indicator
            Container(
              width: 5,
              height: 5,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isSelected ? WemanColors.neonLime : Colors.transparent,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
