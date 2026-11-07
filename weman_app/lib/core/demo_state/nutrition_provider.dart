import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Supported meal categories for daily nutrition tracking.
enum MealCategory {
  breakfast('Breakfast'),
  lunch('Lunch'),
  snacks('Evening Snacks'),
  dinner('Dinner');

  final String displayName;
  const MealCategory(this.displayName);
}

/// Individual recorded or seeded meal item.
class NutritionMeal {
  final String id;
  final String name;
  final String servingSize;
  final int calories;
  final int proteinGrams;
  final int carbsGrams;
  final int fatsGrams;
  final MealCategory category;
  final bool isDemo;
  final DateTime loggedAt;
  final String? sub;

  NutritionMeal({
    required this.id,
    required this.name,
    required this.servingSize,
    required this.calories,
    required this.proteinGrams,
    required this.carbsGrams,
    required this.fatsGrams,
    required this.category,
    this.isDemo = false,
    DateTime? loggedAt,
    this.sub,
  }) : loggedAt = loggedAt ?? DateTime.now();

  NutritionMeal copyWith({
    String? id,
    String? name,
    String? servingSize,
    int? calories,
    int? proteinGrams,
    int? carbsGrams,
    int? fatsGrams,
    MealCategory? category,
    bool? isDemo,
    DateTime? loggedAt,
    String? sub,
  }) {
    return NutritionMeal(
      id: id ?? this.id,
      name: name ?? this.name,
      servingSize: servingSize ?? this.servingSize,
      calories: calories ?? this.calories,
      proteinGrams: proteinGrams ?? this.proteinGrams,
      carbsGrams: carbsGrams ?? this.carbsGrams,
      fatsGrams: fatsGrams ?? this.fatsGrams,
      category: category ?? this.category,
      isDemo: isDemo ?? this.isDemo,
      loggedAt: loggedAt ?? this.loggedAt,
      sub: sub ?? this.sub,
    );
  }
}

/// State representation for daily nutrition, macros, and hydration.
class NutritionState {
  final List<NutritionMeal> meals;
  final double waterLiters;
  final double waterTargetLiters;
  final int dailyCalorieTarget;
  final int proteinTargetGrams;
  final int carbsTargetGrams;
  final int fatsTargetGrams;
  final int fiberTargetGrams;

  const NutritionState({
    required this.meals,
    this.waterLiters = 3.25,
    this.waterTargetLiters = 4.0,
    this.dailyCalorieTarget = 2100,
    this.proteinTargetGrams = 155,
    this.carbsTargetGrams = 220,
    this.fatsTargetGrams = 55,
    this.fiberTargetGrams = 35,
  });

  /// Total calories from all logged meals.
  int get totalCalories => meals.fold(0, (sum, m) => sum + m.calories);

  /// Total protein (grams) from all logged meals.
  int get totalProtein => meals.fold(0, (sum, m) => sum + m.proteinGrams);

  /// Total carbohydrates (grams) from all logged meals.
  int get totalCarbs => meals.fold(0, (sum, m) => sum + m.carbsGrams);

  /// Total healthy fats (grams) from all logged meals.
  int get totalFats => meals.fold(0, (sum, m) => sum + m.fatsGrams);

  /// Estimated fiber based on meal contents.
  int get totalFiber {
    // Demo estimate proportion: ~1g fiber per 7g carbs or baseline 28g
    if (meals.isEmpty) return 0;
    final calculated = (totalCarbs / 7).round();
    return calculated < 5 ? 5 : calculated;
  }

  /// Calorie progress ratio [0.0 - 1.5]
  double get calorieProgress {
    if (dailyCalorieTarget <= 0) return 0.0;
    return (totalCalories / dailyCalorieTarget).clamp(0.0, 1.5);
  }

  /// Protein progress ratio [0.0 - 1.5]
  double get proteinProgress {
    if (proteinTargetGrams <= 0) return 0.0;
    return (totalProtein / proteinTargetGrams).clamp(0.0, 1.5);
  }

  /// Carbs progress ratio [0.0 - 1.5]
  double get carbsProgress {
    if (carbsTargetGrams <= 0) return 0.0;
    return (totalCarbs / carbsTargetGrams).clamp(0.0, 1.5);
  }

