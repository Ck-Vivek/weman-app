import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/demo_state/demo_state.dart';
import '../../core/theme/weman_colors.dart';
import '../../core/theme/weman_typography.dart';
import 'widgets/add_meal_sheet.dart';

class DietTrackerScreen extends ConsumerStatefulWidget {
  const DietTrackerScreen({super.key});

  @override
  ConsumerState<DietTrackerScreen> createState() => _DietTrackerScreenState();
}

class _DietTrackerScreenState extends ConsumerState<DietTrackerScreen> {
  void _openAddMealSheet([MealCategory category = MealCategory.breakfast]) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => AddMealSheet(initialCategory: category),
    );
  }

  void _addWater() {
    ref.read(nutritionProvider.notifier).incrementWater(amount: 0.25);
    final water = ref.read(nutritionProvider).waterLiters;
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('+250ml water added! Total: ${water.toStringAsFixed(2)}L'),
        duration: const Duration(milliseconds: 1500),
      ),
    );
  }

  void _removeWater() {
    ref.read(nutritionProvider.notifier).decrementWater(amount: 0.25);
    final water = ref.read(nutritionProvider).waterLiters;
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content:
            Text('-250ml water removed. Total: ${water.toStringAsFixed(2)}L'),
        duration: const Duration(milliseconds: 1500),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final nutrition = ref.watch(nutritionProvider);

    return Scaffold(
      backgroundColor: WemanColors.surface,
      appBar: AppBar(
        backgroundColor: WemanColors.surface.withValues(alpha: 0.95),
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: WemanColors.onSurface),
          onPressed: () {
            if (Navigator.of(context).canPop()) {
              Navigator.of(context).pop();
            } else {
              context.go('/fitness-hub');
            }
          },
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Diet & Hydration',
              style: TextStyle(
                color: WemanColors.onSurface,
                fontWeight: FontWeight.w700,
                fontSize: 17,
              ),
            ),
            Text(
              'DAILY TARGETS • CALORIC BALANCE',
              style: WemanTypography.labelSmall.copyWith(
                fontSize: 9,
                color: WemanColors.secondary,
                letterSpacing: 0.5,
              ),
            ),
          ],
        ),
        actions: [
          Container(
            margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: WemanColors.surfaceWhite,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: WemanColors.border),
            ),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.calendar_today,
                  size: 13,
                  color: WemanColors.secondary,
                ),
                SizedBox(width: 4),
                Text(
                  'Today, Oct 24',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: WemanColors.onSurface,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Daily Fuel Card
            _buildDailyFuelCard(nutrition),
            const SizedBox(height: 16),

            // Daily Macros & Micros
            _buildMacrosCard(nutrition),
            const SizedBox(height: 20),

            // Meal Timeline Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Meal Timeline',
                  style: WemanTypography.titleMedium.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Text(
                  '${nutrition.completedCategoriesCount} OF 4 LOGGED',
                  style: WemanTypography.labelSmall.copyWith(
                    color: WemanColors.secondary,
                    letterSpacing: 0.5,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // 1. Breakfast
            _buildMealCategoryCard(
              category: MealCategory.breakfast,
              nutrition: nutrition,
            ),
            const SizedBox(height: 12),

            // 2. Lunch
            _buildMealCategoryCard(
              category: MealCategory.lunch,
              nutrition: nutrition,
            ),
            const SizedBox(height: 12),

            // 3. Evening Snacks
            _buildMealCategoryCard(
              category: MealCategory.snacks,
              nutrition: nutrition,
            ),
            const SizedBox(height: 12),

            // 4. Dinner
            _buildDinnerCard(nutrition),
            const SizedBox(height: 20),

            // Nutrition & Hydration Streak
            _buildStreakCard(),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildDailyFuelCard(NutritionState nutrition) {
    final percentMet = (nutrition.calorieProgress * 100).round();
    final isCompleted = nutrition.completedCategoriesCount == 4;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: WemanColors.surfaceWhite,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              // Radial Gauge Left
              Stack(
                alignment: Alignment.center,
                children: [
                  SizedBox(
                    width: 100,
                    height: 100,
                    child: CircularProgressIndicator(
                      value: nutrition.calorieProgress.clamp(0.0, 1.0),
                      strokeWidth: 10,
                      backgroundColor: WemanColors.surfaceContainerHigh,
                      valueColor: const AlwaysStoppedAnimation<Color>(
                        WemanColors.neonLime,
                      ),
                    ),
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        nutrition.totalCalories.toString(),
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w800,
                          color: WemanColors.onSurface,
                        ),
                      ),
                      Text(
                        '/ ${nutrition.dailyCalorieTarget} kcal',
                        style: const TextStyle(
                          fontSize: 10,
                          color: WemanColors.secondary,
                        ),
                      ),
                      Text(
                        '$percentMet% Met',
                        style: const TextStyle(
                          fontSize: 9,
                          fontWeight: FontWeight.w700,
                          color: WemanColors.deepMoss,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(width: 20),

              // Meal Status & Hydration Right
              Expanded(
                child: Column(
                  children: [
                    // Meal Status Tile
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: WemanColors.surface,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              const Icon(
                                Icons.restaurant_menu,
                                size: 18,
                                color: WemanColors.secondary,
                              ),
                              const SizedBox(width: 6),
                              Text(
                                '${nutrition.completedCategoriesCount} of 4 Meals',
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 6,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: isCompleted
                                  ? WemanColors.surfaceContainerHigh
                                  : WemanColors.neonLime,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              isCompleted
                                  ? 'COMPLETED'
                                  : '${4 - nutrition.completedCategoriesCount} LEFT',
                              style: const TextStyle(
                                fontSize: 9,
                                fontWeight: FontWeight.w800,
                                color: WemanColors.onSurface,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 8),

                    // Hydration Tile
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: WemanColors.surface,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              const Icon(
                                Icons.water_drop,
                                size: 18,
                                color: Colors.blueAccent,
                              ),
                              const SizedBox(width: 6),
                              Text(
                                '${nutrition.waterLiters.toStringAsFixed(2)}L / ${nutrition.waterTargetLiters.toStringAsFixed(1)}L',
                                style: const TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              // Decrement water
                              InkWell(
                                key: const Key('water_decrement_button'),
                                onTap: _removeWater,
                                borderRadius: BorderRadius.circular(6),
                                child: Container(
                                  padding: const EdgeInsets.all(3),
                                  decoration: BoxDecoration(
                                    color: WemanColors.surfaceWhite,
                                    borderRadius: BorderRadius.circular(6),
                                    border:
                                        Border.all(color: WemanColors.border),
                                  ),
                                  child: const Icon(
                                    Icons.remove,
                                    size: 14,
                                    color: WemanColors.onSurface,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 4),
                              // Increment water
                              InkWell(
                                key: const Key('water_increment_button'),
                                onTap: _addWater,
                                borderRadius: BorderRadius.circular(6),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 6,
                                    vertical: 3,
                                  ),
                                  decoration: BoxDecoration(
                                    color: WemanColors.surfaceWhite,
                                    borderRadius: BorderRadius.circular(6),
                                    border:
                                        Border.all(color: WemanColors.border),
                                  ),
                                  child: const Text(
                                    '+ 250ml',
                                    style: TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.w700,
                                      color: WemanColors.onSurface,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),

          // Bottom Macro Goal Line
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'MACRO GOAL: ${nutrition.proteinTargetGrams}G PROTEIN',
                style: const TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                  color: WemanColors.secondary,
                ),
              ),
              Text(
                '${(nutrition.proteinProgress * 100).round()}% FULFILLED',
                style: const TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                  color: WemanColors.deepMoss,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: LinearProgressIndicator(
              value: nutrition.proteinProgress.clamp(0.0, 1.0),
              minHeight: 6,
              backgroundColor: WemanColors.surfaceContainerHigh,
              valueColor:
                  const AlwaysStoppedAnimation<Color>(WemanColors.neonLime),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMacrosCard(NutritionState nutrition) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: WemanColors.surfaceWhite,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Daily Macros & Micro',
                style: WemanTypography.titleSmall.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              const Icon(
                Icons.auto_awesome,
                size: 16,
                color: WemanColors.deepMoss,
              ),
            ],
          ),
          Text(
            'Balanced for athletic recovery',
            style: WemanTypography.bodySmall.copyWith(
              color: WemanColors.secondary,
            ),
          ),
          const SizedBox(height: 14),

          // Protein Bar
          _buildMacroRow(
            title: 'Protein',
            tag: 'GROWTH',
            amount:
                '${nutrition.totalProtein}g / ${nutrition.proteinTargetGrams}g (${(nutrition.proteinProgress * 100).round()}%)',
            progress: nutrition.proteinProgress.clamp(0.0, 1.0),
            color: WemanColors.neonLime,
          ),
          const SizedBox(height: 10),

          // Complex Carbs Bar
          _buildMacroRow(
            title: 'Complex Carbs',
            amount:
                '${nutrition.totalCarbs}g / ${nutrition.carbsTargetGrams}g (${(nutrition.carbsProgress * 100).round()}%)',
            progress: nutrition.carbsProgress.clamp(0.0, 1.0),
            color: WemanColors.charcoal,
          ),
          const SizedBox(height: 10),

          // Healthy Fats Bar
          _buildMacroRow(
            title: 'Healthy Fats',
            amount:
                '${nutrition.totalFats}g / ${nutrition.fatsTargetGrams}g (${(nutrition.fatsProgress * 100).round()}%)',
            progress: nutrition.fatsProgress.clamp(0.0, 1.0),
            color: const Color(0xFF74786E),
          ),
          const SizedBox(height: 10),

          // Fiber & Greens
          _buildMacroRow(
            title: 'Fiber & Greens',
            amount:
                '${nutrition.totalFiber}g / ${nutrition.fiberTargetGrams}g (${((nutrition.totalFiber / nutrition.fiberTargetGrams) * 100).round()}%)',
            progress:
                (nutrition.totalFiber / nutrition.fiberTargetGrams).clamp(0.0, 1.0),
            color: const Color(0xFF2E6930),
          ),
          const SizedBox(height: 12),

          // Note
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: WemanColors.surface,
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Row(
              children: [
                Icon(
                  Icons.info_outline,
                  size: 14,
                  color: WemanColors.secondary,
                ),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Seeded sample items labeled as DEMO. Log custom meals to update your daily balance.',
                    style:
                        TextStyle(fontSize: 11, color: WemanColors.secondary),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMacroRow({
    required String title,
    String? tag,
    required String amount,
    required double progress,
    required Color color,
  }) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: WemanColors.onSurface,
                  ),
                ),
                if (tag != null) ...[
                  const SizedBox(width: 6),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 5,
                      vertical: 1,
                    ),
                    decoration: BoxDecoration(
                      color: WemanColors.softLime,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      tag,
                      style: const TextStyle(
                        fontSize: 9,
                        fontWeight: FontWeight.w800,
                        color: WemanColors.onSurface,
                      ),
                    ),
                  ),
                ],
              ],
            ),
            Text(
              amount,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: WemanColors.secondary,
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: progress,
            minHeight: 6,
            backgroundColor: WemanColors.surfaceContainerHigh,
            valueColor: AlwaysStoppedAnimation<Color>(color),
          ),
        ),
      ],
    );
  }

  Widget _buildMealCategoryCard({
    required MealCategory category,
    required NutritionState nutrition,
  }) {
    final meals = nutrition.getMealsFor(category);
    final hasMeals = meals.isNotEmpty;
    final totalCalories = nutrition.getCaloriesFor(category);
    final totalProtein = nutrition.getProteinFor(category);

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: WemanColors.surfaceWhite,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Text(
                    category.displayName,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: WemanColors.onSurface,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 6,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: hasMeals
                          ? WemanColors.surfaceContainerHigh
                          : WemanColors.surfaceContainerLow,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      hasMeals ? 'Logged (${meals.length})' : 'Pending',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        color: hasMeals
                            ? WemanColors.secondary
                            : WemanColors.textMuted,
                      ),
                    ),
                  ),
                ],
              ),
              InkWell(
                key: Key('add_food_button_${category.name}'),
                onTap: () => _openAddMealSheet(category),
                borderRadius: BorderRadius.circular(8),
                child: const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                  child: Row(
                    children: [
                      Icon(Icons.add, size: 14, color: WemanColors.deepMoss),
                      SizedBox(width: 2),
                      Text(
                        'Food',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: WemanColors.deepMoss,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 2),
          Text(
            '$totalCalories kcal • ${totalProtein}g Protein',
            style: const TextStyle(fontSize: 12, color: WemanColors.secondary),
          ),
          const SizedBox(height: 10),

          // Items or Empty State
          if (!hasMeals)
            _buildEmptyCategoryState(category)
          else
            ...meals.map((meal) => _buildMealItemRow(meal)),
        ],
      ),
    );
  }

  Widget _buildEmptyCategoryState(MealCategory category) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
      decoration: BoxDecoration(
        color: WemanColors.surface,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: WemanColors.surfaceContainerHigh),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.no_meals_outlined,
            size: 20,
            color: WemanColors.secondary,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'No meals logged yet for ${category.displayName}',
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: WemanColors.onSurface,
                  ),
                ),
                const Text(
                  'Tap "+ Food" to add meal & calculate macros.',
                  style: TextStyle(fontSize: 10, color: WemanColors.secondary),
                ),
              ],
            ),
          ),
          TextButton(
            key: Key('empty_add_button_${category.name}'),
            onPressed: () => _openAddMealSheet(category),
            style: TextButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              minimumSize: Size.zero,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            child: const Text(
              '+ Add',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w800,
                color: WemanColors.primary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMealItemRow(NutritionMeal meal) {
    IconData icon = Icons.restaurant;
    if (meal.category == MealCategory.breakfast) icon = Icons.grain;
    if (meal.category == MealCategory.snacks) icon = Icons.local_drink;
    if (meal.category == MealCategory.dinner) icon = Icons.soup_kitchen;

    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: WemanColors.surface,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          children: [
            Icon(icon, size: 18, color: WemanColors.secondary),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Row(
                          children: [
                            Flexible(
                              child: Text(
                                meal.name,
                                style: const TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                  color: WemanColors.onSurface,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            if (meal.isDemo) ...[
                              const SizedBox(width: 6),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 4,
                                  vertical: 1,
                                ),
                                decoration: BoxDecoration(
                                  color: WemanColors.surfaceContainerHigh,
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: const Text(
                                  'DEMO',
                                  style: TextStyle(
                                    fontSize: 8,
                                    fontWeight: FontWeight.w800,
                                    color: WemanColors.secondary,
                                  ),
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '${meal.calories} kcal',
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: WemanColors.onSurface,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 2),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          meal.sub ??
                              '${meal.servingSize} • ${meal.proteinGrams}g P • ${meal.carbsGrams}g C • ${meal.fatsGrams}g F',
                          style: const TextStyle(
                            fontSize: 11,
                            color: WemanColors.secondary,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      InkWell(
                        key: Key('remove_meal_${meal.id}'),
                        onTap: () {
                          ref
                              .read(nutritionProvider.notifier)
                              .removeMeal(meal.id);
                          ScaffoldMessenger.of(context).hideCurrentSnackBar();
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Removed ${meal.name}'),
                              duration: const Duration(seconds: 1),
                            ),
                          );
                        },
                        borderRadius: BorderRadius.circular(12),
                        child: const Padding(
                          padding: EdgeInsets.all(2),
                          child: Icon(
                            Icons.delete_outline_rounded,
                            size: 15,
                            color: WemanColors.textMuted,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDinnerCard(NutritionState nutrition) {
    final dinnerMeals = nutrition.getMealsFor(MealCategory.dinner);
    final isDinnerLogged = dinnerMeals.isNotEmpty;
    final totalCalories = nutrition.getCaloriesFor(MealCategory.dinner);
    final totalProtein = nutrition.getProteinFor(MealCategory.dinner);

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: WemanColors.surfaceWhite,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDinnerLogged ? WemanColors.border : WemanColors.neonLime,
          width: 1.5,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Text(
                    'Dinner',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: WemanColors.onSurface,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 6,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: isDinnerLogged
                          ? WemanColors.softLime
                          : WemanColors.surfaceContainerHigh,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      isDinnerLogged
                          ? 'LOGGED (${dinnerMeals.length})'
                          : 'PENDING',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        color: isDinnerLogged
                            ? WemanColors.onSurface
                            : WemanColors.secondary,
                      ),
                    ),
                  ),
                ],
              ),
              InkWell(
                key: const Key('add_food_button_dinner'),
                onTap: () => _openAddMealSheet(MealCategory.dinner),
                borderRadius: BorderRadius.circular(8),
                child: const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                  child: Row(
                    children: [
                      Icon(Icons.add, size: 14, color: WemanColors.deepMoss),
                      SizedBox(width: 2),
                      Text(
                        'Food',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: WemanColors.deepMoss,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 2),
          Text(
            isDinnerLogged
                ? '$totalCalories kcal • ${totalProtein}g Protein'
                : 'Target: 580 kcal • 47g Protein',
            style: const TextStyle(fontSize: 11, color: WemanColors.secondary),
          ),
          const SizedBox(height: 10),

          // Logged dinner items or suggestion container
          if (isDinnerLogged)
            ...dinnerMeals.map((m) => _buildMealItemRow(m))
          else
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: WemanColors.surface,
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Row(
                children: [
                  Icon(
                    Icons.lightbulb_outline,
                    size: 16,
                    color: WemanColors.deepMoss,
                  ),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Suggestion: Light grilled paneer/fish + stir-fried veggies & bowl of soup to complete your daily macros easily.',
                      style:
                          TextStyle(fontSize: 11, color: WemanColors.secondary),
                    ),
                  ),
                ],
              ),
            ),
          const SizedBox(height: 12),

          // Quick Toggle / Log Button
          SizedBox(
            width: double.infinity,
            height: 46,
            child: ElevatedButton(
              key: const Key('quick_dinner_toggle_button'),
              onPressed: () {
                ref.read(nutritionProvider.notifier).toggleQuickDinner();
                final updated = ref.read(nutritionProvider).isCategoryLogged(MealCategory.dinner);
                ScaffoldMessenger.of(context).hideCurrentSnackBar();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      updated
                          ? 'Dinner meal logged! Macros updated.'
                          : 'Dinner meal log reset.',
                    ),
                    backgroundColor: WemanColors.charcoal,
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: isDinnerLogged
                    ? WemanColors.surfaceContainerHigh
                    : WemanColors.neonLime,
                foregroundColor: WemanColors.onSurface,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24),
                ),
                elevation: 0,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    isDinnerLogged ? Icons.check : Icons.add,
                    size: 18,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    isDinnerLogged ? 'DINNER LOGGED' : 'LOG DINNER MEAL',
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 0.5,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStreakCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: WemanColors.surfaceWhite,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.eco, size: 18, color: WemanColors.deepMoss),
              SizedBox(width: 6),
              Text(
                'Nutrition & Hydration Streak',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: WemanColors.onSurface,
                ),
              ),
            ],
          ),
          const Text(
            '7-day overview of logged targets',
            style: TextStyle(fontSize: 11, color: WemanColors.secondary),
          ),
          const SizedBox(height: 14),

          // Day pills
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildDayPill('M', isCompleted: true),
              _buildDayPill('T', isCompleted: true),
              _buildDayPill('W', isCompleted: true),
              _buildDayPill('T', isCompleted: true),
              _buildDayPill('F', isToday: true),
              _buildDayPill('S', isPending: true),
              _buildDayPill('S', isPending: true),
            ],
          ),
          const SizedBox(height: 14),

          // Banner
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: WemanColors.surface,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: const BoxDecoration(
                    color: WemanColors.neonLime,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.bolt,
                    size: 16,
                    color: WemanColors.onSurface,
                  ),
                ),
                const SizedBox(width: 10),
                const Expanded(
                  child: Text(
                    '4 days logged this week! Consistency fuels fast cellular recovery and stable energy.',
                    style: TextStyle(
                      fontSize: 11,
                      color: WemanColors.onSurface,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDayPill(
    String day, {
    bool isCompleted = false,
    bool isToday = false,
    bool isPending = false,
  }) {
    Color bg = WemanColors.surface;
    Color textCol = WemanColors.secondary;
    Widget icon = const SizedBox(height: 14);

    if (isCompleted) {
      bg = WemanColors.surfaceContainerHigh;
      textCol = WemanColors.onSurface;
      icon = const Icon(Icons.check, size: 14, color: WemanColors.deepMoss);
    } else if (isToday) {
      bg = WemanColors.neonLime;
      textCol = WemanColors.onSurface;
      icon = const CircleAvatar(
        radius: 7,
        backgroundImage: AssetImage('assets/images/pavan_avatar.png'),
      );
    } else {
      icon = const Text(
        '—',
        style: TextStyle(fontSize: 12, color: WemanColors.secondary),
      );
    }

    return Container(
      width: 40,
      padding: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Text(
            day,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: textCol,
            ),
          ),
          const SizedBox(height: 4),
          icon,
        ],
      ),
    );
  }
}
