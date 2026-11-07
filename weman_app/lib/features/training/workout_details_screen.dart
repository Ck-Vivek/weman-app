import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/weman_colors.dart';
import '../../core/theme/weman_typography.dart';

class WorkoutDetailsScreen extends StatefulWidget {
  const WorkoutDetailsScreen({super.key});

  @override
  State<WorkoutDetailsScreen> createState() => _WorkoutDetailsScreenState();
}

class _WorkoutDetailsScreenState extends State<WorkoutDetailsScreen> {
  bool _isBookmarked = false;

  final List<_ExerciseStep> _exercises = [
    _ExerciseStep(
      number: 1,
      title: 'Hanging Leg Raises',
      sets: '4 Sets × 12–15 Reps',
      rest: '45s Rest',
      focus: 'Lower Abs Focus',
      imageUrl:
          'https://lh3.googleusercontent.com/aida-public/AB6AXuBGNtLPXdcSBGYbqHxQt5jJFvdXxJLnfRgQN5lYaip0ajFbfc5HmFfay2GHnnPfaHAWaMKfGdx7frudTZOINJ3jhy877mtu4VJaoOyXY1IRT16baxyLM4SzAb-XYuUSx5sd-G_nhFgeFjRUkeWyvJyUHml61FMVwUhQ2jVuXtR2kdLomHbnDWEX_4I19nhDfdklp14GnpsFSJ7cpsTfNspVsTg6thvWsckFzvokeYZ8ujVqHP4AhEur',
    ),
    _ExerciseStep(
      number: 2,
      title: 'Cable Woodchoppers',
      sets: '3 Sets × 15 Reps / side',
      rest: '45s Rest',
      focus: 'Oblique Rotational Transfer',
      imageUrl:
          'https://lh3.googleusercontent.com/aida-public/AB6AXuAmlBiHyWtVIqOE7esnEyEl9b3Mi_nmPK7WIeb4t8XvZ-ZdoVm7JPN5HcldrUrxDgRf_F7lgXIiM-8g7ycviezTZVPL5vbeFPtMYiMYIdiovaG7JnNN0QcB0vdQQIOofnmAs8-_23ORhNnzju2ddoQ8X0aZoDDSNK5ORgZvyQi6aXCutp2pfI1yqcuDmFWIdYnioISEZJEZyK_76HHFO9em1-QBIl3pbF3uJNLrlb979pEnZoglnfv9',
    ),
    _ExerciseStep(
      number: 3,
      title: 'Ab Wheel Rollouts',
      sets: '3 Sets × 10–12 Reps',
      rest: '60s Rest',
      focus: 'Deep Anti-Extension Hold',
      imageUrl:
          'https://lh3.googleusercontent.com/aida-public/AB6AXuDMeL59a5TgRKp0KSyxwnF-mufm58nGN85tzIxJwg-oD3yjoeuyxxw3NV9--nXSUY48rCCC_KqoPLIMVRieLxdUAbjERK1rVvntMpqcBAIDWqfq1JmFvK22BijKsjXxywwjm1gZkKjMv-Y_B0nJdbHyC-f9T8rTsKk0IrSN6WOZL21Ntv6_EnjCu5eYO0eb5RsRK6uFZCwSzF6VRm_HLNdINxvNB4acVc4rZz6tFCLIL7Ax000qp7E1',
    ),
    _ExerciseStep(
      number: 4,
      title: 'Weighted Decline Crunches',
      sets: '4 Sets × 12 Reps',
      rest: '45s Rest',
      focus: 'Upper Rectus Hypertrophy',
      imageUrl:
          'https://lh3.googleusercontent.com/aida-public/AB6AXuCZWW55_r_B-8bqFxYKHVNvvLQVEI3UK0D0lIMNPUn9s9BkGN_fmfT06zu40xXZnwOxRW5PryUqxwu11Nh8kVC8QLmYayFqUJIXWDgDFNB-WYqLjILYjEYXrUoSAlzqRcrypUN-YlJjAixSDcBgL1wm39PfxZkJOse6FLK5S_FbE_Ydm8JzwDAwoeDYLrK84RKvNgv_L15HHmVwZqjxapuoI77SsygsQWn3MXbPYkeuGpoSQJNAGslD',
    ),
    _ExerciseStep(
      number: 5,
      title: 'Hollow Body Isometric Hold',
      sets: '3 Sets × 45 Seconds',
      rest: '30s Rest',
      focus: 'Intra-Abdominal Bracing',
      imageUrl:
          'https://lh3.googleusercontent.com/aida-public/AB6AXuC6BPuZIICVc2Sq8r_dtFscAFhDAEm_AjCbaQifteFzYFCVsTYuv9sa90iMYJ5-wRcNSVeR9azMINBqvqmE5xN9K-MUOIEn5iZ9XjGV9MX9OrqnfKZuzk3cqNQLO2rCfAi_xTR_H_Kl9v1xDEMb1bnqtaB_4qQ6w0LLGegKz7xyNgjuipnZSVxeOC15O3NzPRmrPOKLJRnRTAFkend_AeV3cZEyPxynZBA1WsCnQz4U5zpAIEz-m7Ax',
    ),
  ];

