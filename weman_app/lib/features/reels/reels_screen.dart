import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/weman_colors.dart';
import '../../core/theme/weman_typography.dart';
import '../../core/widgets/weman_bottom_nav.dart';

class ReelComment {
  final String author;
  final String handle;
  final String text;
  final String time;
  int likes;
  bool isLiked;

  ReelComment({
    required this.author,
    required this.handle,
    required this.text,
    required this.time,
    required this.likes,
    this.isLiked = false,
  });
}

class ReelItem {
  final String id;
  final String authorHandle;
  final String authorRole;
  final String authorAvatar;
  final String categoryTag;
  final String title;
  final String caption;
  final List<String> tags;
  final String audioTitle;
  final String attachedWorkoutTitle;
  final String attachedWorkoutSub;
  final String attachedWorkoutDifficulty;
  final String bgImageUrl;
  final int views;
  int likes;
  int commentsCount;
  int saves;
  int shares;
  bool isLiked;
  bool isSaved;
  bool isFollowing;
  final List<ReelComment> comments;

  ReelItem({
    required this.id,
    required this.authorHandle,
    required this.authorRole,
    required this.authorAvatar,
    required this.categoryTag,
    required this.title,
    required this.caption,
    required this.tags,
    required this.audioTitle,
    required this.attachedWorkoutTitle,
    required this.attachedWorkoutSub,
    required this.attachedWorkoutDifficulty,
    required this.bgImageUrl,
    required this.views,
    required this.likes,
    required this.commentsCount,
    required this.saves,
    required this.shares,
    this.isLiked = false,
    this.isSaved = false,
    this.isFollowing = false,
    required this.comments,
  });
}

class ReelsScreen extends StatefulWidget {
  const ReelsScreen({super.key});

  @override
  State<ReelsScreen> createState() => _ReelsScreenState();
}