  /// Fats progress ratio [0.0 - 1.5]
  double get fatsProgress {
    if (fatsTargetGrams <= 0) return 0.0;
    return (totalFats / fatsTargetGrams).clamp(0.0, 1.5);
  }

  /// Water progress ratio [0.0 - 1.5]
  double get waterProgress {
    if (waterTargetLiters <= 0) return 0.0;
    return (waterLiters / waterTargetLiters).clamp(0.0, 1.5);
  }

  /// Retrieves all meals logged under a specific meal category.
  List<NutritionMeal> getMealsFor(MealCategory category) {
    return meals.where((m) => m.category == category).toList();
  }

  /// Total calories in a specific category.
  int getCaloriesFor(MealCategory category) {
    return getMealsFor(category).fold(0, (sum, m) => sum + m.calories);
  }

  /// Total protein in a specific category.
  int getProteinFor(MealCategory category) {
    return getMealsFor(category).fold(0, (sum, m) => sum + m.proteinGrams);
  }

  /// Number of meal categories that have at least one meal logged (0 - 4).
  int get completedCategoriesCount {
    int count = 0;
    for (final cat in MealCategory.values) {
      if (meals.any((m) => m.category == cat)) {
        count++;
      }
    }
    return count;
  }

  /// Checks if a category has at least one meal.
  bool isCategoryLogged(MealCategory category) {
    return meals.any((m) => m.category == category);
  }

  NutritionState copyWith({
    List<NutritionMeal>? meals,
    double? waterLiters,
    double? waterTargetLiters,
    int? dailyCalorieTarget,
    int? proteinTargetGrams,
    int? carbsTargetGrams,
    int? fatsTargetGrams,
    int? fiberTargetGrams,
  }) {
    return NutritionState(
      meals: meals ?? this.meals,
      waterLiters: waterLiters ?? this.waterLiters,
      waterTargetLiters: waterTargetLiters ?? this.waterTargetLiters,
      dailyCalorieTarget: dailyCalorieTarget ?? this.dailyCalorieTarget,
      proteinTargetGrams: proteinTargetGrams ?? this.proteinTargetGrams,
      carbsTargetGrams: carbsTargetGrams ?? this.carbsTargetGrams,
      fatsTargetGrams: fatsTargetGrams ?? this.fatsTargetGrams,
      fiberTargetGrams: fiberTargetGrams ?? this.fiberTargetGrams,
    );
  }
}

/// Initial seeded demo meals labeled as demo data.
final List<NutritionMeal> _initialDemoMeals = [
  NutritionMeal(
    id: 'demo-meal-1',
    name: '3x Steamed Oats & Moong Idli',
    servingSize: '3 idlis (180g)',
    calories: 280,
    proteinGrams: 14,
    carbsGrams: 42,
    fatsGrams: 4,
    category: MealCategory.breakfast,
    isDemo: true,
    sub: 'South Indian Fiber Blend • 14g P',
  ),
  NutritionMeal(
    id: 'demo-meal-2',
    name: '100g Paneer Bhurji with greens',
    servingSize: '100g',
    calories: 200,
    proteinGrams: 18,
    carbsGrams: 6,
    fatsGrams: 12,
    category: MealCategory.breakfast,
    isDemo: true,
    sub: 'Slow Release Casein • 18g P',
  ),
  NutritionMeal(
    id: 'demo-meal-3',
    name: '1.5 cups Brown Basmati + Tadka Dal',
    servingSize: '1.5 cups (250g)',
    calories: 360,
    proteinGrams: 11,
    carbsGrams: 68,
    fatsGrams: 6,
    category: MealCategory.lunch,
    isDemo: true,
    sub: 'Complex Carb fuel for bench & squat • 11g P',
  ),
  NutritionMeal(
    id: 'demo-meal-4',
    name: '150g Grilled Herb Chicken Breast',
    servingSize: '150g',
    calories: 260,
    proteinGrams: 42,
    carbsGrams: 2,
    fatsGrams: 6,
    category: MealCategory.lunch,
    isDemo: true,
    sub: 'High Leucine Protein Core • 42g P',
  ),
  NutritionMeal(
    id: 'demo-meal-5',
    name: 'Fresh Cucumber, Tomato & Sprouts',
    servingSize: '1 bowl (120g)',
    calories: 90,
    proteinGrams: 5,
    carbsGrams: 14,
    fatsGrams: 1,
    category: MealCategory.lunch,
    isDemo: true,
    sub: 'Electrolytes & Raw Enzymes • 5g P',
  ),
  NutritionMeal(
    id: 'demo-meal-6',
    name: 'Roasted Chana & Handful Almonds',
    servingSize: '50g',
    calories: 190,
    proteinGrams: 7,
    carbsGrams: 18,
    fatsGrams: 10,
    category: MealCategory.snacks,
    isDemo: true,
    sub: 'Roasted Micronutrients & Magnesium • 7g P',
  ),
  NutritionMeal(
    id: 'demo-meal-7',
    name: 'Whey Protein Shake / Sattu Elixir',
    servingSize: '1 scoop (30g) + water',
    calories: 140,
    proteinGrams: 24,
    carbsGrams: 4,
    fatsGrams: 2,
    category: MealCategory.snacks,
    isDemo: true,
    sub: 'Rapid Absorption Fuel • 24g P',
  ),
];

