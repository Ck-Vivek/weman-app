import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/weman_colors.dart';
import '../../core/theme/weman_typography.dart';
import '../../core/widgets/weman_button.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _isSignUp = false;
  bool _obscurePassword = true;
  bool _isLoading = false;

  final TextEditingController _emailController =
      TextEditingController(text: 'alex.chen@weman.fit');
  final TextEditingController _passwordController =
      TextEditingController(text: 'WemanPass2026!');
  final TextEditingController _nameController =
      TextEditingController(text: 'Alex Chen');
  final TextEditingController _collegeController =
      TextEditingController(text: 'City Engineering College');

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _nameController.dispose();
    _collegeController.dispose();
    super.dispose();
  }

  void _handleAuth() {
    setState(() {
      _isLoading = true;
    });

    Future.delayed(const Duration(milliseconds: 900), () {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
        context.go('/feed');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: WemanColors.surface,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top Brand Anchor
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        Container(
                          width: 42,
                          height: 42,
                          decoration: BoxDecoration(
                            color: WemanColors.inverseSurface,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.12),
                                blurRadius: 8,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Center(
                            child: Text(
                              'W',
                              style: WemanTypography.headlineMedium.copyWith(
                                color: WemanColors.voltGreen,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Flexible(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'WEMAN FIT',
                                style: WemanTypography.headlineSmall.copyWith(
                                  fontWeight: FontWeight.w900,
                                  letterSpacing: 1.2,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                              Text(
                                'PERFORMANCE LABS',
                                style: WemanTypography.labelSmall.copyWith(
                                  color: WemanColors.textMuted,
                                  letterSpacing: 1.0,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: WemanColors.surfaceContainerLow,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 6,
                          height: 6,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: WemanColors.voltGreen,
                          ),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          'LIVE MESH',
                          style: WemanTypography.labelSmall.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Editorial Header
              Text(
                _isSignUp ? 'Create Athlete Account' : 'Welcome Back',
                style: WemanTypography.displaySmall.copyWith(
                  fontWeight: FontWeight.w800,
                  color: WemanColors.inverseSurface,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                _isSignUp
                    ? 'Join your campus gym squad and start logging workouts.'
                    : 'Log into your athlete account and sync with your crew.',
                style: WemanTypography.bodyMedium.copyWith(
                  color: WemanColors.textMuted,
                ),
              ),
              const SizedBox(height: 20),

              // Segmented Auth Switcher
              Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: WemanColors.surfaceContainer,
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () => setState(() => _isSignUp = false),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          decoration: BoxDecoration(
                            color: !_isSignUp
                                ? WemanColors.cardBg
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(24),
                            boxShadow: !_isSignUp
                                ? [
                                    BoxShadow(
                                      color:
                                          Colors.black.withValues(alpha: 0.06),
                                      blurRadius: 8,
                                    ),
                                  ]
                                : [],
                          ),
                          child: Center(
                            child: Text(
                              'Sign In',
                              style: WemanTypography.labelLarge.copyWith(
                                color: !_isSignUp
                                    ? WemanColors.onSurface
                                    : WemanColors.textMuted,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: GestureDetector(
                        onTap: () => setState(() => _isSignUp = true),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          decoration: BoxDecoration(
                            color: _isSignUp
                                ? WemanColors.cardBg
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(24),
                            boxShadow: _isSignUp
                                ? [
                                    BoxShadow(
                                      color:
                                          Colors.black.withValues(alpha: 0.06),
                                      blurRadius: 8,
                                    ),
                                  ]
                                : [],
                          ),
                          child: Center(
                            child: Text(
                              'Create Account',
                              style: WemanTypography.labelLarge.copyWith(
                                color: _isSignUp
                                    ? WemanColors.onSurface
                                    : WemanColors.textMuted,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Mosaic Context Pill
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: WemanColors.surfaceContainerLow,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: WemanColors.outlineVariant.withValues(alpha: 0.4),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Row(
                        children: [
                          const Icon(
                            Icons.bolt_rounded,
                            color: WemanColors.primary,
                            size: 20,
                          ),
                          const SizedBox(width: 8),
                          Flexible(
                            child: Text(
                              'Bangalore Campus Network',
                              style: WemanTypography.labelMedium.copyWith(
                                fontWeight: FontWeight.w700,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: WemanColors.voltGreen,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        '412 Athletes',
                        style: WemanTypography.labelSmall.copyWith(
                          fontWeight: FontWeight.w800,
                          color: WemanColors.onSurface,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Form Fields
              if (_isSignUp) ...[
                _buildFieldLabel('Full Name'),
                TextField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.person_outline_rounded),
                    hintText: 'Alex Chen',
                  ),
                ),
                const SizedBox(height: 16),
                _buildFieldLabel('College / Campus Gym'),
                TextField(
                  controller: _collegeController,
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.school_outlined),
                    hintText: 'City Engineering College',
                  ),
                ),
                const SizedBox(height: 16),
              ],

              _buildFieldLabel('Athlete Identifier (Email)'),
              TextField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.alternate_email_rounded),
                  suffixIcon: Container(
                    margin: const EdgeInsets.all(10),
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      color: WemanColors.voltGreen.withValues(alpha: 0.4),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.check,
                        size: 14, color: WemanColors.primary),
                  ),
                  hintText: 'your.name@weman.fit',
                ),
              ),
              const SizedBox(height: 16),

              _buildFieldLabel('Security Key (Password)'),
              TextField(
                controller: _passwordController,
                obscureText: _obscurePassword,
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.lock_outline_rounded),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscurePassword
                          ? Icons.visibility_off_outlined
                          : Icons.visibility_outlined,
                      color: WemanColors.textMuted,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscurePassword = !_obscurePassword;
                      });
                    },
                  ),
                  hintText: '••••••••••••',
                ),
              ),
              const SizedBox(height: 28),

              // Action CTA
              WemanButton(
                text:
                    _isSignUp ? 'REGISTER ATHLETE PROFILE' : 'SIGN IN TO WEMAN',
                width: double.infinity,
                variant: WemanButtonVariant.voltPrimary,
                isLoading: _isLoading,
                icon: const Icon(Icons.arrow_forward_rounded,
                    color: WemanColors.onSurface),
                onPressed: _handleAuth,
              ),
              const SizedBox(height: 20),

              // Alternative Sign In
              Center(
                child: TextButton(
                  onPressed: () => context.go('/feed'),
                  child: Text(
                    'Explore Campus Feed as Guest',
                    style: WemanTypography.labelMedium.copyWith(
                      color: WemanColors.primary,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Fast Direct Screen Switcher for Testing/Review
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: WemanColors.cardBg,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: WemanColors.outlineVariant,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: WemanColors.neonLime,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(Icons.touch_app_rounded,
                              size: 16, color: WemanColors.onSurface),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          '⚡ DIRECT SCREEN INSPECTOR',
                          style: WemanTypography.labelSmall.copyWith(
                            fontWeight: FontWeight.w900,
                            letterSpacing: 0.8,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        _buildScreenChip('🏋️ Campus Feed', '/feed'),
                        _buildScreenChip('🥗 Diet Tracker', '/diet-tracker'),
                        _buildScreenChip(
                            '⏱️ Active Workout', '/active-training'),
                        _buildScreenChip(
                            '📋 Workout Details', '/workout-details'),
                        _buildScreenChip('💪 Training Hub', '/training-hub'),
                        _buildScreenChip('📊 Telemetry', '/fitness-tracking'),
                        _buildScreenChip('🏆 Rankings', '/rankings'),
                        _buildScreenChip('🎖️ Badges', '/badge-gallery'),
                        _buildScreenChip('💬 Coach Inbox', '/inbox'),
                        _buildScreenChip('📸 Create Post', '/create-post'),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFieldLabel(String label) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 8),
      child: Text(
        label,
        style: WemanTypography.labelSmall.copyWith(
          fontWeight: FontWeight.w700,
          color: WemanColors.onSurfaceVariant,
          letterSpacing: 0.8,
        ),
      ),
    );
  }

  Widget _buildScreenChip(String label, String route) {
    return InkWell(
      onTap: () => context.push(route),
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
        decoration: BoxDecoration(
          color: WemanColors.surfaceContainerLow,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: WemanColors.outlineVariant),
        ),
        child: Text(
          label,
          style: WemanTypography.labelSmall.copyWith(
            fontWeight: FontWeight.w700,
            color: WemanColors.onSurface,
          ),
        ),
      ),
    );
  }
}
