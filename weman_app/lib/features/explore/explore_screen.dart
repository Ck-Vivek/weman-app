import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/weman_colors.dart';
import '../../core/theme/weman_typography.dart';
import '../../core/widgets/weman_card.dart';
import '../../core/widgets/weman_button.dart';
import '../../core/widgets/weman_bottom_nav.dart';
import '../../core/widgets/weman_drawer.dart';

class ExploreScreen extends StatefulWidget {
  const ExploreScreen({super.key});

  @override
  State<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  int _selectedFilter = 0;
  final TextEditingController _searchController = TextEditingController();

  final List<String> _filters = [
    'All',
    'Near Me (Bengaluru)',
    'Hypertrophy',
    'Strength',
    'Calisthenics',
    'Student Crews',
  ];

  final List<Map<String, dynamic>> _muscleGroups = [
    {
      'name': 'Chest',
      'sub': 'Pectorals Major & Minor',
      'routines': '42 Routines',
      'exercises': '128 Exercises',
      'icon': Icons.fitness_center_rounded,
    },
    {
      'name': 'Back',
      'sub': 'Lats, Rhomboids & Traps',
      'routines': '56 Routines',
      'exercises': '145 Exercises',
      'icon': Icons.expand_rounded,
    },
    {
      'name': 'Legs',
      'sub': 'Quads, Hamstrings & Calves',
      'routines': '64 Routines',
      'exercises': '180 Exercises',
      'icon': Icons.directions_run_rounded,
    },
    {
      'name': 'Arms & Delts',
      'sub': 'Shoulders, Biceps & Triceps',
      'routines': '38 Routines',
      'exercises': '92 Exercises',
      'icon': Icons.sports_martial_arts_rounded,
    },
  ];

  final List<Map<String, dynamic>> _trendingRoutines = [
    {
      'title': 'The 4-Day Push/Pull/Legs Split',
      'coach': 'Coach Alex Chen',
      'rating': '4.9 ★ (1.2k completions)',
      'level': 'Advanced',
      'desc':
          'Hypertrophy-focused volume block calibrated for muscular density, heavy compound stability, and progressive overload tracking.',
      'time': '55 min/day',
      'days': '4 Days/wk',
    },
    {
      'title': 'Metabolic Engine HIIT Conditioning',
      'coach': 'Maya Torres',
      'rating': '4.8 ★ (890 completions)',
      'level': 'Intermediate',
      'desc':
          'High-cadence functional intervals fusing plyometric conditioning, kettlebell circuits, and cardiovascular VO2max output.',
      'time': '32 min/day',
      'days': 'Zone 4-5',
    },
  ];

