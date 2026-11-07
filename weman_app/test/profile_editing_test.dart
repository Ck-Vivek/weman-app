import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:weman_app/core/demo_state/demo_state.dart';
import 'package:weman_app/features/profile/my_space_screen.dart';
import 'package:weman_app/features/profile/profile_screen.dart';

void main() {
  group('ProfileNotifier Unit Tests', () {
    test('initializes with default WEMAN FIT demo profile', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final profile = container.read(userProfileProvider);
      expect(profile.name, 'Pavan');
      expect(profile.handle, '@pavan.fit');
      expect(profile.bio, 'Building strength, one day at a time.');
      expect(profile.fitnessGoal, 'Hypertrophy & Strength PRs');
      expect(profile.athleteBadge, 'MASTER ATHLETE');
      expect(profile.followersCount, '1.4k');
      expect(profile.followingCount, '382');
    });

    test('updateProfile updates all fields and normalizes handle with @ prefix',
        () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final notifier = container.read(userProfileProvider.notifier);

      notifier.updateProfile(
        name: 'Pavan Murthy',
        handle: 'pavan_beast', // Missing @ prefix
        bio: 'Deadlift PR 200kg incoming! 💥',
        fitnessGoal: 'Powerlifting & Heavy Compound',
      );

      final updated = container.read(userProfileProvider);
      expect(updated.name, 'Pavan Murthy');
      expect(updated.handle, '@pavan_beast'); // Normalized with @
      expect(updated.bio, 'Deadlift PR 200kg incoming! 💥');
      expect(updated.fitnessGoal, 'Powerlifting & Heavy Compound');
    });

    test('reset restores initial default state', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final notifier = container.read(userProfileProvider.notifier);
      notifier.updateProfile(
        name: 'Custom Athlete',
        handle: '@custom',
        bio: 'Custom bio',
        fitnessGoal: 'Cardio',
      );

      expect(container.read(userProfileProvider).name, 'Custom Athlete');

      notifier.reset();
      expect(container.read(userProfileProvider).name, 'Pavan');
      expect(container.read(userProfileProvider).handle, '@pavan.fit');
    });
  });

  group('Profile Editing Widget & Flow Tests', () {
    testWidgets('ProfileScreen renders current profile information',
        (WidgetTester tester) async {
      tester.view.physicalSize = const Size(800, 2000);
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

      expect(find.text('Pavan'), findsOneWidget);
      expect(find.text('@pavan.fit'), findsOneWidget);
      expect(
          find.text('Building strength, one day at a time.'), findsOneWidget);
      expect(find.text('Hypertrophy & Strength PRs'), findsOneWidget);
      expect(find.byKey(const Key('profile_edit_button')), findsOneWidget);
    });

    testWidgets('Tapping Edit Profile opens bottom sheet with prefilled fields',
        (WidgetTester tester) async {
      tester.view.physicalSize = const Size(800, 2000);
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

      // Tap Edit Profile button
      await tester.tap(find.byKey(const Key('profile_edit_button')));
      await tester.pumpAndSettle();

      // Verify bottom sheet is presented
      expect(find.byKey(const Key('edit_profile_sheet')), findsOneWidget);
      expect(find.text('EDIT ATHLETE PROFILE'), findsOneWidget);

      // Verify fields are prefilled with current profile data
      final nameField = tester.widget<TextFormField>(
          find.byKey(const Key('edit_profile_name_field')));
      expect(nameField.controller?.text, 'Pavan');

      final handleField = tester.widget<TextFormField>(
          find.byKey(const Key('edit_profile_handle_field')));
      expect(handleField.controller?.text, '@pavan.fit');

      final bioField = tester.widget<TextFormField>(
          find.byKey(const Key('edit_profile_bio_field')));
      expect(bioField.controller?.text, 'Building strength, one day at a time.');

      final goalField = tester.widget<TextFormField>(
          find.byKey(const Key('edit_profile_goal_field')));
      expect(goalField.controller?.text, 'Hypertrophy & Strength PRs');
    });

    testWidgets(
        'Validation triggers when required fields are cleared and prevents save',
        (WidgetTester tester) async {
      tester.view.physicalSize = const Size(800, 2000);
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

      // Open bottom sheet
      await tester.tap(find.byKey(const Key('profile_edit_button')));
      await tester.pumpAndSettle();

      // Clear all fields
      await tester.enterText(
          find.byKey(const Key('edit_profile_name_field')), '   ');
      await tester.enterText(
          find.byKey(const Key('edit_profile_handle_field')), '');
      await tester.enterText(
          find.byKey(const Key('edit_profile_bio_field')), '  ');
      await tester.enterText(
          find.byKey(const Key('edit_profile_goal_field')), '');

      // Tap Save Changes
      await tester.tap(find.byKey(const Key('edit_profile_save_button')));
      await tester.pumpAndSettle();

      // Verify validation error messages appear
      expect(find.text('Display name is required'), findsOneWidget);
      expect(find.text('Username/handle is required'), findsOneWidget);
      expect(find.text('Bio is required'), findsOneWidget);
      expect(find.text('Fitness goal is required'), findsOneWidget);

      // Verify bottom sheet remains open
      expect(find.byKey(const Key('edit_profile_sheet')), findsOneWidget);
    });

    testWidgets(
        'Editing fields and saving updates profile immediately on ProfileScreen',
        (WidgetTester tester) async {
      tester.view.physicalSize = const Size(800, 2000);
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
            home: ProfileScreen(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Open bottom sheet
      await tester.tap(find.byKey(const Key('profile_edit_button')));
      await tester.pumpAndSettle();

      // Enter new valid profile details
      await tester.enterText(
          find.byKey(const Key('edit_profile_name_field')), 'Pavan C M');
      await tester.enterText(
          find.byKey(const Key('edit_profile_handle_field')), '@pavan.beast');
      await tester.enterText(find.byKey(const Key('edit_profile_bio_field')),
          'Chasing a 500kg powerlifting total.');
      await tester.enterText(find.byKey(const Key('edit_profile_goal_field')),
          'Powerlifting & Heavy Compound');

      // Tap Save
      await tester.tap(find.byKey(const Key('edit_profile_save_button')));
      await tester.pumpAndSettle();

      // Bottom sheet dismissed
      expect(find.byKey(const Key('edit_profile_sheet')), findsNothing);

      // Verify ProfileScreen updated immediately
      expect(find.text('Pavan C M'), findsOneWidget);
      expect(find.text('@pavan.beast'), findsOneWidget);
      expect(
          find.text('Chasing a 500kg powerlifting total.'), findsOneWidget);
      expect(find.text('Powerlifting & Heavy Compound'), findsOneWidget);

      // Verify provider state also updated
      final currentProfile = container.read(userProfileProvider);
      expect(currentProfile.name, 'Pavan C M');
      expect(currentProfile.handle, '@pavan.beast');
      expect(currentProfile.bio, 'Chasing a 500kg powerlifting total.');
      expect(currentProfile.fitnessGoal, 'Powerlifting & Heavy Compound');
    });

    testWidgets(
        'Profile changes persist across session navigation between Profile and My Space',
        (WidgetTester tester) async {
      tester.view.physicalSize = const Size(800, 2000);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      final container = ProviderContainer();
      addTearDown(container.dispose);

      // Update provider in session
      container.read(userProfileProvider.notifier).updateProfile(
            name: 'Pavan Athlete',
            handle: '@pavan.pro',
            bio: 'Elite Athlete Session',
            fitnessGoal: 'Athletic Conditioning',
          );

      // Render MySpaceScreen
      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: const MaterialApp(
            home: MySpaceScreen(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Verify MySpace header displays updated handle
      expect(find.text('@pavan.pro'), findsOneWidget);

      // Now navigate to ProfileScreen
      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: const MaterialApp(
            home: ProfileScreen(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Verify ProfileScreen displays updated profile
      expect(find.text('Pavan Athlete'), findsOneWidget);
      expect(find.text('@pavan.pro'), findsOneWidget);
      expect(find.text('Elite Athlete Session'), findsOneWidget);
      expect(find.text('Athletic Conditioning'), findsOneWidget);
    });
  });
}
