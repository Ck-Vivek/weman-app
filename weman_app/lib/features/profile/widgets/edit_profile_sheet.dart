import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/demo_state/demo_state.dart';
import '../../../core/theme/weman_colors.dart';
import '../../../core/theme/weman_typography.dart';

/// Modal bottom sheet for editing athlete profile details.
class EditProfileSheet extends ConsumerStatefulWidget {
  const EditProfileSheet({super.key});

  @override
  ConsumerState<EditProfileSheet> createState() => _EditProfileSheetState();
}

class _EditProfileSheetState extends ConsumerState<EditProfileSheet> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _nameController;
  late final TextEditingController _handleController;
  late final TextEditingController _bioController;
  late final TextEditingController _goalController;

  static const List<String> _suggestedGoals = [
    'Hypertrophy & Strength PRs',
    'Lean Muscle & Conditioning',
    'Powerlifting & Heavy Compound',
    'Endurance & Athletic Mobility',
  ];

  @override
  void initState() {
    super.initState();
    final profile = ref.read(userProfileProvider);
    _nameController = TextEditingController(text: profile.name);
    _handleController = TextEditingController(text: profile.handle);
    _bioController = TextEditingController(text: profile.bio);
    _goalController = TextEditingController(text: profile.fitnessGoal);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _handleController.dispose();
    _bioController.dispose();
    _goalController.dispose();
    super.dispose();
  }

  void _saveProfile() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    ref.read(userProfileProvider.notifier).updateProfile(
          name: _nameController.text,
          handle: _handleController.text,
          bio: _bioController.text,
          fitnessGoal: _goalController.text,
        );

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
            Text(
              'Profile updated successfully! ⚡',
              style: WemanTypography.bodyMedium.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
        backgroundColor: WemanColors.deepMoss,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      key: const Key('edit_profile_sheet'),
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
                // Top drag pill
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
                            Icons.manage_accounts_rounded,
                            size: 18,
                            color: WemanColors.onPrimaryContainer,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'EDIT ATHLETE PROFILE',
                              style: WemanTypography.labelSmall.copyWith(
                                fontWeight: FontWeight.w900,
                                letterSpacing: 0.8,
                                color: WemanColors.primary,
                              ),
                            ),
                            Text(
                              'Update your public fitness identity',
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
                const SizedBox(height: 20),

                // Display Name Field
                _buildFieldLabel('DISPLAY NAME'),
                const SizedBox(height: 6),
                TextFormField(
                  key: const Key('edit_profile_name_field'),
                  controller: _nameController,
                  style: WemanTypography.bodyMedium.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                  decoration: _buildInputDecoration(
                    hintText: 'Enter your full name or athlete moniker',
                    prefixIcon: const Icon(
                      Icons.badge_outlined,
                      size: 20,
                      color: WemanColors.secondary,
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Display name is required';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Username / Handle Field
                _buildFieldLabel('ATHLETE HANDLE / USERNAME'),
                const SizedBox(height: 6),
                TextFormField(
                  key: const Key('edit_profile_handle_field'),
                  controller: _handleController,
                  style: WemanTypography.bodyMedium.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                  decoration: _buildInputDecoration(
                    hintText: '@handle',
                    prefixIcon: const Icon(
                      Icons.alternate_email_rounded,
                      size: 20,
                      color: WemanColors.secondary,
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Username/handle is required';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Bio Field
                _buildFieldLabel('ATHLETE BIO'),
                const SizedBox(height: 6),
                TextFormField(
                  key: const Key('edit_profile_bio_field'),
                  controller: _bioController,
                  maxLines: 3,
                  style: WemanTypography.bodyMedium,
                  decoration: _buildInputDecoration(
                    hintText: 'Share your fitness ethos, PR targets, or motto',
                    prefixIcon: const Padding(
                      padding: EdgeInsets.only(bottom: 36),
                      child: Icon(
                        Icons.notes_rounded,
                        size: 20,
                        color: WemanColors.secondary,
                      ),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Bio is required';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Primary Fitness Goal Field
                _buildFieldLabel('PRIMARY FITNESS GOAL'),
                const SizedBox(height: 6),
                TextFormField(
                  key: const Key('edit_profile_goal_field'),
                  controller: _goalController,
                  style: WemanTypography.bodyMedium.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                  decoration: _buildInputDecoration(
                    hintText: 'e.g. Hypertrophy & Strength PRs',
                    prefixIcon: const Icon(
                      Icons.fitness_center_rounded,
                      size: 20,
                      color: WemanColors.secondary,
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Fitness goal is required';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 8),

                // Goal Quick Chips
                Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  children: _suggestedGoals.map((goal) {
                    return InkWell(
                      borderRadius: BorderRadius.circular(20),
                      onTap: () {
                        setState(() {
                          _goalController.text = goal;
                        });
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 5,
                        ),
                        decoration: BoxDecoration(
                          color: _goalController.text == goal
                              ? WemanColors.softLime
                              : WemanColors.surfaceContainerLow,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: _goalController.text == goal
                                ? WemanColors.primary
                                : WemanColors.surfaceContainerHigh,
                          ),
                        ),
                        child: Text(
                          goal,
                          style: WemanTypography.labelSmall.copyWith(
                            fontSize: 10,
                            fontWeight: _goalController.text == goal
                                ? FontWeight.w800
                                : FontWeight.w600,
                            color: _goalController.text == goal
                                ? WemanColors.onPrimaryContainer
                                : WemanColors.textMuted,
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 24),

                // Actions: Cancel & Save Changes
                Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: OutlinedButton(
                        key: const Key('edit_profile_cancel_button'),
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
                        key: const Key('edit_profile_save_button'),
                        onPressed: _saveProfile,
                        icon: const Icon(
                          Icons.check_rounded,
                          size: 18,
                          color: WemanColors.onPrimaryContainer,
                        ),
                        label: Text(
                          'Save Changes',
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
