import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/demo_state/demo_state.dart';
import '../../core/theme/weman_colors.dart';
import '../../core/theme/weman_typography.dart';

class MySpaceScreen extends ConsumerStatefulWidget {
  final int
      initialSection; // 0: Activity, 1: Saved, 2: History, 3: Privacy, 4: Notifications, 5: Settings

  const MySpaceScreen({
    super.key,
    this.initialSection = 0,
  });

  @override
  ConsumerState<MySpaceScreen> createState() => _MySpaceScreenState();
}

class _MySpaceScreenState extends ConsumerState<MySpaceScreen> {
  late int _selectedSection;
  bool _isMetric = true;
  bool _restTimerAudio = true;
  bool _profilePublic = true;
  bool _workoutReminders = true;
  String _selectedLanguage = 'English';

  List<Map<String, dynamic>> _getSections(WorkoutTelemetryState telemetry) => [
    {
      'title': 'My Activity',
      'icon': Icons.trending_up_rounded,
      'badge': 'Live',
    },
    {
      'title': 'Saved Collection',
      'icon': Icons.bookmark_rounded,
      'badge': '14 Items',
    },
    {
      'title': 'Workout History',
      'icon': Icons.fitness_center_rounded,
      'badge': '${telemetry.totalCompletedWorkouts} Logs',
    },
    {
      'title': 'Account & Privacy',
      'icon': Icons.shield_rounded,
      'badge': 'Campus CEC',
    },
    {
      'title': 'Notifications',
      'icon': Icons.notifications_rounded,
      'badge': '3 New',
    },
    {
      'title': 'Settings',
      'icon': Icons.settings_rounded,
      'badge': null,
    },
  ];

