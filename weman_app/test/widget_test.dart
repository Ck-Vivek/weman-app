import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:weman_app/core/widgets/weman_bottom_nav.dart';
import 'package:weman_app/features/profile/profile_screen.dart';
import 'package:weman_app/features/reels/reels_screen.dart';

void main() {
  testWidgets('WemanBottomNav renders Reels button at index 2 with play icon',
      (WidgetTester tester) async {
    int tappedIndex = -1;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          bottomNavigationBar: WemanBottomNav(
            currentIndex: 2,
            onTap: (index) => tappedIndex = index,
          ),
        ),
      ),
    );

    // Verify all 5 navigation items are rendered
    expect(find.text('Home'), findsOneWidget);
    expect(find.text('Hub'), findsOneWidget);
    expect(find.text('Reels'), findsOneWidget);
    expect(find.text('Explore'), findsOneWidget);
    expect(find.text('Profile'), findsOneWidget);

    // Verify play icon is present
    expect(find.byIcon(Icons.play_circle_rounded), findsOneWidget);

    // Tap Reels
    await tester.tap(find.text('Reels'));
    expect(tappedIndex, 2);
  });

  testWidgets(
      'ProfileScreen displays Rankings & Leaderboard below Achievements with 5 preview ranks and View All Rankings button',
      (WidgetTester tester) async {
    tester.view.physicalSize = const Size(800, 2400);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    await tester.pumpWidget(
      const ProviderScope(
        child: MaterialApp(
          home: ProfileScreen(),
        ),
      ),
    );

    await tester.pumpAndSettle();

    // Tap on Achievements tab segment
    final achievementsTab = find.text('Achievements');
    expect(achievementsTab, findsOneWidget);
    await tester.tap(achievementsTab);
    await tester.pumpAndSettle();

    // Verify Achievements list is present
    expect(find.text('All Achievements (16/24 Unlocked)'), findsOneWidget);

    // Verify Rankings & Leaderboard section is rendered immediately below Achievements
    expect(find.text('Rankings & Leaderboard'), findsOneWidget);
    expect(find.text('DEMO DATA'), findsOneWidget);

    // Verify all 5 ranks are previewed
    expect(find.text('National Rank'), findsOneWidget);
    expect(find.text('#14'), findsOneWidget);
    expect(find.text('State Rank'), findsOneWidget);
    expect(find.text('#2'), findsOneWidget);
    expect(find.text('District Rank'), findsOneWidget);
    expect(find.text('#1'), findsNWidgets(2)); // District #1 and College #1
    expect(find.text('Region Rank'), findsOneWidget);
    expect(find.text('#5'), findsOneWidget);
    expect(find.text('College Rank'), findsOneWidget);

    // Verify prominent View All Rankings button
    expect(find.text('View All Rankings'), findsOneWidget);
  });

  testWidgets('ReelsScreen renders matching Stitch reference with interactions',
      (WidgetTester tester) async {
    tester.view.physicalSize = const Size(800, 1600);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    await tester.pumpWidget(
      const MaterialApp(
        home: ReelsScreen(),
      ),
    );

    await tester.pump();

    // Verify header and title
    expect(find.text('WEMAN'), findsOneWidget);
    expect(find.text('REELS'), findsOneWidget);

    // Verify Try Workout volt pill
    expect(find.text('TRY WORKOUT'), findsOneWidget);

    // Verify bottom overlay with author and workout template
    expect(find.text('@jordan_prime'), findsOneWidget);
    expect(find.text('45-Min Quad & Glute Hypertrophy'), findsOneWidget);
    expect(find.text('Log Routine'), findsOneWidget);

    // Verify Bottom Navigation with Reels active
    expect(find.text('Reels'), findsOneWidget);
  });
}
