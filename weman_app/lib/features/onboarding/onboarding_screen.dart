import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/weman_colors.dart';
import '../../core/theme/weman_typography.dart';
import '../../core/widgets/weman_button.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  int _selectedGoalIndex = 0;

  final List<Map<String, dynamic>> _goals = [
    {
      'title': 'Hypertrophy',
      'subtitle': 'Muscle volume & structural mass',
      'icon': Icons.fitness_center_rounded,
      'tags': ['3-5 Day Splits', 'RPE Focus'],
      'badge': '🔥 High Demand',
    },
    {
      'title': 'Strength & Power',
      'subtitle': 'Compound PRs & raw progressive overload',
      'icon': Icons.bolt_rounded,
      'tags': ['1RM Progression', 'Powerlifting'],
      'badge': '⚡ Top Tier',
    },
    {
      'title': 'Athletic Endurance',
      'subtitle': 'Stamina, HIIT & hybrid conditioning',
      'icon': Icons.directions_run_rounded,
      'tags': ['VO2 Max Focus', 'Hybrid Athlete'],
      'badge': '⏱ Aerobic Base',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: WemanColors.surface,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                    horizontal: 20.0, vertical: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Step & Progress Tracker
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: WemanColors.surfaceContainer,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
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
                                'STEP 01/03',
                                style: WemanTypography.labelSmall.copyWith(
                                  fontWeight: FontWeight.w800,
                                  color: WemanColors.onSurface,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Text(
                          '33% Completed',
                          style: WemanTypography.labelMedium.copyWith(
                            color: WemanColors.textMuted,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),

                    // Micro Segmented Bar
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            height: 6,
                            decoration: BoxDecoration(
                              color: WemanColors.voltGreen,
                              borderRadius: BorderRadius.circular(3),
                            ),
                          ),
                        ),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Container(
                            height: 6,
                            decoration: BoxDecoration(
                              color: WemanColors.surfaceContainerHigh,
                              borderRadius: BorderRadius.circular(3),
                            ),
                          ),
                        ),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Container(
                            height: 6,
                            decoration: BoxDecoration(
                              color: WemanColors.surfaceContainerHigh,
                              borderRadius: BorderRadius.circular(3),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),

                    // Header
                    RichText(
                      text: TextSpan(
                        style: WemanTypography.displayMedium.copyWith(
                          color: WemanColors.onSurface,
                          fontWeight: FontWeight.w800,
                        ),
                        children: const [
                          TextSpan(text: 'Build Your\n'),
                          TextSpan(text: 'Fitness Journey'),
                        ],
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Select your primary training focus to calibrate your campus feed and gym squads.',
                      style: WemanTypography.bodyMedium.copyWith(
                        color: WemanColors.textMuted,
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Hero Athlete Banner Card
                    Container(
                      height: 180,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(24),
                        gradient: const LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            Color(0xFF2E3132),
                            Color(0xFF191C1D),
                          ],
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.12),
                            blurRadius: 16,
                            offset: const Offset(0, 6),
                          ),
                        ],
                      ),
                      child: Stack(
                        children: [
                          Positioned(
                            top: -20,
                            right: -20,
                            child: Container(
                              width: 140,
                              height: 140,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: WemanColors.voltGreen
                                    .withValues(alpha: 0.12),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withValues(alpha: 0.15),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Container(
                                        width: 6,
                                        height: 6,
                                        decoration: const BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: WemanColors.voltGreen,
                                        ),
                                      ),
                                      const SizedBox(width: 6),
                                      Text(
                                        'KARNATAKA PILOT ACTIVE',
                                        style:
                                            WemanTypography.labelSmall.copyWith(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        Container(
                                          width: 40,
                                          height: 40,
                                          decoration: const BoxDecoration(
                                            color: WemanColors.voltGreen,
                                            shape: BoxShape.circle,
                                          ),
                                          child: const Icon(
                                            Icons.groups_rounded,
                                            color: WemanColors.onSurface,
                                            size: 22,
                                          ),
                                        ),
                                        const SizedBox(width: 12),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              'ACTIVE CREWS',
                                              style: WemanTypography.labelSmall
                                                  .copyWith(
                                                color: Colors.white70,
                                                letterSpacing: 1,
                                              ),
                                            ),
                                            Text(
                                              '14.8k Training Now',
                                              style: WemanTypography
                                                  .headlineSmall
                                                  .copyWith(
                                                color: Colors.white,
                                                fontWeight: FontWeight.w800,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10, vertical: 4),
                                      decoration: BoxDecoration(
                                        color: WemanColors.voltGreen,
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Text(
                                        '+14 Gyms',
                                        style:
                                            WemanTypography.labelSmall.copyWith(
                                          fontWeight: FontWeight.w800,
                                          color: WemanColors.onSurface,
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
                    ),
                    const SizedBox(height: 20),

                    // Goal Selection List
                    ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: _goals.length,
                      separatorBuilder: (context, index) =>
                          const SizedBox(height: 12),
                      itemBuilder: (context, index) {
                        final goal = _goals[index];
                        final isSelected = _selectedGoalIndex == index;

                        return InkWell(
                          onTap: () {
                            setState(() {
                              _selectedGoalIndex = index;
                            });
                          },
                          borderRadius: BorderRadius.circular(24),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            decoration: BoxDecoration(
                              color: WemanColors.cardBg,
                              borderRadius: BorderRadius.circular(24),
                              border: Border.all(
                                color: isSelected
                                    ? WemanColors.voltGreen
                                    : WemanColors.outlineVariant
                                        .withValues(alpha: 0.4),
                                width: isSelected ? 2 : 1,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: isSelected
                                      ? WemanColors.voltGreen
                                          .withValues(alpha: 0.2)
                                      : Colors.black.withValues(alpha: 0.04),
                                  blurRadius: isSelected ? 18 : 8,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(18),
                                  child: Row(
                                    children: [
                                      Container(
                                        width: 48,
                                        height: 48,
                                        decoration: BoxDecoration(
                                          color: isSelected
                                              ? WemanColors.voltGreen
                                              : WemanColors.surfaceContainerLow,
                                          borderRadius:
                                              BorderRadius.circular(16),
                                        ),
                                        child: Icon(
                                          goal['icon'] as IconData,
                                          color: WemanColors.onSurface,
                                          size: 24,
                                        ),
                                      ),
                                      const SizedBox(width: 16),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              goal['title'] as String,
                                              style: WemanTypography.titleMedium
                                                  .copyWith(
                                                fontWeight: FontWeight.w700,
                                              ),
                                            ),
                                            const SizedBox(height: 2),
                                            Text(
                                              goal['subtitle'] as String,
                                              style: WemanTypography.bodySmall,
                                            ),
                                          ],
                                        ),
                                      ),
                                      Container(
                                        width: 28,
                                        height: 28,
                                        decoration: BoxDecoration(
                                          color: isSelected
                                              ? WemanColors.voltGreen
                                              : WemanColors.surfaceContainer,
                                          shape: BoxShape.circle,
                                        ),
                                        child: Icon(
                                          Icons.check,
                                          size: 16,
                                          color: isSelected
                                              ? WemanColors.onSurface
                                              : Colors.transparent,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 18, vertical: 10),
                                  decoration: BoxDecoration(
                                    color: WemanColors.surfaceContainerLow
                                        .withValues(alpha: 0.6),
                                    borderRadius: const BorderRadius.vertical(
                                      bottom: Radius.circular(24),
                                    ),
                                  ),
                                  child: Row(
                                    children: [
                                      for (var tag
                                          in goal['tags'] as List<String>) ...[
                                        Container(
                                          margin:
                                              const EdgeInsets.only(right: 8),
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 8, vertical: 3),
                                          decoration: BoxDecoration(
                                            color: WemanColors.surfaceContainer,
                                            borderRadius:
                                                BorderRadius.circular(12),
                                          ),
                                          child: Text(
                                            tag,
                                            style: WemanTypography.labelSmall
                                                .copyWith(
                                              color:
                                                  WemanColors.onSurfaceVariant,
                                              fontSize: 10,
                                            ),
                                          ),
                                        ),
                                      ],
                                      const Spacer(),
                                      Text(
                                        goal['badge'] as String,
                                        style:
                                            WemanTypography.labelSmall.copyWith(
                                          fontWeight: FontWeight.w700,
                                          color: WemanColors.primary,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 16),

                    // Micro-Notice
                    Row(
                      children: [
                        const Icon(
                          Icons.verified_rounded,
                          size: 16,
                          color: WemanColors.primary,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'You can adjust this training bias anytime in your campus settings.',
                            style: WemanTypography.bodySmall,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),

            // Sticky Bottom CTA
            Container(
              padding: const EdgeInsets.all(20),
              decoration: const BoxDecoration(
                color: WemanColors.surface,
                border: Border(
                  top: BorderSide(
                      color: WemanColors.surfaceContainerHigh, width: 0.5),
                ),
              ),
              child: WemanButton(
                text: 'CONTINUE',
                width: double.infinity,
                variant: WemanButtonVariant.voltPrimary,
                icon: const Icon(Icons.arrow_forward_rounded,
                    color: WemanColors.onSurface),
                onPressed: () {
                  context.go('/login');
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