class _ReelsScreenState extends State<ReelsScreen>
    with SingleTickerProviderStateMixin {
  late final PageController _pageController;
  late final AnimationController _vinylController;
  Timer? _scrubTimer;
  double _scrubProgress = 0.25;
  bool _isMuted = false;
  int _currentPageIndex = 0;
  bool _showHeartAnimation = false;

  final List<ReelItem> _reels = [
    // Reel 1: Barbell Squat Form Clinic (Stitch Exact Reference)
    ReelItem(
      id: 'reel_1',
      authorHandle: '@jordan_prime',
      authorRole: 'PRO COACH',
      authorAvatar:
          'https://lh3.googleusercontent.com/aida-public/AB6AXuCVpOw5uyE0JmjlP7eMMROHsX5ilVy328_BmtsiM_AB1qX1Ax6D8_VY-dKjjN2bTdtK4qomn_h5lyRYA8p_HTW1VPOf6kW0EOiZCYfvLdHATPqZBrmu8Mpr7MvfmGM0aLbYOeZxunD9-lgJT2R47sw7p5TTqaBR04C2I9SWJ2aprxR-y9zPNvLJiKhcgdhofHdj2Q3xOYKZbPn5D3XBcclvzK2dJoKNic9aSPlJUYxbunNWG1D_EvA3',
      categoryTag: 'Form Clinic',
      title: 'Barbell Back Squat Depth & Mechanics',
      caption:
          '3 cues to instantly fix your squat depth and protect your lumbar spine 🔥 Keep chest upright, drive knees out, and brace your core!',
      tags: ['#SquatMechanics', '#LegDay', '#FormClinic'],
      audioTitle: 'Original Audio — Jordan Prime • Heavy Bass Synth (132 BPM)',
      attachedWorkoutTitle: '45-Min Quad & Glute Hypertrophy',
      attachedWorkoutSub: '5 Exercises • 18 Sets • ~420 kcal',
      attachedWorkoutDifficulty: 'Int.',
      bgImageUrl:
          'https://lh3.googleusercontent.com/aida-public/AB6AXuAjta1Rz50yaYLsYrLIm0RP2mo62GCRSKpqe2jdFu9lXM-1ki5h7-kdDRyIIaQv9-IGWzLt7LXvAoPdwK40MfUg-Eo8TGOqSUGZciA4JggUq1YMD39a7TuIRe6rRdfjhEZCj94_h-JjSkU4iWT1frwR7eMzEep39udub-s9FoXx4wCd0yd8rvg849FMvWRMGFxgWXbp-5EB2Yq3LTIB7YwAJjTIrGOlKr1-WlPdOXTeYOEc6pWPqulx',
      views: 9840,
      likes: 48200,
      commentsCount: 1420,
      saves: 8900,
      shares: 3120,
      isLiked: false,
      isSaved: false,
      isFollowing: false,
      comments: [
        ReelComment(
          author: 'Arjun Mehta',
          handle: '@arjun.lifts',
          text:
              'The knee cue made an immediate difference on my 315lb set today!',
          time: '2h ago',
          likes: 48,
        ),
        ReelComment(
          author: 'Sneha Rao',
          handle: '@sneha.fit',
          text: 'Great tempo breakdown! Please do Romanian Deadlifts next 🙌',
          time: '4h ago',
          likes: 24,
        ),
        ReelComment(
          author: 'Dev Patel',
          handle: '@dev.runs',
          text: 'Solid hip mobility pre-exhaust routine included?',
          time: '5h ago',
          likes: 12,
        ),
      ],
    ),

    // Reel 2: Conventional Deadlift Mastery
    ReelItem(
      id: 'reel_2',
      authorHandle: '@arjun.lifts',
      authorRole: 'GRANDMASTER',
      authorAvatar:
          'https://lh3.googleusercontent.com/aida-public/AB6AXuDQNTLCikX5_o5zgXSYFLVFiY9ejIQCSYPv8j5kMpr0SsEo1_sr6F7XZ9ArRiA_a-979Yb6XkdtJWKeyAAlCaHlepSasYfIN2vWJyF1ExRVHN60S_f_wegIIbt-r8AzsAaOtXlZQcUtZZ4iAjv2mQ4krD7bREdPGjA-Um_6o_xd6x5_WKwVA4ujzj_doBu72ifB3n75lBeLyC0gpqiAqmW8VT9ILsuAH5R5rxCLgIMHlOadshYWCkYW',
      categoryTag: 'Strength PR',
      title: 'Deadlift Wedge & Slack Pulling Cue',
      caption:
          'Pulling the slack out of the barbell before leg drive. Watch the bar click before the hips engage 💪 No rounded backs allowed!',
      tags: ['#DeadliftCues', '#Powerlifting', '#BackVolume'],
      audioTitle: 'Heavy Metal Barbell Soundtrack • 140 BPM Hype',
      attachedWorkoutTitle: 'Back & Core Volume Blitz',
      attachedWorkoutSub: '4 Exercises • 16 Sets • ~390 kcal',
      attachedWorkoutDifficulty: 'Adv.',
      bgImageUrl:
          'https://images.unsplash.com/photo-1517838277536-f5f99be501cd?auto=format&fit=crop&w=1080&q=80',
      views: 14200,
      likes: 62400,
      commentsCount: 2180,
      saves: 11400,
      shares: 4890,
      isLiked: true,
      isSaved: true,
      isFollowing: true,
      comments: [
        ReelComment(
          author: 'Pavan C M',
          handle: '@pavan.fit',
          text:
              'Tested this cue on my 405lb lift this morning. Felt so tight off the floor!',
          time: '1h ago',
          likes: 85,
        ),
        ReelComment(
          author: 'Vikram Das',
          handle: '@vikram.iron',
          text: 'Top tier wedge explanation. Cleanest pull in Karnataka!',
          time: '3h ago',
          likes: 31,
        ),
      ],
    ),

    // Reel 3: High Intensity Athletic Conditioning
    ReelItem(
      id: 'reel_3',
      authorHandle: '@sneha.movement',
      authorRole: 'MASTER ATHLETE',
      authorAvatar:
          'https://lh3.googleusercontent.com/aida-public/AB6AXuAbWhwTXn23u8f0wBHsMBpPnWzNsvnB_ylpJHQAEAJ0UnmaLW_a_XcAxE0fcL8Us5GnRuZZtBFBbd3yn3LPvzPKwoX42hB95iJVY5vdz2xGqiZxHVU2ZVw8w7mcBaEo63yBi3MlrWCnUsQJ4mfwlC8XE_Qq0sNmIwMFrPSq0DfnjNy8aE78rxgDXRwthgBtj08i1odm7V4X7ij2brJd3qmG5VQ30AqpmNlF_KMw4okxuIu0n5hgglSB',
      categoryTag: 'HIIT Conditioning',
      title: '20-Min Kettlebell Athletic Engine',
      caption:
          'Quick 20-minute metabolic flush. 40s work, 20s rest. Swings, cleans, and goblet lunges for max VO2 boost ⚡',
      tags: ['#HIITWorkout', '#KettlebellSport', '#Endurance'],
      audioTitle: 'High Energy Electronic Beats • Tribal Rhythms',
      attachedWorkoutTitle: 'HIIT Engine & Core Flush',
      attachedWorkoutSub: '6 Exercises • 12 Rounds • ~310 kcal',
      attachedWorkoutDifficulty: 'All',
      bgImageUrl:
          'https://images.unsplash.com/photo-1549060279-7e168fcee0c2?auto=format&fit=crop&w=1080&q=80',
      views: 7420,
      likes: 31200,
      commentsCount: 890,
      saves: 5400,
      shares: 1840,
      isLiked: false,
      isSaved: false,
      isFollowing: false,
      comments: [
        ReelComment(
          author: 'Maya Torres',
          handle: '@maya.fit',
          text: 'Bookmarked for tomorrow’s morning cardio session! 🔥',
          time: '30m ago',
          likes: 19,
        ),
      ],
    ),

    // Reel 4: Nutrition & Clean Fuel
    ReelItem(
      id: 'reel_4',
      authorHandle: '@maya.nutrition',
      authorRole: 'CERTIFIED DIETITIAN',
      authorAvatar:
          'https://lh3.googleusercontent.com/aida-public/AB6AXuC_SKEyjObMOSKEzssvbDmmvz8EVGbCKGootMUP9AaQCx_9IJWuK1URt8lQLlMIWERbwpXzjJa-iYeUU0c8rCdeDrWhAL7zOpH4--cTSCCA5Zzd_LMO3XKTSEF75bNPHemS-LluW0719dhxlMIg_CfIe-72DRStHRWjKwjsVkKQLTcJp4f6JCCnui0WmC_rqvd28CULaeF7RTfYJSPJtXlKl4-6hCurkHSndIo-YvjldV86QInO4LKL',
      categoryTag: 'Healthy Nutrition',
      title: 'Post-Workout High Protein Recovery Shake (48g Protein)',
      caption:
          'Only 5 ingredients: Whey isolate, oat milk, frozen bananas, chia seeds, and 1 tbsp natural peanut butter 🥜 Smooth, clean fuel!',
      tags: ['#CleanNutrition', '#ProteinShake', '#MealPrep'],
      audioTitle: 'Lo-Fi Chill Beats • Relaxing Kitchen Vibe',
      attachedWorkoutTitle: 'Complete Athlete Nutrition Plan',
      attachedWorkoutSub: 'Daily Macro Breakdown • 2,400 kcal',
      attachedWorkoutDifficulty: 'Nutr.',
      bgImageUrl:
          'https://images.unsplash.com/photo-1550989460-0adf9ea622e2?auto=format&fit=crop&w=1080&q=80',
      views: 11900,
      likes: 54100,
      commentsCount: 1650,
      saves: 14200,
      shares: 6100,
      isLiked: false,
      isSaved: false,
      isFollowing: true,
      comments: [
        ReelComment(
          author: 'Kabir Roy',
          handle: '@kabir.lifts',
          text: 'Tried adding blueberries too, delicious recipe!',
          time: '1h ago',
          likes: 14,
        ),
      ],
    ),
  ];

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _vinylController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 6),
    )..repeat();

    _scrubTimer = Timer.periodic(const Duration(milliseconds: 200), (timer) {
      if (mounted) {
        setState(() {
          _scrubProgress = (_scrubProgress + 0.006) % 1.0;
        });
      }
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    _vinylController.dispose();
    _scrubTimer?.cancel();
    super.dispose();
  }

  void _handleDoubleTapLike(ReelItem reel) {
    if (!reel.isLiked) {
      setState(() {
        reel.isLiked = true;
        reel.likes += 1;
        _showHeartAnimation = true;
      });
      Future.delayed(const Duration(milliseconds: 700), () {
        if (mounted) {
          setState(() {
            _showHeartAnimation = false;
          });
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        top: false,
        child: Stack(
          children: [
            // Vertical Swipeable PageView of Video Reels
            PageView.builder(
              controller: _pageController,
              scrollDirection: Axis.vertical,
              itemCount: _reels.length,
              onPageChanged: (index) {
                setState(() {
                  _currentPageIndex = index;
                  _scrubProgress = 0.05;
                });
              },
              itemBuilder: (context, index) {
                final reel = _reels[index];
                return _buildReelPage(reel);
              },
            ),

            // Top Header Bar Overlay
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: SafeArea(
                child: _buildTopHeaderOverlay(),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: WemanBottomNav(
        currentIndex: 2,
        onTap: (index) {
          if (index == 0) context.go('/feed');
          if (index == 1) context.go('/fitness-hub');
          if (index == 2) {}
          if (index == 3) context.go('/explore');
          if (index == 4) context.go('/profile');
        },
      ),
    );
  }

  // --- TOP HEADER OVERLAY ---
  Widget _buildTopHeaderOverlay() {
    final currentReel = _reels[_currentPageIndex];

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.black.withValues(alpha: 0.8),
            Colors.black.withValues(alpha: 0.2),
            Colors.transparent,
          ],
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              IconButton(
                onPressed: () {
                  if (context.canPop()) {
                    context.pop();
                  } else {
                    context.go('/feed');
                  }
                },
                icon: const Icon(
                  Icons.arrow_back_rounded,
                  color: Colors.white,
                  size: 22,
                ),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
              const SizedBox(width: 10),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: WemanColors.neonLime,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  'WEMAN',
                  style: WemanTypography.labelSmall.copyWith(
                    fontWeight: FontWeight.w900,
                    letterSpacing: 0.8,
                    color: WemanColors.onPrimaryContainer,
                  ),
                ),
              ),
              const SizedBox(width: 6),
              const Text(
                '/',
                style: TextStyle(
                  color: Colors.white54,
                  fontSize: 14,
                  fontWeight: FontWeight.w300,
                ),
              ),
              const SizedBox(width: 6),
              Text(
                'REELS',
                style: WemanTypography.labelSmall.copyWith(
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                  letterSpacing: 0.8,
                ),
              ),
            ],
          ),
          Row(
            children: [
              // Category tag chip
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.5),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.white24, width: 0.5),
                ),
                child: Row(
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
                      currentReel.categoryTag,
                      style: WemanTypography.labelSmall.copyWith(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),

              // Sound Toggle Button
              GestureDetector(
                onTap: () {
                  setState(() {
                    _isMuted = !_isMuted;
                  });
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      duration: const Duration(seconds: 1),
                      backgroundColor: WemanColors.inverseSurface,
                      content: Text(
                        _isMuted
                            ? 'Audio muted'
                            : 'Audio playing • ${currentReel.audioTitle}',
                        style: const TextStyle(fontSize: 12),
                      ),
                    ),
                  );
                },
                child: Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.5),
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white24, width: 0.5),
                  ),
                  child: Icon(
                    _isMuted
                        ? Icons.volume_off_rounded
                        : Icons.volume_up_rounded,
                    color: Colors.white,
                    size: 18,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // --- REEL PAGE VIEW ITEM ---
  Widget _buildReelPage(ReelItem reel) {
    return GestureDetector(
      onDoubleTap: () => _handleDoubleTapLike(reel),
      child: Stack(
        fit: StackFit.expand,
        children: [
          // 1. Background Video / Media Canvas
          Image.network(
            reel.bgImageUrl,
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => Container(
              color: const Color(0xFF16181A),
              child: const Center(
                child: Icon(
                  Icons.fitness_center_rounded,
                  size: 64,
                  color: WemanColors.neonLime,
                ),
              ),
            ),
          ),

          // 2. High contrast scrim gradients matching Stitch design
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.black.withValues(alpha: 0.55),
                  Colors.transparent,
                  Colors.black.withValues(alpha: 0.4),
                  Colors.black.withValues(alpha: 0.95),
                ],
                stops: const [0.0, 0.25, 0.6, 1.0],
              ),
            ),
          ),

          // Double tap heart pop animation
          if (_showHeartAnimation)
            Center(
              child: TweenAnimationBuilder<double>(
                tween: Tween(begin: 0.6, end: 1.3),
                duration: const Duration(milliseconds: 300),
                builder: (context, val, child) {
                  return Transform.scale(
                    scale: val,
                    child: const Icon(
                      Icons.favorite_rounded,
                      color: Colors.redAccent,
                      size: 96,
                    ),
                  );
                },
              ),
            ),

          // 3. Floating "Try Workout" Volt Action Pill (Top Right)
          Positioned(
            top: 76,
            right: 14,
            child: GestureDetector(
              onTap: () => _showTryWorkoutModal(context, reel),
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
                decoration: BoxDecoration(
                  color: WemanColors.neonLime,
                  borderRadius: BorderRadius.circular(22),
                  boxShadow: [
                    BoxShadow(
                      color: WemanColors.neonLime.withValues(alpha: 0.5),
                      blurRadius: 14,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.bolt_rounded,
                      size: 17,
                      color: WemanColors.onPrimaryContainer,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      'TRY WORKOUT',
                      style: WemanTypography.labelSmall.copyWith(
                        color: WemanColors.onPrimaryContainer,
                        fontWeight: FontWeight.w900,
                        fontSize: 10,
                        letterSpacing: 0.6,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // 4. Right Side Floating Interaction Pillar (Avatar, Like, Comment, Save, Share, Vinyl)
          Positioned(
            right: 12,
            bottom: 30,
            child: _buildRightActionPillar(reel),
          ),

          // 5. Bottom Content Overlay (Author, Caption, Tags, Audio, Attached Workout)
          Positioned(
            left: 14,
            right: 80,
            bottom: 12,
            child: _buildBottomContentOverlay(reel),
          ),

          // 6. Timeline Scrubber Progress Line at the very bottom
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              height: 3,
              color: Colors.white12,
              child: Align(
                alignment: Alignment.centerLeft,
                child: Container(
                  width: MediaQuery.of(context).size.width * _scrubProgress,
                  color: WemanColors.neonLime,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // --- RIGHT ACTION PILLAR ---
  Widget _buildRightActionPillar(ReelItem reel) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Creator Avatar + Follow Badge
        Stack(
          clipBehavior: Clip.none,
          alignment: Alignment.center,
          children: [
            Container(
              width: 48,
              height: 48,
              padding: const EdgeInsets.all(2),
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: WemanColors.neonLime,
              ),
              child: ClipOval(
                child: Image.network(
                  reel.authorAvatar,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => const Icon(
                    Icons.person,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: -6,
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    reel.isFollowing = !reel.isFollowing;
                  });
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      duration: const Duration(seconds: 1),
                      backgroundColor: WemanColors.inverseSurface,
                      content: Text(
                        reel.isFollowing
                            ? 'Following ${reel.authorHandle}!'
                            : 'Unfollowed ${reel.authorHandle}',
                      ),
                    ),
                  );
                },
                child: Container(
                  width: 20,
                  height: 20,
                  decoration: BoxDecoration(
                    color:
                        reel.isFollowing ? Colors.white : WemanColors.neonLime,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.black, width: 1.5),
                  ),
                  child: Icon(
                    reel.isFollowing ? Icons.check : Icons.add,
                    size: 13,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 18),

        // Like Button
        GestureDetector(
          onTap: () {
            setState(() {
              reel.isLiked = !reel.isLiked;
              reel.likes += reel.isLiked ? 1 : -1;
            });
          },
          child: Column(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.55),
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white12),
                ),
                child: Icon(
                  reel.isLiked
                      ? Icons.favorite_rounded
                      : Icons.favorite_outline_rounded,
                  color: reel.isLiked ? Colors.redAccent : Colors.white,
                  size: 25,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                '${(reel.likes / 1000).toStringAsFixed(1)}k',
                style: WemanTypography.labelSmall.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                  fontSize: 11,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 14),

        // Comment Button
        GestureDetector(
          onTap: () => _showCommentsModal(context, reel),
          child: Column(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.55),
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white12),
                ),
                child: const Icon(
                  Icons.chat_bubble_outline_rounded,
                  color: Colors.white,
                  size: 22,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                '${(reel.commentsCount / 1000).toStringAsFixed(1)}k',
                style: WemanTypography.labelSmall.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                  fontSize: 11,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 14),

        // Bookmark / Save Routine
        GestureDetector(
          onTap: () {
            setState(() {
              reel.isSaved = !reel.isSaved;
              reel.saves += reel.isSaved ? 1 : -1;
            });
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                duration: const Duration(seconds: 1),
                backgroundColor: WemanColors.inverseSurface,
                content: Text(
                  reel.isSaved
                      ? 'Routine saved to My Space!'
                      : 'Routine unsaved',
                ),
              ),
            );
          },
          child: Column(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.55),
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white12),
                ),
                child: Icon(
                  reel.isSaved
                      ? Icons.bookmark_rounded
                      : Icons.bookmark_outline_rounded,
                  color: reel.isSaved ? WemanColors.neonLime : Colors.white,
                  size: 24,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                '${(reel.saves / 1000).toStringAsFixed(1)}k',
                style: WemanTypography.labelSmall.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                  fontSize: 11,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 14),

        // Share Action
        GestureDetector(
          onTap: () => _showShareModal(context, reel),
          child: Column(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.55),
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white12),
                ),
                child: const Icon(
                  Icons.send_rounded,
                  color: Colors.white,
                  size: 21,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Share',
                style: WemanTypography.labelSmall.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                  fontSize: 11,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),

        // Spinning Audio Vinyl Component
        RotationTransition(
          turns: _vinylController,
          child: Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: const Color(0xFF121416),
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white24, width: 2),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.6),
                  blurRadius: 8,
                ),
              ],
            ),
            child: Center(
              child: Container(
                width: 14,
                height: 14,
                decoration: const BoxDecoration(
                  color: WemanColors.neonLime,
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  // --- BOTTOM CONTENT OVERLAY ---
  Widget _buildBottomContentOverlay(ReelItem reel) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        // Creator Handle + Verified Badge + Role
        Row(
          children: [
            Text(
              reel.authorHandle,
              style: WemanTypography.headlineSmall.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w800,
                fontSize: 15,
                letterSpacing: -0.2,
              ),
            ),
            const SizedBox(width: 6),
            Container(
              width: 15,
              height: 15,
              decoration: const BoxDecoration(
                color: WemanColors.neonLime,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.check,
                size: 10,
                color: WemanColors.onPrimaryContainer,
              ),
            ),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.16),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                reel.authorRole,
                style: WemanTypography.labelSmall.copyWith(
                  color: Colors.white,
                  fontSize: 9,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 0.4,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),

        // Caption & Fitness Tags
        RichText(
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          text: TextSpan(
            style: WemanTypography.bodySmall.copyWith(
              color: Colors.white.withValues(alpha: 0.92),
              fontSize: 12,
              height: 1.3,
            ),
            children: [
              TextSpan(text: '${reel.caption} '),
              for (final tag in reel.tags)
                TextSpan(
                  text: '$tag ',
                  style: const TextStyle(
                    color: WemanColors.neonLime,
                    fontWeight: FontWeight.w700,
                  ),
                ),
            ],
          ),
        ),
        const SizedBox(height: 8),

        // Audio Track Details
        Row(
          children: [
            const Icon(
              Icons.graphic_eq_rounded,
              size: 15,
              color: WemanColors.neonLime,
            ),
            const SizedBox(width: 6),
            Expanded(
              child: Text(
                reel.audioTitle,
                style: WemanTypography.labelSmall.copyWith(
                  color: Colors.white70,
                  fontSize: 10,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),

        // Explicit Hyperlink Anchor Module: Attached Workout Template
        GestureDetector(
          onTap: () => _showTryWorkoutModal(context, reel),
          child: Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.black.withValues(alpha: 0.55),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.white24, width: 0.8),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.3),
                  blurRadius: 10,
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              color:
                                  WemanColors.neonLime.withValues(alpha: 0.2),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.fitness_center_rounded,
                              size: 14,
                              color: WemanColors.neonLime,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      'VERIFIED TEMPLATE',
                                      style:
                                          WemanTypography.labelSmall.copyWith(
                                        color: WemanColors.neonLime,
                                        fontSize: 8.5,
                                        fontWeight: FontWeight.w800,
                                        letterSpacing: 0.4,
                                      ),
                                    ),
                                    const SizedBox(width: 4),
                                    const Text('•',
                                        style: TextStyle(
                                            color: Colors.white38,
                                            fontSize: 10)),
                                    const SizedBox(width: 4),
                                    Text(
                                      'Coached',
                                      style:
                                          WemanTypography.labelSmall.copyWith(
                                        color: Colors.white60,
                                        fontSize: 9,
                                      ),
                                    ),
                                  ],
                                ),
                                Text(
                                  reel.attachedWorkoutTitle,
                                  style: WemanTypography.titleSmall.copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w800,
                                    fontSize: 12,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 7, vertical: 2),
                      decoration: BoxDecoration(
                        color: Colors.white12,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        reel.attachedWorkoutDifficulty,
                        style: WemanTypography.labelSmall.copyWith(
                          color: Colors.white70,
                          fontSize: 9,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      reel.attachedWorkoutSub,
                      style: WemanTypography.bodySmall.copyWith(
                        color: Colors.white70,
                        fontSize: 10,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: WemanColors.neonLime,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'Log Routine',
                            style: WemanTypography.labelSmall.copyWith(
                              fontWeight: FontWeight.w900,
                              color: WemanColors.onPrimaryContainer,
                              fontSize: 9,
                            ),
                          ),
                          const SizedBox(width: 3),
                          const Icon(
                            Icons.arrow_forward_rounded,
                            size: 11,
                            color: WemanColors.onPrimaryContainer,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // --- COMMENTS MODAL SHEET ---
  void _showCommentsModal(BuildContext context, ReelItem reel) {
    final commentController = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: WemanColors.cardBg,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Padding(
              padding: EdgeInsets.only(
                left: 16,
                right: 16,
                top: 14,
                bottom: MediaQuery.of(ctx).viewInsets.bottom + 16,
              ),
              child: SizedBox(
                height: 480,
                child: Column(
                  children: [
                    // Handle pill
                    Container(
                      width: 38,
                      height: 4,
                      decoration: BoxDecoration(
                        color: WemanColors.surfaceContainerHigh,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '${reel.comments.length} Comments',
                          style: WemanTypography.titleMedium.copyWith(
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.close_rounded, size: 20),
                          onPressed: () => Navigator.pop(ctx),
                        ),
                      ],
                    ),
                    const Divider(color: WemanColors.surfaceContainerHigh),
                    Expanded(
                      child: ListView.separated(
                        itemCount: reel.comments.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 12),
                        itemBuilder: (context, idx) {
                          final c = reel.comments[idx];
                          return Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CircleAvatar(
                                radius: 16,
                                backgroundColor:
                                    WemanColors.surfaceContainerLow,
                                child: Text(
                                  c.author.isNotEmpty ? c.author[0] : 'U',
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold),
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
                                          c.author,
                                          style: WemanTypography.labelSmall
                                              .copyWith(
                                            fontWeight: FontWeight.w800,
                                          ),
                                        ),
                                        const SizedBox(width: 6),
                                        Text(
                                          c.time,
                                          style: WemanTypography.labelSmall
                                              .copyWith(
                                            color: WemanColors.textMuted,
                                            fontSize: 9,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      c.text,
                                      style: WemanTypography.bodySmall.copyWith(
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  setModalState(() {
                                    c.isLiked = !c.isLiked;
                                    c.likes += c.isLiked ? 1 : -1;
                                  });
                                },
                                child: Column(
                                  children: [
                                    Icon(
                                      c.isLiked
                                          ? Icons.favorite_rounded
                                          : Icons.favorite_border_rounded,
                                      size: 16,
                                      color: c.isLiked
                                          ? Colors.red
                                          : WemanColors.textMuted,
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      '${c.likes}',
                                      style: TextStyle(
                                        fontSize: 9,
                                        color: c.isLiked
                                            ? Colors.red
                                            : WemanColors.textMuted,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: commentController,
                            style: WemanTypography.bodySmall,
                            decoration: InputDecoration(
                              hintText: 'Add workout feedback or question...',
                              hintStyle: WemanTypography.bodySmall.copyWith(
                                color: WemanColors.textMuted,
                                fontSize: 12,
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 10,
                              ),
                              filled: true,
                              fillColor: WemanColors.surfaceContainerLow,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20),
                                borderSide: BorderSide.none,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        IconButton(
                          onPressed: () {
                            if (commentController.text.trim().isNotEmpty) {
                              setModalState(() {
                                reel.comments.insert(
                                  0,
                                  ReelComment(
                                    author: 'Pavan C M',
                                    handle: '@pavan.fit',
                                    text: commentController.text.trim(),
                                    time: 'Just now',
                                    likes: 0,
                                  ),
                                );
                                reel.commentsCount += 1;
                              });
                              commentController.clear();
                            }
                          },
                          icon: const Icon(Icons.send_rounded,
                              color: WemanColors.primary),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  // --- SHARE MODAL SHEET ---
  void _showShareModal(BuildContext context, ReelItem reel) {
    showModalBottomSheet(
      context: context,
      backgroundColor: WemanColors.cardBg,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) {
        return Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Share Reel',
                style: WemanTypography.titleMedium
                    .copyWith(fontWeight: FontWeight.w900),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildShareOption(Icons.link_rounded, 'Copy Link', () {
                    Navigator.pop(ctx);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text('Reel link copied to clipboard!')),
                    );
                  }),
                  _buildShareOption(Icons.send_rounded, 'WEMAN Chat', () {
                    Navigator.pop(ctx);
                    context.push('/inbox');
                  }),
                  _buildShareOption(Icons.camera_alt_outlined, 'Snap / Story',
                      () {
                    Navigator.pop(ctx);
                    context.push('/create-post');
                  }),
                  _buildShareOption(Icons.share_outlined, 'More Options', () {
                    Navigator.pop(ctx);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text('Sharing fitness demonstration...')),
                    );
                  }),
                ],
              ),
              const SizedBox(height: 12),
            ],
          ),
        );
      },
    );
  }

  Widget _buildShareOption(IconData icon, String label, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: WemanColors.surfaceContainerLow,
              shape: BoxShape.circle,
              border: Border.all(color: WemanColors.surfaceContainerHigh),
            ),
            child: Icon(icon, color: WemanColors.onSurface, size: 22),
          ),
          const SizedBox(height: 6),
          Text(
            label,
            style: WemanTypography.labelSmall.copyWith(
              fontSize: 10,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }

  // --- TRY WORKOUT MODAL ---
  void _showTryWorkoutModal(BuildContext context, ReelItem reel) {
    showModalBottomSheet(
      context: context,
      backgroundColor: WemanColors.cardBg,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) {
        return Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: WemanColors.neonLime,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(Icons.bolt_rounded,
                        color: WemanColors.onPrimaryContainer),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          reel.attachedWorkoutTitle,
                          style: WemanTypography.titleMedium
                              .copyWith(fontWeight: FontWeight.w900),
                        ),
                        Text(
                          'Curated by ${reel.authorHandle} • Verified Form Protocol',
                          style: WemanTypography.labelSmall.copyWith(
                            color: WemanColors.textMuted,
                            fontSize: 11,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: WemanColors.surfaceContainerLow,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildStatCol('EST. BURN', '~420 kcal'),
                    _buildStatCol('TIME', '45 Mins'),
                    _buildStatCol('DIFFICULTY', reel.attachedWorkoutDifficulty),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(ctx);
                  context.push('/fitness-tracking');
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: WemanColors.neonLime,
                  foregroundColor: WemanColors.onPrimaryContainer,
                  elevation: 0,
                  minimumSize: const Size.fromHeight(48),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16)),
                ),
                child: Text(
                  'Launch Workout Tracker Now',
                  style: WemanTypography.labelLarge.copyWith(
                    fontWeight: FontWeight.w900,
                    color: WemanColors.onPrimaryContainer,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildStatCol(String label, String value) {
    return Column(
      children: [
        Text(
          label,
          style: WemanTypography.labelSmall.copyWith(
            color: WemanColors.textMuted,
            fontSize: 9,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: WemanTypography.labelMedium.copyWith(
            fontWeight: FontWeight.w900,
          ),
        ),
      ],
    );
  }
}
