import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../theme/weman_colors.dart';
import '../theme/weman_typography.dart';

class WemanDrawer extends StatelessWidget {
  const WemanDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: WemanColors.surface,
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Header
            Container(
              padding: const EdgeInsets.all(24),
              decoration: const BoxDecoration(
                color: WemanColors.surfaceContainerLow,
                border: Border(
                  bottom: BorderSide(color: WemanColors.surfaceContainerHigh),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: WemanColors.voltGreen,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          'WEMAN FIT',
                          style: WemanTypography.headlineMedium.copyWith(
                            fontWeight: FontWeight.w900,
                            letterSpacing: 1.2,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'KARNATAKA',
                        style: WemanTypography.labelSmall.copyWith(
                          fontWeight: FontWeight.w700,
                          color: WemanColors.primary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Campus Gym Network',
                    style: WemanTypography.titleMedium,
                  ),
                  Text(
                    'Connected to 14 Student Gyms',
                    style: WemanTypography.bodySmall,
                  ),
                ],
              ),
            ),

            // Navigation Items
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(vertical: 12),
                children: [
                  _buildDrawerItem(
                    icon: Icons.dynamic_feed_rounded,
                    title: 'Campus Social Feed',
                    onTap: () {
                      Navigator.pop(context);
                      context.go('/feed');
                    },
                  ),
                  _buildDrawerItem(
                    icon: Icons.fitness_center_rounded,
                    title: 'Fitness Hub',
                    badge: 'NEW',
                    onTap: () {
                      Navigator.pop(context);
                      context.go('/fitness-hub');
                    },
                  ),
                  _buildDrawerItem(
                    icon: Icons.person_rounded,
                    title: 'Athlete Profile & My Space',
                    onTap: () {
                      Navigator.pop(context);
                      context.go('/profile');
                    },
                  ),
                  _buildDrawerItem(
                    icon: Icons.explore_rounded,
                    title: 'Explore Exercises & Gyms',
                    onTap: () {
                      Navigator.pop(context);
                      context.go('/explore');
                    },
                  ),
                  _buildDrawerItem(
                    icon: Icons.play_circle_fill_rounded,
                    title: 'Gym Reels Player',
                    badge: 'LIVE',
                    onTap: () {
                      Navigator.pop(context);
                      context.go('/reels');
                    },
                  ),
                  _buildDrawerItem(
                    icon: Icons.school_rounded,
                    title: 'My College Hub (CMRIT / CEC)',
                    onTap: () {
                      Navigator.pop(context);
                    },
                  ),
                  _buildDrawerItem(
                    icon: Icons.history_edu_rounded,
                    title: 'Offline Workout Logs',
                    onTap: () {
                      Navigator.pop(context);
                    },
                  ),
                  const Divider(
                      color: WemanColors.surfaceContainerHigh, height: 32),
                  _buildDrawerItem(
                    icon: Icons.translate_rounded,
                    title: 'Language (English / ಕನ್ನಡ)',
                    trailing:
                        Text('EN/ಕನ್ನಡ', style: WemanTypography.labelSmall),
                    onTap: () {
                      // Toggle locale
                    },
                  ),
                  _buildDrawerItem(
                    icon: Icons.shield_outlined,
                    title: 'Safety & Moderation Policy',
                    onTap: () {},
                  ),
                  _buildDrawerItem(
                    icon: Icons.logout_rounded,
                    title: 'Sign Out',
                    textColor: WemanColors.error,
                    onTap: () {
                      Navigator.pop(context);
                      context.go('/login');
                    },
                  ),
                ],
              ),
            ),

            // Footer
            Padding(
              padding: const EdgeInsets.all(20),
              child: Text(
                'WEMAN v3.0 • Karnataka Pilot\nDecoupled Polyglot Architecture',
                style: WemanTypography.labelSmall.copyWith(
                  color: WemanColors.textMuted,
                  fontSize: 10,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDrawerItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    String? badge,
    Widget? trailing,
    Color? textColor,
  }) {
    return ListTile(
      leading: Icon(icon, color: textColor ?? WemanColors.onSurface),
      title: Text(
        title,
        style: WemanTypography.titleMedium.copyWith(
          color: textColor ?? WemanColors.onSurface,
          fontWeight: FontWeight.w600,
        ),
      ),
      trailing: badge != null
          ? Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: WemanColors.voltGreen,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                badge,
                style: WemanTypography.labelSmall.copyWith(
                  fontWeight: FontWeight.w800,
                  color: WemanColors.onSurface,
                ),
              ),
            )
          : trailing,
      onTap: onTap,
    );
  }
}
