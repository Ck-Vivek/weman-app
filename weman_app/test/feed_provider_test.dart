import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:weman_app/core/demo_state/feed_provider.dart';
import 'package:weman_app/features/feed/social_feed_screen.dart';
import 'package:weman_app/models/models.dart';

void main() {
  group('FeedNotifier Unit Tests', () {
    test('initializes with 3 default showcase posts', () {
      final notifier = FeedNotifier();
      expect(notifier.state.length, 3);
      expect(notifier.state[0].author.handle, '@aanya.lifts');
      expect(notifier.state[1].author.handle, '@rohan.eats.fit');
      expect(notifier.state[2].author.handle, '@dev.runs');
    });

    test('addPost prepends a new post to the top of the feed', () {
      final notifier = FeedNotifier();
      const newPost = WemanFeedPost(
        id: 'test-pavan-post',
        author: WemanUser(
          id: 'user-pavan',
          name: 'Pavan',
          handle: '@pavan.fit',
          avatarUrl: 'assets/images/pavan_avatar.png',
          college: 'Bangalore Institute of Technology',
          isVerifiedTrainer: true,
        ),
        authorRole: 'Master Athlete',
        content: 'Clean 180kg deadlift triple today! 💥🏋️‍♂️',
        likesCount: 1,
        commentsCount: 0,
        sharesCount: 0,
        timestamp: 'Just now • Bangalore',
        isLiked: true,
        isSaved: false,
      );

      notifier.addPost(newPost);

      expect(notifier.state.length, 4);
      expect(notifier.state.first.id, 'test-pavan-post');
      expect(notifier.state.first.author.handle, '@pavan.fit');
      expect(notifier.state.first.content,
          'Clean 180kg deadlift triple today! 💥🏋️‍♂️');
    });

    test('toggleLike toggles like state and updates count', () {
      final notifier = FeedNotifier();
      final initialLike = notifier.state[0].isLiked;
      final initialCount = notifier.state[0].likesCount;

      notifier.toggleLike('post-1');
      expect(notifier.state[0].isLiked, !initialLike);
      expect(notifier.state[0].likesCount, initialCount + 1);

      notifier.toggleLike('post-1');
      expect(notifier.state[0].isLiked, initialLike);
      expect(notifier.state[0].likesCount, initialCount);
    });

    test('toggleSave toggles bookmark state', () {
      final notifier = FeedNotifier();
      expect(notifier.state[0].isSaved, false);

      notifier.toggleSave('post-1');
      expect(notifier.state[0].isSaved, true);

      notifier.toggleSave('post-1');
      expect(notifier.state[0].isSaved, false);
    });
  });

  group('SocialFeedScreen & Provider Widget Tests', () {
    testWidgets(
        'renders feed posts and updates immediately when new post added',
        (WidgetTester tester) async {
      tester.view.physicalSize = const Size(800, 2400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      final container = ProviderContainer();
      addTearDown(container.dispose);

      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: const MaterialApp(
            home: SocialFeedScreen(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Verify default posts exist
      expect(find.text('@aanya.lifts'), findsOneWidget);
      expect(find.text('@rohan.eats.fit'), findsOneWidget);

      // Now add a post to feedProvider via container
      const newPost = WemanFeedPost(
        id: 'new-live-post',
        author: WemanUser(
          id: 'user-pavan',
          name: 'Pavan',
          handle: '@pavan.fit',
          avatarUrl: 'assets/images/pavan_avatar.png',
          college: 'Bangalore Institute of Technology',
          isVerifiedTrainer: true,
        ),
        authorRole: 'Master Athlete',
        content: 'Brand new workout published to feed!',
        likesCount: 1,
        commentsCount: 0,
        sharesCount: 0,
        timestamp: 'Just now • Bangalore',
      );

      container.read(feedProvider.notifier).addPost(newPost);

      await tester.pumpAndSettle();

      // Verify new post appears on the screen
      expect(find.text('@pavan.fit'), findsOneWidget);
      expect(find.text('Brand new workout published to feed!'), findsOneWidget);
    });
  });
}