  @override
  Widget build(BuildContext context) {
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
          'Workout Details',
          style: TextStyle(
            color: WemanColors.onSurface,
            fontWeight: FontWeight.w700,
            fontSize: 18,
          ),
        ),
        actions: [
          IconButton(
            icon:
                const Icon(Icons.share_outlined, color: WemanColors.onSurface),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Workout link copied to clipboard!'),
                  duration: Duration(seconds: 1),
                ),
              );
            },
          ),
          IconButton(
            icon: Icon(
              _isBookmarked ? Icons.bookmark : Icons.bookmark_border,
              color:
                  _isBookmarked ? WemanColors.deepMoss : WemanColors.onSurface,
            ),
            onPressed: () {
              setState(() => _isBookmarked = !_isBookmarked);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    _isBookmarked
                        ? 'Added to Saved Workouts'
                        : 'Removed from Saved Workouts',
                  ),
                  duration: const Duration(seconds: 1),
                ),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(bottom: 100),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Category Strip
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: WemanColors.surfaceContainerHigh,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 8,
                          height: 8,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: WemanColors.neonLime,
                          ),
                        ),
                        const SizedBox(width: 6),
                        const Text(
                          'HYPERTROPHY + CORE',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0.5,
                            color: WemanColors.onSurface,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Hero Card
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Container(
                height: 250,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: WemanColors.surfaceWhite,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.05),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                clipBehavior: Clip.antiAlias,
                child: Stack(
                  children: [
                    Positioned.fill(
                      child: Image.network(
                        'https://lh3.googleusercontent.com/aida-public/AB6AXuCZWW55_r_B-8bqFxYKHVNvvLQVEI3UK0D0lIMNPUn9s9BkGN_fmfT06zu40xXZnwOxRW5PryUqxwu11Nh8kVC8QLmYayFqUJIXWDgDFNB-WYqLjILYjEYXrUoSAlzqRcrypUN-YlJjAixSDcBgL1wm39PfxZkJOse6FLK5S_FbE_Ydm8JzwDAwoeDYLrK84RKvNgv_L15HHmVwZqjxapuoI77SsygsQWn3MXbPYkeuGpoSQJNAGslD',
                        fit: BoxFit.cover,
                        errorBuilder: (ctx, err, stack) => Container(
                          color: const Color(0xFF2E3132),
                        ),
                      ),
                    ),
                    Positioned.fill(
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.transparent,
                              Colors.black.withValues(alpha: 0.4),
                              Colors.black.withValues(alpha: 0.85),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 16,
                      left: 16,
                      right: 16,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 3,
                                ),
                                decoration: BoxDecoration(
                                  color: WemanColors.neonLime,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: const Text(
                                  'INTERMEDIATE',
                                  style: TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.w800,
                                    color: WemanColors.onSurface,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              _buildPillTag(Icons.timer, '28 Mins'),
                              const SizedBox(width: 8),
                              _buildPillTag(
                                Icons.local_fire_department,
                                '420 kcal est.',
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            'Six-Pack & Core Shred Protocol',
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.w800,
                              color: Colors.white,
                              height: 1.2,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Row(
                            children: [
                              _buildSmallTag('Rectus Abdominis'),
                              const SizedBox(width: 6),
                              _buildSmallTag('Obliques'),
                              const SizedBox(width: 6),
                              _buildSmallTag('Transverse'),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Performance Snapshot Metrics (3 tiles)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: WemanColors.surfaceWhite,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.02),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    _buildMetricBox(
                        'INTENSITY', '8.5 / 10', WemanColors.onSurface),
                    const SizedBox(width: 8),
                    _buildMetricBox(
                        'ROUNDS', '3–4 Sets', WemanColors.onSurface),
                    const SizedBox(width: 8),
                    _buildMetricBox('FOCUS', 'Anti-Ext', WemanColors.deepMoss),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Protocol Architecture Overview
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: WemanColors.surfaceWhite,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.02),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Protocol Architecture',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: WemanColors.onSurface,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Engineered for deep anterior wall density and structural spinal fortitude. This session alternates between high-velocity dynamic flexion, rotational power transfer, and prolonged isometric anti-extension holds to trigger complete metabolic fatigue without lumbar compensation.',
                      style: WemanTypography.bodySmall.copyWith(
                        color: WemanColors.secondary,
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: 12),
                    const Divider(color: WemanColors.border),
                    const SizedBox(height: 6),
                    const Text(
                      'EQUIPMENT REQUIRED',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        color: WemanColors.secondary,
                        letterSpacing: 0.5,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        _buildEquipChip(Icons.accessibility_new, 'Bodyweight'),
                        const SizedBox(width: 8),
                        _buildEquipChip(Icons.layers, 'Exercise Mat'),
                        const SizedBox(width: 8),
                        _buildEquipChip(Icons.fitness_center, 'Pull-up Bar'),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Exercise Sequence Timeline
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Exercise Sequence',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                          color: WemanColors.onSurface,
                        ),
                      ),
                      Text(
                        '5 Target movements • Strict tempo',
                        style: WemanTypography.bodySmall.copyWith(
                          color: WemanColors.secondary,
                        ),
                      ),
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 3,
                    ),
                    decoration: BoxDecoration(
                      color: WemanColors.neonLime,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Text(
                      '5 EXERCISES',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w800,
                        color: WemanColors.onSurface,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),

            // List of exercises
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: _exercises.length,
              itemBuilder: (context, idx) {
                final ex = _exercises[idx];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 10),
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
                    child: Row(
                      children: [
                        Stack(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: SizedBox(
                                width: 70,
                                height: 70,
                                child: Image.network(
                                  ex.imageUrl,
                                  fit: BoxFit.cover,
                                  errorBuilder: (ctx, err, stack) => Container(
                                    color: const Color(0xFF2E3132),
                                    child: const Icon(
                                      Icons.fitness_center,
                                      color: WemanColors.neonLime,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Positioned(
                              top: 4,
                              left: 4,
                              child: Container(
                                width: 20,
                                height: 20,
                                decoration: const BoxDecoration(
                                  color: WemanColors.charcoal,
                                  shape: BoxShape.circle,
                                ),
                                child: Center(
                                  child: Text(
                                    '${ex.number}',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 10,
                                      fontWeight: FontWeight.w800,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                ex.title,
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w700,
                                  color: WemanColors.onSurface,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                ex.sets,
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w700,
                                  color: WemanColors.deepMoss,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Row(
                                children: [
                                  const Icon(
                                    Icons.timelapse,
                                    size: 13,
                                    color: WemanColors.secondary,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    ex.rest,
                                    style: const TextStyle(
                                      fontSize: 11,
                                      color: WemanColors.secondary,
                                    ),
                                  ),
                                  const SizedBox(width: 6),
                                  Container(
                                    width: 3,
                                    height: 3,
                                    decoration: const BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: WemanColors.secondary,
                                    ),
                                  ),
                                  const SizedBox(width: 6),
                                  Expanded(
                                    child: Text(
                                      ex.focus,
                                      style: const TextStyle(
                                        fontSize: 11,
                                        color: WemanColors.secondary,
                                      ),
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
                  ),
                );
              },
            ),
            const SizedBox(height: 12),

            // Spinal Decompression Warmup Prep Card
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: WemanColors.surfaceContainerHigh,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: const BoxDecoration(
                        color: WemanColors.surfaceWhite,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.fitness_center,
                        size: 20,
                        color: WemanColors.deepMoss,
                      ),
                    ),
                    const SizedBox(width: 12),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Spinal Decompression Prep',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                              color: WemanColors.onSurface,
                            ),
                          ),
                          SizedBox(height: 2),
                          Text(
                            'Complete 60s cat-cow & deadbug sequence before loading.',
                            style: TextStyle(
                              fontSize: 11,
                              color: WemanColors.secondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomSheet: Container(
        padding: EdgeInsets.only(
          left: 16,
          right: 16,
          top: 12,
          bottom: MediaQuery.of(context).padding.bottom + 12,
        ),
        decoration: BoxDecoration(
          color: WemanColors.surfaceWhite.withValues(alpha: 0.95),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, -3),
            ),
          ],
        ),
        child: SizedBox(
          width: double.infinity,
          height: 52,
          child: ElevatedButton(
            onPressed: () => context.push('/active-training'),
            style: ElevatedButton.styleFrom(
              backgroundColor: WemanColors.neonLime,
              foregroundColor: WemanColors.onSurface,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(26),
              ),
              elevation: 2,
            ),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'START TRAINING (5 EXERCISES)',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 0.5,
                  ),
                ),
                SizedBox(width: 8),
                Icon(Icons.arrow_forward, size: 18),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPillTag(IconData icon, String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.85),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: WemanColors.onSurface),
          const SizedBox(width: 4),
          Text(
            text,
            style: const TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w600,
              color: WemanColors.onSurface,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSmallTag(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        text,
        style: const TextStyle(fontSize: 10, color: Colors.white),
      ),
    );
  }

  Widget _buildMetricBox(String label, String value, Color valueColor) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          color: WemanColors.surface,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          children: [
            Text(
              label,
              style: const TextStyle(
                fontSize: 9,
                color: WemanColors.secondary,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              value,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w800,
                color: valueColor,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEquipChip(IconData icon, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: WemanColors.surface,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: WemanColors.onSurface),
          const SizedBox(width: 4),
          Text(
            label,
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: WemanColors.onSurface,
            ),
          ),
        ],
      ),
    );
  }
}

class _ExerciseStep {
  final int number;
  final String title;
  final String sets;
  final String rest;
  final String focus;
  final String imageUrl;

  _ExerciseStep({
    required this.number,
    required this.title,
    required this.sets,
    required this.rest,
    required this.focus,
    required this.imageUrl,
  });
}
