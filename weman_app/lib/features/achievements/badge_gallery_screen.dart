import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/weman_colors.dart';

class BadgeItem {
  final String title;
  final String category;
  final String description;
  final IconData icon;
  final bool isEarned;
  final bool isInProgress;
  final double progress;

  BadgeItem({
    required this.title,
    required this.category,
    required this.description,
    required this.icon,
    required this.isEarned,
    this.isInProgress = false,
    required this.progress,
  });
}

class BadgeGalleryScreen extends StatefulWidget {
  const BadgeGalleryScreen({super.key});

  @override
  State<BadgeGalleryScreen> createState() => _BadgeGalleryScreenState();
}

class _BadgeGalleryScreenState extends State<BadgeGalleryScreen> {
  String _selectedCategory = 'all';

  final List<BadgeItem> _badges = [
    BadgeItem(
      title: 'First Workout',
      category: 'workouts',
      description: 'Logged first athletic training session.',
      icon: Icons.fitness_center,
      isEarned: true,
      progress: 1.0,
    ),
    BadgeItem(
      title: '7-Day Streak',
      category: 'streaks',
      description: 'Maintained training momentum for 7 consecutive days.',
      icon: Icons.local_fire_department,
      isEarned: true,
      progress: 1.0,
    ),
    BadgeItem(
      title: '30-Day Consist',
      category: 'consistency',
      description: 'Complete 30 days of workouts or mobility work.',
      icon: Icons.shield,
      isEarned: false,
      isInProgress: true,
      progress: 0.60,
    ),
    BadgeItem(
      title: '10k Steps Club',
      category: 'running',
      description: 'Logged 10,000 steps in a single training day.',
      icon: Icons.directions_run,
      isEarned: true,
      progress: 1.0,
    ),
    BadgeItem(
      title: 'Heavy Lifter',
      category: 'workouts',
      description: 'Achieved 100kg+ squat or 180kg deadlift lockout.',
      icon: Icons.hardware,
      isEarned: true,
      progress: 1.0,
    ),
    BadgeItem(
      title: 'Century Ride',
      category: 'challenges',
      description: 'Cover 100km total cardio training in a single month.',
      icon: Icons.pedal_bike,
      isEarned: false,
      progress: 0.40,
    ),
    BadgeItem(
      title: 'Early Bird',
      category: 'consistency',
      description: 'Crushed 5 morning sessions before 7:00 AM.',
      icon: Icons.wb_sunny,
      isEarned: true,
      progress: 1.0,
    ),
    BadgeItem(
      title: 'Iron Master',
      category: 'milestones',
      description: 'Rank among top 15 lifters statewide in Karnataka.',
      icon: Icons.military_tech,
      isEarned: false,
      progress: 0.15,
    ),
  ];