  @override
  void initState() {
    super.initState();
    _selectedSection = widget.initialSection;
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
            _buildAppBar(profile),
            _buildSectionPills(telemetry),
            Expanded(
              child: SingleChildScrollView(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: _buildSelectedContent(telemetry),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAppBar(UserProfile profile) {
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
              IconButton(
                onPressed: () => context.pop(),
                icon: const Icon(Icons.arrow_back_rounded,
                    color: WemanColors.onSurface),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
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
                      const SizedBox(width: 6),
                      Text(
                        'WEMAN FIT',
                        style: WemanTypography.labelSmall.copyWith(
                          fontWeight: FontWeight.w900,
                          letterSpacing: 1.1,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '/',
                        style: WemanTypography.labelSmall.copyWith(
                          color: WemanColors.textMuted,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        'MY SPACE',
                        style: WemanTypography.labelSmall.copyWith(
                          color: WemanColors.primary,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ],
                  ),
                  Text(
                    'Athlete Workspace & Controls',
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
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: WemanColors.surfaceContainerLow,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: WemanColors.surfaceContainerHigh),
            ),
            child: Row(
              children: [
                const Icon(Icons.person_rounded,
                    size: 14, color: WemanColors.primary),
                const SizedBox(width: 4),
                Text(
                  profile.handle,
                  style: WemanTypography.labelSmall.copyWith(
                    fontWeight: FontWeight.w700,
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionPills(WorkoutTelemetryState telemetry) {
    final sections = _getSections(telemetry);
    return Container(
      color: WemanColors.cardBg,
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: SizedBox(
        height: 38,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          itemCount: sections.length,
          itemBuilder: (context, index) {
            final section = sections[index];
            final isSelected = _selectedSection == index;
            return Padding(
              padding: const EdgeInsets.only(right: 8),
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedSection = index;
                  });
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 180),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? WemanColors.inverseSurface
                        : WemanColors.surfaceContainerLow,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: isSelected
                          ? WemanColors.inverseSurface
                          : WemanColors.surfaceContainerHigh,
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        section['icon'] as IconData,
                        size: 15,
                        color: isSelected
                            ? WemanColors.neonLime
                            : WemanColors.textMuted,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        section['title'] as String,
                        style: WemanTypography.labelSmall.copyWith(
                          color:
                              isSelected ? Colors.white : WemanColors.onSurface,
                          fontWeight:
                              isSelected ? FontWeight.w800 : FontWeight.w600,
                          fontSize: 12,
                        ),
                      ),
                      if (section['badge'] != null && !isSelected) ...[
                        const SizedBox(width: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 6, vertical: 1),
                          decoration: BoxDecoration(
                            color: WemanColors.softLime,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            section['badge'] as String,
                            style: WemanTypography.labelSmall.copyWith(
                              fontSize: 9,
                              fontWeight: FontWeight.w800,
                              color: WemanColors.onPrimaryContainer,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildSelectedContent(WorkoutTelemetryState telemetry) {
    switch (_selectedSection) {
      case 0:
        return _buildActivityContent();
      case 1:
        return _buildSavedContent();
      case 2:
        return _buildHistoryContent(telemetry);
      case 3:
        return _buildPrivacyContent();
      case 4:
        return _buildNotificationsContent();
      case 5:
        return _buildSettingsContent();
      default:
        return _buildActivityContent();
    }
  }

  // --- SECTION 1: MY ACTIVITY ---
  Widget _buildActivityContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader(
            'Live Telemetry & Workload', 'Synced with Smart Gym sensors'),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _buildMetricTile(
                icon: Icons.fitness_center_rounded,
                title: 'Weekly Volume',
                value: '42,600 kg',
                sub: '+12% vs last week',
                isHighlight: true,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _buildMetricTile(
                icon: Icons.local_fire_department_rounded,
                title: 'Active Streak',
                value: '18 Days',
                sub: 'Personal Best',
                isHighlight: false,
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            Expanded(
              child: _buildMetricTile(
                icon: Icons.favorite_rounded,
                title: 'Avg Heart Rate',
                value: '142 bpm',
                sub: 'Zone 3 Aerobic Base',
                isHighlight: false,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _buildMetricTile(
                icon: Icons.battery_charging_full_rounded,
                title: 'Recovery Score',
                value: '88% Optimal',
                sub: 'Ready for Heavy Session',
                isHighlight: false,
              ),
            ),
          ],
        ),
        const SizedBox(height: 18),
        _buildSectionHeader(
            'Weekly Muscle Split Distribution', 'Volume balance'),
        const SizedBox(height: 10),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: WemanColors.cardBg,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: WemanColors.surfaceContainerHigh),
          ),
          child: Column(
            children: [
              _buildSplitProgress('Chest & Triceps (Push)', 0.32, '18 Sets'),
              const SizedBox(height: 12),
              _buildSplitProgress('Back & Biceps (Pull)', 0.28, '16 Sets'),
              const SizedBox(height: 12),
              _buildSplitProgress('Quads & Hamstrings (Legs)', 0.24, '14 Sets'),
              const SizedBox(height: 12),
              _buildSplitProgress('Core & Dynamic Mobility', 0.16, '8 Sets'),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSplitProgress(String label, double ratio, String sets) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label,
                style: WemanTypography.labelSmall
                    .copyWith(fontWeight: FontWeight.w700)),
            Text(sets,
                style: WemanTypography.labelSmall.copyWith(
                    color: WemanColors.primary, fontWeight: FontWeight.w800)),
          ],
        ),
        const SizedBox(height: 6),
        ClipRRect(
          borderRadius: BorderRadius.circular(6),
          child: LinearProgressIndicator(
            value: ratio,
            minHeight: 7,
            backgroundColor: WemanColors.surfaceContainerLow,
            valueColor:
                const AlwaysStoppedAnimation<Color>(WemanColors.neonLime),
          ),
        ),
      ],
    );
  }

  // --- SECTION 2: SAVED / COLLECTION ---
  Widget _buildSavedContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader('Bookmarked Routines & Guides',
            '14 saved workouts & nutrition plans'),
        const SizedBox(height: 12),
        _buildSavedCard(
          tag: 'ROUTINE',
          title: 'Upper / Lower Volume Specialization',
          detail: '4 Days/Wk • 60 min avg • 18 Sets/Session',
          icon: Icons.layers_rounded,
        ),
        const SizedBox(height: 10),
        _buildSavedCard(
          tag: 'EXERCISE GUIDE',
          title: 'Hack Squat: 30° Foot Angle Quad Bias',
          detail: 'Target: Vastus Medialis • 4 sets x 10 reps',
          icon: Icons.accessibility_new_rounded,
        ),
        const SizedBox(height: 10),
        _buildSavedCard(
          tag: 'NUTRITION',
          title: 'High-Protein Flank Steak & Quinoa Bowl',
          detail: '52g Protein • 580 kcal • 15 min prep',
          icon: Icons.restaurant_rounded,
        ),
        const SizedBox(height: 10),
        _buildSavedCard(
          tag: 'HABIT CUE',
          title: 'Electrolyte Intra-Workout Sodium Protocol',
          detail: '500mg sodium in 750ml water for muscular pump',
          icon: Icons.water_drop_rounded,
        ),
      ],
    );
  }

  Widget _buildSavedCard({
    required String tag,
    required String title,
    required String detail,
    required IconData icon,
  }) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: WemanColors.cardBg,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: WemanColors.surfaceContainerHigh),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: WemanColors.softLime,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, size: 20, color: WemanColors.onPrimaryContainer),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                  decoration: BoxDecoration(
                    color: WemanColors.surfaceContainerLow,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    tag,
                    style: WemanTypography.labelSmall.copyWith(
                      fontSize: 9,
                      fontWeight: FontWeight.w800,
                      color: WemanColors.textMuted,
                    ),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  title,
                  style: WemanTypography.titleSmall
                      .copyWith(fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 2),
                Text(
                  detail,
                  style: WemanTypography.bodySmall.copyWith(
                    color: WemanColors.textMuted,
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.bookmark_remove_outlined,
                color: WemanColors.textMuted, size: 20),
            onPressed: () {},
          ),
        ],
      ),
    );
  }

  // --- SECTION 3: WORKOUT HISTORY ---
  Widget _buildHistoryContent(WorkoutTelemetryState telemetry) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader(
            'Past Logged Workouts', 'Chronological log with PR verifications'),
        const SizedBox(height: 12),
        if (telemetry.workoutHistory.isNotEmpty) ...[
          for (final workout in telemetry.workoutHistory)
            Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: _buildHistoryItem(
                date:
                    'TODAY • ${workout.completedAt.hour.toString().padLeft(2, '0')}:${workout.completedAt.minute.toString().padLeft(2, '0')}',
                title: workout.workoutName,
                stats:
                    '${workout.durationMinutes} mins • ${workout.caloriesBurned} kcal • ${workout.completedSets}/${workout.totalSets} Sets',
                gym: 'WEMAN FIT Session',
                xp: '+${workout.xpEarned} XP',
                isPr: true,
              ),
            ),
        ],
        _buildHistoryItem(
          date: 'TODAY • 07:15 AM',
          title: 'Heavy Deadlift PR & Volume',
          stats: '68 mins • Top: 405 lbs (PR) • 14,280 lbs vol',
          gym: 'Tribe Fitness • Campus CEC',
          xp: '+420 XP',
          isPr: true,
        ),
        const SizedBox(height: 10),
        _buildHistoryItem(
          date: 'YESTERDAY • 06:30 PM',
          title: 'HIIT Engine & Core Flush',
          stats: '35 mins • 12 Rounds • 410 kcal burned',
          gym: 'CEC Campus Gym',
          xp: '+260 XP',
          isPr: false,
        ),
        const SizedBox(height: 10),
        _buildHistoryItem(
          date: '3 DAYS AGO • 07:00 AM',
          title: 'Upper Body Hypertrophy (Chest & Back)',
          stats: '55 mins • 18 Total Sets • Barbell Bench 85kg',
          gym: 'Tribe Fitness',
          xp: '+380 XP',
          isPr: false,
        ),
        const SizedBox(height: 10),
        _buildHistoryItem(
          date: '5 DAYS AGO • 05:45 PM',
          title: 'Quad Specialization & Hack Squats',
          stats: '62 mins • Hack Squat 140kg x 8 • 4 sets RDL',
          gym: 'CEC Campus Gym',
          xp: '+350 XP',
          isPr: true,
        ),
      ],
    );
  }

  Widget _buildHistoryItem({
    required String date,
    required String title,
    required String stats,
    required String gym,
    required String xp,
    required bool isPr,
  }) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: WemanColors.cardBg,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: isPr ? WemanColors.neonLime : WemanColors.surfaceContainerHigh,
          width: isPr ? 1.5 : 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(date,
                  style: WemanTypography.labelSmall
                      .copyWith(color: WemanColors.textMuted, fontSize: 10)),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: isPr
                      ? WemanColors.neonLime
                      : WemanColors.surfaceContainerLow,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  xp,
                  style: WemanTypography.labelSmall.copyWith(
                    fontWeight: FontWeight.w800,
                    color: isPr
                        ? WemanColors.onPrimaryContainer
                        : WemanColors.onSurface,
                    fontSize: 10,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              Expanded(
                child: Text(
                  title,
                  style: WemanTypography.titleSmall
                      .copyWith(fontWeight: FontWeight.w700),
                ),
              ),
              if (isPr)
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: WemanColors.primary,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    'PR SET',
                    style: WemanTypography.labelSmall.copyWith(
                      color: Colors.white,
                      fontSize: 8,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 4),
          Text(stats,
              style: WemanTypography.bodySmall
                  .copyWith(color: WemanColors.onSurface, fontSize: 12)),
          const SizedBox(height: 4),
          Row(
            children: [
              const Icon(Icons.location_on_outlined,
                  size: 12, color: WemanColors.textMuted),
              const SizedBox(width: 4),
              Text(gym,
                  style: WemanTypography.labelSmall
                      .copyWith(color: WemanColors.textMuted, fontSize: 10)),
            ],
          ),
        ],
      ),
    );
  }

  // --- SECTION 4: ACCOUNT & PRIVACY ---
  Widget _buildPrivacyContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader('Security, Privacy & Campus Identity',
            'Manage athlete visibility and data'),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: WemanColors.cardBg,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: WemanColors.surfaceContainerHigh),
          ),
          child: Column(
            children: [
              _buildSettingRow(
                icon: Icons.public_rounded,
                title: 'Public Athlete Profile',
                sub:
                    'Allow gym peers on campus to discover your PRs and profile',
                trailing: Switch(
                  value: _profilePublic,
                  activeThumbColor: WemanColors.onPrimaryContainer,
                  activeTrackColor: WemanColors.neonLime,
                  onChanged: (val) => setState(() => _profilePublic = val),
                ),
              ),
              const Divider(
                  color: WemanColors.surfaceContainerHigh, height: 24),
              _buildSettingRow(
                icon: Icons.school_rounded,
                title: 'Campus Affiliation',
                sub: 'City Engineering College (CEC), Bengaluru',
                trailing: const Icon(Icons.chevron_right_rounded,
                    color: WemanColors.textMuted),
              ),
              const Divider(
                  color: WemanColors.surfaceContainerHigh, height: 24),
              _buildSettingRow(
                icon: Icons.lock_outline_rounded,
                title: 'Biometric App Lock',
                sub: 'Require FaceID / Fingerprint to open logs',
                trailing: Switch(
                  value: true,
                  activeThumbColor: WemanColors.onPrimaryContainer,
                  activeTrackColor: WemanColors.neonLime,
                  onChanged: (val) {},
                ),
              ),
              const Divider(
                  color: WemanColors.surfaceContainerHigh, height: 24),
              _buildSettingRow(
                icon: Icons.delete_outline_rounded,
                title: 'Download or Erase Data',
                sub: 'Export workout JSON or delete account under DPDP Act',
                trailing: const Icon(Icons.chevron_right_rounded,
                    color: WemanColors.textMuted),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // --- SECTION 5: NOTIFICATIONS ---
  Widget _buildNotificationsContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader(
            'Alerts & Community Updates', '3 unread notifications'),
        const SizedBox(height: 12),
        _buildNotificationItem(
          icon: Icons.electric_bolt_rounded,
          title: 'Kavya and 7 others fistbumped your 405 lbs Deadlift PR!',
          time: '25 mins ago',
          isUnread: true,
        ),
        const SizedBox(height: 10),
        _buildNotificationItem(
          icon: Icons.military_tech_rounded,
          title: 'Rank Milestone: You unlocked Master Athlete Level 24!',
          time: '2 hours ago',
          isUnread: true,
        ),
        const SizedBox(height: 10),
        _buildNotificationItem(
          icon: Icons.timer_outlined,
          title:
              'Recovery Prompt: Deload week suggested after 5 intense blocks.',
          time: 'Yesterday',
          isUnread: true,
        ),
        const SizedBox(height: 10),
        _buildNotificationItem(
          icon: Icons.campaign_rounded,
          title:
              'Campus Squad CEC: Intramural Bench Press Challenge is now live.',
          time: '2 days ago',
          isUnread: false,
        ),
      ],
    );
  }

  Widget _buildNotificationItem({
    required IconData icon,
    required String title,
    required String time,
    required bool isUnread,
  }) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: isUnread ? WemanColors.surfaceContainerLow : WemanColors.cardBg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isUnread
              ? WemanColors.neonLime
              : WemanColors.surfaceContainerHigh,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: isUnread
                  ? WemanColors.neonLime
                  : WemanColors.surfaceContainerLow,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, size: 18, color: WemanColors.onPrimaryContainer),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: WemanTypography.bodySmall.copyWith(
                    fontWeight: isUnread ? FontWeight.w700 : FontWeight.w500,
                    color: WemanColors.onSurface,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  time,
                  style: WemanTypography.labelSmall.copyWith(
                    color: WemanColors.textMuted,
                    fontSize: 10,
                  ),
                ),
              ],
            ),
          ),
          if (isUnread)
            Container(
              width: 8,
              height: 8,
              decoration: const BoxDecoration(
                color: WemanColors.primary,
                shape: BoxShape.circle,
              ),
            ),
        ],
      ),
    );
  }

  // --- SECTION 6: SETTINGS ---
  Widget _buildSettingsContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader(
            'Preferences & Units', 'Customize your workout experience'),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: WemanColors.cardBg,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: WemanColors.surfaceContainerHigh),
          ),
          child: Column(
            children: [
              _buildSettingRow(
                icon: Icons.scale_rounded,
                title: 'Weight Units',
                sub: _isMetric
                    ? 'Metric (Kilograms / kg)'
                    : 'Imperial (Pounds / lbs)',
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ChoiceChip(
                      label: const Text('KG'),
                      selected: _isMetric,
                      selectedColor: WemanColors.neonLime,
                      onSelected: (val) => setState(() => _isMetric = true),
                    ),
                    const SizedBox(width: 6),
                    ChoiceChip(
                      label: const Text('LBS'),
                      selected: !_isMetric,
                      selectedColor: WemanColors.neonLime,
                      onSelected: (val) => setState(() => _isMetric = false),
                    ),
                  ],
                ),
              ),
              const Divider(
                  color: WemanColors.surfaceContainerHigh, height: 24),
              _buildSettingRow(
                icon: Icons.volume_up_rounded,
                title: 'Rest Timer Audio Beeps',
                sub: 'Chime on 3-2-1 countdown',
                trailing: Switch(
                  value: _restTimerAudio,
                  activeThumbColor: WemanColors.onPrimaryContainer,
                  activeTrackColor: WemanColors.neonLime,
                  onChanged: (val) => setState(() => _restTimerAudio = val),
                ),
              ),
              const Divider(
                  color: WemanColors.surfaceContainerHigh, height: 24),
              _buildSettingRow(
                icon: Icons.translate_rounded,
                title: 'Interface Language',
                sub: 'English / ಕನ್ನಡ (Kannada)',
                trailing: DropdownButton<String>(
                  value: _selectedLanguage,
                  underline: const SizedBox(),
                  items: const [
                    DropdownMenuItem(value: 'English', child: Text('English')),
                    DropdownMenuItem(value: 'ಕನ್ನಡ', child: Text('ಕನ್ನಡ')),
                  ],
                  onChanged: (val) {
                    if (val != null) setState(() => _selectedLanguage = val);
                  },
                ),
              ),
              const Divider(
                  color: WemanColors.surfaceContainerHigh, height: 24),
              _buildSettingRow(
                icon: Icons.notifications_active_rounded,
                title: 'Workout Notifications',
                sub: 'Daily streak reminders and community alerts',
                trailing: Switch(
                  value: _workoutReminders,
                  activeThumbColor: WemanColors.onPrimaryContainer,
                  activeTrackColor: WemanColors.neonLime,
                  onChanged: (val) => setState(() => _workoutReminders = val),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        Center(
          child: Text(
            'WEMAN FIT • Karnataka Launch Build v3.2.0\nHigh-Performance Social Fitness',
            style: WemanTypography.labelSmall.copyWith(
              color: WemanColors.textMuted,
              fontSize: 10,
            ),
            textAlign: TextAlign.center,
          ),
        ),
        const SizedBox(height: 12),
      ],
    );
  }

  Widget _buildSectionHeader(String title, String subtitle) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title,
            style: WemanTypography.titleMedium
                .copyWith(fontWeight: FontWeight.w800)),
        Text(subtitle,
            style: WemanTypography.bodySmall
                .copyWith(color: WemanColors.textMuted, fontSize: 11)),
      ],
    );
  }

  Widget _buildMetricTile({
    required IconData icon,
    required String title,
    required String value,
    required String sub,
    required bool isHighlight,
  }) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: WemanColors.cardBg,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: isHighlight
              ? WemanColors.neonLime
              : WemanColors.surfaceContainerHigh,
          width: isHighlight ? 1.5 : 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: isHighlight
                  ? WemanColors.neonLime
                  : WemanColors.surfaceContainerLow,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, size: 16, color: WemanColors.onPrimaryContainer),
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: WemanTypography.headlineSmall.copyWith(
              fontWeight: FontWeight.w800,
              fontSize: 18,
            ),
          ),
          Text(title,
              style: WemanTypography.labelSmall.copyWith(
                  fontWeight: FontWeight.w600, color: WemanColors.textMuted)),
          const SizedBox(height: 2),
          Text(
            sub,
            style: WemanTypography.labelSmall.copyWith(
              color: WemanColors.primary,
              fontWeight: FontWeight.w700,
              fontSize: 9,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingRow({
    required IconData icon,
    required String title,
    required String sub,
    required Widget trailing,
  }) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: WemanColors.surfaceContainerLow,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, size: 18, color: WemanColors.onSurface),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title,
                  style: WemanTypography.titleSmall
                      .copyWith(fontWeight: FontWeight.w700, fontSize: 13)),
              Text(sub,
                  style: WemanTypography.bodySmall
                      .copyWith(color: WemanColors.textMuted, fontSize: 11)),
            ],
          ),
        ),
        trailing,
      ],
    );
  }
}
