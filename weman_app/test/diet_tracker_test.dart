import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:weman_app/core/demo_state/demo_state.dart';
import 'package:weman_app/features/nutrition/diet_tracker_screen.dart';
import 'package:weman_app/features/profile/profile_screen.dart';

void main() {
  group('NutritionNotifier Unit Tests', () {
    test('initializes with baseline seeded demo meals and calculates macros',
        () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final state = container.read(nutritionProvider);
      expect(state.meals.isNotEmpty, true);
      expect(state.totalCalories, greaterThan(0));
      expect(state.totalProtein, greaterThan(0));
      expect(state.totalCarbs, greaterThan(0));
      expect(state.totalFats, greaterThan(0));
      expect(state.waterLiters, 3.25);
      expect(state.waterTargetLiters, 4.0);
    });

    test('addMeal increases macro totals automatically and rejects negative values',
        () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final notifier = container.read(nutritionProvider.notifier);
      final initialCalories = container.read(nutritionProvider).totalCalories;
      final initialProtein = container.read(nutritionProvider).totalProtein;

      // 1. Valid meal addition
      final newMeal = NutritionMeal(
        id: 'test-meal-1',
        name: 'Whey Isolate Shake',
        servingSize: '1 scoop (30g)',
        calories: 120,
        proteinGrams: 27,
        carbsGrams: 1,
        fatsGrams: 1,
        category: MealCategory.snacks,
      );

      final success = notifier.addMeal(newMeal);
      expect(success, true);

      final updatedState = container.read(nutritionProvider);
      expect(updatedState.totalCalories, initialCalories + 120);
      expect(updatedState.totalProtein, initialProtein + 27);
      expect(updatedState.getMealsFor(MealCategory.snacks).any((m) => m.id == 'test-meal-1'), true);

      // 2. Reject negative numbers
      final invalidMeal = NutritionMeal(
        id: 'test-meal-invalid',
        name: 'Invalid Meal',
        servingSize: '100g',
        calories: -50,
        proteinGrams: 10,
        carbsGrams: 5,
        fatsGrams: 2,
        category: MealCategory.lunch,
      );

      final rejected = notifier.addMeal(invalidMeal);
      expect(rejected, false);
      expect(container.read(nutritionProvider).totalCalories, initialCalories + 120);
    });

    test('removeMeal decreases macro totals automatically', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final notifier = container.read(nutritionProvider.notifier);
      final mealToRemove = container.read(nutritionProvider).meals.first;
      final initialCalories = container.read(nutritionProvider).totalCalories;

      notifier.removeMeal(mealToRemove.id);

      final state = container.read(nutritionProvider);
      expect(state.totalCalories, initialCalories - mealToRemove.calories);
      expect(state.meals.any((m) => m.id == mealToRemove.id), false);
    });

    test('water increments and decrements accurately and clamps to non-negative', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final notifier = container.read(nutritionProvider.notifier);
      expect(container.read(nutritionProvider).waterLiters, 3.25);

      // Increment +250ml
      notifier.incrementWater(amount: 0.25);
      expect(container.read(nutritionProvider).waterLiters, 3.50);

      // Decrement -250ml
      notifier.decrementWater(amount: 0.25);
      expect(container.read(nutritionProvider).waterLiters, 3.25);

      // Decrement down to 0 clamp
      for (int i = 0; i < 20; i++) {
        notifier.decrementWater(amount: 0.5);
      }
      expect(container.read(nutritionProvider).waterLiters, 0.0);
    });

    test('clearAllMeals presents zeroed macros and empty meal lists', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final notifier = container.read(nutritionProvider.notifier);
      notifier.clearAllMeals();

      final state = container.read(nutritionProvider);
      expect(state.meals.isEmpty, true);
      expect(state.totalCalories, 0);
      expect(state.totalProtein, 0);
      expect(state.totalCarbs, 0);
      expect(state.totalFats, 0);
      expect(state.completedCategoriesCount, 0);
    });
  });

  group('DietTrackerScreen Widget & Integration Tests', () {
    testWidgets('Renders fuel card, macro bars, and seeded meals labeled as demo',
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
            home: DietTrackerScreen(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Top title
      expect(find.text('Diet & Hydration'), findsOneWidget);

      // Category cards
      expect(find.text('Breakfast'), findsOneWidget);
      expect(find.text('Lunch'), findsOneWidget);
      expect(find.text('Evening Snacks'), findsOneWidget);
      expect(find.text('Dinner'), findsOneWidget);

      // Seeded sample items labeled as DEMO
      expect(find.text('DEMO'), findsWidgets);

      // Hydration buttons
      expect(find.byKey(const Key('water_increment_button')), findsOneWidget);
      expect(find.byKey(const Key('water_decrement_button')), findsOneWidget);
    });

    testWidgets('Water tracker increments and decrements via UI buttons',
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
            home: DietTrackerScreen(),
          ),
        ),
      );

      await tester.pumpAndSettle();
      expect(find.text('3.25L / 4.0L'), findsOneWidget);

      // Tap + 250ml
      await tester.tap(find.byKey(const Key('water_increment_button')));
      await tester.pumpAndSettle();

      expect(find.text('3.50L / 4.0L'), findsOneWidget);
      expect(container.read(nutritionProvider).waterLiters, 3.50);

      // Tap - 250ml
      await tester.tap(find.byKey(const Key('water_decrement_button')));
      await tester.pumpAndSettle();

      expect(find.text('3.25L / 4.0L'), findsOneWidget);
      expect(container.read(nutritionProvider).waterLiters, 3.25);
    });

    testWidgets('Add Meal sheet validates required and non-negative fields',
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
            home: DietTrackerScreen(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Open Add Meal sheet for Breakfast
      await tester.tap(find.byKey(const Key('add_food_button_breakfast')));
      await tester.pumpAndSettle();

      expect(find.byKey(const Key('add_meal_sheet')), findsOneWidget);

      // Leave fields empty and tap Log Meal
      await tester.tap(find.byKey(const Key('add_meal_save_button')));
      await tester.pumpAndSettle();

      // Verification errors
      expect(find.text('Meal name is required'), findsOneWidget);
      expect(find.text('Required'), findsWidgets);

      // Sheet stays open
      expect(find.byKey(const Key('add_meal_sheet')), findsOneWidget);
    });

    testWidgets('Adding a meal updates meal card and macro totals automatically',
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
            home: DietTrackerScreen(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      final initialCalories = container.read(nutritionProvider).totalCalories;

      // Open Add Meal sheet for Dinner
      await tester.tap(find.byKey(const Key('add_food_button_dinner')));
      await tester.pumpAndSettle();

      // Enter details
      await tester.enterText(
          find.byKey(const Key('add_meal_name_field')), 'Tofu & Broccoli Stir Fry');
      await tester.enterText(
          find.byKey(const Key('add_meal_serving_field')), '1 bowl (220g)');
      await tester.enterText(
          find.byKey(const Key('add_meal_calories_field')), '310');
      await tester.enterText(
          find.byKey(const Key('add_meal_protein_field')), '24');
      await tester.enterText(
          find.byKey(const Key('add_meal_carbs_field')), '18');
      await tester.enterText(
          find.byKey(const Key('add_meal_fats_field')), '14');

      // Tap Log Meal
      await tester.tap(find.byKey(const Key('add_meal_save_button')));
      await tester.pumpAndSettle();

      // Sheet closes
      expect(find.byKey(const Key('add_meal_sheet')), findsNothing);

      // New meal appears in Dinner section
      expect(find.text('Tofu & Broccoli Stir Fry'), findsOneWidget);
      expect(find.text('310 kcal'), findsOneWidget);

      // Macro totals updated
      expect(container.read(nutritionProvider).totalCalories, initialCalories + 310);
    });

    testWidgets('Removing a meal updates macro totals immediately',
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
            home: DietTrackerScreen(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      final initialCalories = container.read(nutritionProvider).totalCalories;

      // Tap delete on demo-meal-1
      await tester.tap(find.byKey(const Key('remove_meal_demo-meal-1')));
      await tester.pumpAndSettle();

      // 280 calories removed
      expect(container.read(nutritionProvider).totalCalories, initialCalories - 280);
      expect(find.text('3x Steamed Oats & Moong Idli'), findsNothing);
    });

    testWidgets('Empty state is rendered when category has no meals',
        (WidgetTester tester) async {
      tester.view.physicalSize = const Size(800, 2400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      final container = ProviderContainer();
      addTearDown(container.dispose);

      // Initial state has no dinner meals
      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: const MaterialApp(
            home: DietTrackerScreen(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Dinner starts pending with suggestion card and Log Dinner Meal button
      expect(find.text('LOG DINNER MEAL'), findsOneWidget);

      // Now clear all meals from provider
      container.read(nutritionProvider.notifier).clearAllMeals();
      await tester.pumpAndSettle();

      // Empty states appear for categories
      expect(find.text('No meals logged yet for Breakfast'), findsOneWidget);
      expect(find.text('No meals logged yet for Lunch'), findsOneWidget);
      expect(find.text('No meals logged yet for Evening Snacks'), findsOneWidget);
    });

    testWidgets('Nutrition data persists across navigation in current app session',
        (WidgetTester tester) async {
      tester.view.physicalSize = const Size(800, 2400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      final container = ProviderContainer();
      addTearDown(container.dispose);

      // Log a custom meal in DietTrackerScreen
      container.read(nutritionProvider.notifier).addMeal(
            NutritionMeal(
              id: 'persisted-snack-1',
              name: 'Peanut Butter Energy Bar',
              servingSize: '1 bar (60g)',
              calories: 250,
              proteinGrams: 15,
              carbsGrams: 28,
              fatsGrams: 9,
              category: MealCategory.snacks,
            ),
          );
      container.read(nutritionProvider.notifier).incrementWater(amount: 0.50);

      // Navigate to ProfileScreen
      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: const MaterialApp(
            home: ProfileScreen(),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Navigate back to DietTrackerScreen
      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: const MaterialApp(
            home: DietTrackerScreen(),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Verify custom meal and updated water persisted in session
      expect(find.text('Peanut Butter Energy Bar'), findsOneWidget);
      expect(find.text('3.75L / 4.0L'), findsOneWidget);
    });
  });
}