/// StateNotifier that manages in-session meals and hydration.
class NutritionNotifier extends StateNotifier<NutritionState> {
  NutritionNotifier() : super(NutritionState(meals: _initialDemoMeals));

  /// Logs a new meal with validation.
  ///
  /// Rejects negative values for macros.
  bool addMeal(NutritionMeal meal) {
    if (meal.calories < 0 ||
        meal.proteinGrams < 0 ||
        meal.carbsGrams < 0 ||
        meal.fatsGrams < 0) {
      return false;
    }

    state = state.copyWith(
      meals: [...state.meals, meal],
    );
    return true;
  }

  /// Removes a meal by its unique ID.
  void removeMeal(String mealId) {
    state = state.copyWith(
      meals: state.meals.where((m) => m.id != mealId).toList(),
    );
  }

  /// Toggles/logs a quick default dinner meal if none exists, or clears dinner meals.
  void toggleQuickDinner() {
    final dinnerMeals = state.getMealsFor(MealCategory.dinner);
    if (dinnerMeals.isEmpty) {
      final quickDinner = NutritionMeal(
        id: 'dinner-${DateTime.now().millisecondsSinceEpoch}',
        name: 'Grilled Paneer Tikka + Mixed Greens & Soup',
        servingSize: '1 plate (280g)',
        calories: 580,
        proteinGrams: 47,
        carbsGrams: 32,
        fatsGrams: 18,
        category: MealCategory.dinner,
        sub: 'Nighttime Casein & Electrolytes • 47g P',
      );
      addMeal(quickDinner);
    } else {
      state = state.copyWith(
        meals: state.meals
            .where((m) => m.category != MealCategory.dinner)
            .toList(),
      );
    }
  }

  /// Increments water by [amount] (default 0.25L / 250ml).
  void incrementWater({double amount = 0.25}) {
    final newAmount =
        (state.waterLiters + amount).clamp(0.0, state.waterTargetLiters + 2.0);
    // Round to 2 decimals to avoid floating point imprecision
    final rounded = double.parse(newAmount.toStringAsFixed(2));
    state = state.copyWith(waterLiters: rounded);
  }

  /// Decrements water by [amount] (default 0.25L / 250ml).
  void decrementWater({double amount = 0.25}) {
    final newAmount =
        (state.waterLiters - amount).clamp(0.0, state.waterTargetLiters + 2.0);
    final rounded = double.parse(newAmount.toStringAsFixed(2));
    state = state.copyWith(waterLiters: rounded);
  }

  /// Clears all meals (for testing empty states).
  void clearAllMeals() {
    state = state.copyWith(meals: []);
  }

  /// Resets back to demo baseline.
  void resetToDemo() {
    state = NutritionState(meals: _initialDemoMeals);
  }
}

/// Shared global Riverpod provider for diet and hydration state.
final nutritionProvider =
    StateNotifierProvider<NutritionNotifier, NutritionState>((ref) {
  return NutritionNotifier();
});
