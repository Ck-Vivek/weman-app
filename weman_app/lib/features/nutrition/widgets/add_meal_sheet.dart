import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/demo_state/demo_state.dart';
import '../../../core/theme/weman_colors.dart';
import '../../../core/theme/weman_typography.dart';

/// Modal bottom sheet to log a new meal under a category.
class AddMealSheet extends ConsumerStatefulWidget {
  final MealCategory initialCategory;

  const AddMealSheet({
    super.key,
    this.initialCategory = MealCategory.breakfast,
  });

  @override
  ConsumerState<AddMealSheet> createState() => _AddMealSheetState();
}

class _AddMealSheetState extends ConsumerState<AddMealSheet> {
  final _formKey = GlobalKey<FormState>();

  late MealCategory _selectedCategory;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _servingController =
      TextEditingController(text: '1 serving');
  final TextEditingController _caloriesController = TextEditingController();
  final TextEditingController _proteinController = TextEditingController();
  final TextEditingController _carbsController = TextEditingController();
  final TextEditingController _fatsController = TextEditingController();

  static final List<Map<String, dynamic>> _quickPresets = [
    {
      'name': '3x Boiled Eggs & Toast',
      'serving': '3 eggs + 2 slices',
      'cal': 290,
      'p': 20,
      'c': 26,
      'f': 11,
      'cat': MealCategory.breakfast,
    },
    {
      'name': 'Grilled Chicken & Brown Rice',
      'serving': '1 bowl (300g)',
      'cal': 480,
      'p': 44,
      'c': 52,
      'f': 8,
      'cat': MealCategory.lunch,
    },
    {
      'name': 'Whey Protein Shake',
      'serving': '1 scoop (32g)',
      'cal': 130,
      'p': 26,
      'c': 2,
      'f': 1,
      'cat': MealCategory.snacks,
    },
    {
      'name': 'Spiced Paneer Bowl with Veggies',
      'serving': '1 plate (250g)',
      'cal': 360,
      'p': 22,
      'c': 12,
      'f': 24,
      'cat': MealCategory.dinner,
    },
  ];

  @override
  void initState() {
    super.initState();
    _selectedCategory = widget.initialCategory;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _servingController.dispose();
    _caloriesController.dispose();
    _proteinController.dispose();
    _carbsController.dispose();
    _fatsController.dispose();
    super.dispose();
  }

  void _applyPreset(Map<String, dynamic> preset) {
    setState(() {
      _selectedCategory = preset['cat'] as MealCategory;
      _nameController.text = preset['name'] as String;
      _servingController.text = preset['serving'] as String;
      _caloriesController.text = (preset['cal'] as int).toString();
      _proteinController.text = (preset['p'] as int).toString();
      _carbsController.text = (preset['c'] as int).toString();
      _fatsController.text = (preset['f'] as int).toString();
    });
  }

  void _saveMeal() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final calories = int.parse(_caloriesController.text.trim());
    final protein = int.parse(_proteinController.text.trim());
    final carbs = int.parse(_carbsController.text.trim());
    final fats = int.parse(_fatsController.text.trim());

    final newMeal = NutritionMeal(
      id: 'meal-${DateTime.now().millisecondsSinceEpoch}',
      name: _nameController.text.trim(),
      servingSize: _servingController.text.trim(),
      calories: calories,
      proteinGrams: protein,
      carbsGrams: carbs,
      fatsGrams: fats,
      category: _selectedCategory,
      isDemo: false,
      sub: '${_servingController.text.trim()} • ${protein}g P • ${carbs}g C • ${fats}g F',
    );

    final success = ref.read(nutritionProvider.notifier).addMeal(newMeal);

