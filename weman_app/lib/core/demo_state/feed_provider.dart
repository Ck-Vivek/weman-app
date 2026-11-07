import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../models/models.dart';

class FeedNotifier extends StateNotifier<List<WemanFeedPost>> {
  FeedNotifier() : super(_initialPosts);

  static final List<WemanFeedPost> _initialPosts = [
    const WemanFeedPost(
      id: 'post-1',
      author: WemanUser(
        id: 'user-aanya',
        name: 'Aanya Sharma',
        handle: '@aanya.lifts',
        avatarUrl:
            'https://lh3.googleusercontent.com/aida-public/AB6AXuCLxebhFGRsv7ILx6y2r5T8u2THgUQuTW9YFbu4SYVo5p62eJ-Le8Jht0pRhXeSKYHpTYwk67rL8LemjFzvg7Bpedw-BJBDWJ6u13ob3oX9nciYQN54ZT8F8qURmQ1RbADakX0YPyXpaRe4Rf1rBoElWiwwr4eupDm1T6OPEN_dAqn0NymeYjr6zL64UXT0L35VojInOPWUdqjNpvA5WSVkViqBBmaulrtQ759P2jcGRhnaJIpUoq-2',
        college: 'PES University, Bangalore',
        isVerifiedTrainer: true,
      ),
      authorRole: 'Master Athlete',
      postType: 'strength',
      content:
          'Clean conventional triple today! Heavy pulls felt crisp with the morning crew 💥🏋️‍♀️',
      imageUrl:
          'https://lh3.googleusercontent.com/aida-public/AB6AXuCor2V2WtuahNK_cJsRlxMMcunM3iBgM1kQE3OukdVd6bmb0maitoBfFozFXSvVTfWs2vr6HYy2sSHxP3Q_YplgbKihLkQfd0_nTB5H1lASpXSx8S-HEvR3Ayu5i37mO98duWxscNZg6_uHZJJMq0OzRdkzA6KKH2QWAnthoiChzuYoWqrT8pLLb8t8dyEyAGR9iSPexviY4NqxlXv-GtG8h5NFALncU9qy49Ps5LxWrGAHtfy8r-RA',
      imageBadgeTop: 'Barbell Deadlifts • 135 kg PR',
      timerBadge: '00:48',
      exerciseName: 'Conventional Deadlift',
      rpeBadge: 'RPE 9.0',
      routineButtonText: 'TRY ROUTINE (4 EXERCISES)',
      metrics: {
        'SETS': '4',
        'REPS': '5',
        'LOAD': '297 lbs',
        'RPE': '9.0',
      },
      likesCount: 342,
      commentsCount: 28,
      sharesCount: 14,
      timestamp: '25m ago • Iron Arena',
      isLiked: false,
      isSaved: false,
    ),
    const WemanFeedPost(
      id: 'post-2',
      author: WemanUser(
        id: 'user-rohan',
        name: 'Rohan Patel',
        handle: '@rohan.eats.fit',
        avatarUrl:
            'https://lh3.googleusercontent.com/aida-public/AB6AXuD6_FlxiZy_2rTyD_pgSptZvh4Jo4COnnNjXLDa4FLuXvBwBljIGZut_aDOS2U-jIckv7EjSbe8gAa92iRL_DONrhV89_oKL-2O2-05rf8j4N9YIm7GBksaB-tQNfKyjQK8Um4TaVTjSuIXbsLcCpPi6rd1imcU1T5mKdvP1PVzjCGvNlzJMqS9kZjeR9uTToBMcd68UIiW1BmWnT3w5A8qN5k5bNAW1yXm6h2LcEl6FsrwxUNMmJNI',
        college: 'IIT Bombay',
        isVerifiedTrainer: false,
      ),
      authorRole: 'Nutritionist',
      postType: 'nutrition',
      categoryTag: 'FUELING & MACROS',
      postTitle: 'High Protein Indian Power Breakfast',
      content:
          'South Indian power breakfast done right 🌱 Fluffy oats & moong idlis paired with spiced paneer and home-style dal sambar. Macro fuel! 🍛💪',
      imageUrl:
          'https://lh3.googleusercontent.com/aida-public/AB6AXuBpV-l5w_ltrDM2SgRzW7frxLgxiR_b3MFreDss5hyVbaXMAo9WM0kndBm0hFg0JFxgd7S2bEKvTXYbFP6d-sF9fJOiUi3hBwYRnVgW-N966QgfV0EbXmqhOqeirI6Ipp1id0HeBpysCfSJOPPn0fVOGWWHGhIvA5SyZm8Cu9qTSzq__tdj374INi-SSiugDf6X4SlZ-eX3dq7KbQ7v5jX4MlzbaJRZ-zJRkk7Zfl490zky60air1Ea',
      imageBadgeBottom: 'Steamed Moong Idli + Paneer Bhurji',
      macroHeadline: '38g Protein • 520 kcal • Clean Carbs',
      metrics: {
        'CALORIES': '520 kcal',
        'PROTEIN': '38g',
        'CARBS': '54g',
        'FATS': '14g',
      },
      likesCount: 512,
      commentsCount: 45,
      sharesCount: 32,
      timestamp: '1h ago • Mumbai',
      isLiked: false,
      isSaved: false,
    ),
    const WemanFeedPost(
      id: 'post-3',
      author: WemanUser(
        id: 'user-dev',
        name: 'Dev Kapoor',
        handle: '@dev.runs',
        avatarUrl:
            'https://lh3.googleusercontent.com/aida-public/AB6AXuBpmx1-h9qPzxuKmq0rAVmxDC_E4c1NzceqN9El1JsWfLaJsP1Azk_vuIAkRmaMBL8bs6yFaqb2KSTMqVsX9m6axLiD6FKhSGaxECVPlw3ipZ-Qg-CmSVb20LWKg627KNv1T4E_ydXzRfgyXfUY8_qpNiWeEciVZOWdKaKzPNp337vQvnQvIkm27cHVjhULtJQcM4sQQxQ5hOtCFAJx3f9fydf0i7LoJJvTkg9SJjuRyWEhJ_uZ-xLI',
        college: 'RV College, Bangalore',
        isVerifiedTrainer: false,
      ),
      authorRole: 'Endurance Coach',
      postType: 'running',
      content:
          'Pre-monsoon morning tempo run. Kept cadence steady at 178 spm 🏃‍♂️⚡ Consistency beats motivation every single day.',
      imageUrl:
          'https://lh3.googleusercontent.com/aida-public/AB6AXuDD-2dMXa00vo0V7aswEI2V_oLTjAPx-B-V7n2OsjfK9Uw8P2sZ1TkBs7qoLgEVNID4_gDNFa2I6DaX1rUrEvQ0aPOgV4rkj7uszTi4Uldy6sfJ7Am7NTcgZu7dT6UgETEZbv7ZWAmn7teFJlOMq8nWRpF95qamWyxHlyTrOkFKitef2J0v7cpLTfB_3pRH9wQH6JSAgDnNNEkTW62pY0YaoOzPpmpvvB3s0IbMhlRwGDiyliKB0e1o',
      imageBadgeTop: 'Tempo Run 8.2 km',
      metrics: {
        'PACE': "4'48\" /km",
        'TIME': '39m 22s',
        'HEART RATE': '162 bpm',
      },
      likesCount: 289,
      commentsCount: 19,
      sharesCount: 11,
      timestamp: '3h ago • Sea Breeze Trail',
      isLiked: false,
      isSaved: false,
    ),
  ];

  /// Prepends a new post to the top of the feed
  void addPost(WemanFeedPost post) {
    state = [post, ...state];
  }

  /// Toggles like state and increments/decrements like count
  void toggleLike(String postId) {
    state = [
      for (final post in state)
        if (post.id == postId)
          post.copyWith(
            isLiked: !post.isLiked,
            likesCount: post.isLiked
                ? (post.likesCount > 0 ? post.likesCount - 1 : 0)
                : post.likesCount + 1,
          )
        else
          post,
    ];
  }

  /// Toggles bookmark/saved state for the post
  void toggleSave(String postId) {
    state = [
      for (final post in state)
        if (post.id == postId)
          post.copyWith(
            isSaved: !post.isSaved,
          )
        else
          post,
    ];
  }
}

final feedProvider =
    StateNotifierProvider<FeedNotifier, List<WemanFeedPost>>((ref) {
  return FeedNotifier();
});
