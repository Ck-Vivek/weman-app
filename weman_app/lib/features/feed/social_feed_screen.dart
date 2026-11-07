import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/demo_state/feed_provider.dart';
import '../../models/models.dart';
import '../../core/theme/weman_colors.dart';
import '../../core/theme/weman_typography.dart';
import '../../core/widgets/weman_card.dart';
import '../../core/widgets/weman_bottom_nav.dart';
import '../../core/widgets/weman_drawer.dart';

class SocialFeedScreen extends ConsumerStatefulWidget {
  const SocialFeedScreen({super.key});

  @override
  ConsumerState<SocialFeedScreen> createState() => _SocialFeedScreenState();
}

class _SocialFeedScreenState extends ConsumerState<SocialFeedScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  // Daily Snaps / Stories data from approved Stitch Design
  final List<Map<String, String>> _dailySnaps = [
    {
      'name': 'Your Story',
      'label': 'Your Story',
      'avatar':
          'https://lh3.googleusercontent.com/aida/AEtjO1X5Nj9Se13MRhEdx0DUW0NEIAabzUdDCNr-Qiwd9Dp-vagjDLTDgbcrWOd6bO0pbTwLx1gwW8EGf8pYA41kC7HekPJPiPffiAzsEkZCF3Bdi_5XNrUiJvVlzg4uuDJwKg3bmNp2od0jpr_mUIonYAI42iqH8iWQfMYZYvBJAey8z-fFwgNPNtwV1rqcMzAaYxEPHySmTfS1p1NWMg4zwCaIh-zrHalrDDBcklSRUevnQZVI2YNvLbVpZQ',
      'isSelf': 'true',
    },
    {
      'name': 'Aanya • Gym',
      'label': 'Aanya • Gym',
      'avatar':
          'https://lh3.googleusercontent.com/aida-public/AB6AXuCLxebhFGRsv7ILx6y2r5T8u2THgUQuTW9YFbu4SYVo5p62eJ-Le8Jht0pRhXeSKYHpTYwk67rL8LemjFzvg7Bpedw-BJBDWJ6u13ob3oX9nciYQN54ZT8F8qURmQ1RbADakX0YPyXpaRe4Rf1rBoElWiwwr4eupDm1T6OPEN_dAqn0NymeYjr6zL64UXT0L35VojInOPWUdqjNpvA5WSVkViqBBmaulrtQ759P2jcGRhnaJIpUoq-2',
      'isSelf': 'false',
    },
    {
      'name': 'Dev • Run',
      'label': 'Dev • Run',
      'avatar':
          'https://lh3.googleusercontent.com/aida-public/AB6AXuBpmx1-h9qPzxuKmq0rAVmxDC_E4c1NzceqN9El1JsWfLaJsP1Azk_vuIAkRmaMBL8bs6yFaqb2KSTMqVsX9m6axLiD6FKhSGaxECVPlw3ipZ-Qg-CmSVb20LWKg627KNv1T4E_ydXzRfgyXfUY8_qpNiWeEciVZOWdKaKzPNp337vQvnQvIkm27cHVjhULtJQcM4sQQxQ5hOtCFAJx3f9fydf0i7LoJJvTkg9SJjuRyWEhJ_uZ-xLI',
      'isSelf': 'false',
    },
    {
      'name': 'Meera • Mobility',
      'label': 'Meera • Mobility',
      'avatar':
          'https://lh3.googleusercontent.com/aida-public/AB6AXuAd43O5xWPLaVebgfLPk_2dUNEDtBWkQOQd3UfvUl1j1FGLJUO56Lu3C0_L0KLfJXjwHBBHyaOVz_lYztUi0xvBhw4Qq7IZMSrSQYBxpL7e3KsnApzQTx0kFKXgaGEX5dXF8YPFp3tB_UUkdfwiuPrbRIOZL-8aisK9XvdtTr_EcsRXONO-jsY6IBppbWord8r9CoPsZZQ5biJHLuKtKbpK7VahyFGU7adPgB90-FrWIRT71f1-OjiL',
      'isSelf': 'false',
    },
    {
      'name': 'Rohan • Nutrition',
      'label': 'Rohan • Nutrition',
      'avatar':
          'https://lh3.googleusercontent.com/aida-public/AB6AXuD6_FlxiZy_2rTyD_pgSptZvh4Jo4COnnNjXLDa4FLuXvBwBljIGZut_aDOS2U-jIckv7EjSbe8gAa92iRL_DONrhV89_oKL-2O2-05rf8j4N9YIm7GBksaB-tQNfKyjQK8Um4TaVTjSuIXbsLcCpPi6rd1imcU1T5mKdvP1PVzjCGvNlzJMqS9kZjeR9uTToBMcd68UIiW1BmWnT3w5A8qN5k5bNAW1yXm6h2LcEl6FsrwxUNMmJNI',
      'isSelf': 'false',
    },
    {
      'name': 'Pooja • HIIT',
      'label': 'Pooja • HIIT',
      'avatar':
          'https://lh3.googleusercontent.com/aida-public/AB6AXuDD-2dMXa00vo0V7aswEI2V_oLTjAPx-B-V7n2OsjfK9Uw8P2sZ1TkBs7qoLgEVNID4_gDNFa2I6DaX1rUrEvQ0aPOgV4rkj7uszTi4Uldy6sfJ7Am7NTcgZu7dT6UgETEZbv7ZWAmn7teFJlOMq8nWRpF95qamWyxHlyTrOkFKitef2J0v7cpLTfB_3pRH9wQH6JSAgDnNNEkTW62pY0YaoOzPpmpvvB3s0IbMhlRwGDiyliKB0e1o',
      'isSelf': 'false',
    },
  ];

  @override
  Widget build(BuildContext context) {
    final posts = ref.watch(feedProvider);
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: WemanColors.surface,
      drawer: const WemanDrawer(),
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60.0),
        child: Container(
          decoration: BoxDecoration(
            color: WemanColors.surface.withValues(alpha: 0.92),
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
                          color: WemanColors.neonLime,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          'WEMAN FIT',
                          style: WemanTypography.labelLarge.copyWith(
                            fontWeight: FontWeight.w900,
                            letterSpacing: 0.8,
                            fontSize: 12,
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
                        'HOME',
                        style: WemanTypography.labelLarge.copyWith(
                          color: WemanColors.onSurface,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 0.8,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      IconButton(
                        icon: Stack(
                          clipBehavior: Clip.none,
                          children: [
                            const Icon(Icons.notifications_none_rounded,
                                color: WemanColors.onSurface, size: 24),
                            Positioned(
                              top: 0,
                              right: 0,
                              child: Container(
                                width: 8,
                                height: 8,
                                decoration: BoxDecoration(
                                  color: WemanColors.neonLime,
                                  shape: BoxShape.circle,
                                  boxShadow: [
                                    BoxShadow(
                                      color: WemanColors.neonLime
                                          .withValues(alpha: 0.8),
                                      blurRadius: 4,
                                      spreadRadius: 1,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        onPressed: () => context.push('/inbox'),
                      ),
                      const SizedBox(width: 6),
                      GestureDetector(
                        onTap: () => context.go('/profile'),
                        child: Container(
                          width: 36,
                          height: 36,
                          padding: const EdgeInsets.all(2),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                                color: WemanColors.neonLime, width: 2),
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
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Daily Snaps Header
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 14, 16, 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: WemanColors.neonLime,
                          boxShadow: [
                            BoxShadow(
                              color:
                                  WemanColors.neonLime.withValues(alpha: 0.6),
                              blurRadius: 4,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'DAILY SNAPS',
                        style: WemanTypography.labelSmall.copyWith(
                          fontWeight: FontWeight.w800,
                          letterSpacing: 1.0,
                          color: WemanColors.onSurface,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Container(
                        width: 6,
                        height: 6,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: WemanColors.neonLime,
                          boxShadow: [
                            BoxShadow(
                              color:
                                  WemanColors.neonLime.withValues(alpha: 0.6),
                              blurRadius: 3,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        'LIVE NOW',
                        style: WemanTypography.labelSmall.copyWith(
                          color: WemanColors.primary,
                          fontWeight: FontWeight.w800,
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Horizontal Daily Snaps Scroll
            SizedBox(
              height: 104,
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                scrollDirection: Axis.horizontal,
                itemCount: _dailySnaps.length,
                itemBuilder: (context, index) {
                  final snap = _dailySnaps[index];
                  final isSelf = snap['isSelf'] == 'true';

                  return Padding(
                    padding: const EdgeInsets.only(right: 14),
                    child: GestureDetector(
                      onTap: () {
                        if (isSelf) {
                          context.push('/create-post');
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              backgroundColor: WemanColors.inverseSurface,
                              content: Text('Viewing snap by ${snap['name']}'),
                              duration: const Duration(seconds: 1),
                            ),
                          );
                        }
                      },
                      child: Column(
                        children: [
                          Stack(
                            clipBehavior: Clip.none,
                            children: [
                              Container(
                                width: 64,
                                height: 64,
                                padding: const EdgeInsets.all(2.5),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: WemanColors.neonLime,
                                    width: 2,
                                  ),
                                ),
                                child: ClipOval(
                                  child: Image.network(
                                    snap['avatar']!,
                                    fit: BoxFit.cover,
                                    errorBuilder: (_, __, ___) => Container(
                                      color: WemanColors.surfaceContainerHigh,
                                      child: const Icon(Icons.person,
                                          color: WemanColors.onSurface),
                                    ),
                                  ),
                                ),
                              ),
                              if (isSelf)
                                Positioned(
                                  bottom: 0,
                                  right: 0,
                                  child: Container(
                                    width: 20,
                                    height: 20,
                                    decoration: BoxDecoration(
                                      color: WemanColors.neonLime,
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                          color: WemanColors.surface, width: 2),
                                      boxShadow: [
                                        BoxShadow(
                                          color: WemanColors.neonLime
                                              .withValues(alpha: 0.5),
                                          blurRadius: 4,
                                        ),
                                      ],
                                    ),
                                    child: const Center(
                                      child: Icon(Icons.add,
                                          size: 12,
                                          color: WemanColors.onSurface),
                                    ),
                                  ),
                                )
                              else
                                Positioned(
                                  bottom: 0,
                                  right: 0,
                                  child: Container(
                                    width: 14,
                                    height: 14,
                                    decoration: BoxDecoration(
                                      color: WemanColors.neonLime,
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                          color: WemanColors.surface, width: 2),
                                    ),
                                    child: Center(
                                      child: Container(
                                        width: 5,
                                        height: 5,
                                        decoration: const BoxDecoration(
                                          color: WemanColors.onSurface,
                                          shape: BoxShape.circle,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                            ],
                          ),
                          const SizedBox(height: 6),
                          SizedBox(
                            width: 68,
                            child: Text(
                              snap['label']!,
                              textAlign: TextAlign.center,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: WemanTypography.labelSmall.copyWith(
                                fontWeight:
                                    isSelf ? FontWeight.w800 : FontWeight.w700,
                                color: WemanColors.onSurface,
                                fontSize: 11,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 12),

            // Feed Posts Container
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  for (final post in posts) ...[
                    if (post.postType == 'nutrition')
                      _buildNutritionPostCard(post: post)
                    else if (post.postType == 'running')
                      _buildRunningPostCard(post: post)
                    else
                      _buildStrengthPostCard(post: post),
                    const SizedBox(height: 16),
                  ],
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: WemanBottomNav(
        currentIndex: 0,
        onTap: (index) {
          if (index == 0) {}
          if (index == 1) context.go('/fitness-hub');
          if (index == 2) context.go('/reels');
          if (index == 3) context.go('/explore');
          if (index == 4) context.go('/profile');
        },
      ),
    );
  }

  // Image and avatar helpers
  Widget _buildCardImage(String? url,
      {BoxFit fit = BoxFit.cover, Widget? placeholder}) {
    if (url == null || url.isEmpty) {
      return placeholder ??
          Container(
            color: WemanColors.surfaceContainerHigh,
            child: const Center(
              child: Icon(Icons.fitness_center_rounded,
                  size: 48, color: WemanColors.primary),
            ),
          );
    }
    if (url.startsWith('assets/')) {
      return Image.asset(
        url,
        fit: fit,
        errorBuilder: (_, __, ___) =>
            placeholder ??
            Container(
              color: WemanColors.surfaceContainerHigh,
              child: const Center(
                child: Icon(Icons.fitness_center_rounded,
                    size: 48, color: WemanColors.primary),
              ),
            ),
      );
    }
    return Image.network(
      url,
      fit: fit,
      errorBuilder: (_, __, ___) =>
          placeholder ??
          Container(
            color: WemanColors.surfaceContainerHigh,
            child: const Center(
              child: Icon(Icons.fitness_center_rounded,
                  size: 48, color: WemanColors.primary),
            ),
          ),
    );
  }

  Widget _buildAvatarImage(String url) {
    if (url.startsWith('assets/')) {
      return Image.asset(
        url,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) =>
            const Icon(Icons.person, color: WemanColors.onSurface),
      );
    }
    return Image.network(
      url,
      fit: BoxFit.cover,
      errorBuilder: (_, __, ___) =>
          const Icon(Icons.person, color: WemanColors.onSurface),
    );
  }

  // --- POST 1 BUILDER ---
  Widget _buildStrengthPostCard({
    required WemanFeedPost post,
  }) {
    final isLiked = post.isLiked;
    final isSaved = post.isSaved;
    final author = post.author.handle;
    final authorRole = post.authorRole ?? 'Master Athlete';
    final avatarUrl = post.author.avatarUrl;
    final locationTime = post.timestamp;
    final imageUrl = post.imageUrl;
    final imageBadgeTop = post.imageBadgeTop ??
        (post.exerciseTag != null
            ? '${post.exerciseTag} • PR'
            : 'Workout Session');
    final timerBadge = post.timerBadge ?? '00:48';
    final exerciseName =
        post.exerciseName ?? post.exerciseTag ?? 'Workout Milestone';
    final rpeBadge = post.rpeBadge ?? 'RPE 8.5';
    final sets = post.metrics?['SETS'] ?? '4';
    final reps = post.metrics?['REPS'] ?? '5';
    final load = post.metrics?['LOAD'] ?? post.metrics?['WEIGHT'] ?? '180 kg';
    final rpe = post.metrics?['RPE'] ?? '8.5';
    final caption = post.content;
    final routineButtonText =
        post.routineButtonText ?? 'TRY ROUTINE (4 EXERCISES)';
    final commentsCount = post.commentsCount;

    return WemanCard(
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Author Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: const BoxDecoration(
                      color: WemanColors.surfaceContainerHigh,
                      shape: BoxShape.circle,
                    ),
                    child: ClipOval(
                      child: _buildAvatarImage(avatarUrl),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            author,
                            style: WemanTypography.labelLarge.copyWith(
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          const SizedBox(width: 6),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 7, vertical: 2),
                            decoration: BoxDecoration(
                              color: WemanColors.neonLime,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Row(
                              children: [
                                const Icon(Icons.verified,
                                    size: 11, color: WemanColors.onSurface),
                                const SizedBox(width: 3),
                                Text(
                                  authorRole,
                                  style: WemanTypography.labelSmall.copyWith(
                                    fontSize: 10,
                                    fontWeight: FontWeight.w800,
                                    color: WemanColors.onSurface,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 2),
                      Text(
                        locationTime,
                        style: WemanTypography.bodySmall.copyWith(
                          color: WemanColors.textMuted,
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              IconButton(
                icon:
                    const Icon(Icons.more_horiz, color: WemanColors.textMuted),
                onPressed: () {},
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Workout Media
          if (imageUrl != null && imageUrl.isNotEmpty) ...[
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Stack(
                children: [
                  AspectRatio(
                    aspectRatio: 4 / 3,
                    child: _buildCardImage(imageUrl),
                  ),
                  // Top Tag Pill
                  Positioned(
                    top: 12,
                    left: 12,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.75),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 6,
                            height: 6,
                            decoration: const BoxDecoration(
                              color: WemanColors.neonLime,
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 6),
                          Text(
                            imageBadgeTop,
                            style: WemanTypography.labelSmall.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                              fontSize: 11,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  // Bottom Timer Badge
                  Positioned(
                    bottom: 12,
                    right: 12,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.8),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.timer_outlined,
                              size: 13, color: WemanColors.neonLime),
                          const SizedBox(width: 4),
                          Text(
                            timerBadge,
                            style: WemanTypography.labelSmall.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                              fontSize: 11,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
          ],

          // Telemetry Bento Metrics Box
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: WemanColors.surfaceContainerLow,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.fitness_center_rounded,
                            color: WemanColors.primary, size: 18),
                        const SizedBox(width: 8),
                        Text(
                          exerciseName,
                          style: WemanTypography.headlineSmall.copyWith(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: WemanColors.neonLime,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        rpeBadge,
                        style: WemanTypography.labelSmall.copyWith(
                          fontWeight: FontWeight.w900,
                          color: WemanColors.onSurface,
                          fontSize: 10,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    _buildMetricCell('SETS', sets),
                    const SizedBox(width: 8),
                    _buildMetricCell('REPS', reps),
                    const SizedBox(width: 8),
                    _buildMetricCell('LOAD', load),
                    const SizedBox(width: 8),
                    _buildMetricCell('RPE', rpe, highlight: true),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),

          // Caption
          Text(
            caption,
            style: WemanTypography.bodyMedium.copyWith(
              color: WemanColors.onSurface,
              height: 1.35,
            ),
          ),
          const SizedBox(height: 12),

          // Routine CTA Button
          GestureDetector(
            onTap: () => context.push('/workout-details'),
            child: Container(
              width: double.infinity,
              height: 46,
              decoration: BoxDecoration(
                color: WemanColors.neonLime,
                borderRadius: BorderRadius.circular(24),
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
                  const Icon(Icons.bolt_rounded,
                      size: 20, color: WemanColors.onSurface),
                  const SizedBox(width: 6),
                  Text(
                    routineButtonText,
                    style: WemanTypography.labelLarge.copyWith(
                      color: WemanColors.onSurface,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 0.5,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 8),

          // Social Actions Footer
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  IconButton(
                    icon: Icon(
                      isLiked ? Icons.favorite : Icons.favorite_border_rounded,
                      color: isLiked ? Colors.red : WemanColors.textMuted,
                      size: 22,
                    ),
                    onPressed: () {
                      ref.read(feedProvider.notifier).toggleLike(post.id);
                    },
                  ),
                  Text(
                    '${post.likesCount}',
                    style: WemanTypography.labelMedium.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(width: 14),
                  IconButton(
                    icon: const Icon(Icons.chat_bubble_outline_rounded,
                        size: 20, color: WemanColors.textMuted),
                    onPressed: () => _showCommentsSheet(context, author),
                  ),
                  Text(
                    '$commentsCount',
                    style: WemanTypography.labelMedium.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(width: 14),
                  IconButton(
                    icon: const Icon(Icons.send_rounded,
                        size: 20, color: WemanColors.textMuted),
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text('Post link copied to clipboard!')),
                      );
                    },
                  ),
                ],
              ),
              IconButton(
                icon: Icon(
                  isSaved ? Icons.bookmark : Icons.bookmark_border_rounded,
                  color: isSaved ? WemanColors.primary : WemanColors.textMuted,
                  size: 22,
                ),
                onPressed: () {
                  ref.read(feedProvider.notifier).toggleSave(post.id);
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  // --- POST 2 BUILDER ---
  Widget _buildNutritionPostCard({
    required WemanFeedPost post,
  }) {
    final isLiked = post.isLiked;
    final isSaved = post.isSaved;
    final author = post.author.handle;
    final authorRole = post.authorRole ?? 'Nutritionist';
    final avatarUrl = post.author.avatarUrl;
    final locationTime = post.timestamp;
    final categoryTag = post.categoryTag ?? 'FUELING & MACROS';
    final postTitle = post.postTitle ?? 'High Protein Indian Power Breakfast';
    final imageUrl = post.imageUrl;
    final imageBadgeBottom =
        post.imageBadgeBottom ?? 'Steamed Moong Idli + Paneer Bhurji';
    final macroHeadline =
        post.macroHeadline ?? '38g Protein • 520 kcal • Clean Carbs';
    const macroTag = 'Macro Fuel';
    final caption = post.content;
    final commentsCount = post.commentsCount;

    return WemanCard(
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Author Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: const BoxDecoration(
                      color: WemanColors.surfaceContainerHigh,
                      shape: BoxShape.circle,
                    ),
                    child: ClipOval(
                      child: _buildAvatarImage(avatarUrl),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            author,
                            style: WemanTypography.labelLarge.copyWith(
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          const SizedBox(width: 6),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 7, vertical: 2),
                            decoration: BoxDecoration(
                              color: WemanColors.surfaceContainerHigh,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Row(
                              children: [
                                const Icon(Icons.verified,
                                    size: 11, color: WemanColors.primary),
                                const SizedBox(width: 3),
                                Text(
                                  authorRole,
                                  style: WemanTypography.labelSmall.copyWith(
                                    fontSize: 10,
                                    fontWeight: FontWeight.w800,
                                    color: WemanColors.onSurface,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 2),
                      Text(
                        locationTime,
                        style: WemanTypography.bodySmall.copyWith(
                          color: WemanColors.textMuted,
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              IconButton(
                icon:
                    const Icon(Icons.more_horiz, color: WemanColors.textMuted),
                onPressed: () {},
              ),
            ],
          ),
          const SizedBox(height: 10),

          // Title & Category
          Text(
            categoryTag,
            style: WemanTypography.labelSmall.copyWith(
              color: WemanColors.primary,
              fontWeight: FontWeight.w800,
              fontSize: 10,
              letterSpacing: 0.8,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            postTitle,
            style: WemanTypography.headlineSmall.copyWith(
              fontWeight: FontWeight.w800,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 10),

          // Food Media
          if (imageUrl != null && imageUrl.isNotEmpty) ...[
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Stack(
                children: [
                  AspectRatio(
                    aspectRatio: 4 / 3,
                    child: _buildCardImage(
                      imageUrl,
                      placeholder: Container(
                        color: WemanColors.surfaceContainerHigh,
                        child: const Center(
                          child: Icon(Icons.restaurant_rounded,
                              size: 48, color: WemanColors.primary),
                        ),
                      ),
                    ),
                  ),
                  // Bottom Badge
                  Positioned(
                    bottom: 12,
                    left: 12,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.8),
                        borderRadius: BorderRadius.circular(18),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.restaurant_rounded,
                              size: 13, color: WemanColors.neonLime),
                          const SizedBox(width: 6),
                          Text(
                            imageBadgeBottom,
                            style: WemanTypography.labelSmall.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                              fontSize: 11,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
          ],

          // Macro Bar
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              color: WemanColors.surfaceContainerLow,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Icon(Icons.eco_rounded,
                        color: WemanColors.primary, size: 18),
                    const SizedBox(width: 6),
                    Text(
                      macroHeadline,
                      style: WemanTypography.labelMedium.copyWith(
                        fontWeight: FontWeight.w800,
                        color: WemanColors.onSurface,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: WemanColors.neonLime,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    macroTag,
                    style: WemanTypography.labelSmall.copyWith(
                      fontWeight: FontWeight.w900,
                      color: WemanColors.onSurface,
                      fontSize: 10,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),

          // Caption
          Text(
            caption,
            style: WemanTypography.bodyMedium.copyWith(
              color: WemanColors.onSurface,
              height: 1.35,
            ),
          ),
          const SizedBox(height: 8),

          // Social Actions Footer
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  IconButton(
                    icon: Icon(
                      isLiked ? Icons.favorite : Icons.favorite_border_rounded,
                      color: isLiked ? Colors.red : WemanColors.textMuted,
                      size: 22,
                    ),
                    onPressed: () {
                      ref.read(feedProvider.notifier).toggleLike(post.id);
                    },
                  ),
                  Text(
                    '${post.likesCount}',
                    style: WemanTypography.labelMedium.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(width: 14),
                  IconButton(
                    icon: const Icon(Icons.chat_bubble_outline_rounded,
                        size: 20, color: WemanColors.textMuted),
                    onPressed: () => _showCommentsSheet(context, author),
                  ),
                  Text(
                    '$commentsCount',
                    style: WemanTypography.labelMedium.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(width: 14),
                  IconButton(
                    icon: const Icon(Icons.send_rounded,
                        size: 20, color: WemanColors.textMuted),
                    onPressed: () {},
                  ),
                ],
              ),
              IconButton(
                icon: Icon(
                  isSaved ? Icons.bookmark : Icons.bookmark_border_rounded,
                  color: isSaved ? WemanColors.primary : WemanColors.textMuted,
                  size: 22,
                ),
                onPressed: () {
                  ref.read(feedProvider.notifier).toggleSave(post.id);
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  // --- POST 3 BUILDER ---
  Widget _buildRunningPostCard({
    required WemanFeedPost post,
  }) {
    final isLiked = post.isLiked;
    final isSaved = post.isSaved;
    final author = post.author.handle;
    final authorRole = post.authorRole ?? 'Endurance Coach';
    final avatarUrl = post.author.avatarUrl;
    final locationTime = post.timestamp;
    final imageUrl = post.imageUrl;
    final imageBadgeTop = post.imageBadgeTop ?? 'Tempo Run 8.2 km';
    final pace = post.metrics?['PACE'] ?? '4\'48" /km';
    final time = post.metrics?['TIME'] ?? '39m 22s';
    final heartRate = post.metrics?['HEART RATE'] ?? '162 bpm';
    final caption = post.content;
    final commentsCount = post.commentsCount;

    return WemanCard(
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Author Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: const BoxDecoration(
                      color: WemanColors.surfaceContainerHigh,
                      shape: BoxShape.circle,
                    ),
                    child: ClipOval(
                      child: _buildAvatarImage(avatarUrl),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            author,
                            style: WemanTypography.labelLarge.copyWith(
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          const SizedBox(width: 6),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 7, vertical: 2),
                            decoration: BoxDecoration(
                              color: WemanColors.surfaceContainerHigh,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Row(
                              children: [
                                const Icon(Icons.verified,
                                    size: 11, color: WemanColors.primary),
                                const SizedBox(width: 3),
                                Text(
                                  authorRole,
                                  style: WemanTypography.labelSmall.copyWith(
                                    fontSize: 10,
                                    fontWeight: FontWeight.w800,
                                    color: WemanColors.onSurface,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 2),
                      Text(
                        locationTime,
                        style: WemanTypography.bodySmall.copyWith(
                          color: WemanColors.textMuted,
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              IconButton(
                icon:
                    const Icon(Icons.more_horiz, color: WemanColors.textMuted),
                onPressed: () {},
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Running Media
          if (imageUrl != null && imageUrl.isNotEmpty) ...[
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Stack(
                children: [
                  AspectRatio(
                    aspectRatio: 4 / 3,
                    child: _buildCardImage(
                      imageUrl,
                      placeholder: Container(
                        color: WemanColors.surfaceContainerHigh,
                        child: const Center(
                          child: Icon(Icons.directions_run_rounded,
                              size: 48, color: WemanColors.primary),
                        ),
                      ),
                    ),
                  ),
                  // Top Tag Pill
                  Positioned(
                    top: 12,
                    left: 12,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.75),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 6,
                            height: 6,
                            decoration: const BoxDecoration(
                              color: WemanColors.neonLime,
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 6),
                          Text(
                            imageBadgeTop,
                            style: WemanTypography.labelSmall.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                              fontSize: 11,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
          ],

          // 3-Metric Runner Grid
          Row(
            children: [
              _buildMetricCell('PACE', pace),
              const SizedBox(width: 8),
              _buildMetricCell('TIME', time),
              const SizedBox(width: 8),
              _buildMetricCell('HEART RATE', heartRate, highlight: true),
            ],
          ),
          const SizedBox(height: 12),

          // Caption
          Text(
            caption,
            style: WemanTypography.bodyMedium.copyWith(
              color: WemanColors.onSurface,
              height: 1.35,
            ),
          ),
          const SizedBox(height: 8),

          // Social Actions Footer
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  IconButton(
                    icon: Icon(
                      isLiked ? Icons.favorite : Icons.favorite_border_rounded,
                      color: isLiked ? Colors.red : WemanColors.textMuted,
                      size: 22,
                    ),
                    onPressed: () {
                      ref.read(feedProvider.notifier).toggleLike(post.id);
                    },
                  ),
                  Text(
                    '${post.likesCount}',
                    style: WemanTypography.labelMedium.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(width: 14),
                  IconButton(
                    icon: const Icon(Icons.chat_bubble_outline_rounded,
                        size: 20, color: WemanColors.textMuted),
                    onPressed: () => _showCommentsSheet(context, author),
                  ),
                  Text(
                    '$commentsCount',
                    style: WemanTypography.labelMedium.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(width: 14),
                  IconButton(
                    icon: const Icon(Icons.send_rounded,
                        size: 20, color: WemanColors.textMuted),
                    onPressed: () {},
                  ),
                ],
              ),
              IconButton(
                icon: Icon(
                  isSaved ? Icons.bookmark : Icons.bookmark_border_rounded,
                  color: isSaved ? WemanColors.primary : WemanColors.textMuted,
                  size: 22,
                ),
                onPressed: () {
                  ref.read(feedProvider.notifier).toggleSave(post.id);
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMetricCell(String label, String value,
      {bool highlight = false}) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          color: WemanColors.surfaceContainerLow,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Text(
              label,
              style: WemanTypography.labelSmall.copyWith(
                fontSize: 9,
                color: WemanColors.textMuted,
                letterSpacing: 0.5,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              value,
              style: WemanTypography.titleMedium.copyWith(
                fontWeight: FontWeight.w800,
                fontSize: 13,
                color: highlight ? WemanColors.primary : WemanColors.onSurface,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showCommentsSheet(BuildContext context, String author) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: WemanColors.cardBg,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) {
        return Padding(
          padding: EdgeInsets.only(
            left: 20,
            right: 20,
            top: 20,
            bottom: MediaQuery.of(ctx).viewInsets.bottom + 20,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Comments on $author',
                      style: WemanTypography.titleMedium
                          .copyWith(fontWeight: FontWeight.w800)),
                  IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Navigator.pop(ctx)),
                ],
              ),
              const Divider(color: WemanColors.surfaceContainerHigh),
              const ListTile(
                contentPadding: EdgeInsets.zero,
                leading: CircleAvatar(
                  backgroundColor: WemanColors.neonLime,
                  child: Text('K',
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.black)),
                ),
                title: Text('Karan V.',
                    style:
                        TextStyle(fontWeight: FontWeight.w700, fontSize: 13)),
                subtitle: Text('Insane bar speed! That form is locked in 🔥',
                    style: TextStyle(fontSize: 12)),
              ),
              const ListTile(
                contentPadding: EdgeInsets.zero,
                leading: CircleAvatar(
                  backgroundColor: WemanColors.surfaceContainerLow,
                  child: Text('S',
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.black)),
                ),
                title: Text('Sneha R.',
                    style:
                        TextStyle(fontWeight: FontWeight.w700, fontSize: 13)),
                subtitle: Text('Inspiring workout, adding this routine today!',
                    style: TextStyle(fontSize: 12)),
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14),
                decoration: BoxDecoration(
                  color: WemanColors.surfaceContainerLow,
                  borderRadius: BorderRadius.circular(24),
                ),
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'Add an athlete cheer or tip...',
                    hintStyle: WemanTypography.bodySmall
                        .copyWith(color: WemanColors.textMuted),
                    border: InputBorder.none,
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.send_rounded,
                          color: WemanColors.primary),
                      onPressed: () => Navigator.pop(ctx),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
