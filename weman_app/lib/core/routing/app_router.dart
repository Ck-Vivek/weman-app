import 'package:go_router/go_router.dart';
import '../../features/onboarding/onboarding_screen.dart';
import '../../features/auth/login_screen.dart';
import '../../features/feed/social_feed_screen.dart';
import '../../features/feed/create_post_screen.dart';
import '../../features/reels/reels_screen.dart';
import '../../features/explore/explore_screen.dart';
import '../../features/fitness_hub/fitness_hub_screen.dart';
import '../../features/profile/profile_screen.dart';
import '../../features/profile/my_space_screen.dart';
import '../../features/messaging/conversations_inbox_screen.dart';
import '../../features/messaging/chat_detail_screen.dart';
import '../../features/nutrition/diet_tracker_screen.dart';
import '../../features/training/training_hub_screen.dart';
import '../../features/training/workout_details_screen.dart';
import '../../features/training/active_training_screen.dart';
import '../../features/tracking/fitness_tracking_screen.dart';
import '../../features/achievements/badge_gallery_screen.dart';
import '../../features/rankings/rankings_screen.dart';

class AppRouter {
  AppRouter._();

  static final GoRouter router = GoRouter(
    initialLocation: '/feed',
    routes: [
      GoRoute(
        path: '/',
        name: 'home',
        builder: (context, state) => const SocialFeedScreen(),
      ),
      GoRoute(
        path: '/login',
        name: 'login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/onboarding',
        name: 'onboarding',
        builder: (context, state) => const OnboardingScreen(),
      ),
      GoRoute(
        path: '/feed',
        name: 'feed',
        builder: (context, state) => const SocialFeedScreen(),
      ),
      GoRoute(
        path: '/create-post',
        name: 'create-post',
        builder: (context, state) => const CreatePostScreen(),
      ),
      GoRoute(
        path: '/inbox',
        name: 'inbox',
        builder: (context, state) => const ConversationsInboxScreen(),
      ),
      GoRoute(
        path: '/chat-detail',
        name: 'chat-detail',
        builder: (context, state) {
          final conversationId = state.extra is String
              ? state.extra as String
              : (state.uri.queryParameters['id'] ?? 'maya_torres');
          return ChatDetailScreen(conversationId: conversationId);
        },
      ),
      GoRoute(
        path: '/fitness-hub',
        name: 'fitness-hub',
        builder: (context, state) => const FitnessHubScreen(),
      ),
      GoRoute(
        path: '/training-hub',
        name: 'training-hub',
        builder: (context, state) => const TrainingHubScreen(),
      ),
      GoRoute(
        path: '/workout-details',
        name: 'workout-details',
        builder: (context, state) => const WorkoutDetailsScreen(),
      ),
      GoRoute(
        path: '/active-training',
        name: 'active-training',
        builder: (context, state) => const ActiveTrainingScreen(),
      ),
      GoRoute(
        path: '/diet-tracker',
        name: 'diet-tracker',
        builder: (context, state) => const DietTrackerScreen(),
      ),
      GoRoute(
        path: '/fitness-tracking',
        name: 'fitness-tracking',
        builder: (context, state) => const FitnessTrackingScreen(),
      ),
      GoRoute(
        path: '/badge-gallery',
        name: 'badge-gallery',
        builder: (context, state) => const BadgeGalleryScreen(),
      ),
      GoRoute(
        path: '/rankings',
        name: 'rankings',
        builder: (context, state) => const RankingsScreen(),
      ),
      GoRoute(
        path: '/explore',
        name: 'explore',
        builder: (context, state) => const ExploreScreen(),
      ),
      GoRoute(
        path: '/profile',
        name: 'profile',
        builder: (context, state) => const ProfileScreen(),
      ),
      GoRoute(
        path: '/my-space',
        name: 'my-space',
        builder: (context, state) => const MySpaceScreen(),
      ),
      // Preserved to prevent broken references
      GoRoute(
        path: '/reels',
        name: 'reels',
        builder: (context, state) => const ReelsScreen(),
      ),
    ],
  );
}