    if (success) {
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(
                Icons.check_circle_rounded,
                color: WemanColors.neonLime,
                size: 20,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Added to ${_selectedCategory.displayName}! ($calories kcal, ${protein}g P)',
                  style: WemanTypography.bodyMedium.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
          backgroundColor: WemanColors.deepMoss,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      key: const Key('add_meal_sheet'),
      decoration: const BoxDecoration(
        color: WemanColors.cardBg,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom + 20,
      ),
      child: SafeArea(
        top: false,
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Drag handle pill
                Center(
                  child: Container(
                    width: 36,
                    height: 4,
                    margin: const EdgeInsets.only(bottom: 16),
                    decoration: BoxDecoration(
                      color: WemanColors.surfaceContainerHigh,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),

                // Sheet Header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 32,
                          height: 32,
                          decoration: BoxDecoration(
                            color: WemanColors.softLime,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(
                            Icons.restaurant_rounded,
                            size: 18,
                            color: WemanColors.onPrimaryContainer,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'LOG ATHLETE MEAL',
                              style: WemanTypography.labelSmall.copyWith(
                                fontWeight: FontWeight.w900,
                                letterSpacing: 0.8,
                                color: WemanColors.primary,
                              ),
                            ),
                            Text(
                              'Track macros & calories accurately',
                              style: WemanTypography.bodySmall.copyWith(
                                color: WemanColors.textMuted,
                                fontSize: 11,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    IconButton(
                      icon: const Icon(Icons.close_rounded,
                          color: WemanColors.textMuted),
                      onPressed: () => Navigator.of(context).pop(),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                  ],
                ),
                const SizedBox(height: 18),

                // Meal Category Selector
                _buildFieldLabel('MEAL SESSION'),
                const SizedBox(height: 6),
                Wrap(
                  spacing: 6,
                  children: MealCategory.values.map((cat) {
                    final isSelected = _selectedCategory == cat;
                    return ChoiceChip(
                      key: Key('meal_category_chip_${cat.name}'),
                      label: Text(
                        cat.displayName,
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight:
                              isSelected ? FontWeight.w800 : FontWeight.w600,
                          color: isSelected
                              ? WemanColors.onPrimaryContainer
                              : WemanColors.onSurface,
                        ),
                      ),
                      selected: isSelected,
                      selectedColor: WemanColors.neonLime,
                      backgroundColor: WemanColors.surfaceContainerLow,
                      side: BorderSide(
                        color: isSelected
                            ? WemanColors.neonLime
                            : WemanColors.surfaceContainerHigh,
                      ),
                      onSelected: (selected) {
                        if (selected) {
                          setState(() => _selectedCategory = cat);
                        }
                      },
                    );
                  }).toList(),
                ),
                const SizedBox(height: 14),

                // Quick Presets
                _buildFieldLabel('QUICK ATHLETE PRESETS'),
                const SizedBox(height: 6),
                Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  children: _quickPresets.map((preset) {
                    return InkWell(
                      borderRadius: BorderRadius.circular(16),
                      onTap: () => _applyPreset(preset),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: WemanColors.surfaceContainerLow,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                              color: WemanColors.surfaceContainerHigh),
                        ),
                        child: Text(
                          '+ ${preset['name']}',
                          style: WemanTypography.labelSmall.copyWith(
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                            color: WemanColors.primary,
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 16),

                // Meal Name
                _buildFieldLabel('MEAL NAME *'),
                const SizedBox(height: 6),
                TextFormField(
                  key: const Key('add_meal_name_field'),
                  controller: _nameController,
                  style: WemanTypography.bodyMedium.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                  decoration: _buildInputDecoration(
                    hintText: 'e.g. Grilled Chicken & Basmati Rice',
                    prefixIcon: const Icon(Icons.fastfood_outlined,
                        size: 18, color: WemanColors.secondary),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Meal name is required';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 14),

                // Serving Size
                _buildFieldLabel('SERVING SIZE *'),
                const SizedBox(height: 6),
                TextFormField(
                  key: const Key('add_meal_serving_field'),
                  controller: _servingController,
                  style: WemanTypography.bodyMedium,
                  decoration: _buildInputDecoration(
                    hintText: 'e.g. 1 plate (250g) / 2 scoops',
                    prefixIcon: const Icon(Icons.straighten,
                        size: 18, color: WemanColors.secondary),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Serving size is required';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 14),

                // Macros row: Calories & Protein
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildFieldLabel('CALORIES (KCAL) *'),
                          const SizedBox(height: 6),
                          TextFormField(
                            key: const Key('add_meal_calories_field'),
                            controller: _caloriesController,
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly
                            ],
                            style: WemanTypography.bodyMedium.copyWith(
                              fontWeight: FontWeight.w700,
                            ),
                            decoration: _buildInputDecoration(
                              hintText: '450',
                              prefixIcon: const Icon(
                                Icons.local_fire_department_rounded,
                                size: 18,
                                color: Colors.orange,
                              ),
                            ),
                            validator: _validateNonNegativeNumber,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildFieldLabel('PROTEIN (G) *'),
                          const SizedBox(height: 6),
                          TextFormField(
                            key: const Key('add_meal_protein_field'),
                            controller: _proteinController,
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly
                            ],
                            style: WemanTypography.bodyMedium.copyWith(
                              fontWeight: FontWeight.w700,
                            ),
                            decoration: _buildInputDecoration(
                              hintText: '35',
                              prefixIcon: const Icon(
                                Icons.fitness_center_rounded,
                                size: 18,
                                color: WemanColors.primary,
                              ),
                            ),
                            validator: _validateNonNegativeNumber,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),

                // Macros row: Carbs & Fats
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildFieldLabel('CARBS (G) *'),
                          const SizedBox(height: 6),
                          TextFormField(
                            key: const Key('add_meal_carbs_field'),
                            controller: _carbsController,
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly
                            ],
                            style: WemanTypography.bodyMedium.copyWith(
                              fontWeight: FontWeight.w700,
                            ),
                            decoration: _buildInputDecoration(
                              hintText: '40',
                              prefixIcon: const Icon(
                                Icons.grain_rounded,
                                size: 18,
                                color: WemanColors.charcoal,
                              ),
                            ),
                            validator: _validateNonNegativeNumber,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildFieldLabel('FATS (G) *'),
                          const SizedBox(height: 6),
                          TextFormField(
                            key: const Key('add_meal_fats_field'),
                            controller: _fatsController,
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly
                            ],
                            style: WemanTypography.bodyMedium.copyWith(
                              fontWeight: FontWeight.w700,
                            ),
                            decoration: _buildInputDecoration(
                              hintText: '12',
                              prefixIcon: const Icon(
                                Icons.opacity_rounded,
                                size: 18,
                                color: Color(0xFF74786E),
                              ),
                            ),
                            validator: _validateNonNegativeNumber,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // Action Buttons
                Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: OutlinedButton(
                        key: const Key('add_meal_cancel_button'),
                        onPressed: () => Navigator.of(context).pop(),
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(
                            color: WemanColors.surfaceContainerHigh,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                        ),
                        child: Text(
                          'Cancel',
                          style: WemanTypography.labelMedium.copyWith(
                            fontWeight: FontWeight.w700,
                            color: WemanColors.textMuted,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      flex: 2,
                      child: ElevatedButton.icon(
                        key: const Key('add_meal_save_button'),
                        onPressed: _saveMeal,
                        icon: const Icon(
                          Icons.add_task_rounded,
                          size: 18,
                          color: WemanColors.onPrimaryContainer,
                        ),
                        label: Text(
                          'Log Meal',
                          style: WemanTypography.labelMedium.copyWith(
                            fontWeight: FontWeight.w900,
                            color: WemanColors.onPrimaryContainer,
                            letterSpacing: 0.5,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: WemanColors.neonLime,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String? _validateNonNegativeNumber(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Required';
    }
    final parsed = int.tryParse(value.trim());
    if (parsed == null || parsed < 0) {
      return 'Must be >= 0';
    }
    return null;
  }

  Widget _buildFieldLabel(String label) {
    return Text(
      label,
      style: WemanTypography.labelSmall.copyWith(
        fontWeight: FontWeight.w800,
        color: WemanColors.secondary,
        fontSize: 10,
        letterSpacing: 0.6,
      ),
    );
  }

  InputDecoration _buildInputDecoration({
    required String hintText,
    required Widget prefixIcon,
  }) {
    return InputDecoration(
      filled: true,
      fillColor: WemanColors.surfaceContainerLow,
      hintText: hintText,
      hintStyle: WemanTypography.bodySmall.copyWith(
        color: WemanColors.textMuted.withValues(alpha: 0.7),
      ),
      prefixIcon: prefixIcon,
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: WemanColors.surfaceContainerHigh),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: WemanColors.surfaceContainerHigh),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: WemanColors.primary, width: 1.5),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: WemanColors.error),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: WemanColors.error, width: 1.5),
      ),
    );
  }
}
