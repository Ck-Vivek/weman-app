import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/weman_colors.dart';
import '../../core/theme/weman_typography.dart';

class TrainingHubScreen extends StatefulWidget {
  const TrainingHubScreen({super.key});

  @override
  State<TrainingHubScreen> createState() => _TrainingHubScreenState();
}

class _TrainingHubScreenState extends State<TrainingHubScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

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
          'TRAINING HUB',
          style: TextStyle(
            color: WemanColors.onSurface,
            fontWeight: FontWeight.w800,
            fontSize: 18,
            letterSpacing: 0.5,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.send_outlined, color: WemanColors.onSurface),
            onPressed: () => context.push('/inbox'),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Container(
              padding: const EdgeInsets.all(2),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: WemanColors.neonLime, width: 2),
              ),
              child: const CircleAvatar(
                radius: 14,
                backgroundImage: AssetImage('assets/images/pavan_avatar.png'),
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Search Bar
            Container(
              height: 48,
              decoration: BoxDecoration(
                color: WemanColors.surfaceWhite,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.03),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: TextField(
                controller: _searchController,
                decoration: const InputDecoration(
                  prefixIcon: Icon(
                    Icons.search,
                    color: WemanColors.secondary,
                    size: 20,
                  ),
                  hintText: 'Find a workout or muscle group...',
                  hintStyle: TextStyle(
                    color: WemanColors.secondary,
                    fontSize: 14,
                  ),
                  border: InputBorder.none,
                  suffixIcon: Icon(
                    Icons.tune,
                    color: WemanColors.secondary,
                    size: 18,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Section: Target Muscle Library
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.baseline,
              textBaseline: TextBaseline.alphabetic,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'TARGET MUSCLE LIBRARY',
                      style: WemanTypography.titleSmall.copyWith(
                        fontWeight: FontWeight.w800,
                        letterSpacing: 0.5,
                      ),
                    ),
                    Text(
                      '12 FOCUS GROUPS',
                      style: WemanTypography.labelSmall.copyWith(
                        color: WemanColors.secondary,
                        fontSize: 10,
                      ),
                    ),
                  ],
                ),
                TextButton(
                  onPressed: () {},
                  child: const Text(
                    'VIEW ALL',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: WemanColors.onSurface,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // 2-Column Muscle Grid
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              childAspectRatio: 0.95,
              children: [
                _buildMuscleCard(
                  name: 'Chest',
                  routines: '12 Routines',
                  sub: 'Pectorals, Press & Flyes',
                  imageUrl:
                      'https://lh3.googleusercontent.com/aida-public/AB6AXuDZPP-QfwaK7rlZEuX6UJv01ZO7DYQS8EjDxfLqwnTA3wm0DjBM3BaOr6jRwHWpC2Xixrz--WKwE5bgnQCRrYQHbqOLGbnFa-tpCQAN9OJNRTV6Q_lKWq2LOVKIehuF8eHmUwrl2r1LEwaKmsfVRAxMIkNN04hKGccZV1dZ7L7zPsngK4mhJilQWq4tX67jEMCpWJuTQ2DLOgR31McGlWuLnJ9rP07eZx62_fgzhGHmgN_hXpapNvVQ',
                  onTap: () => context.push('/workout-details'),
                ),
                _buildMuscleCard(
                  name: 'Back',
                  routines: '14 Routines',
                  sub: 'Lats, Traps & Pulls',
                  imageUrl:
                      'https://lh3.googleusercontent.com/aida-public/AB6AXuBOtrKrJgOhLrfs3GFjNyoxVDNnaP0ZX4tqVK8nLBqK2FM7MAk9scmjWGMTiG1nbyLOtcwMdZKwvAcDbR-HHIhaZjopRUIxdxsSt_hOzzaXYDcANUZ4sMg2tU6mKsH--GrNz27udkPhtK6q6NUtqo7eN01SaNA2dUmwmGh8dsVfsm_u2SNgUy62jVKkeqAg3Zpm5Qcobw_2LY8-B5k9Zbhvs2prBj0H7YNc6ZIqQBH1OoDcXyyhuAmr',
                  onTap: () => context.push('/workout-details'),
                ),
                _buildMuscleCard(
                  name: 'Shoulders',
                  routines: '9 Routines',
                  sub: 'Deltoids & OHP',
                  imageUrl:
                      'https://lh3.googleusercontent.com/aida-public/AB6AXuBsOlv284-ZgQ6AaXtwU9O7CN_b5jRCmourec9-QKd3-4pttgQHR0BibYCp0USQCFcjAqNY_R6Q-dtSBiwQmpJFLH4vTXPJ_5FgavKG2eWkTJJnBnJUFd0D7a3SkGOnHbqCRe2py6ujGu1U5oHhVCvA76hXPQqfU673Ru3nFGUrMNknSsC5VfYlkEMbdvX5tWGDrmeYERX-PIsPYd0wMLz8QXZL6P2ieA4w6QKhyGd9GPkQCyW7ErU7',
                  onTap: () => context.push('/workout-details'),
                ),
                _buildMuscleCard(
                  name: 'Biceps',
                  routines: '8 Routines',
                  sub: 'Peak Curls & Pulls',
                  imageUrl:
                      'https://lh3.googleusercontent.com/aida-public/AB6AXuCWSb5njjO02FXg7E6Si8yUml3EW1TAehFBdgGbq5kqdjFcdERcjF9ZLSCtQb4rqYGT44hzeSTAzI4mXd2dzwzWWKoyxmh3A6zCJpZE6lReN2xe3ME2KMUxKfeJ9zLcecKJBzNDJd_U2hj5JmiklyuCsZt3j75OY2tTKhCvzLTU689d7aRGOAZPCq6q-miS7RiguhfZHU1KB6M7bnqIhe5N0YBVzGDr1ircDNNl0e64RrVVuGQr04JX',
                  onTap: () => context.push('/workout-details'),
                ),
                _buildMuscleCard(
                  name: 'Triceps',
                  routines: '8 Routines',
                  sub: 'Dips & Extensions',
                  imageUrl:
                      'https://lh3.googleusercontent.com/aida-public/AB6AXuBmkgsG9T0S_PTQmIczNoOOxWtK8RwFyShyvO8eLjFQmgjGQM2KwTPVurdBqBo08rSS9fAQ9DaeoH5wY9SflOwz42b1I65YV4ZWGi1rrZcY8hFyXs9FHB2q7rlCwTYBPcZ0GIM4nLSyVGB6TwKYNey58NmwgZAJf9rzK3Kt-IDFcoOGspP2WSFeSiX6BN5iqOYGzvzJ77ZoS8GjQEND2llBCmTWadUGZrie_gsRTeLmzs1iqAeD941d',
                  onTap: () => context.push('/workout-details'),
                ),
                _buildMuscleCard(
                  name: 'Legs',
                  routines: '16 Routines',
                  sub: 'Quads, Hamstrings, Calves',
                  imageUrl:
                      'https://lh3.googleusercontent.com/aida-public/AB6AXuCK8HSmV_L4jbbImAVatKrcK8AqFm2AMkdnv5MaRHMTdEH1evO02aZ45pGXlNb5JJ1_krWIv3tUVfsY8HpFZWKCbrsaQLeBEwq_Iz6dALKaVMjJ0HZZ87aPaBIvp-BaWToJwPz1SDpRZe13B_vTr3-RkpzuVSk-WAak2b9x1d_dmrWkNUrNgKcNvBMZnh0cu57nk-Zr-gcPzhYcvOqzfiWayHcsr6oMkAVv1jiwSAk5VQyVj07bnYLj',
                  onTap: () => context.push('/workout-details'),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Six-Pack / Abs (POPULAR HIGHLIGHT CARD)
            InkWell(
              onTap: () => context.push('/workout-details'),
              borderRadius: BorderRadius.circular(20),
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: WemanColors.surfaceWhite,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.04),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Stack(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: SizedBox(
                            width: 100,
                            height: 85,
                            child: Image.network(
                              'https://lh3.googleusercontent.com/aida-public/AB6AXuDMeL59a5TgRKp0KSyxwnF-mufm58nGN85tzIxJwg-oD3yjoeuyxxw3NV9--nXSUY48rCCC_KqoPLIMVRieLxdUAbjERK1rVvntMpqcBAIDWqfq1JmFvK22BijKsjXxywwjm1gZkKjMv-Y_B0nJdbHyC-f9T8rTsKk0IrSN6WOZL21Ntv6_EnjCu5eYO0eb5RsRK6uFZCwSzF6VRm_HLNdINxvNB4acVc4rZz6tFCLIL7Ax000qp7E1',
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
                          top: 6,
                          left: 6,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 6,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: WemanColors.neonLime,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Text(
                              'POPULAR',
                              style: TextStyle(
                                fontSize: 8,
                                fontWeight: FontWeight.w800,
                                color: WemanColors.onSurface,
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
                          const Row(
                            children: [
                              Text(
                                'Six-Pack / Abs',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w800,
                                  color: WemanColors.onSurface,
                                ),
                              ),
                              SizedBox(width: 4),
                              Icon(
                                Icons.bolt,
                                size: 16,
                                color: WemanColors.deepMoss,
                              ),
                            ],
                          ),
                          const SizedBox(height: 2),
                          const Text(
                            'Core stability & Obliques',
                            style: TextStyle(
                              fontSize: 12,
                              color: WemanColors.secondary,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 3,
                                ),
                                decoration: BoxDecoration(
                                  color: WemanColors.surface,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: const Text(
                                  '10 Routines',
                                  style: TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.w700,
                                    color: WemanColors.secondary,
                                  ),
                                ),
                              ),
                              Container(
                                width: 28,
                                height: 28,
                                decoration: const BoxDecoration(
                                  color: WemanColors.neonLime,
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.arrow_forward,
                                  size: 16,
                                  color: WemanColors.onSurface,
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
            ),
            const SizedBox(height: 24),

            // Section: Structured Multi-Week Programs
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'STRUCTURED PROGRAMS',
                  style: WemanTypography.titleSmall.copyWith(
                    fontWeight: FontWeight.w800,
                    letterSpacing: 0.5,
                  ),
                ),
                Text(
                  '4 ENROLLED',
                  style: WemanTypography.labelSmall.copyWith(
                    color: WemanColors.secondary,
                    fontSize: 10,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            _buildProgramCard(
              title: 'Hypertrophy Push-Pull-Legs',
              frequency: '6 Days / Wk • 8 Weeks',
              level: 'Intermediate',
              color: WemanColors.neonLime,
              onTap: () => context.push('/workout-details'),
            ),
            const SizedBox(height: 10),

            _buildProgramCard(
              title: 'Upper / Lower Strength Matrix',
              frequency: '4 Days / Wk • 6 Weeks',
              level: 'Advanced',
              color: WemanColors.softLime,
              onTap: () => context.push('/workout-details'),
            ),
            const SizedBox(height: 10),

            _buildProgramCard(
              title: '5x5 Linear Strength Peak',
              frequency: '3 Days / Wk • 12 Weeks',
              level: 'Powerbuilding',
              color: WemanColors.surfaceContainerHigh,
              onTap: () => context.push('/workout-details'),
            ),
            const SizedBox(height: 10),

            _buildProgramCard(
              title: 'Core Engine & Hyrox Prep',
              frequency: '5 Days / Wk • 4 Weeks',
              level: 'Conditioning',
              color: WemanColors.softLime,
              onTap: () => context.push('/workout-details'),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildMuscleCard({
    required String name,
    required String routines,
    required String sub,
    required String imageUrl,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(10),
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
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: SizedBox(
                height: 80,
                width: double.infinity,
                child: Image.network(
                  imageUrl,
                  fit: BoxFit.cover,
                  errorBuilder: (ctx, err, stack) => Container(
                    color: const Color(0xFF2E3132),
                    child: const Center(
                      child: Icon(
                        Icons.fitness_center,
                        color: WemanColors.neonLime,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: WemanColors.onSurface,
                  ),
                ),
                Text(
                  routines,
                  style: const TextStyle(
                    fontSize: 10,
                    color: WemanColors.secondary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 2),
            Text(
              sub,
              style: const TextStyle(
                fontSize: 10,
                color: WemanColors.secondary,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProgramCard({
    required String title,
    required String frequency,
    required String level,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(14),
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
            Container(
              width: 4,
              height: 44,
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: WemanColors.onSurface,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    frequency,
                    style: const TextStyle(
                      fontSize: 11,
                      color: WemanColors.secondary,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                color: WemanColors.surface,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                level,
                style: const TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                  color: WemanColors.deepMoss,
                ),
              ),
            ),
            const SizedBox(width: 6),
            const Icon(
              Icons.chevron_right,
              color: WemanColors.secondary,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }
}
