import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/demo_state/demo_state.dart';
import '../../core/theme/weman_colors.dart';
import '../../core/theme/weman_typography.dart';
import '../../core/widgets/weman_bottom_nav.dart';
import 'my_space_screen.dart';
import 'widgets/edit_profile_sheet.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  int _selectedTab = 0; // 0: Activity, 1: Workouts, 2: Achievements
  int _fistbumpCount = 48;
  bool _hasFistbumped = false;

  void _openMySpace([int section = 0]) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => MySpaceScreen(initialSection: section),
      ),
    );
  }

  void _openEditProfileSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const EditProfileSheet(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final telemetry = ref.watch(workoutTelemetryProvider);
    final profile = ref.watch(userProfileProvider);

    return Scaffold(
      backgroundColor: WemanColors.surface,
      body: SafeArea(
        child: Column(
          children: [
            _buildTopAppBar(),
            Expanded(
              child: SingleChildScrollView(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _buildMySpacePortalBanner(),
                    const SizedBox(height: 14),
                    _buildIdentityHeaderCard(profile),
                    const SizedBox(height: 14),
                    _buildTelemetryDashboard(telemetry),
                    const SizedBox(height: 14),
                    _buildRankHierarchyCard(),
                    const SizedBox(height: 14),
                    _buildTabSegment(),
                    const SizedBox(height: 12),
                    _buildTabContent(telemetry),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: WemanBottomNav(
        currentIndex: 4,
        onTap: (index) {
          if (index == 0) context.go('/feed');
          if (index == 1) context.go('/fitness-hub');
          if (index == 2) context.go('/reels');
          if (index == 3) context.go('/explore');
          if (index == 4) {}
        },
      ),
    );
  }

  Widget _buildTopAppBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: const BoxDecoration(
        color: WemanColors.cardBg,
        border: Border(
          bottom: BorderSide(color: WemanColors.surfaceContainerHigh),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                width: 8,
                height: 8,
                decoration: const BoxDecoration(
                  color: WemanColors.neonLime,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                'WEMAN FIT',
                style: WemanTypography.labelSmall.copyWith(
                  fontWeight: FontWeight.w900,
                  letterSpacing: 1.1,
                ),
              ),
              const SizedBox(width: 6),
              Text(
                '/',
                style: WemanTypography.labelSmall.copyWith(
                  color: WemanColors.textMuted,
                ),
              ),
              const SizedBox(width: 6),
              Text(
                'PROFILE',
                style: WemanTypography.labelSmall.copyWith(
                  color: WemanColors.textMuted,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
          Row(
            children: [
              IconButton(
                onPressed: () => context.push('/rankings'),
                icon: const Icon(
                  Icons.leaderboard_outlined,
                  color: WemanColors.onSurface,
                  size: 20,
                ),
                tooltip: 'Leaderboard',
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
              const SizedBox(width: 8),
              IconButton(
                onPressed: () => context.push('/badge-gallery'),
                icon: const Icon(
                  Icons.military_tech_outlined,
                  color: WemanColors.onSurface,
                  size: 20,
                ),
                tooltip: 'Badges',
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
              const SizedBox(width: 8),
              GestureDetector(
                onTap: () => _openMySpace(0),
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: WemanColors.surfaceContainerLow,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: WemanColors.surfaceContainerHigh),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.dashboard_customize_rounded,
                        size: 14,
                        color: WemanColors.primary,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        'My Space',
                        style: WemanTypography.labelSmall.copyWith(
                          fontWeight: FontWeight.w800,
                          fontSize: 10,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 6),
              IconButton(
                onPressed: () => _openMySpace(5), // open Settings
                icon: const Icon(
                  Icons.settings_rounded,
                  color: WemanColors.textMuted,
                  size: 20,
                ),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // --- MY SPACE PORTAL QUICK ACCESS BANNER ---
  Widget _buildMySpacePortalBanner() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: WemanColors.cardBg,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: WemanColors.surfaceContainerHigh),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    width: 28,
                    height: 28,
                    decoration: BoxDecoration(
                      color: WemanColors.softLime,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(
                      Icons.menu_open_rounded,
                      size: 17,
                      color: WemanColors.onPrimaryContainer,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'MY SPACE PORTAL',
                        style: WemanTypography.labelSmall.copyWith(
                          fontWeight: FontWeight.w800,
                          letterSpacing: 0.8,
                          fontSize: 11,
                        ),
                      ),
                      Text(
                        'Quick athlete center & workspace',
                        style: WemanTypography.labelSmall.copyWith(
                          color: WemanColors.textMuted,
                          fontSize: 9,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: WemanColors.neonLime,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  'ACTIVE SYNC',
                  style: WemanTypography.labelSmall.copyWith(
                    fontSize: 8,
                    fontWeight: FontWeight.w900,
                    color: WemanColors.onPrimaryContainer,
                    letterSpacing: 0.6,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildPortalItem(Icons.trending_up_rounded, 'Activity', 0),
              _buildPortalItem(Icons.bookmark_rounded, 'Saved', 1),
              _buildPortalItem(Icons.fitness_center_rounded, 'History', 2),
              _buildPortalItem(Icons.shield_rounded, 'Privacy', 3),
              _buildPortalItem(Icons.notifications_rounded, 'Alerts', 4),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPortalItem(IconData icon, String label, int sectionIndex) {
    return GestureDetector(
      onTap: () => _openMySpace(sectionIndex),
      child: Column(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: WemanColors.surfaceContainerLow,
              shape: BoxShape.circle,
              border: Border.all(color: WemanColors.surfaceContainerHigh),
            ),
            child: Icon(icon, size: 20, color: WemanColors.onSurface),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: WemanTypography.labelSmall.copyWith(
              fontSize: 10,
              fontWeight: FontWeight.w700,
              color: WemanColors.onSurface,
            ),
          ),
        ],
      ),
    );
  }

  // --- PROFILE IDENTITY HEADER CARD ---
  Widget _buildIdentityHeaderCard(UserProfile profile) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: WemanColors.cardBg,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: WemanColors.surfaceContainerHigh),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 12,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Profile Photo with Neon-Lime Ring & Master Athlete Emblem
              Stack(
                clipBehavior: Clip.none,
                children: [
                  Container(
                    width: 86,
                    height: 86,
                    padding: const EdgeInsets.all(3.5),
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        colors: [
                          WemanColors.neonLime,
                          Color(0xFFE0FF60),
                          WemanColors.neonLime,
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                    child: Container(
                      padding: const EdgeInsets.all(2),
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: WemanColors.cardBg,
                      ),
                      child: ClipOval(
                        child: Image.asset(
                          'assets/images/pavan_avatar.png',
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => Image.network(
                            'https://lh3.googleusercontent.com/aida-public/AB6AXuCw9tWt1jbtoNP4HQgEBwNCu_YIWEwuGdjH79xR0vUtuLEDI83Tie2rDAtpig0Smh1H4FggzH1O89O0HKBGZ-5C4dRpf_BCK9u9zO21uWurwtPGvKc4URxQpt3GqWyCatoBecOMgbJiXWFvkGzURnxrmqn6WvopbWZjEGRR6An28H92HkAgUu12MRf5szsUKVLSrOrtHJHJ2tepmY212pBJDZRoIlZhvHLFPbRCkaCxhptqaUKUQ6nS',
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      width: 26,
                      height: 26,
                      decoration: BoxDecoration(
                        color: WemanColors.neonLime,
                        shape: BoxShape.circle,
                        border: Border.all(color: WemanColors.cardBg, width: 2),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.1),
                            blurRadius: 4,
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.workspace_premium_rounded,
                        size: 15,
                        color: WemanColors.onPrimaryContainer,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          profile.name,
                          style: WemanTypography.headlineSmall.copyWith(
                            fontWeight: FontWeight.w900,
                            letterSpacing: -0.5,
                          ),
                        ),
                        const SizedBox(width: 8),
                        GestureDetector(
                          onTap: () => context.push('/badge-gallery'),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 7, vertical: 2),
                            decoration: BoxDecoration(
                              color: WemanColors.neonLime,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(Icons.bolt_rounded,
                                    size: 12,
                                    color: WemanColors.onPrimaryContainer),
                                const SizedBox(width: 2),
                                Text(
                                  profile.athleteBadge,
                                  style: WemanTypography.labelSmall.copyWith(
                                    fontSize: 8,
                                    fontWeight: FontWeight.w900,
                                    color: WemanColors.onPrimaryContainer,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    Text(
                      profile.handle,
                      style: WemanTypography.bodySmall.copyWith(
                        color: WemanColors.textMuted,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      profile.bio,
                      style: WemanTypography.bodySmall.copyWith(
                        color: WemanColors.onSurface,
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: WemanColors.surfaceContainerLow,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                            color: WemanColors.surfaceContainerHigh),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.track_changes_rounded,
                            size: 13,
                            color: WemanColors.primary,
                          ),
                          const SizedBox(width: 4),
                          Flexible(
                            child: Text(
                              profile.fitnessGoal,
                              style: WemanTypography.labelSmall.copyWith(
                                color: WemanColors.primary,
                                fontWeight: FontWeight.w700,
                                fontSize: 11,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Text(profile.followersCount,
                            style: WemanTypography.labelSmall
                                .copyWith(fontWeight: FontWeight.w800)),
                        const SizedBox(width: 3),
                        Text('Followers',
                            style: WemanTypography.labelSmall.copyWith(
                                color: WemanColors.textMuted, fontSize: 11)),
                        const SizedBox(width: 12),
                        Text(profile.followingCount,
                            style: WemanTypography.labelSmall
                                .copyWith(fontWeight: FontWeight.w800)),
                        const SizedBox(width: 3),
                        Text('Following',
                            style: WemanTypography.labelSmall.copyWith(
                                color: WemanColors.textMuted, fontSize: 11)),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  key: const Key('profile_edit_button'),
                  onPressed: _openEditProfileSheet,
                  icon: const Icon(Icons.edit_outlined,
                      size: 15, color: WemanColors.onSurface),
                  label: Text(
                    'Edit Profile',
                    style: WemanTypography.labelSmall.copyWith(
                      fontWeight: FontWeight.w700,
                      color: WemanColors.onSurface,
                    ),
                  ),
                  style: OutlinedButton.styleFrom(
                    backgroundColor: WemanColors.surfaceContainerLow,
                    side: const BorderSide(
                        color: WemanColors.surfaceContainerHigh),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)),
                    padding: const EdgeInsets.symmetric(vertical: 10),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.share_outlined,
                      size: 15, color: WemanColors.onSurface),
                  label: Text(
                    'Share Profile',
                    style: WemanTypography.labelSmall.copyWith(
                      fontWeight: FontWeight.w700,
                      color: WemanColors.onSurface,
                    ),
                  ),
                  style: OutlinedButton.styleFrom(
                    backgroundColor: WemanColors.surfaceContainerLow,
                    side: const BorderSide(
                        color: WemanColors.surfaceContainerHigh),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)),
                    padding: const EdgeInsets.symmetric(vertical: 10),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // --- TELEMETRY DASHBOARD ---
  Widget _buildTelemetryDashboard(WorkoutTelemetryState telemetry) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: () => context.push('/fitness-tracking'),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Text(
                    'TELEMETRY & PROGRESS',
                    style: WemanTypography.labelSmall.copyWith(
                      fontWeight: FontWeight.w800,
                      color: WemanColors.textMuted,
                      letterSpacing: 0.8,
                    ),
                  ),
                  const SizedBox(width: 4),
                  const Icon(
                    Icons.arrow_forward_ios,
                    size: 10,
                    color: WemanColors.primary,
                  ),
                ],
              ),
              Row(
                children: [
                  Container(
                    width: 6,
                    height: 6,
                    decoration: const BoxDecoration(
                      color: WemanColors.neonLime,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    'Live Sync',
                    style: WemanTypography.labelSmall.copyWith(
                      color: WemanColors.primary,
                      fontWeight: FontWeight.w700,
                      fontSize: 10,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: _buildTelemetryTile(
                icon: Icons.fitness_center_rounded,
                value: '${telemetry.totalCompletedWorkouts}',
                label: 'Workouts Completed',
                hasGlow: false,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _buildTelemetryTile(
                icon: Icons.local_fire_department_rounded,
                value: '${telemetry.currentStreakDays} Days',
                label: 'Current Streak',
                hasGlow: true,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _buildTelemetryTile(
                icon: Icons.directions_walk_rounded,
                value: '11,420',
                label: 'Daily Steps (Demo)',
                hasGlow: false,
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        // Level & Consistency Indicator Card
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: WemanColors.cardBg,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: WemanColors.surfaceContainerHigh),
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 28,
                        height: 28,
                        decoration: const BoxDecoration(
                          color: WemanColors.neonLime,
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: Text(
                            '24',
                            style: WemanTypography.labelSmall.copyWith(
                              fontWeight: FontWeight.w900,
                              color: WemanColors.onPrimaryContainer,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Level 24 Master Athlete',
                            style: WemanTypography.labelSmall
                                .copyWith(fontWeight: FontWeight.w800),
                          ),
                          Text(
                            '820 XP to Grandmaster',
                            style: WemanTypography.labelSmall.copyWith(
                                color: WemanColors.textMuted, fontSize: 10),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Text(
                    '5/5 Days Met',
                    style: WemanTypography.labelSmall.copyWith(
                      color: WemanColors.primary,
                      fontWeight: FontWeight.w800,
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              // Weekly Consistency Mini Bars (Mon-Fri filled, Sat-Sun unfilled)
              const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Mon',
                      style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                          color: WemanColors.textMuted)),
                  Text('Tue',
                      style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                          color: WemanColors.textMuted)),
                  Text('Wed',
                      style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                          color: WemanColors.textMuted)),
                  Text('Thu',
                      style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                          color: WemanColors.textMuted)),
                  Text('Fri',
                      style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                          color: WemanColors.textMuted)),
                  Text('Sat',
                      style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                          color: WemanColors.outlineVariant)),
                  Text('Sun',
                      style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                          color: WemanColors.outlineVariant)),
                ],
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  for (int i = 0; i < 7; i++) ...[
                    Expanded(
                      child: Container(
                        height: 7,
                        decoration: BoxDecoration(
                          color: i < 5
                              ? WemanColors.neonLime
                              : WemanColors.surfaceContainerLow,
                          borderRadius: BorderRadius.circular(4),
                          border: Border.all(
                            color: i < 5
                                ? WemanColors.neonLime
                                : WemanColors.surfaceContainerHigh,
                            width: 0.5,
                          ),
                        ),
                      ),
                    ),
                    if (i < 6) const SizedBox(width: 5),
                  ],
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTelemetryTile({
    required IconData icon,
    required String value,
    required String label,
    required bool hasGlow,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
      decoration: BoxDecoration(
        color: WemanColors.cardBg,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color:
              hasGlow ? WemanColors.neonLime : WemanColors.surfaceContainerHigh,
          width: hasGlow ? 1.5 : 1,
        ),
        boxShadow: hasGlow
            ? [
                BoxShadow(
                  color: WemanColors.neonLime.withValues(alpha: 0.25),
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                ),
              ]
            : [],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(5),
            decoration: BoxDecoration(
              color: hasGlow
                  ? WemanColors.neonLime
                  : WemanColors.surfaceContainerLow,
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              size: 15,
              color: hasGlow
                  ? WemanColors.onPrimaryContainer
                  : WemanColors.primary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: WemanTypography.titleMedium.copyWith(
              fontWeight: FontWeight.w900,
              letterSpacing: -0.3,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: WemanTypography.labelSmall.copyWith(
              color: WemanColors.textMuted,
              fontSize: 9,
              height: 1.1,
            ),
            maxLines: 2,
          ),
        ],
      ),
    );
  }

  // --- RANK HIERARCHY CAROUSEL & BADGES ---
  Widget _buildRankHierarchyCard() {
    final ranks = [
      {'name': 'Rookie', 'unlocked': true, 'isCurrent': false},
      {'name': 'Warrior', 'unlocked': true, 'isCurrent': false},
      {'name': 'Veteran', 'unlocked': true, 'isCurrent': false},
      {'name': 'Elite', 'unlocked': true, 'isCurrent': false},
      {'name': 'Master Athlete', 'unlocked': true, 'isCurrent': true},
      {'name': 'Grandmaster', 'unlocked': false, 'isCurrent': false},
    ];

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: WemanColors.cardBg,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: WemanColors.surfaceContainerHigh),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(Icons.military_tech_rounded,
                      size: 18, color: WemanColors.primary),
                  const SizedBox(width: 6),
                  Text(
                    'RANK HIERARCHY',
                    style: WemanTypography.labelSmall.copyWith(
                      fontWeight: FontWeight.w800,
                      letterSpacing: 0.8,
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
              Text(
                'Rank 5 of 6',
                style: WemanTypography.labelSmall.copyWith(
                  color: WemanColors.primary,
                  fontWeight: FontWeight.w800,
                  fontSize: 11,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          // Scrollable rank pills
          SizedBox(
            height: 32,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: ranks.length,
              itemBuilder: (context, index) {
                final r = ranks[index];
                final isCurrent = r['isCurrent'] as bool;
                final isUnlocked = r['unlocked'] as bool;

                return Padding(
                  padding: const EdgeInsets.only(right: 6),
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: isCurrent
                          ? WemanColors.neonLime
                          : (isUnlocked
                              ? WemanColors.surfaceContainerLow
                              : WemanColors.surfaceContainer),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: isCurrent
                            ? WemanColors.primary.withValues(alpha: 0.3)
                            : WemanColors.surfaceContainerHigh,
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          isCurrent
                              ? Icons.stars_rounded
                              : (isUnlocked
                                  ? Icons.check_circle_rounded
                                  : Icons.lock_outline_rounded),
                          size: 13,
                          color: isCurrent
                              ? WemanColors.onPrimaryContainer
                              : WemanColors.textMuted,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          r['name'] as String,
                          style: WemanTypography.labelSmall.copyWith(
                            fontSize: 10,
                            fontWeight:
                                isCurrent ? FontWeight.w900 : FontWeight.w600,
                            color: isCurrent
                                ? WemanColors.onPrimaryContainer
                                : WemanColors.onSurface,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 14),
          const Divider(color: WemanColors.surfaceContainerHigh, height: 1),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'EARNED BADGES',
                style: WemanTypography.labelSmall.copyWith(
                  fontWeight: FontWeight.w800,
                  color: WemanColors.textMuted,
                  letterSpacing: 0.8,
                  fontSize: 10,
                ),
              ),
              Text(
                '16 Unlocked',
                style: WemanTypography.labelSmall.copyWith(
                  color: WemanColors.onSurface,
                  fontWeight: FontWeight.w700,
                  fontSize: 11,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildBadgeTile(Icons.fitness_center_rounded, '100lb PR Club'),
              _buildBadgeTile(Icons.bolt_rounded, '30-Day Pure'),
              _buildBadgeTile(Icons.wb_sunny_rounded, 'Early Riser 6 AM'),
              _buildBadgeTile(Icons.pedal_bike_rounded, 'Century Ride'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBadgeTile(IconData icon, String name) {
    return Container(
      width: 72,
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
      decoration: BoxDecoration(
        color: WemanColors.surfaceContainerLow,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: WemanColors.surfaceContainerHigh),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: const BoxDecoration(
              color: WemanColors.softLime,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, size: 16, color: WemanColors.onPrimaryContainer),
          ),
          const SizedBox(height: 6),
          Text(
            name,
            style: WemanTypography.labelSmall.copyWith(
              fontSize: 9,
              fontWeight: FontWeight.w700,
            ),
            textAlign: TextAlign.center,
            maxLines: 2,
          ),
        ],
      ),
    );
  }

  // --- 3-TAB SEGMENT ---
  Widget _buildTabSegment() {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: WemanColors.surfaceContainer,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Row(
        children: [
          _buildSegmentButton(0, 'Activity'),
          _buildSegmentButton(1, 'Workouts'),
          _buildSegmentButton(2, 'Achievements'),
        ],
      ),
    );
  }

  Widget _buildSegmentButton(int index, String label) {
    final isSelected = _selectedTab == index;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _selectedTab = index),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          padding: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            color: isSelected ? WemanColors.cardBg : Colors.transparent,
            borderRadius: BorderRadius.circular(20),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.05),
                      blurRadius: 6,
                    ),
                  ]
                : [],
          ),
          child: Center(
            child: Text(
              label,
              style: WemanTypography.labelSmall.copyWith(
                fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
                color:
                    isSelected ? WemanColors.onSurface : WemanColors.textMuted,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTabContent(WorkoutTelemetryState telemetry) {
    if (_selectedTab == 0) {
      return _buildActivityFeed();
    } else if (_selectedTab == 1) {
      return _buildWorkoutsFeed(telemetry);
    } else {
      return _buildAchievementsView();
    }
  }

  // --- WORKOUT CARDS MATCHING STITCH HTML ---
  Widget _buildActivityFeed() {
    return Column(
      children: [
        // Card 1: Heavy Deadlift PR & Volume
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: WemanColors.cardBg,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: WemanColors.surfaceContainerHigh),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 38,
                        height: 38,
                        decoration: BoxDecoration(
                          color: WemanColors.neonLime,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(
                          Icons.fitness_center_rounded,
                          size: 20,
                          color: WemanColors.onPrimaryContainer,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                'Heavy Deadlift PR & Volume',
                                style: WemanTypography.titleSmall
                                    .copyWith(fontWeight: FontWeight.w800),
                              ),
                              const SizedBox(width: 6),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 5, vertical: 1),
                                decoration: BoxDecoration(
                                  color: WemanColors.softLime,
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Row(
                                  children: [
                                    const Icon(Icons.verified_rounded,
                                        size: 9, color: WemanColors.primary),
                                    const SizedBox(width: 2),
                                    Text(
                                      'VERIFIED',
                                      style:
                                          WemanTypography.labelSmall.copyWith(
                                        fontSize: 8,
                                        fontWeight: FontWeight.w900,
                                        color: WemanColors.primary,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          Text(
                            'Today, 07:15 AM • 68 mins • Tribe Fitness',
                            style: WemanTypography.labelSmall.copyWith(
                                color: WemanColors.textMuted, fontSize: 10),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: WemanColors.softLime,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      '+420 XP',
                      style: WemanTypography.labelSmall.copyWith(
                        fontWeight: FontWeight.w900,
                        color: WemanColors.primary,
                        fontSize: 11,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              // Telemetry Chips
              Wrap(
                spacing: 6,
                runSpacing: 6,
                children: [
                  _buildChip('Top Lift:', '405 lbs (PR)'),
                  _buildChip('Total Volume:', '14,280 lbs'),
                  _buildChip('Heart Rate:', '158 bpm'),
                ],
              ),
              const SizedBox(height: 12),
              // Set Breakdown
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: WemanColors.surfaceContainerLow,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: WemanColors.surfaceContainerHigh),
                ),
                child: Column(
                  children: [
                    _buildExerciseSetRow(
                        'Conventional Deadlift', '5 sets • RPE 9.0', true),
                    const SizedBox(height: 6),
                    _buildExerciseSetRow(
                        'Barbell Romanian Deadlift', '4 sets • 12 reps', false),
                    const SizedBox(height: 6),
                    _buildExerciseSetRow('Weighted Pull-ups (+45 lbs)',
                        '4 sets • 8 reps', false),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            _hasFistbumped = !_hasFistbumped;
                            _fistbumpCount += _hasFistbumped ? 1 : -1;
                          });
                        },
                        child: Row(
                          children: [
                            Icon(
                              Icons.electric_bolt_rounded,
                              size: 16,
                              color: _hasFistbumped
                                  ? WemanColors.primary
                                  : WemanColors.textMuted,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              '$_fistbumpCount Fistbumps',
                              style: WemanTypography.labelSmall.copyWith(
                                fontWeight: FontWeight.w700,
                                fontSize: 11,
                                color: _hasFistbumped
                                    ? WemanColors.primary
                                    : WemanColors.onSurface,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 14),
                      Row(
                        children: [
                          const Icon(Icons.chat_bubble_outline_rounded,
                              size: 15, color: WemanColors.textMuted),
                          const SizedBox(width: 4),
                          Text(
                            '12 comments',
                            style: WemanTypography.labelSmall.copyWith(
                              color: WemanColors.textMuted,
                              fontSize: 11,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Text(
                    'WEMAN FIT Community',
                    style: WemanTypography.labelSmall.copyWith(
                      color: WemanColors.textMuted,
                      fontSize: 10,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        // Card 2: HIIT Engine & Core Flush
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: WemanColors.cardBg,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: WemanColors.surfaceContainerHigh),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 38,
                        height: 38,
                        decoration: BoxDecoration(
                          color: WemanColors.surfaceContainerLow,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(
                          Icons.timer_outlined,
                          size: 20,
                          color: WemanColors.onSurface,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                'HIIT Engine & Core Flush',
                                style: WemanTypography.titleSmall
                                    .copyWith(fontWeight: FontWeight.w800),
                              ),
                              const SizedBox(width: 6),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 5, vertical: 1),
                                decoration: BoxDecoration(
                                  color: WemanColors.surfaceContainerLow,
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Text(
                                  'TEMPO',
                                  style: WemanTypography.labelSmall.copyWith(
                                    fontSize: 8,
                                    fontWeight: FontWeight.w800,
                                    color: WemanColors.textMuted,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Text(
                            'Yesterday, 06:30 PM • 35 mins',
                            style: WemanTypography.labelSmall.copyWith(
                                color: WemanColors.textMuted, fontSize: 10),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: WemanColors.surfaceContainerLow,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      '+260 XP',
                      style: WemanTypography.labelSmall.copyWith(
                        fontWeight: FontWeight.w800,
                        color: WemanColors.textMuted,
                        fontSize: 11,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  _buildChip('Intervals:', '12 Rounds'),
                  const SizedBox(width: 8),
                  _buildChip('Calories:', '410 kcal'),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildWorkoutsFeed(WorkoutTelemetryState telemetry) {
    return Column(
      children: [
        if (telemetry.workoutHistory.isNotEmpty) ...[
          for (final workout in telemetry.workoutHistory)
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: _buildWorkoutPlanItem(
                workout.workoutName,
                '${workout.durationMinutes}m • ${workout.caloriesBurned} kcal (Demo Est.) • ${workout.completedSets}/${workout.totalSets} Sets',
                'Completed Today',
              ),
            ),
        ],
        _buildWorkoutPlanItem('Upper / Lower Volume Specialization',
            '4 Days/Wk • Hypertrophy', 'Active Program'),
        const SizedBox(height: 8),
        _buildWorkoutPlanItem('Linear 5x5 Strength Block',
            '3 Days/Wk • Powerlifting', 'Completed'),
        const SizedBox(height: 8),
        _buildWorkoutPlanItem(
            'Kettlebell Athletic Conditioning', '2 Days/Wk • HIIT', 'Archived'),
      ],
    );
  }

  Widget _buildWorkoutPlanItem(String title, String subtitle, String status) {
    final isActive = status == 'Active Program' || status == 'Completed Today';
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: WemanColors.cardBg,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: isActive
              ? WemanColors.neonLime
              : WemanColors.surfaceContainerHigh,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: WemanTypography.titleSmall
                      .copyWith(fontWeight: FontWeight.w700),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: WemanTypography.bodySmall
                      .copyWith(color: WemanColors.textMuted, fontSize: 11),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
            decoration: BoxDecoration(
              color: isActive
                  ? WemanColors.neonLime
                  : WemanColors.surfaceContainerLow,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              status,
              style: WemanTypography.labelSmall.copyWith(
                fontWeight: FontWeight.w800,
                color: isActive
                    ? WemanColors.onPrimaryContainer
                    : WemanColors.textMuted,
                fontSize: 10,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAchievementsView() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: WemanColors.cardBg,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: WemanColors.surfaceContainerHigh),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'All Achievements (16/24 Unlocked)',
                style: WemanTypography.titleSmall
                    .copyWith(fontWeight: FontWeight.w800),
              ),
              const SizedBox(height: 12),
              _buildAchievementRow(
                Icons.emoji_events_rounded,
                'Iron Century Club',
                'Logged over 100 workouts on WEMAN FIT',
                true,
              ),
              const SizedBox(height: 8),
              _buildAchievementRow(
                Icons.local_fire_department_rounded,
                'Unstoppable Habit',
                '14-Day continuous workout streak',
                true,
              ),
              const SizedBox(height: 8),
              _buildAchievementRow(
                Icons.groups_rounded,
                'Campus Inspiration',
                'Received 500+ fistbumps from CEC peers',
                true,
              ),
              const SizedBox(height: 8),
              _buildAchievementRow(
                Icons.diamond_rounded,
                'Grandmaster Ascendant',
                'Reach Level 25 to unlock',
                false,
              ),
            ],
          ),
        ),
        const SizedBox(height: 14),
        _buildRankingsAndLeaderboardSection(),
      ],
    );
  }

  Widget _buildRankingsAndLeaderboardSection() {
    final ranks = [
      {
        'scope': 'National Rank',
        'sub': 'All India • 14,280 athletes',
        'rank': '#14',
        'icon': Icons.flag_rounded,
        'badge': 'TOP 1%',
        'isTop': false,
      },
      {
        'scope': 'State Rank',
        'sub': 'Karnataka • 2,410 athletes',
        'rank': '#2',
        'icon': Icons.location_city_rounded,
        'badge': 'SILVER PODIUM',
        'isTop': true,
      },
      {
        'scope': 'District Rank',
        'sub': 'Bangalore Urban • 680 athletes',
        'rank': '#1',
        'icon': Icons.domain_rounded,
        'badge': 'DISTRICT CHAMPION',
        'isTop': true,
      },
      {
        'scope': 'Region Rank',
        'sub': 'South Zone • 5,120 athletes',
        'rank': '#5',
        'icon': Icons.explore_rounded,
        'badge': 'ELITE TIER',
        'isTop': false,
      },
      {
        'scope': 'College Rank',
        'sub': 'Canara Engg / Metro Univ • 142 gymers',
        'rank': '#1',
        'icon': Icons.school_rounded,
        'badge': 'CAMPUS #1',
        'isTop': true,
      },
    ];

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: WemanColors.cardBg,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: WemanColors.surfaceContainerHigh),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 12,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header Row with Trophy Icon, Title & Demo Data Indicator
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    width: 38,
                    height: 38,
                    decoration: BoxDecoration(
                      color: WemanColors.neonLime,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.emoji_events_rounded,
                      size: 20,
                      color: WemanColors.onPrimaryContainer,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Rankings & Leaderboard',
                        style: WemanTypography.titleSmall.copyWith(
                          fontWeight: FontWeight.w900,
                          letterSpacing: -0.2,
                        ),
                      ),
                      Text(
                        'Verified Athletic Standing',
                        style: WemanTypography.labelSmall.copyWith(
                          color: WemanColors.textMuted,
                          fontSize: 10,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: WemanColors.surfaceContainerLow,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: WemanColors.surfaceContainerHigh),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 5,
                      height: 5,
                      decoration: const BoxDecoration(
                        color: WemanColors.primary,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      'DEMO DATA',
                      style: WemanTypography.labelSmall.copyWith(
                        fontSize: 9,
                        fontWeight: FontWeight.w800,
                        color: WemanColors.textMuted,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),

          // 5 Preview Ranking Rows
          for (int i = 0; i < ranks.length; i++) ...[
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              decoration: BoxDecoration(
                color: ranks[i]['isTop'] == true
                    ? WemanColors.softLime.withValues(alpha: 0.5)
                    : WemanColors.surfaceContainerLow,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: ranks[i]['isTop'] == true
                      ? WemanColors.neonLime.withValues(alpha: 0.6)
                      : WemanColors.surfaceContainerHigh,
                ),
              ),
              child: Row(
                children: [
                  Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: ranks[i]['isTop'] == true
                          ? WemanColors.neonLime
                          : WemanColors.surfaceContainer,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      ranks[i]['icon'] as IconData,
                      size: 16,
                      color: ranks[i]['isTop'] == true
                          ? WemanColors.onPrimaryContainer
                          : WemanColors.onSurface,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              ranks[i]['scope'] as String,
                              style: WemanTypography.labelSmall.copyWith(
                                fontWeight: FontWeight.w800,
                                fontSize: 12,
                              ),
                            ),
                            const SizedBox(width: 6),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 5, vertical: 1),
                              decoration: BoxDecoration(
                                color: ranks[i]['isTop'] == true
                                    ? WemanColors.neonLime
                                    : WemanColors.surfaceContainerHigh,
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                ranks[i]['badge'] as String,
                                style: WemanTypography.labelSmall.copyWith(
                                  fontSize: 8,
                                  fontWeight: FontWeight.w900,
                                  color: ranks[i]['isTop'] == true
                                      ? WemanColors.onPrimaryContainer
                                      : WemanColors.textMuted,
                                ),
                              ),
                            ),
                          ],
                        ),
                        Text(
                          ranks[i]['sub'] as String,
                          style: WemanTypography.bodySmall.copyWith(
                            color: WemanColors.textMuted,
                            fontSize: 10,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: ranks[i]['isTop'] == true
                          ? WemanColors.neonLime
                          : WemanColors.cardBg,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: ranks[i]['isTop'] == true
                            ? WemanColors.neonLime
                            : WemanColors.surfaceContainerHigh,
                      ),
                      boxShadow: ranks[i]['isTop'] == true
                          ? [
                              BoxShadow(
                                color:
                                    WemanColors.neonLime.withValues(alpha: 0.3),
                                blurRadius: 6,
                              ),
                            ]
                          : [],
                    ),
                    child: Text(
                      ranks[i]['rank'] as String,
                      style: WemanTypography.labelMedium.copyWith(
                        fontWeight: FontWeight.w900,
                        color: ranks[i]['isTop'] == true
                            ? WemanColors.onPrimaryContainer
                            : WemanColors.onSurface,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            if (i < ranks.length - 1) const SizedBox(height: 8),
          ],
          const SizedBox(height: 16),

          // Prominent View All Rankings Button (CTA)
          ElevatedButton(
            onPressed: () => context.push('/rankings'),
            style: ElevatedButton.styleFrom(
              backgroundColor: WemanColors.neonLime,
              foregroundColor: WemanColors.onPrimaryContainer,
              elevation: 0,
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              shadowColor: WemanColors.neonLime.withValues(alpha: 0.4),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.leaderboard_rounded,
                  size: 18,
                  color: WemanColors.onPrimaryContainer,
                ),
                const SizedBox(width: 8),
                Text(
                  'View All Rankings',
                  style: WemanTypography.labelLarge.copyWith(
                    fontWeight: FontWeight.w900,
                    color: WemanColors.onPrimaryContainer,
                    fontSize: 13,
                    letterSpacing: 0.3,
                  ),
                ),
                const SizedBox(width: 6),
                const Icon(
                  Icons.arrow_forward_rounded,
                  size: 16,
                  color: WemanColors.onPrimaryContainer,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAchievementRow(
      IconData icon, String title, String sub, bool unlocked) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: unlocked
                ? WemanColors.softLime
                : WemanColors.surfaceContainerLow,
            shape: BoxShape.circle,
          ),
          child: Icon(icon,
              size: 18,
              color: unlocked ? WemanColors.primary : WemanColors.textMuted),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title,
                  style: WemanTypography.labelSmall
                      .copyWith(fontWeight: FontWeight.w700)),
              Text(sub,
                  style: WemanTypography.bodySmall
                      .copyWith(color: WemanColors.textMuted, fontSize: 10)),
            ],
          ),
        ),
        if (unlocked)
          const Icon(Icons.check_circle_rounded,
              color: WemanColors.primary, size: 16)
        else
          const Icon(Icons.lock_outline_rounded,
              color: WemanColors.textMuted, size: 16),
      ],
    );
  }

  Widget _buildChip(String label, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: WemanColors.surfaceContainerLow,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(label,
              style: WemanTypography.labelSmall
                  .copyWith(color: WemanColors.textMuted, fontSize: 10)),
          const SizedBox(width: 4),
          Text(value,
              style: WemanTypography.labelSmall
                  .copyWith(fontWeight: FontWeight.w800, fontSize: 10)),
        ],
      ),
    );
  }

  Widget _buildExerciseSetRow(String name, String sets, bool isVoltDot) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Container(
              width: 6,
              height: 6,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isVoltDot ? WemanColors.neonLime : WemanColors.textMuted,
              ),
            ),
            const SizedBox(width: 8),
            Text(name,
                style: WemanTypography.labelSmall
                    .copyWith(fontWeight: FontWeight.w700, fontSize: 11)),
          ],
        ),
        Text(sets,
            style: WemanTypography.labelSmall
                .copyWith(color: WemanColors.textMuted, fontSize: 10)),
      ],
    );
  }
}
