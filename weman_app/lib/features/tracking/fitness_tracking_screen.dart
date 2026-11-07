import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/demo_state/demo_state.dart';
import '../../core/theme/weman_colors.dart';
import '../../core/theme/weman_typography.dart';
import '../../core/widgets/weman_card.dart';

class FitnessTrackingScreen extends ConsumerStatefulWidget {
  const FitnessTrackingScreen({super.key});

  @override
  ConsumerState<FitnessTrackingScreen> createState() =>
      _FitnessTrackingScreenState();
}

class _FitnessTrackingScreenState extends ConsumerState<FitnessTrackingScreen> {
  int _viewMode = 0; // 0 = Daily, 1 = Weekly
  String _selectedDate = 'Today, Oct 24';

  @override
  Widget build(BuildContext context) {
    final telemetry = ref.watch(workoutTelemetryProvider);

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
        title: Text(
          'Fitness Tracking',
          style: WemanTypography.headlineSmall.copyWith(
            fontWeight: FontWeight.w800,
            color: WemanColors.onSurface,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.send_rounded,
                color: WemanColors.onSurface, size: 22),
            onPressed: () => context.push('/inbox'),
          ),
          IconButton(
            icon: const Icon(Icons.info_outline_rounded,
                color: WemanColors.onSurface, size: 22),
            onPressed: () => _showInfoModal(context),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // 1. Date & Daily / Weekly View Selector
            _buildViewSelector(),
            const SizedBox(height: 12),

            // 2. Session Progression Banner
            _buildSessionProgressionBanner(telemetry),
            const SizedBox(height: 14),

            // 3. Hero Telemetry Radial Target Ring Card
            _buildHeroTelemetryCard(telemetry),
            const SizedBox(height: 14),

            // 4. Core Metrics 2x2 Grid (Steps, Active Burn, Active Time, Distance)
            _buildMetricsGrid(telemetry),
            const SizedBox(height: 14),

            // 5. Recorded Workout History Section
            _buildWorkoutHistorySection(telemetry),
            const SizedBox(height: 14),

            // 6. Weekly Consistency Bar Chart & Streak Card
            _buildWeeklyConsistencyCard(telemetry),
            const SizedBox(height: 14),

            // 7. Cardio Intensity Zones Breakdown
            _buildCardioZonesCard(),
            const SizedBox(height: 14),

            // 8. Coach Feedback Banner
            _buildCoachFeedbackCard(),
            const SizedBox(height: 18),

            // 9. Illustrative Telemetry Disclaimer
            Center(
              child: Text(
                'Illustrative athlete telemetry demo values.',
                style: WemanTypography.bodySmall.copyWith(
                  color: WemanColors.textMuted,
                  fontSize: 11,
                ),
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  // --- 1. DATE & VIEW TOGGLE ---
  Widget _buildViewSelector() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        GestureDetector(
          onTap: () => _showDatePickerSheet(),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            decoration: BoxDecoration(
              color: WemanColors.cardBg,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: WemanColors.surfaceContainerHigh),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.02),
                  blurRadius: 6,
                ),
              ],
            ),
            child: Row(
              children: [
                const Icon(Icons.calendar_today_rounded,
                    size: 15, color: WemanColors.primary),
                const SizedBox(width: 8),
                Text(
                  _selectedDate,
                  style: WemanTypography.labelMedium.copyWith(
                    fontWeight: FontWeight.w700,
                    color: WemanColors.onSurface,
                  ),
                ),
                const SizedBox(width: 4),
                const Icon(Icons.expand_more_rounded,
                    size: 18, color: WemanColors.textMuted),
              ],
            ),
          ),
        ),
        Container(
          padding: const EdgeInsets.all(3),
          decoration: BoxDecoration(
            color: WemanColors.surfaceContainer,
            borderRadius: BorderRadius.circular(24),
          ),
          child: Row(
            children: [
              _buildToggleChip('DAILY', 0),
              _buildToggleChip('WEEKLY', 1),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildToggleChip(String label, int index) {
    final isSelected = _viewMode == index;
    return GestureDetector(
      onTap: () => setState(() => _viewMode = index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected ? WemanColors.cardBg : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 4,
                  ),
                ]
              : null,
        ),
        child: Text(
          label,
          style: WemanTypography.labelSmall.copyWith(
            color: isSelected ? WemanColors.onSurface : WemanColors.textMuted,
            fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
            fontSize: 11,
          ),
        ),
      ),
    );
  }

  // --- 2. SESSION PROGRESSION BANNER ---
  Widget _buildSessionProgressionBanner(WorkoutTelemetryState telemetry) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: WemanColors.cardBg,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: WemanColors.surfaceContainerHigh),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 6,
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                width: 38,
                height: 38,
                decoration: const BoxDecoration(
                  color: WemanColors.neonLime,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.check_circle_rounded,
                  color: WemanColors.onSurface,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'SESSION PROGRESSION',
                    style: WemanTypography.labelSmall.copyWith(
                      color: WemanColors.textMuted,
                      fontSize: 9,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 0.8,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '${telemetry.todayCompletedWorkouts} Completed',
                    style: WemanTypography.headlineSmall.copyWith(
                      fontWeight: FontWeight.w800,
                      fontSize: 15,
                    ),
                  ),
                ],
              ),
            ],
          ),
          GestureDetector(
            onTap: () => context.push('/workout-details'),
            child: Text(
              'Next: Core & 15m Wrap',
              style: WemanTypography.labelSmall.copyWith(
                color: WemanColors.primary,
                fontWeight: FontWeight.w800,
                decoration: TextDecoration.underline,
                fontSize: 11,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // --- 3. HERO TELEMETRY RADIAL PROGRESS RING CARD ---
  Widget _buildHeroTelemetryCard(WorkoutTelemetryState telemetry) {
    return WemanCard(
      padding: const EdgeInsets.all(18),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Radial Progress Ring
              SizedBox(
                width: 130,
                height: 130,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    const SizedBox(
                      width: 120,
                      height: 120,
                      child: CircularProgressIndicator(
                        value: 0.84,
                        strokeWidth: 12,
                        backgroundColor: WemanColors.surfaceContainerHigh,
                        valueColor:
                            AlwaysStoppedAnimation<Color>(WemanColors.neonLime),
                        strokeCap: StrokeCap.round,
                      ),
                    ),
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'TARGET',
                          style: WemanTypography.labelSmall.copyWith(
                            color: WemanColors.textMuted,
                            fontSize: 9,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 0.8,
                          ),
                        ),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '84',
                              style: WemanTypography.displaySmall.copyWith(
                                fontWeight: FontWeight.w900,
                                fontSize: 26,
                                height: 1.1,
                              ),
                            ),
                            Text(
                              '%',
                              style: WemanTypography.labelSmall.copyWith(
                                color: WemanColors.primary,
                                fontWeight: FontWeight.w900,
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                        Text(
                          'Crushing It',
                          style: WemanTypography.labelSmall.copyWith(
                            color: WemanColors.primary,
                            fontWeight: FontWeight.w800,
                            fontSize: 10,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 18),

              // Momentum Copy & Stat Callouts
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'DAILY MOMENTUM',
                          style: WemanTypography.labelSmall.copyWith(
                            color: WemanColors.onSurface,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 0.6,
                            fontSize: 10,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 7, vertical: 2),
                          decoration: BoxDecoration(
                            color: WemanColors.neonLime,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            'OPTIMAL',
                            style: WemanTypography.labelSmall.copyWith(
                              fontWeight: FontWeight.w900,
                              fontSize: 9,
                              color: WemanColors.onSurface,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'You have achieved ${telemetry.caloriesBurned} kcal towards your combined 2,600 kcal burned + 10k steps benchmark today.',
                      style: WemanTypography.bodySmall.copyWith(
                        color: WemanColors.textMuted,
                        fontSize: 11,
                        height: 1.35,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: WemanColors.surfaceContainerLow,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Energy Left',
                                  style: WemanTypography.labelSmall.copyWith(
                                    color: WemanColors.textMuted,
                                    fontSize: 9,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  '384 kcal',
                                  style: WemanTypography.labelMedium.copyWith(
                                    fontWeight: FontWeight.w800,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: WemanColors.surfaceContainerLow,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Est. Finish',
                                  style: WemanTypography.labelSmall.copyWith(
                                    color: WemanColors.textMuted,
                                    fontSize: 9,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  '18:45 hrs',
                                  style: WemanTypography.labelMedium.copyWith(
                                    fontWeight: FontWeight.w800,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // --- 4. 2x2 CORE METRICS GRID ---
  Widget _buildMetricsGrid(WorkoutTelemetryState telemetry) {
    return GridView.count(
      crossAxisCount: 2,
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      childAspectRatio: 1.05,
      children: [
        // Metric 1: Steps Taken (Demo)
        _buildMetricBox(
          icon: Icons.directions_walk_rounded,
          iconBg: WemanColors.surfaceContainer,
          badgeWidget: SizedBox(
            width: 26,
            height: 26,
            child: Stack(
              alignment: Alignment.center,
              children: [
                const CircularProgressIndicator(
                  value: 0.95,
                  strokeWidth: 3,
                  backgroundColor: WemanColors.surfaceContainerHigh,
                  valueColor:
                      AlwaysStoppedAnimation<Color>(WemanColors.primary),
                ),
                Text(
                  '95%',
                  style: WemanTypography.labelSmall
                      .copyWith(fontSize: 8, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          label: 'Steps Taken',
          value: '11,420',
          subtext: '/ ${telemetry.stepGoal} target (Demo)',
          footerIcon: Icons.trending_up_rounded,
          footerText: 'DEMO SENSOR DATA',
          footerColor: WemanColors.primary,
        ),

        // Metric 2: Active Burn
        _buildMetricBox(
          icon: Icons.local_fire_department_rounded,
          iconBg: WemanColors.neonLime,
          badgeWidget: Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              color: WemanColors.surfaceContainer,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              'ACTIVE',
              style: WemanTypography.labelSmall
                  .copyWith(fontSize: 9, color: WemanColors.textMuted),
            ),
          ),
          label: 'Active Burn',
          value: '${telemetry.caloriesBurned} kcal',
          progressBarValue: (telemetry.caloriesBurned / 900).clamp(0.1, 1.0),
          progressColor: WemanColors.neonLime,
          footerText: 'DEMO EST. • ${telemetry.workoutHistory.length} SESSIONS',
          footerColor: WemanColors.textMuted,
        ),

        // Metric 3: Active Time
        _buildMetricBox(
          icon: Icons.timer_outlined,
          iconBg: WemanColors.surfaceContainer,
          badgeWidget: const Icon(Icons.bolt_rounded,
              size: 20, color: WemanColors.primary),
          label: 'Active Time',
          value: '${telemetry.activeMinutes} mins',
          progressBarValue: (telemetry.activeMinutes / 90).clamp(0.1, 1.0),
          progressColor: WemanColors.softLime,
          footerText: 'MEASURED & ACCUMULATED',
          footerColor: WemanColors.textMuted,
        ),

        // Metric 4: Distance (Demo)
        _buildMetricBox(
          icon: Icons.route_rounded,
          iconBg: WemanColors.surfaceContainer,
          badgeWidget: Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              color: WemanColors.softLime,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              '+21%',
              style: WemanTypography.labelSmall.copyWith(
                fontSize: 9,
                fontWeight: FontWeight.w800,
                color: WemanColors.primary,
              ),
            ),
          ),
          label: 'Distance',
          value: '${telemetry.distanceKm} km',
          subtext: 'Demo GPS Estimate',
          footerIcon: Icons.arrow_upward_rounded,
          footerText: 'ESTIMATED ROAD',
          footerColor: WemanColors.primary,
        ),
      ],
    );
  }

  Widget _buildMetricBox({
    required IconData icon,
    required Color iconBg,
    required Widget badgeWidget,
    required String label,
    required String value,
    String? subtext,
    double? progressBarValue,
    Color? progressColor,
    IconData? footerIcon,
    required String footerText,
    required Color footerColor,
  }) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: WemanColors.cardBg,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: WemanColors.surfaceContainerHigh),
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
                width: 34,
                height: 34,
                decoration: BoxDecoration(
                  color: iconBg,
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, size: 18, color: WemanColors.onSurface),
              ),
              badgeWidget,
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: WemanTypography.labelSmall.copyWith(
                  color: WemanColors.textMuted,
                  fontSize: 11,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: WemanTypography.headlineSmall.copyWith(
                  fontWeight: FontWeight.w900,
                  fontSize: 18,
                ),
              ),
              if (subtext != null) ...[
                const SizedBox(height: 2),
                Text(
                  subtext,
                  style: WemanTypography.bodySmall.copyWith(
                    color: WemanColors.textMuted,
                    fontSize: 10,
                  ),
                ),
              ],
              if (progressBarValue != null) ...[
                const SizedBox(height: 6),
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: progressBarValue,
                    minHeight: 6,
                    backgroundColor: WemanColors.surfaceContainerHigh,
                    valueColor: AlwaysStoppedAnimation<Color>(
                        progressColor ?? WemanColors.neonLime),
                  ),
                ),
              ],
              const SizedBox(height: 6),
              Row(
                children: [
                  if (footerIcon != null) ...[
                    Icon(footerIcon, size: 12, color: footerColor),
                    const SizedBox(width: 3),
                  ],
                  Text(
                    footerText,
                    style: WemanTypography.labelSmall.copyWith(
                      color: footerColor,
                      fontSize: 9.5,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  // --- RECENT COMPLETED WORKOUTS HISTORY ---
  Widget _buildWorkoutHistorySection(WorkoutTelemetryState telemetry) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Text(
                  'WORKOUT HISTORY',
                  style: WemanTypography.labelSmall.copyWith(
                    fontWeight: FontWeight.w900,
                    letterSpacing: 0.8,
                    color: WemanColors.textMuted,
                    fontSize: 11,
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                  decoration: BoxDecoration(
                    color: WemanColors.neonLime,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    '${telemetry.workoutHistory.length} LOGGED',
                    style: WemanTypography.labelSmall.copyWith(
                      fontWeight: FontWeight.w900,
                      fontSize: 9,
                      color: WemanColors.onSurface,
                    ),
                  ),
                ),
              ],
            ),
            Text(
              '${telemetry.activeMinutes}m Total Active',
              style: WemanTypography.labelSmall.copyWith(
                color: WemanColors.primary,
                fontWeight: FontWeight.w700,
                fontSize: 11,
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        if (telemetry.workoutHistory.isEmpty)
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: WemanColors.cardBg,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: WemanColors.surfaceContainerHigh),
            ),
            child: Center(
              child: Text(
                'No recorded workouts yet. Complete a session to log telemetry.',
                style: WemanTypography.bodySmall.copyWith(
                  color: WemanColors.textMuted,
                  fontSize: 12,
                ),
              ),
            ),
          )
        else
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: telemetry.workoutHistory.length,
            separatorBuilder: (_, __) => const SizedBox(height: 8),
            itemBuilder: (context, index) {
              final workout = telemetry.workoutHistory[index];
              final timeString =
                  '${workout.completedAt.hour.toString().padLeft(2, '0')}:${workout.completedAt.minute.toString().padLeft(2, '0')}';
              return Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: WemanColors.cardBg,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: WemanColors.surfaceContainerHigh),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.02),
                      blurRadius: 6,
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: const BoxDecoration(
                        color: WemanColors.neonLime,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.fitness_center_rounded,
                        color: WemanColors.onSurface,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text(
                                  workout.workoutName,
                                  style: WemanTypography.titleSmall.copyWith(
                                    fontWeight: FontWeight.w800,
                                    fontSize: 13,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              Text(
                                timeString,
                                style: WemanTypography.labelSmall.copyWith(
                                  color: WemanColors.textMuted,
                                  fontSize: 10,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(
                            workout.exerciseName,
                            style: WemanTypography.bodySmall.copyWith(
                              color: WemanColors.textMuted,
                              fontSize: 11,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Wrap(
                            spacing: 6,
                            runSpacing: 4,
                            children: [
                              _buildMiniBadge(
                                Icons.timer_outlined,
                                '${workout.durationMinutes}m',
                                WemanColors.surfaceContainerLow,
                                WemanColors.onSurface,
                              ),
                              _buildMiniBadge(
                                Icons.local_fire_department_rounded,
                                '${workout.caloriesBurned} kcal (Demo Est.)',
                                WemanColors.surfaceContainerLow,
                                WemanColors.onSurface,
                              ),
                              _buildMiniBadge(
                                Icons.check_circle_outline,
                                '${workout.completedSets}/${workout.totalSets} Sets',
                                WemanColors.surfaceContainerLow,
                                WemanColors.onSurface,
                              ),
                              _buildMiniBadge(
                                Icons.bolt_rounded,
                                '+${workout.xpEarned} XP',
                                WemanColors.softLime,
                                WemanColors.primary,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
      ],
    );
  }

  Widget _buildMiniBadge(
      IconData icon, String text, Color bg, Color textColor) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 11, color: textColor),
          const SizedBox(width: 3),
          Text(
            text,
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w700,
              color: textColor,
            ),
          ),
        ],
      ),
    );
  }

  // --- 5. WEEKLY CONSISTENCY BAR CHART & STREAK ---
  Widget _buildWeeklyConsistencyCard(WorkoutTelemetryState telemetry) {
    final List<Map<String, dynamic>> weekDays = [
      {'day': 'M', 'height': 0.72, 'label': '70m', 'isToday': false},
      {'day': 'T', 'height': 0.52, 'label': '50m', 'isToday': false},
      {'day': 'W', 'height': 0.88, 'label': '85m', 'isToday': false},
      {'day': 'T', 'height': 0.42, 'label': '40m', 'isToday': false},
      {'day': 'F', 'height': 0.94, 'label': '94m', 'isToday': true},
      {
        'day': 'S',
        'height': 0.25,
        'label': 'Plan',
        'isToday': false,
        'isFuture': true
      },
      {
        'day': 'S',
        'height': 0.15,
        'label': 'Rest',
        'isToday': false,
        'isFuture': true
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
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 6,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Weekly Consistency',
                    style: WemanTypography.headlineSmall.copyWith(
                      fontWeight: FontWeight.w800,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'Target: 5 training days / week',
                    style: WemanTypography.bodySmall.copyWith(
                      color: WemanColors.textMuted,
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                decoration: BoxDecoration(
                  color: WemanColors.surfaceContainerHigh,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  'WEEK 43',
                  style: WemanTypography.labelSmall.copyWith(
                    fontWeight: FontWeight.w800,
                    fontSize: 10,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),

          // 7-Day Bar Chart
          SizedBox(
            height: 130,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: weekDays.map((bar) {
                final isToday = bar['isToday'] as bool;
                final isFuture = bar['isFuture'] == true;
                final heightFraction = bar['height'] as double;

                return Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      bar['label'] as String,
                      style: WemanTypography.labelSmall.copyWith(
                        fontSize: 9,
                        color: isToday
                            ? WemanColors.primary
                            : WemanColors.textMuted,
                        fontWeight: isToday ? FontWeight.w900 : FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Container(
                      width: 28,
                      height: 80 * heightFraction,
                      decoration: BoxDecoration(
                        color: isToday
                            ? WemanColors.neonLime
                            : isFuture
                                ? WemanColors.surfaceContainerHigh
                                : WemanColors.inverseSurface,
                        borderRadius: BorderRadius.circular(14),
                        boxShadow: isToday
                            ? [
                                BoxShadow(
                                  color: WemanColors.neonLime
                                      .withValues(alpha: 0.6),
                                  blurRadius: 8,
                                  spreadRadius: 1,
                                ),
                              ]
                            : null,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      bar['day'] as String,
                      style: WemanTypography.labelSmall.copyWith(
                        fontSize: 11,
                        color: isToday
                            ? WemanColors.onSurface
                            : WemanColors.textMuted,
                        fontWeight: isToday ? FontWeight.w900 : FontWeight.w700,
                      ),
                    ),
                  ],
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 14),

          // Streak Strip
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: WemanColors.surfaceContainerLow,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                Container(
                  width: 34,
                  height: 34,
                  decoration: const BoxDecoration(
                    color: WemanColors.neonLime,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.local_fire_department_rounded,
                      size: 20, color: WemanColors.onSurface),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            '${telemetry.currentStreakDays}-Day',
                            style: WemanTypography.labelMedium.copyWith(
                              fontWeight: FontWeight.w900,
                              fontSize: 13,
                            ),
                          ),
                          const SizedBox(width: 6),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 6, vertical: 1.5),
                            decoration: BoxDecoration(
                              color: WemanColors.inverseSurface,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              'ACTIVE STREAK',
                              style: WemanTypography.labelSmall.copyWith(
                                color: WemanColors.neonLime,
                                fontSize: 8.5,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                          ),
                        ],
                      ),
                      Text(
                        'You never miss a Friday session',
                        style: WemanTypography.bodySmall.copyWith(
                          color: WemanColors.textMuted,
                          fontSize: 10.5,
                        ),
                      ),
                    ],
                  ),
                ),
                const Icon(Icons.arrow_forward_ios_rounded,
                    size: 13, color: WemanColors.textMuted),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // --- 6. CARDIO INTENSITY ZONES ---
  Widget _buildCardioZonesCard() {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: WemanColors.cardBg,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: WemanColors.surfaceContainerHigh),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 6,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Cardio Intensity Zones',
                    style: WemanTypography.headlineSmall.copyWith(
                      fontWeight: FontWeight.w800,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'Based on optical sensor telemetry',
                    style: WemanTypography.bodySmall.copyWith(
                      color: WemanColors.textMuted,
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: WemanColors.surfaceContainerLow,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.monitor_heart_rounded,
                        size: 14, color: WemanColors.primary),
                    const SizedBox(width: 4),
                    Text(
                      '144 avg bpm',
                      style: WemanTypography.labelSmall.copyWith(
                        fontWeight: FontWeight.w800,
                        fontSize: 10,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),

          // Zone 2
          _buildZoneRow(
            dotColor: WemanColors.primary,
            title: 'Zone 2: Aerobic Base',
            duration: '24 mins',
            bpmRange: '110 - 138 bpm',
            percentage: '46% of workout',
            progressFraction: 0.46,
            barColor: WemanColors.primary,
          ),
          const SizedBox(height: 10),

          // Zone 4
          _buildZoneRow(
            dotColor: WemanColors.neonLime,
            title: 'Zone 4: Threshold & VO2',
            duration: '18 mins',
            bpmRange: '155 - 170 bpm',
            percentage: '35% of workout',
            progressFraction: 0.35,
            barColor: WemanColors.neonLime,
          ),
          const SizedBox(height: 10),

          // Zone 5
          _buildZoneRow(
            dotColor: WemanColors.error,
            title: 'Peak Zone 5: Maximum Effort',
            duration: '10 mins',
            bpmRange: '172+ bpm',
            percentage: '19% of workout',
            progressFraction: 0.19,
            barColor: WemanColors.error,
          ),
        ],
      ),
    );
  }

  Widget _buildZoneRow({
    required Color dotColor,
    required String title,
    required String duration,
    required String bpmRange,
    required String percentage,
    required double progressFraction,
    required Color barColor,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: WemanColors.surfaceContainerLow,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    width: 7,
                    height: 7,
                    decoration: BoxDecoration(
                      color: dotColor,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    title,
                    style: WemanTypography.labelMedium.copyWith(
                      fontWeight: FontWeight.w700,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
              Text(
                duration,
                style: WemanTypography.labelSmall.copyWith(
                  fontWeight: FontWeight.w800,
                  fontSize: 11,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: progressFraction,
              minHeight: 5,
              backgroundColor: WemanColors.surfaceContainerHigh,
              valueColor: AlwaysStoppedAnimation<Color>(barColor),
            ),
          ),
          const SizedBox(height: 6),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                bpmRange,
                style: WemanTypography.bodySmall.copyWith(
                  color: WemanColors.textMuted,
                  fontSize: 10,
                ),
              ),
              Text(
                percentage,
                style: WemanTypography.bodySmall.copyWith(
                  color: WemanColors.textMuted,
                  fontSize: 10,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // --- 7. COACH FEEDBACK CARD ---
  Widget _buildCoachFeedbackCard() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: WemanColors.cardBg,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: WemanColors.surfaceContainerHigh),
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: const BoxDecoration(
              color: WemanColors.surfaceContainerHigh,
              shape: BoxShape.circle,
            ),
            child: ClipOval(
              child: Image.network(
                'https://lh3.googleusercontent.com/aida-public/AB6AXuCLxebhFGRsv7ILx6y2r5T8u2THgUQuTW9YFbu4SYVo5p62eJ-Le8Jht0pRhXeSKYHpTYwk67rL8LemjFzvg7Bpedw-BJBDWJ6u13ob3oX9nciYQN54ZT8F8qURmQ1RbADakX0YPyXpaRe4Rf1rBoElWiwwr4eupDm1T6OPEN_dAqn0NymeYjr6zL64UXT0L35VojInOPWUdqjNpvA5WSVkViqBBmaulrtQ759P2jcGRhnaJIpUoq-2',
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) =>
                    const Icon(Icons.person, color: WemanColors.onSurface),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'COACH FEEDBACK',
                  style: WemanTypography.labelSmall.copyWith(
                    color: WemanColors.primary,
                    fontWeight: FontWeight.w900,
                    fontSize: 9,
                    letterSpacing: 0.6,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'Excellent pacing in Zone 2 today. Muscle recovery readiness is predicted at 92% for tomorrow\'s leg day.',
                  style: WemanTypography.bodySmall.copyWith(
                    color: WemanColors.onSurface,
                    fontSize: 11,
                    height: 1.3,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showDatePickerSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: WemanColors.cardBg,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) {
        final dates = [
          'Today, Oct 24',
          'Yesterday, Oct 23',
          'Tue, Oct 22',
          'Mon, Oct 21',
          'Sun, Oct 20'
        ];
        return Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Select Activity Log Day',
                  style: WemanTypography.titleMedium
                      .copyWith(fontWeight: FontWeight.w800)),
              const SizedBox(height: 12),
              ...dates.map((d) => ListTile(
                    title: Text(d,
                        style: const TextStyle(fontWeight: FontWeight.w600)),
                    trailing: d == _selectedDate
                        ? const Icon(Icons.check, color: WemanColors.primary)
                        : null,
                    onTap: () {
                      setState(() => _selectedDate = d);
                      Navigator.pop(ctx);
                    },
                  )),
            ],
          ),
        );
      },
    );
  }

  void _showInfoModal(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: WemanColors.cardBg,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('About Fitness Tracking',
            style: TextStyle(fontWeight: FontWeight.w800)),
        content: const Text(
          'Tracked parameters (active minutes, estimated calories, and steps) combine user logged workouts with estimated basal rate calculations.\n\nOptical telemetry readings are illustrative demo values.',
          style: TextStyle(fontSize: 13, height: 1.4),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Got it',
                style: TextStyle(
                    color: WemanColors.primary, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }
}
