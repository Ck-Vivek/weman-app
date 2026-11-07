import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:weman_app/core/demo_state/demo_state.dart';
import 'package:weman_app/features/explore/explore_screen.dart';
import 'package:weman_app/features/profile/profile_screen.dart';
import 'package:weman_app/features/tracking/fitness_tracking_screen.dart';
import 'package:weman_app/features/training/active_training_screen.dart';

void main() {
  group('WorkoutTelemetryNotifier Unit Tests', () {
    test('initializes with baseline telemetry and 1 baseline workout', () {
      final notifier = WorkoutTelemetryNotifier();
      final state = notifier.state;

      expect(state.workoutHistory.length, 1);
      expect(state.workoutHistory.first.workoutName,
          'Morning Mobility & Core Flow');
      expect(state.dailySteps, 11420);
      expect(state.stepGoal, 12000);
      expect(state.currentStreakDays, 18);
      expect(state.activeMinutes, 52 + 20);
      expect(state.caloriesBurned, 640 + 140);
      expect(state.totalCompletedWorkouts, 184 + 1);
    });

    test('logCompletedWorkout records workout and updates telemetry metrics',
        () {
      final notifier = WorkoutTelemetryNotifier();
      final now = DateTime.now();

      final record = WemanWorkoutRecord(
        id: 'workout-test-1',
        workoutName: 'Hanging Leg Raises & Core Circuit',
        completedAt: now,
        durationMinutes: 24,
        caloriesBurned: 420,
        completedSets: 4,
        totalSets: 4,
        exerciseName: 'Hanging Leg Raises',
        xpEarned: 250,
        heartRateAvg: 138,
      );

      final result = notifier.logCompletedWorkout(record);

      expect(result, isTrue);
      expect(notifier.state.workoutHistory.length, 2);
      expect(notifier.state.workoutHistory.first.id, 'workout-test-1');
      expect(notifier.state.activeMinutes, 52 + 20 + 24);
      expect(notifier.state.caloriesBurned, 640 + 140 + 420);
      expect(notifier.state.totalCompletedWorkouts, 184 + 2);
    });

    test('avoids duplicate workout records with same ID', () {
      final notifier = WorkoutTelemetryNotifier();
      final now = DateTime.now();

      final record = WemanWorkoutRecord(
        id: 'workout-unique-123',
        workoutName: 'Heavy Pull-Up Session',
        completedAt: now,
        durationMinutes: 30,
        caloriesBurned: 310,
        completedSets: 4,
        totalSets: 4,
        exerciseName: 'Weighted Pull-Ups',
      );

      final firstAttempt = notifier.logCompletedWorkout(record);
      final secondAttempt = notifier.logCompletedWorkout(record);

      expect(firstAttempt, isTrue);
      expect(secondAttempt, isFalse);
      expect(notifier.state.workoutHistory.length, 2);
    });

    test('avoids duplicate workout records on rapid re-submission within 5s',
        () {
      final notifier = WorkoutTelemetryNotifier();
      final now = DateTime.now();

      final record1 = WemanWorkoutRecord(
        id: 'workout-rapid-1',
        workoutName: 'HIIT Kettlebell Swings',
        completedAt: now,
        durationMinutes: 15,
        caloriesBurned: 180,
        completedSets: 3,
        totalSets: 3,
        exerciseName: 'Kettlebell Swings',
      );

      final record2 = WemanWorkoutRecord(
        id: 'workout-rapid-2',
        workoutName: 'HIIT Kettlebell Swings',
        completedAt: now.add(const Duration(seconds: 1)),
        durationMinutes: 15,
        caloriesBurned: 180,
        completedSets: 3,
        totalSets: 3,
        exerciseName: 'Kettlebell Swings',
      );

      final firstAttempt = notifier.logCompletedWorkout(record1);
      final secondAttempt = notifier.logCompletedWorkout(record2);

      expect(firstAttempt, isTrue);
      expect(secondAttempt, isFalse);
      expect(notifier.state.workoutHistory.length, 2);
    });

    test(
        'streak rule: multiple workouts on the same day do not double-increment streak',
        () {
      final notifier = WorkoutTelemetryNotifier();
      final initialStreak = notifier.state.currentStreakDays;

      // Baseline workout was already completed earlier today
      final recordToday = WemanWorkoutRecord(
        id: 'workout-same-day-2',
        workoutName: 'Evening Core Blast',
        completedAt: DateTime.now(),
        durationMinutes: 15,
        caloriesBurned: 120,
        completedSets: 3,
        totalSets: 3,
        exerciseName: 'Planks',
      );

      notifier.logCompletedWorkout(recordToday);

      expect(notifier.state.currentStreakDays, initialStreak);
    });

    test(
        'streak rule: workout on consecutive calendar day increments streak by 1',
        () {
      final notifier = WorkoutTelemetryNotifier();
      final initialStreak = notifier.state.currentStreakDays;

      // Workout on tomorrow (consecutive day)
      final tomorrow = DateTime.now().add(const Duration(days: 1));
      final recordTomorrow = WemanWorkoutRecord(
        id: 'workout-consecutive-day',
        workoutName: 'Next Day Morning Run',
        completedAt: tomorrow,
        durationMinutes: 35,
        caloriesBurned: 350,
        completedSets: 1,
        totalSets: 1,
        exerciseName: 'Outdoor Run',
      );

      notifier.logCompletedWorkout(recordTomorrow);

      expect(notifier.state.currentStreakDays, initialStreak + 1);
    });
  });

  group('Active Training and Navigation Tests', () {
    testWidgets(
        'cancelling/exiting session via back arrow does NOT record a completed workout',
        (tester) async {
      final container = ProviderContainer();
      final initialHistoryLength =
          container.read(workoutTelemetryProvider).workoutHistory.length;

      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: MaterialApp(
            home: Builder(
              builder: (context) => Scaffold(
                body: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const ActiveTrainingScreen(),
                      ),
                    );
                  },
                  child: const Text('Open'),
                ),
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Open'));
      await tester.pumpAndSettle();
      expect(find.byType(ActiveTrainingScreen), findsOneWidget);

      // Tap the back arrow button
      final backButton = find.byIcon(Icons.arrow_back);
      expect(backButton, findsOneWidget);
      await tester.tap(backButton);
      await tester.pumpAndSettle();

      expect(find.byType(ActiveTrainingScreen), findsNothing);
      expect(container.read(workoutTelemetryProvider).workoutHistory.length,
          initialHistoryLength);
    });

    testWidgets(
        'cancelling/exiting session via EXIT chip does NOT record a completed workout',
        (tester) async {
      final container = ProviderContainer();
      final initialHistoryLength =
          container.read(workoutTelemetryProvider).workoutHistory.length;

      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: MaterialApp(
            home: Builder(
              builder: (context) => Scaffold(
                body: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const ActiveTrainingScreen(),
                      ),
                    );
                  },
                  child: const Text('Open'),
                ),
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Open'));
      await tester.pumpAndSettle();
      expect(find.byType(ActiveTrainingScreen), findsOneWidget);

      // Tap EXIT button
      final exitChip = find.text('EXIT');
      expect(exitChip, findsOneWidget);
      await tester.tap(exitChip);
      await tester.pumpAndSettle();

      expect(find.byType(ActiveTrainingScreen), findsNothing);
      expect(container.read(workoutTelemetryProvider).workoutHistory.length,
          initialHistoryLength);
    });

    testWidgets(
        'completing session via Finish and LOG & RETURN TO HUB records workout to provider',
        (tester) async {
      final container = ProviderContainer();
      final initialHistoryLength =
          container.read(workoutTelemetryProvider).workoutHistory.length;

      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: MaterialApp(
            home: Builder(
              builder: (context) => Scaffold(
                body: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const ActiveTrainingScreen(),
                      ),
                    );
                  },
                  child: const Text('Open'),
                ),
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Open'));
      await tester.pumpAndSettle();

      // Active training starts with set 2 of 4 (completedSets: [true, false, false, false])
      // Tap COMPLETE SET for sets 2 and 3
      final completeButton = find.text('COMPLETE SET');
      expect(completeButton, findsOneWidget);

      await tester.tap(completeButton); // completes set 2 -> advances to set 3
      await tester.pump();

      await tester.tap(completeButton); // completes set 3 -> advances to set 4
      await tester.pump();

      // On final set 4, button reflects FINISH WORKOUT
      final finishButton = find.text('FINISH WORKOUT');
      expect(finishButton, findsOneWidget);

      await tester.tap(finishButton); // completes set 4 -> opens finished dialog
      await tester.pumpAndSettle();

      // Dialog should be shown
      expect(find.text('Session Finished!'), findsOneWidget);
      expect(find.text('LOG & RETURN TO HUB'), findsOneWidget);

      // Tap LOG & RETURN TO HUB
      await tester.tap(find.text('LOG & RETURN TO HUB'));
      await tester.pumpAndSettle();

      // History should have 1 additional record with correct data
      final state = container.read(workoutTelemetryProvider);
      expect(state.workoutHistory.length, initialHistoryLength + 1);
      final logged = state.workoutHistory.first;
      expect(logged.workoutName, 'Hanging Leg Raises & Core Circuit');
      expect(logged.caloriesBurned, 420);
      expect(logged.durationMinutes, 24);
      expect(logged.completedSets, 4);
      expect(logged.totalSets, 4);
      expect(logged.exerciseName, 'Hanging Leg Raises');
      expect(logged.xpEarned, 250);
      expect(logged.heartRateAvg, 138);
    });
  });

  group('FitnessTracker and Profile Integration Tests', () {
    testWidgets(
        'FitnessTrackingScreen reads provider state and displays newly completed workout in Workout History immediately',
        (tester) async {
      tester.view.physicalSize = const Size(800, 2400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      final container = ProviderContainer();

      // Log a completed workout record
      final newWorkout = WemanWorkoutRecord(
        id: 'workout-fresh-101',
        workoutName: 'Hanging Leg Raises & Core Circuit',
        completedAt: DateTime.now(),
        durationMinutes: 24,
        caloriesBurned: 420,
        completedSets: 4,
        totalSets: 4,
        exerciseName: 'Hanging Leg Raises',
        xpEarned: 250,
        heartRateAvg: 138,
      );
      container.read(workoutTelemetryProvider.notifier).logCompletedWorkout(newWorkout);

      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: const MaterialApp(
            home: FitnessTrackingScreen(),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Fitness Tracking'), findsOneWidget);
      expect(find.text('WORKOUT HISTORY'), findsOneWidget);
      expect(find.text('2 LOGGED'), findsOneWidget);
      expect(find.text('Hanging Leg Raises & Core Circuit'), findsOneWidget);
      expect(find.text('Morning Mobility & Core Flow'), findsOneWidget);
      expect(find.text('420 kcal (Demo Est.)'), findsOneWidget);
      expect(find.text('24m'), findsOneWidget);
      expect(find.text('4/4 Sets'), findsOneWidget);
      expect(find.text('+250 XP'), findsOneWidget);
    });

    testWidgets(
        'ProfileScreen reflects telemetry workout count and Workouts section shows completed workout',
        (tester) async {
      tester.view.physicalSize = const Size(800, 2400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      final container = ProviderContainer();

      // Log a completed workout
      final newWorkout = WemanWorkoutRecord(
        id: 'workout-profile-test',
        workoutName: 'Hanging Leg Raises & Core Circuit',
        completedAt: DateTime.now(),
        durationMinutes: 24,
        caloriesBurned: 420,
        completedSets: 4,
        totalSets: 4,
        exerciseName: 'Hanging Leg Raises',
        xpEarned: 250,
      );
      container.read(workoutTelemetryProvider.notifier).logCompletedWorkout(newWorkout);

      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: const MaterialApp(
            home: ProfileScreen(),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Total workouts: 184 base + 1 baseline + 1 newly logged = 186
      expect(find.text('186'), findsOneWidget);
      expect(find.text('TELEMETRY & PROGRESS'), findsOneWidget);

      // Tap on Workouts tab segment
      final workoutsTab = find.text('Workouts');
      expect(workoutsTab, findsOneWidget);
      await tester.tap(workoutsTab);
      await tester.pumpAndSettle();

      // Verify newly completed workout appears in Workouts section
      expect(find.text('Hanging Leg Raises & Core Circuit'), findsOneWidget);
      expect(find.text('Completed Today'), findsWidgets);
    });
  });

  group('Explore to Fitness Tracker Navigation Tests', () {
    testWidgets(
        'ExploreScreen renders Fitness Tracker card and tapping navigates to FitnessTrackingScreen',
        (tester) async {
      tester.view.physicalSize = const Size(800, 2400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      final container = ProviderContainer();

      final router = GoRouter(
        initialLocation: '/explore',
        routes: [
          GoRoute(
            path: '/explore',
            builder: (context, state) => const ExploreScreen(),
          ),
          GoRoute(
            path: '/fitness-tracking',
            builder: (context, state) => const FitnessTrackingScreen(),
          ),
        ],
      );

      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: MaterialApp.router(
            routerConfig: router,
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Verify Explore screen is rendered
      expect(find.text('EXPLORE'), findsOneWidget);

      // Verify Fitness Tracker entry card is rendered near the top
      final fitnessTrackerCard =
          find.byKey(const Key('explore_fitness_tracker_card'));
      expect(fitnessTrackerCard, findsOneWidget);
      expect(find.text('Fitness Tracker'), findsOneWidget);
      expect(find.text('LIVE ATHLETE TELEMETRY'), findsOneWidget);
      expect(find.text('TRACK'), findsOneWidget);

      // Tap on the Fitness Tracker card
      await tester.tap(fitnessTrackerCard);
      await tester.pumpAndSettle();

      // Verify we navigated to FitnessTrackingScreen
      expect(find.text('Fitness Tracking'), findsOneWidget);
      expect(find.text('WORKOUT HISTORY'), findsOneWidget);

      // Tap back button
      final backButton = find.byIcon(Icons.arrow_back);
      expect(backButton, findsOneWidget);
      await tester.tap(backButton);
      await tester.pumpAndSettle();

      // Verify we are back on Explore
      expect(find.text('EXPLORE'), findsOneWidget);
      expect(fitnessTrackerCard, findsOneWidget);
    });
  });
}