  final List<Map<String, dynamic>> _campusHubs = [
    {
      'code': 'CEC',
      'name': 'City Engineering College Barbell Hub',
      'location': 'CEC Campus Rec Center • 0.8 km away',
      'activeNow': 18,
      'members': 420,
      'isJoined': false,
    },
    {
      'code': 'CMR',
      'name': 'CMRIT Fitness & Powerlifting Club',
      'location': 'CMRIT Athletics Hall • 1.4 km away',
      'activeNow': 24,
      'members': 580,
      'isJoined': true,
    },
    {
      'code': 'ICC',
      'name': 'Indiranagar Calisthenics Collective',
      'location': '100ft Road Fitness Ground • 2.8 km away',
      'activeNow': 12,
      'members': 310,
      'isJoined': false,
    },
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: WemanColors.surface,
      drawer: const WemanDrawer(),
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60.0),
        child: Container(
          decoration: BoxDecoration(
            color: WemanColors.surface.withValues(alpha: 0.95),
            border: const Border(
              bottom: BorderSide(
                  color: WemanColors.surfaceContainerHigh, width: 0.5),
            ),
          ),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.menu_rounded,
                            color: WemanColors.onSurface),
                        onPressed: () =>
                            _scaffoldKey.currentState?.openDrawer(),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: WemanColors.voltGreen,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          'WEMAN FIT',
                          style: WemanTypography.labelLarge.copyWith(
                            fontWeight: FontWeight.w900,
                            letterSpacing: 1.0,
                          ),
                        ),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        '/',
                        style: WemanTypography.headlineSmall.copyWith(
                          color: WemanColors.textMuted,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        'EXPLORE',
                        style: WemanTypography.labelLarge.copyWith(
                          color: WemanColors.textMuted,
                          letterSpacing: 0.8,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.notifications_none_rounded,
                            color: WemanColors.onSurface),
                        onPressed: () {},
                      ),
                      GestureDetector(
                        onTap: () => context.go('/profile'),
                        child: Container(
                          width: 34,
                          height: 34,
                          padding: const EdgeInsets.all(2),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                                color: WemanColors.neonLime, width: 2),
                          ),
                          child: ClipOval(
                            child: Image.asset(
                              'assets/images/pavan_avatar.png',
                              fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) => const Icon(
                                Icons.person,
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
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Search Input
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Container(
                decoration: BoxDecoration(
                  color: WemanColors.cardBg,
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.04),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: 'Search routines, muscle groups, campus crews...',
                    prefixIcon: const Icon(Icons.search_rounded,
                        color: WemanColors.textMuted),
                    suffixIcon: Container(
                      margin: const EdgeInsets.all(6),
                      decoration: const BoxDecoration(
                        color: WemanColors.surfaceContainer,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.tune_rounded,
                          size: 18, color: WemanColors.onSurface),
                    ),
                    border: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 14),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),

            // Horizontal Filter Pills
            SizedBox(
              height: 38,
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                scrollDirection: Axis.horizontal,
                itemCount: _filters.length,
                separatorBuilder: (context, index) => const SizedBox(width: 8),
                itemBuilder: (context, index) {
                  final isSelected = _selectedFilter == index;
                  return GestureDetector(
                    onTap: () => setState(() => _selectedFilter = index),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? WemanColors.inverseSurface
                            : WemanColors.cardBg,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: isSelected
                              ? Colors.transparent
                              : WemanColors.outlineVariant
                                  .withValues(alpha: 0.5),
                        ),
                      ),
                      child: Center(
                        child: Text(
                          _filters[index],
                          style: WemanTypography.labelMedium.copyWith(
                            color: isSelected
                                ? WemanColors.voltGreen
                                : WemanColors.onSurface,
                            fontWeight:
                                isSelected ? FontWeight.w800 : FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 16),

            // FITNESS TRACKER ENTRY CARD
            _buildFitnessTrackerCard(context),
            const SizedBox(height: 20),

            // SECTION 1: Target Muscle Library
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'ANATOMICAL FOCUS',
                        style: WemanTypography.labelSmall.copyWith(
                          color: WemanColors.textMuted,
                          letterSpacing: 1.0,
                        ),
                      ),
                      Text(
                        'Target Muscle Library',
                        style: WemanTypography.headlineSmall.copyWith(
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ],
                  ),
                  TextButton(
                    onPressed: () {},
                    child: Text(
                      'See Map',
                      style: WemanTypography.labelMedium.copyWith(
                        color: WemanColors.primary,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),

            // 2x2 Muscle Cards Grid
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _muscleGroups.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 1.15,
                ),
                itemBuilder: (context, index) {
                  final group = _muscleGroups[index];
                  return WemanCard(
                    padding: const EdgeInsets.all(14),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              width: 38,
                              height: 38,
                              decoration: const BoxDecoration(
                                color: WemanColors.surfaceContainerLow,
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                group['icon'] as IconData,
                                color: WemanColors.primary,
                                size: 20,
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: WemanColors.surfaceContainerLow,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Text(
                                group['routines'] as String,
                                style: WemanTypography.labelSmall.copyWith(
                                  fontSize: 9,
                                  color: WemanColors.textMuted,
                                ),
                              ),
                            ),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              group['name'] as String,
                              style: WemanTypography.titleMedium.copyWith(
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            Text(
                              group['sub'] as String,
                              style: WemanTypography.bodySmall
                                  .copyWith(fontSize: 10),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                Container(
                                  width: 6,
                                  height: 6,
                                  decoration: const BoxDecoration(
                                    color: WemanColors.voltGreen,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  group['exercises'] as String,
                                  style: WemanTypography.labelSmall.copyWith(
                                    fontSize: 10,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 28),

            // SECTION 2: Trending Gym Routines
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'MOST PROGRAMMED',
                        style: WemanTypography.labelSmall.copyWith(
                          color: WemanColors.textMuted,
                          letterSpacing: 1.0,
                        ),
                      ),
                      Text(
                        'Trending Gym Routines',
                        style: WemanTypography.headlineSmall.copyWith(
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ],
                  ),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: WemanColors.surfaceContainerLow,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.local_fire_department,
                            size: 14, color: WemanColors.primary),
                        const SizedBox(width: 4),
                        Text(
                          'Top Weekly',
                          style: WemanTypography.labelSmall.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),

            // Routines Cards List
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                children: [
                  for (var routine in _trendingRoutines) ...[
                    WemanCard(
                      padding: const EdgeInsets.all(16),
                      margin: const EdgeInsets.only(bottom: 12),
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
                                    decoration: const BoxDecoration(
                                      color: WemanColors.inverseSurface,
                                      shape: BoxShape.circle,
                                    ),
                                    child: Center(
                                      child: Text(
                                        (routine['coach'] as String)
                                            .substring(0, 1),
                                        style: const TextStyle(
                                          color: WemanColors.voltGreen,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Text(
                                            routine['coach'] as String,
                                            style: WemanTypography.labelMedium
                                                .copyWith(
                                              fontWeight: FontWeight.w800,
                                            ),
                                          ),
                                          const SizedBox(width: 4),
                                          const Icon(Icons.verified,
                                              size: 12,
                                              color: WemanColors.primary),
                                        ],
                                      ),
                                      Text(
                                        routine['rating'] as String,
                                        style: WemanTypography.bodySmall
                                            .copyWith(fontSize: 10),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 3),
                                decoration: BoxDecoration(
                                  color: WemanColors.surfaceContainer,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Text(
                                  routine['level'] as String,
                                  style: WemanTypography.labelSmall.copyWith(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 10,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Text(
                            routine['title'] as String,
                            style: WemanTypography.titleMedium.copyWith(
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            routine['desc'] as String,
                            style: WemanTypography.bodySmall,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 12),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  const Icon(Icons.schedule,
                                      size: 14, color: WemanColors.textMuted),
                                  const SizedBox(width: 4),
                                  Text(
                                    routine['time'] as String,
                                    style: WemanTypography.labelSmall
                                        .copyWith(color: WemanColors.textMuted),
                                  ),
                                  const SizedBox(width: 12),
                                  const Icon(Icons.calendar_view_week,
                                      size: 14, color: WemanColors.textMuted),
                                  const SizedBox(width: 4),
                                  Text(
                                    routine['days'] as String,
                                    style: WemanTypography.labelSmall
                                        .copyWith(color: WemanColors.textMuted),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  IconButton(
                                    icon: const Icon(
                                        Icons.bookmark_border_rounded,
                                        size: 20),
                                    onPressed: () {},
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                          content: Text(
                                              'Inspecting ${routine['title']} details'),
                                        ),
                                      );
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 14, vertical: 8),
                                      decoration: BoxDecoration(
                                        color: WemanColors.voltGreen,
                                        borderRadius: BorderRadius.circular(18),
                                        boxShadow: [
                                          BoxShadow(
                                            color: WemanColors.voltGreen
                                                .withValues(alpha: 0.3),
                                            blurRadius: 8,
                                            offset: const Offset(0, 2),
                                          ),
                                        ],
                                      ),
                                      child: Row(
                                        children: [
                                          Text(
                                            'INSPECT',
                                            style: WemanTypography.labelSmall
                                                .copyWith(
                                              fontWeight: FontWeight.w900,
                                              color: WemanColors.onSurface,
                                            ),
                                          ),
                                          const SizedBox(width: 4),
                                          const Icon(
                                              Icons.arrow_forward_rounded,
                                              size: 14,
                                              color: WemanColors.onSurface),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(height: 20),

            // SECTION 3: Active Student Community Networks (Karnataka)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'CAMPUS & LOCAL HUBS',
                        style: WemanTypography.labelSmall.copyWith(
                          color: WemanColors.textMuted,
                          letterSpacing: 1.0,
                        ),
                      ),
                      Text(
                        'Active Student Networks',
                        style: WemanTypography.headlineSmall.copyWith(
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ],
                  ),
                  TextButton(
                    onPressed: () {},
                    child: Text(
                      'Browse All',
                      style: WemanTypography.labelMedium.copyWith(
                        color: WemanColors.primary,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),

            // Campus Hubs List
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                children: [
                  for (var hub in _campusHubs) ...[
                    WemanCard(
                      padding: const EdgeInsets.all(16),
                      margin: const EdgeInsets.only(bottom: 12),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Container(
                                width: 44,
                                height: 44,
                                decoration: BoxDecoration(
                                  color: WemanColors.surfaceContainerHigh,
                                  borderRadius: BorderRadius.circular(14),
                                ),
                                child: Center(
                                  child: Text(
                                    hub['code'] as String,
                                    style: WemanTypography.labelLarge.copyWith(
                                      fontWeight: FontWeight.w900,
                                      color: WemanColors.primary,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      hub['name'] as String,
                                      style:
                                          WemanTypography.titleMedium.copyWith(
                                        fontWeight: FontWeight.w800,
                                      ),
                                    ),
                                    const SizedBox(height: 2),
                                    Row(
                                      children: [
                                        const Icon(Icons.location_on,
                                            size: 12,
                                            color: WemanColors.textMuted),
                                        const SizedBox(width: 4),
                                        Expanded(
                                          child: Text(
                                            hub['location'] as String,
                                            style: WemanTypography.bodySmall
                                                .copyWith(fontSize: 10),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),

                          // Pulse bar
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 8),
                            decoration: BoxDecoration(
                              color: WemanColors.surfaceContainerLow,
                              borderRadius: BorderRadius.circular(14),
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
                                        color: WemanColors.voltGreen,
                                        shape: BoxShape.circle,
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      '${hub['activeNow']} active now • ${hub['members']} members',
                                      style:
                                          WemanTypography.labelSmall.copyWith(
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ],
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 6, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: WemanColors.surfaceContainer,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Text(
                                    'Verified',
                                    style: WemanTypography.labelSmall.copyWith(
                                      fontSize: 9,
                                      color: WemanColors.primary,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 12),

                          // Join Button
                          Row(
                            children: [
                              Expanded(
                                child: WemanButton(
                                  text: (hub['isJoined'] as bool)
                                      ? 'MEMBER'
                                      : 'JOIN CREW',
                                  height: 42,
                                  variant: (hub['isJoined'] as bool)
                                      ? WemanButtonVariant.outlined
                                      : WemanButtonVariant.voltPrimary,
                                  icon: Icon(
                                    (hub['isJoined'] as bool)
                                        ? Icons.check
                                        : Icons.group_add_rounded,
                                    size: 16,
                                    color: (hub['isJoined'] as bool)
                                        ? WemanColors.onSurface
                                        : WemanColors.onSurface,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      hub['isJoined'] =
                                          !(hub['isJoined'] as bool);
                                    });
                                  },
                                ),
                              ),
                              const SizedBox(width: 8),
                              Container(
                                width: 42,
                                height: 42,
                                decoration: BoxDecoration(
                                  color: WemanColors.surfaceContainer,
                                  borderRadius: BorderRadius.circular(21),
                                ),
                                child: const Icon(Icons.forum_outlined,
                                    size: 20, color: WemanColors.onSurface),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
      bottomNavigationBar: WemanBottomNav(
        currentIndex: 3,
        onTap: (index) {
          if (index == 0) context.go('/feed');
          if (index == 1) context.go('/fitness-hub');
          if (index == 2) context.go('/reels');
          if (index == 3) {}
          if (index == 4) context.go('/profile');
        },
      ),
    );
  }

  Widget _buildFitnessTrackerCard(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: GestureDetector(
        key: const Key('explore_fitness_tracker_card'),
        onTap: () => context.push('/fitness-tracking'),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: WemanColors.cardBg,
            borderRadius: BorderRadius.circular(22),
            border: Border.all(
              color: WemanColors.neonLime,
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: WemanColors.neonLime.withValues(alpha: 0.15),
                blurRadius: 12,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: const BoxDecoration(
                  color: WemanColors.neonLime,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.monitor_heart_rounded,
                  color: WemanColors.onSurface,
                  size: 24,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
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
                        const SizedBox(width: 5),
                        Text(
                          'LIVE ATHLETE TELEMETRY',
                          style: WemanTypography.labelSmall.copyWith(
                            fontSize: 9,
                            fontWeight: FontWeight.w800,
                            color: WemanColors.textMuted,
                            letterSpacing: 0.8,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Fitness Tracker',
                      style: WemanTypography.titleMedium.copyWith(
                        fontWeight: FontWeight.w900,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'View real-time workout history, active burn & vitals',
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
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
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
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'TRACK',
                      style: WemanTypography.labelSmall.copyWith(
                        fontWeight: FontWeight.w900,
                        color: WemanColors.onSurface,
                        fontSize: 11,
                        letterSpacing: 0.5,
                      ),
                    ),
                    const SizedBox(width: 4),
                    const Icon(
                      Icons.arrow_forward_rounded,
                      size: 14,
                      color: WemanColors.onSurface,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