  void _showBadgeDetail(BadgeItem badge) {
    showModalBottomSheet(
      context: context,
      backgroundColor: WemanColors.surfaceWhite,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: badge.isEarned
                    ? WemanColors.neonLime
                    : WemanColors.surfaceContainerHigh,
                shape: BoxShape.circle,
              ),
              child: Icon(
                badge.icon,
                size: 32,
                color: WemanColors.onSurface,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              badge.title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w800,
                color: WemanColors.onSurface,
              ),
            ),
            const SizedBox(height: 4),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
              decoration: BoxDecoration(
                color: badge.isEarned
                    ? WemanColors.softLime
                    : WemanColors.surfaceContainerHigh,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                badge.isEarned
                    ? 'EARNED & VERIFIED'
                    : badge.isInProgress
                        ? 'IN PROGRESS (60%)'
                        : 'LOCKED',
                style: const TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w800,
                  color: WemanColors.onSurface,
                ),
              ),
            ),
            const SizedBox(height: 12),
            Text(
              badge.description,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 13,
                color: WemanColors.secondary,
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(ctx),
                style: ElevatedButton.styleFrom(
                  backgroundColor: WemanColors.onSurface,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                ),
                child: const Text('DISMISS'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final filtered = _selectedCategory == 'all'
        ? _badges
        : _badges
            .where((b) => b.category.toLowerCase() == _selectedCategory)
            .toList();

    return Scaffold(
      backgroundColor: WemanColors.surface,
      appBar: AppBar(
        backgroundColor: WemanColors.surface.withValues(alpha: 0.95),
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: WemanColors.onSurface),
          onPressed: () => context.pop(),
        ),
        title: const Text(
          'Profile Badges',
          style: TextStyle(
            color: WemanColors.onSurface,
            fontWeight: FontWeight.w700,
            fontSize: 18,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.send_outlined, color: WemanColors.onSurface),
            onPressed: () => context.push('/inbox'),
          ),
          IconButton(
            icon: const Icon(Icons.info_outline, color: WemanColors.onSurface),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(bottom: 24),
        child: Column(
          children: [
            // Hero Progress Card
            Padding(
              padding: const EdgeInsets.all(16),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: WemanColors.surfaceWhite,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.03),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(4),
                                  decoration: const BoxDecoration(
                                    color: WemanColors.neonLime,
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(
                                    Icons.military_tech,
                                    size: 14,
                                    color: WemanColors.onSurface,
                                  ),
                                ),
                                const SizedBox(width: 6),
                                const Text(
                                  'PROGRESS TIER',
                                  style: TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.w800,
                                    color: WemanColors.deepMoss,
                                    letterSpacing: 0.5,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            const Text(
                              'Level 24 Master',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w800,
                                color: WemanColors.onSurface,
                              ),
                            ),
                            const SizedBox(height: 2),
                            const Text(
                              '16 of 42 Unlocked (38% Cleared)',
                              style: TextStyle(
                                fontSize: 11,
                                color: WemanColors.secondary,
                              ),
                            ),
                          ],
                        ),
                        // Circular percentage
                        const Stack(
                          alignment: Alignment.center,
                          children: [
                            SizedBox(
                              width: 54,
                              height: 54,
                              child: CircularProgressIndicator(
                                value: 0.38,
                                strokeWidth: 5,
                                backgroundColor:
                                    WemanColors.surfaceContainerHigh,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  WemanColors.neonLime,
                                ),
                              ),
                            ),
                            Text(
                              '38%',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w800,
                                color: WemanColors.onSurface,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),

                    // Quick Stats Strip
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 10,
                      ),
                      decoration: BoxDecoration(
                        color: WemanColors.surface,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          _buildStatItem('Earned', '16', WemanColors.onSurface),
                          _buildStatItem('Active', '04', WemanColors.deepMoss),
                          _buildStatItem('Locked', '22', WemanColors.secondary),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Category Filter Pills
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  _buildFilterPill('all', 'ALL (42)'),
                  const SizedBox(width: 8),
                  _buildFilterPill('workouts', 'WORKOUTS'),
                  const SizedBox(width: 8),
                  _buildFilterPill('consistency', 'CONSISTENCY'),
                  const SizedBox(width: 8),
                  _buildFilterPill('streaks', 'STREAKS'),
                  const SizedBox(width: 8),
                  _buildFilterPill('running', 'RUNNING'),
                  const SizedBox(width: 8),
                  _buildFilterPill('challenges', 'CHALLENGES'),
                  const SizedBox(width: 8),
                  _buildFilterPill('milestones', 'MILESTONES'),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // 2-Column Badges Grid
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: filtered.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  childAspectRatio: 0.95,
                ),
                itemBuilder: (ctx, idx) {
                  final badge = filtered[idx];
                  return InkWell(
                    onTap: () => _showBadgeDetail(badge),
                    borderRadius: BorderRadius.circular(16),
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: WemanColors.surfaceWhite,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.02),
                            blurRadius: 6,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: badge.isEarned
                                      ? WemanColors.softLime
                                      : WemanColors.surface,
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  badge.icon,
                                  size: 20,
                                  color: badge.isEarned
                                      ? WemanColors.onSurface
                                      : WemanColors.secondary,
                                ),
                              ),
                              if (badge.isEarned)
                                Container(
                                  width: 8,
                                  height: 8,
                                  decoration: const BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: WemanColors.neonLime,
                                  ),
                                ),
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  if (badge.isEarned)
                                    const Icon(
                                      Icons.verified,
                                      size: 13,
                                      color: WemanColors.deepMoss,
                                    ),
                                  if (badge.isEarned) const SizedBox(width: 4),
                                  Text(
                                    badge.isEarned
                                        ? 'EARNED'
                                        : badge.isInProgress
                                            ? 'IN PROGRESS'
                                            : 'LOCKED',
                                    style: TextStyle(
                                      fontSize: 9,
                                      fontWeight: FontWeight.w800,
                                      color: badge.isEarned
                                          ? WemanColors.deepMoss
                                          : WemanColors.secondary,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 2),
                              Text(
                                badge.title,
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w800,
                                  color: WemanColors.onSurface,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 2),
                              Text(
                                badge.description,
                                style: const TextStyle(
                                  fontSize: 10,
                                  color: WemanColors.secondary,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                          Column(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(3),
                                child: LinearProgressIndicator(
                                  value: badge.progress,
                                  minHeight: 4,
                                  backgroundColor:
                                      WemanColors.surfaceContainerHigh,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    badge.isEarned
                                        ? WemanColors.neonLime
                                        : WemanColors.secondary,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 2),
                              Align(
                                alignment: Alignment.centerRight,
                                child: Text(
                                  '${(badge.progress * 100).toInt()}%',
                                  style: TextStyle(
                                    fontSize: 9,
                                    fontWeight: FontWeight.w700,
                                    color: badge.isEarned
                                        ? WemanColors.deepMoss
                                        : WemanColors.secondary,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(String label, String value, Color color) {
    return Column(
      children: [
        Text(
          label.toUpperCase(),
          style: const TextStyle(
            fontSize: 9,
            fontWeight: FontWeight.w700,
            color: WemanColors.secondary,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w800,
            color: color,
          ),
        ),
      ],
    );
  }

  Widget _buildFilterPill(String id, String label) {
    final isSelected = _selectedCategory == id;
    return GestureDetector(
      onTap: () => setState(() => _selectedCategory = id),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected ? WemanColors.onSurface : WemanColors.surfaceWhite,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.02),
              blurRadius: 4,
            ),
          ],
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w700,
            color: isSelected ? WemanColors.neonLime : WemanColors.secondary,
            letterSpacing: 0.5,
          ),
        ),
      ),
    );
  }
}
