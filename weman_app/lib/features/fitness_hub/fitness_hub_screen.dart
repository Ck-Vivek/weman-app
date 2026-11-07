import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/weman_colors.dart';
import '../../core/theme/weman_typography.dart';
import '../../core/widgets/weman_bottom_nav.dart';

class FitnessHubScreen extends StatefulWidget {
  const FitnessHubScreen({super.key});

  @override
  State<FitnessHubScreen> createState() => _FitnessHubScreenState();
}

class _FitnessHubScreenState extends State<FitnessHubScreen> {
  int _selectedFilterIndex = 0;
  final TextEditingController _searchController = TextEditingController();

  final List<String> _filters = [
    'All Hub',
    'Workouts',
    'Indian Nutrition',
    'Meal Guide',
    'Habits',
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
                    _buildSearchBar(),
                    const SizedBox(height: 12),
                    _buildFilterChips(),
                    const SizedBox(height: 18),

                    // Section 1: Prominent Daily Diet & Hydration Tracker Banner
                    if (_selectedFilterIndex == 0 ||
                        _selectedFilterIndex == 2 ||
                        _selectedFilterIndex == 3) ...[
                      _buildDietTrackerBanner(),
                      const SizedBox(height: 22),
                    ],

                    // Section 2: Workout Routines
                    if (_selectedFilterIndex == 0 ||
                        _selectedFilterIndex == 1) ...[
                      _buildWorkoutRoutinesSection(),
                      const SizedBox(height: 24),
                    ],

                    // Section 3: Indian Food & Nutrition Visual Guide
                    if (_selectedFilterIndex == 0 ||
                        _selectedFilterIndex == 2) ...[
                      _buildIndianFoodGuideSection(),
                      const SizedBox(height: 24),
                    ],

                    // Section 4: Optimal Meal Plate Balance
                    if (_selectedFilterIndex == 0 ||
                        _selectedFilterIndex == 2 ||
                        _selectedFilterIndex == 3) ...[
                      _buildMealPlateBalanceSection(),
                      const SizedBox(height: 24),
                    ],

                    // Section 5: Recovery & Habit Consistency
                    if (_selectedFilterIndex == 0 ||
                        _selectedFilterIndex == 4) ...[
                      _buildRecoveryHabitsSection(),
                      const SizedBox(height: 28),
                    ],
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: WemanBottomNav(
        currentIndex: 1,
        onTap: (index) {
          if (index == 0) context.go('/feed');
          if (index == 1) {}
          if (index == 2) context.go('/reels');
          if (index == 3) context.go('/explore');
          if (index == 4) context.go('/profile');
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
          bottom:
              BorderSide(color: WemanColors.surfaceContainerHigh, width: 0.5),
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
                decoration: BoxDecoration(
                  color: WemanColors.neonLime,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: WemanColors.neonLime.withValues(alpha: 0.8),
                      blurRadius: 4,
                      spreadRadius: 1,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Text(
                'WEMAN FIT',
                style: WemanTypography.labelSmall.copyWith(
                  fontWeight: FontWeight.w900,
                  letterSpacing: 1.0,
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
                'Fitness Hub',
                style: WemanTypography.labelSmall.copyWith(
                  color: WemanColors.onSurface,
                  fontWeight: FontWeight.w800,
                  fontSize: 12,
                ),
              ),
            ],
          ),
          Row(
            children: [
              IconButton(
                onPressed: () => context.push('/inbox'),
                icon: const Icon(Icons.notifications_none_rounded,
                    color: WemanColors.onSurface, size: 22),
              ),
              const SizedBox(width: 4),
              GestureDetector(
                onTap: () => context.go('/profile'),
                child: Container(
                  width: 34,
                  height: 34,
                  padding: const EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: WemanColors.neonLime, width: 2),
                  ),
                  child: ClipOval(
                    child: Image.network(
                      'https://lh3.googleusercontent.com/aida/AEtjO1X5Nj9Se13MRhEdx0DUW0NEIAabzUdDCNr-Qiwd9Dp-vagjDLTDgbcrWOd6bO0pbTwLx1gwW8EGf8pYA41kC7HekPJPiPffiAzsEkZCF3Bdi_5XNrUiJvVlzg4uuDJwKg3bmNp2od0jpr_mUIonYAI42iqH8iWQfMYZYvBJAey8z-fFwgNPNtwV1rqcMzAaYxEPHySmTfS1p1NWMg4zwCaIh-zrHalrDDBcklSRUevnQZVI2YNvLbVpZQ',
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => const Icon(
                        Icons.person_rounded,
                        size: 20,
                        color: WemanColors.onSurface,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      decoration: BoxDecoration(
        color: WemanColors.cardBg,
        borderRadius: BorderRadius.circular(26),
        border: Border.all(color: WemanColors.surfaceContainerHigh),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TextField(
        controller: _searchController,
        style: WemanTypography.bodySmall.copyWith(color: WemanColors.onSurface),
        decoration: InputDecoration(
          hintText: 'Search routines, exercises, Indian nutrition...',
          hintStyle: WemanTypography.bodySmall
              .copyWith(color: WemanColors.textMuted, fontSize: 13),
          prefixIcon: const Icon(Icons.search_rounded,
              color: WemanColors.textMuted, size: 20),
          suffixIcon: Container(
            margin: const EdgeInsets.all(6),
            width: 30,
            height: 30,
            decoration: const BoxDecoration(
              color: WemanColors.surfaceContainerLow,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.tune_rounded,
                size: 16, color: WemanColors.onSurface),
          ),
          border: InputBorder.none,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        ),
      ),
    );
  }

  Widget _buildFilterChips() {
    return SizedBox(
      height: 34,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: _filters.length,
        itemBuilder: (context, index) {
          final isSelected = _selectedFilterIndex == index;
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: GestureDetector(
              onTap: () => setState(() => _selectedFilterIndex = index),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                padding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                decoration: BoxDecoration(
                  color: isSelected
                      ? WemanColors.inverseSurface
                      : WemanColors.cardBg,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: isSelected
                        ? WemanColors.inverseSurface
                        : WemanColors.surfaceContainerHigh,
                  ),
                  boxShadow: isSelected
                      ? [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.08),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ]
                      : null,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (isSelected) ...[
                      Container(
                        width: 6,
                        height: 6,
                        decoration: const BoxDecoration(
                          color: WemanColors.neonLime,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 6),
                    ],
                    Text(
                      _filters[index],
                      style: WemanTypography.labelSmall.copyWith(
                        color:
                            isSelected ? Colors.white : WemanColors.onSurface,
                        fontWeight:
                            isSelected ? FontWeight.w800 : FontWeight.w600,
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  // --- 1. PROMINENT DIET & HYDRATION TRACKER HERO CARD ---
  Widget _buildDietTrackerBanner() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: WemanColors.cardBg,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: WemanColors.neonLime, width: 2),
        boxShadow: [
          BoxShadow(
            color: WemanColors.neonLime.withValues(alpha: 0.22),
            blurRadius: 18,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: WemanColors.neonLime,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            'DAILY FUEL',
                            style: WemanTypography.labelSmall.copyWith(
                              fontSize: 9,
                              fontWeight: FontWeight.w900,
                              color: WemanColors.onSurface,
                              letterSpacing: 0.6,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
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
                    const SizedBox(height: 6),
                    Text(
                      '🥗 Daily Diet & Hydration Tracker',
                      style: WemanTypography.headlineSmall.copyWith(
                        fontWeight: FontWeight.w800,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      'Log your Indian meals, track protein & macro targets, and monitor daily water intake.',
                      style: WemanTypography.bodySmall.copyWith(
                        color: WemanColors.textMuted,
                        fontSize: 11,
                        height: 1.3,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 10),
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: WemanColors.softLime,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                      color: WemanColors.neonLime.withValues(alpha: 0.5)),
                ),
                child: const Icon(Icons.restaurant_menu_rounded,
                    color: WemanColors.primary, size: 22),
              ),
            ],
          ),
          const SizedBox(height: 14),

          // 3-Metric Progress Row
          Container(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
            decoration: BoxDecoration(
              color: WemanColors.surfaceContainerLow,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'DAILY LOG',
                        style: WemanTypography.labelSmall.copyWith(
                          fontSize: 9,
                          color: WemanColors.textMuted,
                          letterSpacing: 0.5,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '75% Done',
                        style: WemanTypography.labelLarge.copyWith(
                            fontWeight: FontWeight.w800, fontSize: 13),
                      ),
                    ],
                  ),
                ),
                Container(
                    width: 1,
                    height: 28,
                    color: WemanColors.surfaceContainerHigh),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'CALORIES',
                          style: WemanTypography.labelSmall.copyWith(
                            fontSize: 9,
                            color: WemanColors.textMuted,
                            letterSpacing: 0.5,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          '1,780 / 2.2k',
                          style: WemanTypography.labelLarge.copyWith(
                              fontWeight: FontWeight.w800, fontSize: 13),
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                    width: 1,
                    height: 28,
                    color: WemanColors.surfaceContainerHigh),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'HYDRATION',
                          style: WemanTypography.labelSmall.copyWith(
                            fontSize: 9,
                            color: WemanColors.textMuted,
                            letterSpacing: 0.5,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          '3.2L Water',
                          style: WemanTypography.labelLarge.copyWith(
                            fontWeight: FontWeight.w900,
                            color: WemanColors.primary,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),

          // Prominent CTA Button
          GestureDetector(
            onTap: () => context.push('/diet-tracker'),
            child: Container(
              width: double.infinity,
              height: 46,
              decoration: BoxDecoration(
                color: WemanColors.neonLime,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: WemanColors.neonLime.withValues(alpha: 0.35),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'OPEN DIET TRACKER',
                    style: WemanTypography.labelLarge.copyWith(
                      fontWeight: FontWeight.w900,
                      color: WemanColors.onSurface,
                      letterSpacing: 0.6,
                      fontSize: 13,
                    ),
                  ),
                  const SizedBox(width: 6),
                  const Icon(Icons.arrow_forward_rounded,
                      size: 18, color: WemanColors.onSurface),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // --- 2. WORKOUT ROUTINES SECTION (6 Cards from Stitch Design) ---
  Widget _buildWorkoutRoutinesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                const Icon(Icons.fitness_center_rounded,
                    size: 20, color: WemanColors.primary),
                const SizedBox(width: 6),
                Text(
                  'Workout Routines',
                  style: WemanTypography.titleMedium
                      .copyWith(fontWeight: FontWeight.w800),
                ),
              ],
            ),
            GestureDetector(
              onTap: () => context.push('/training-hub'),
              child: Text(
                'View All (18)',
                style: WemanTypography.labelSmall.copyWith(
                  color: WemanColors.primary,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),

        // Routine 1: Chest & Triceps Blast
        _buildRoutineItemCard(
          category: 'HYPERTROPHY',
          level: 'Intermediate',
          categoryColor: WemanColors.softLime,
          title: 'Chest & Triceps Blast',
          desc:
              'Dumbbells & Barbell • Flat Bench, Incline DB Press, Cable Pushdowns.',
          duration: '45 mins',
          equipment: 'Dumbbells & Barbell',
          icon: Icons.fitness_center_rounded,
        ),
        const SizedBox(height: 10),

        // Routine 2: Back & Delts Hypertrophy
        _buildRoutineItemCard(
          category: 'STRENGTH',
          level: 'Advanced',
          categoryColor: WemanColors.surfaceContainerLow,
          title: 'Back & Delts Hypertrophy',
          desc:
              'Pull-up Bar & Cable • Weighted Chins, Lat Pulldowns, Lateral Raises.',
          duration: '55 mins',
          equipment: 'Pull-up Bar & Cable',
          icon: Icons.sports_kabaddi_rounded,
        ),
        const SizedBox(height: 10),

        // Routine 3: Quad & Glute Power
        _buildRoutineItemCard(
          category: 'LOWER BODY',
          level: 'Intermediate',
          categoryColor: WemanColors.softLime,
          title: 'Quad & Glute Power',
          desc:
              'Barbell & Leg Press • Back Squats, Romanian Deadlifts, Walking Lunges.',
          duration: '50 mins',
          equipment: 'Barbell & Leg Press',
          icon: Icons.directions_run_rounded,
        ),
        const SizedBox(height: 10),

        // Routine 4: Full-Body Functional HIIT
        _buildRoutineItemCard(
          category: 'CONDITIONING',
          level: 'All Levels',
          categoryColor: WemanColors.surfaceContainerLow,
          title: 'Full-Body Functional HIIT',
          desc:
              'Kettlebell & Bodyweight • Kettlebell swings, box jumps, burpees, sprint drills.',
          duration: '35 mins',
          equipment: 'Kettlebell & Bodyweight',
          icon: Icons.bolt_rounded,
        ),
        const SizedBox(height: 10),

        // Routine 5: Core & Abdominals Sculpt
        _buildRoutineItemCard(
          category: 'CORE PILLAR',
          level: 'Beginner Friendly',
          categoryColor: WemanColors.surfaceContainerLow,
          title: 'Core & Abdominals Sculpt',
          desc:
              'Mat • Dead bugs, hollow body holds, hanging knee raises, side planks.',
          duration: '20 mins',
          equipment: 'Mat',
          icon: Icons.self_improvement_rounded,
        ),
        const SizedBox(height: 10),

        // Routine 6: Mobility & Dynamic Stretching
        _buildRoutineItemCard(
          category: 'RECOVERY',
          level: 'Recovery Day',
          categoryColor: WemanColors.softLime,
          title: 'Mobility & Dynamic Stretching',
          desc:
              'Foam Roller • Thoracic extensions, 90/90 hip flow, ankle dorsiflexion.',
          duration: '15 mins',
          equipment: 'Foam Roller',
          icon: Icons.accessibility_new_rounded,
        ),
      ],
    );
  }

  Widget _buildRoutineItemCard({
    required String category,
    required String level,
    required Color categoryColor,
    required String title,
    required String desc,
    required String duration,
    required String equipment,
    required IconData icon,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
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
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: categoryColor,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            category,
                            style: WemanTypography.labelSmall.copyWith(
                              fontSize: 9,
                              fontWeight: FontWeight.w900,
                              color: WemanColors.onSurface,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          level,
                          style: WemanTypography.labelSmall.copyWith(
                            color: WemanColors.textMuted,
                            fontSize: 10,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(
                      title,
                      style: WemanTypography.titleSmall.copyWith(
                        fontWeight: FontWeight.w800,
                        fontSize: 15,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      desc,
                      style: WemanTypography.bodySmall.copyWith(
                        color: WemanColors.textMuted,
                        fontSize: 11,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 10),
              Container(
                width: 38,
                height: 38,
                decoration: const BoxDecoration(
                  color: WemanColors.softLime,
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, size: 20, color: WemanColors.primary),
              ),
            ],
          ),
          const SizedBox(height: 12),
          const Divider(color: WemanColors.surfaceContainerHigh, height: 1),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(Icons.schedule_rounded,
                      size: 14, color: WemanColors.textMuted),
                  const SizedBox(width: 4),
                  Text(
                    duration,
                    style: WemanTypography.labelSmall
                        .copyWith(color: WemanColors.textMuted, fontSize: 11),
                  ),
                  const SizedBox(width: 6),
                  const Text('•',
                      style: TextStyle(
                          color: WemanColors.textMuted, fontSize: 10)),
                  const SizedBox(width: 6),
                  Text(
                    equipment,
                    style: WemanTypography.labelSmall
                        .copyWith(color: WemanColors.textMuted, fontSize: 11),
                  ),
                ],
              ),
              GestureDetector(
                onTap: () => context.push('/active-training'),
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                  decoration: BoxDecoration(
                    color: WemanColors.neonLime,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: WemanColors.neonLime.withValues(alpha: 0.3),
                        blurRadius: 6,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Text(
                        'Start Workout',
                        style: WemanTypography.labelSmall.copyWith(
                          fontWeight: FontWeight.w900,
                          color: WemanColors.onSurface,
                          fontSize: 11,
                          letterSpacing: 0.3,
                        ),
                      ),
                      const SizedBox(width: 3),
                      const Icon(Icons.play_arrow_rounded,
                          size: 15, color: WemanColors.onSurface),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // --- 3. INDIAN FOOD & NUTRITION VISUAL GUIDE ---
  Widget _buildIndianFoodGuideSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                const Icon(Icons.restaurant_rounded,
                    size: 20, color: WemanColors.primary),
                const SizedBox(width: 6),
                Text(
                  'Indian Food & Nutrition',
                  style: WemanTypography.titleMedium
                      .copyWith(fontWeight: FontWeight.w800),
                ),
              ],
            ),
            Text(
              'Science-Backed',
              style: WemanTypography.labelSmall.copyWith(
                color: WemanColors.textMuted,
                fontSize: 11,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),

        // Tier 1: Include Regularly (Green Chip)
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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                    decoration: BoxDecoration(
                      color: WemanColors.neonLime,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 6,
                          height: 6,
                          decoration: const BoxDecoration(
                            color: WemanColors.primary,
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          'Include Regularly',
                          style: WemanTypography.labelSmall.copyWith(
                            fontWeight: FontWeight.w800,
                            color: WemanColors.onSurface,
                            fontSize: 11,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    'High Protein & Fiber',
                    style: WemanTypography.labelSmall
                        .copyWith(color: WemanColors.textMuted, fontSize: 10),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: _buildFoodMiniCard(
                      emoji: '🥘',
                      title: 'Idli & Sambar',
                      desc: 'Clean fermentation',
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _buildFoodMiniCard(
                      emoji: '🍲',
                      title: 'Dal & Rice',
                      desc: 'Complete amino acids',
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: _buildFoodMiniCard(
                      emoji: '🍳',
                      title: 'Paneer/Tofu Bhurji',
                      desc: '22g protein / serving',
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _buildFoodMiniCard(
                      emoji: '🥗',
                      title: 'Eggs & Moong',
                      desc: 'Sprouted bio-availability',
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),

        // Tier 2: Sensible Portions (Soft Lime Chip)
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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                    decoration: BoxDecoration(
                      color: WemanColors.softLime,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 6,
                          height: 6,
                          decoration: const BoxDecoration(
                            color: WemanColors.primary,
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          'Sensible Portions',
                          style: WemanTypography.labelSmall.copyWith(
                            fontWeight: FontWeight.w800,
                            color: WemanColors.onSurface,
                            fontSize: 11,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    'Energy Dense',
                    style: WemanTypography.labelSmall
                        .copyWith(color: WemanColors.textMuted, fontSize: 10),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: _buildFoodMiniCard(
                      emoji: '🫓',
                      title: 'Ghee Roti',
                      desc: '1-2 rotis per meal',
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _buildFoodMiniCard(
                      emoji: '🥜',
                      title: 'Poha w/ Peanuts',
                      desc: 'Morning carb fuel',
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: _buildFoodMiniCard(
                      emoji: '🍗',
                      title: 'Biryani & Raita',
                      desc: 'Pair with curd & salad',
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _buildFoodMiniCard(
                      emoji: '🥣',
                      title: 'Curd & Dry Fruits',
                      desc: 'Pre-workout snack',
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),

        // Tier 3: Mindful / Limit Depending on Goals (Neutral Chip)
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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                    decoration: BoxDecoration(
                      color: WemanColors.surfaceContainerLow,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 6,
                          height: 6,
                          decoration: const BoxDecoration(
                            color: WemanColors.textMuted,
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          'Mindful / Limit',
                          style: WemanTypography.labelSmall.copyWith(
                            fontWeight: FontWeight.w800,
                            color: WemanColors.onSurface,
                            fontSize: 11,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    'Goal Dependent',
                    style: WemanTypography.labelSmall
                        .copyWith(color: WemanColors.textMuted, fontSize: 10),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              _buildFoodListRow(
                  emoji: '🥟',
                  title: 'Deep-fried Samosas & Pakoras',
                  note: 'Enjoy occasionally'),
              const SizedBox(height: 8),
              _buildFoodListRow(
                  emoji: '☕',
                  title: 'Sugar-sweetened Chai & Beverages',
                  note: 'Switch to jaggery/unsweetened'),
              const SizedBox(height: 8),
              _buildFoodListRow(
                  emoji: '🍮',
                  title: 'Refined Flour Sweets (Mithai)',
                  note: 'Reserve for celebrations'),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildFoodMiniCard({
    required String emoji,
    required String title,
    required String desc,
  }) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: WemanColors.surfaceContainerLow,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          Text(emoji, style: const TextStyle(fontSize: 18)),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: WemanTypography.labelMedium.copyWith(
                    fontWeight: FontWeight.w800,
                    fontSize: 12,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  desc,
                  style: WemanTypography.bodySmall.copyWith(
                    color: WemanColors.textMuted,
                    fontSize: 10,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFoodListRow({
    required String emoji,
    required String title,
    required String note,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
      decoration: BoxDecoration(
        color: WemanColors.surfaceContainerLow,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Text(emoji, style: const TextStyle(fontSize: 16)),
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
            note,
            style: WemanTypography.bodySmall.copyWith(
              color: WemanColors.textMuted,
              fontSize: 10,
            ),
          ),
        ],
      ),
    );
  }

  // --- 4. OPTIMAL MEAL PLATE BALANCE ---
  Widget _buildMealPlateBalanceSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(Icons.pie_chart_rounded,
                size: 20, color: WemanColors.primary),
            const SizedBox(width: 6),
            Text(
              'Optimal Meal Plate Balance',
              style: WemanTypography.titleMedium
                  .copyWith(fontWeight: FontWeight.w800),
            ),
          ],
        ),
        const SizedBox(height: 2),
        Text(
          'Visual proportions calibrated for sustained energy & muscle repair.',
          style: WemanTypography.bodySmall
              .copyWith(color: WemanColors.textMuted, fontSize: 11),
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: WemanColors.cardBg,
            borderRadius: BorderRadius.circular(22),
            border: Border.all(color: WemanColors.surfaceContainerHigh),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 50% Vegetables & Salad Banner
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: WemanColors.softLime.withValues(alpha: 0.6),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                      color: WemanColors.neonLime.withValues(alpha: 0.4)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'HALF PLATE (50%)',
                          style: WemanTypography.labelSmall.copyWith(
                            color: WemanColors.primary,
                            fontWeight: FontWeight.w900,
                            fontSize: 10,
                            letterSpacing: 0.5,
                          ),
                        ),
                        const Text('🥦 🥗', style: TextStyle(fontSize: 15)),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Green Veggies, Salad & Sabzi',
                      style: WemanTypography.labelLarge
                          .copyWith(fontWeight: FontWeight.w800, fontSize: 13),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Cucumber, palak, bhindi, steamed veggies for digestive fiber & micronutrients.',
                      style: WemanTypography.bodySmall
                          .copyWith(color: WemanColors.textMuted, fontSize: 11),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),

              // Two Quarters: 25% Protein & 25% Complex Carbs
              Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: WemanColors.surfaceContainerLow,
                        borderRadius: BorderRadius.circular(14),
                        border:
                            Border.all(color: WemanColors.surfaceContainerHigh),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                '1/4 PLATE (25%)',
                                style: WemanTypography.labelSmall.copyWith(
                                  color: WemanColors.textMuted,
                                  fontWeight: FontWeight.w800,
                                  fontSize: 9,
                                ),
                              ),
                              const Text('🥚 🧀',
                                  style: TextStyle(fontSize: 13)),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Quality Protein',
                            style: WemanTypography.labelMedium.copyWith(
                                fontWeight: FontWeight.w800, fontSize: 12),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            'Paneer, soya chunks, chicken breast, eggs, or thick dal.',
                            style: WemanTypography.bodySmall.copyWith(
                                color: WemanColors.textMuted, fontSize: 10),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: WemanColors.surfaceContainerLow,
                        borderRadius: BorderRadius.circular(14),
                        border:
                            Border.all(color: WemanColors.surfaceContainerHigh),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                '1/4 PLATE (25%)',
                                style: WemanTypography.labelSmall.copyWith(
                                  color: WemanColors.textMuted,
                                  fontWeight: FontWeight.w800,
                                  fontSize: 9,
                                ),
                              ),
                              const Text('🌾 🍚',
                                  style: TextStyle(fontSize: 13)),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Complex Carbs',
                            style: WemanTypography.labelMedium.copyWith(
                                fontWeight: FontWeight.w800, fontSize: 12),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            'Whole wheat roti, steamed brown/white rice, or millets.',
                            style: WemanTypography.bodySmall.copyWith(
                                color: WemanColors.textMuted, fontSize: 10),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),

              // Side Hydration & Probiotics
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: WemanColors.surfaceContainerLow,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Row(
                  children: [
                    const Text('💧 🥛', style: TextStyle(fontSize: 16)),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Side Hydration & Probiotics',
                            style: WemanTypography.labelMedium.copyWith(
                                fontWeight: FontWeight.w800, fontSize: 12),
                          ),
                          Text(
                            'Probiotic curd / fresh chaas + 500ml water glass',
                            style: WemanTypography.bodySmall.copyWith(
                                color: WemanColors.textMuted, fontSize: 10),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: WemanColors.cardBg,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        'Gut Health',
                        style: WemanTypography.labelSmall.copyWith(
                          fontSize: 9,
                          fontWeight: FontWeight.w800,
                          color: WemanColors.primary,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),

              // Info Note
              Row(
                children: [
                  const Icon(Icons.info_outline_rounded,
                      size: 14, color: WemanColors.primary),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      'Portion sizes vary with body weight, training volume, and individual goals.',
                      style: WemanTypography.bodySmall.copyWith(
                        color: WemanColors.textMuted,
                        fontSize: 10,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  // --- 5. RECOVERY & HABIT CONSISTENCY ---
  Widget _buildRecoveryHabitsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                const Icon(Icons.verified_rounded,
                    size: 20, color: WemanColors.primary),
                const SizedBox(width: 6),
                Text(
                  'Recovery & Habit Consistency',
                  style: WemanTypography.titleMedium
                      .copyWith(fontWeight: FontWeight.w800),
                ),
              ],
            ),
            Text(
              'Daily Mastery',
              style: WemanTypography.labelSmall.copyWith(
                color: WemanColors.textMuted,
                fontSize: 11,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _buildHabitCard(
                icon: Icons.bedtime_rounded,
                title: '7.5h Restful Sleep',
                desc:
                    '🌙 Deep REM cycles optimize muscle repair and growth hormone release.',
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _buildHabitCard(
                icon: Icons.water_drop_rounded,
                title: '3.5L Daily Hydration',
                desc:
                    '💧 Electrolyte balanced baseline prevents muscle cramps & fatigue.',
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            Expanded(
              child: _buildHabitCard(
                icon: Icons.directions_walk_rounded,
                title: '10k Daily Steps',
                desc:
                    '👟 Active NEAT movement baseline for cardiovascular metabolic health.',
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _buildHabitCard(
                icon: Icons.bolt_rounded,
                title: 'Post-Workout Refuel',
                desc:
                    '⚡ Take 30g+ protein & carbs within 60 mins of training for glycogen uptake.',
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildHabitCard({
    required IconData icon,
    required String title,
    required String desc,
  }) {
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
              Icon(icon, size: 22, color: WemanColors.primary),
              Container(
                width: 6,
                height: 6,
                decoration: const BoxDecoration(
                  color: WemanColors.neonLime,
                  shape: BoxShape.circle,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            title,
            style: WemanTypography.labelLarge.copyWith(
              fontWeight: FontWeight.w800,
              fontSize: 13,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            desc,
            style: WemanTypography.bodySmall.copyWith(
              color: WemanColors.textMuted,
              fontSize: 10.5,
              height: 1.35,
            ),
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
