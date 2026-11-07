import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/weman_colors.dart';
import '../../core/theme/weman_typography.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  double _progress = 0.18;
  String _statusText = 'Syncing campus network...';
  late Timer _timer;

  final List<Map<String, dynamic>> _steps = [
    {'at': 0.35, 'text': 'Calibrating personal pace...'},
    {'at': 0.68, 'text': 'Connecting Karnataka squads...'},
    {'at': 0.90, 'text': 'Preparing energy loop...'},
    {'at': 1.00, 'text': 'Ready to move.'},
  ];

  @override
  void initState() {
    super.initState();
    _startProgressAnimation();
  }

  void _startProgressAnimation() {
    _timer = Timer.periodic(const Duration(milliseconds: 120), (timer) {
      if (!mounted) return;
      setState(() {
        _progress += 0.05;
        if (_progress >= 1.0) {
          _progress = 1.0;
          _statusText = 'Ready to move.';
          _timer.cancel();
          Future.delayed(const Duration(milliseconds: 600), () {
            if (mounted) {
              context.go('/onboarding');
            }
          });
        } else {
          for (var step in _steps) {
            if (_progress <= (step['at'] as double)) {
              _statusText = step['text'] as String;
              break;
            }
          }
        }
      });
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final int percentInt = (_progress * 100).toInt();

    return Scaffold(
      backgroundColor: WemanColors.surface,
      body: SafeArea(
        child: Stack(
          children: [
            // Ambient Volt-Green Glows
            Positioned(
              top: -100,
              left: MediaQuery.of(context).size.width / 2 - 150,
              child: Container(
                width: 300,
                height: 300,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: WemanColors.voltGreen.withValues(alpha: 0.18),
                ),
              ),
            ),
            Positioned(
              bottom: -80,
              left: MediaQuery.of(context).size.width / 2 - 120,
              child: Container(
                width: 240,
                height: 240,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: WemanColors.voltGreen.withValues(alpha: 0.12),
                ),
              ),
            ),

            // Main Content
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Top Metadata
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 8,
                            height: 8,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: WemanColors.primary,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'LIVE GRID • KARNATAKA',
                            style: WemanTypography.labelSmall.copyWith(
                              fontWeight: FontWeight.w700,
                              letterSpacing: 1.2,
                              color: WemanColors.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                      Text(
                        'v3.0.0',
                        style: WemanTypography.labelSmall.copyWith(
                          fontWeight: FontWeight.w600,
                          color: WemanColors.textMuted,
                        ),
                      ),
                    ],
                  ),

                  // Center Brand Module
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Emblem with Volt Shadow
                      Stack(
                        clipBehavior: Clip.none,
                        alignment: Alignment.center,
                        children: [
                          Container(
                            width: 130,
                            height: 130,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: WemanColors.voltGreen
                                      .withValues(alpha: 0.35),
                                  blurRadius: 36,
                                  spreadRadius: 8,
                                ),
                              ],
                            ),
                          ),
                          Container(
                            width: 120,
                            height: 120,
                            decoration: BoxDecoration(
                              color: WemanColors.cardBg,
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: WemanColors.outlineVariant
                                    .withValues(alpha: 0.4),
                                width: 1,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.06),
                                  blurRadius: 12,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: ClipOval(
                              child: Image.asset(
                                'assets/images/weman_logo.png',
                                fit: BoxFit.cover,
                                errorBuilder: (ctx, err, stack) => Center(
                                  child: Text(
                                    'W',
                                    style:
                                        WemanTypography.displayLarge.copyWith(
                                      color: WemanColors.onSurface,
                                      fontWeight: FontWeight.w900,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          // Micro Sparkle Badge
                          Positioned(
                            top: -2,
                            right: -2,
                            child: Container(
                              width: 28,
                              height: 28,
                              decoration: BoxDecoration(
                                color: WemanColors.cardBg,
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withValues(alpha: 0.08),
                                    blurRadius: 6,
                                  ),
                                ],
                              ),
                              child: const Icon(
                                Icons.bolt_rounded,
                                color: WemanColors.primary,
                                size: 16,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 28),

                      // Wordmark
                      Text(
                        'WEMAN FIT',
                        style: WemanTypography.displayLarge.copyWith(
                          fontSize: 38,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 2.0,
                          color: WemanColors.onSurface,
                        ),
                      ),
                      const SizedBox(height: 8),

                      // Subtitle
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                              width: 16,
                              height: 1,
                              color: WemanColors.outlineVariant),
                          const SizedBox(width: 8),
                          Text(
                            'SOCIAL FITNESS ELEVATED',
                            style: WemanTypography.labelMedium.copyWith(
                              letterSpacing: 2.0,
                              fontWeight: FontWeight.w700,
                              color: WemanColors.textMuted,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Container(
                              width: 16,
                              height: 1,
                              color: WemanColors.outlineVariant),
                        ],
                      ),
                    ],
                  ),

                  // Bottom Progress & City Activity Module
                  Column(
                    children: [
                      // Progress Bar
                      Container(
                        height: 6,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: WemanColors.surfaceContainerHighest,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: LayoutBuilder(
                          builder: (context, constraints) {
                            return Align(
                              alignment: Alignment.centerLeft,
                              child: Container(
                                width: constraints.maxWidth * _progress,
                                decoration: BoxDecoration(
                                  color: WemanColors.voltGreen,
                                  borderRadius: BorderRadius.circular(10),
                                  boxShadow: [
                                    BoxShadow(
                                      color: WemanColors.voltGreen
                                          .withValues(alpha: 0.6),
                                      blurRadius: 8,
                                      offset: const Offset(0, 2),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: 12),

                      // Status & Percent
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              const Icon(
                                Icons.sync_rounded,
                                size: 16,
                                color: WemanColors.primary,
                              ),
                              const SizedBox(width: 6),
                              Text(
                                _statusText,
                                style: WemanTypography.labelSmall.copyWith(
                                  color: WemanColors.textMuted,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                          Text(
                            '$percentInt%',
                            style: WemanTypography.labelSmall.copyWith(
                              fontWeight: FontWeight.w800,
                              color: WemanColors.onSurface,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),

                      // Community Micro-Ticker
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 14, vertical: 8),
                        decoration: BoxDecoration(
                          color: WemanColors.surfaceContainerLow,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: WemanColors.outlineVariant
                                .withValues(alpha: 0.3),
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              width: 18,
                              height: 18,
                              decoration: const BoxDecoration(
                                color: WemanColors.voltGreen,
                                shape: BoxShape.circle,
                              ),
                              child: const Center(
                                child: Text(
                                  '⚡',
                                  style: TextStyle(fontSize: 10),
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            RichText(
                              text: TextSpan(
                                children: [
                                  TextSpan(
                                    text: '3.8k athletes ',
                                    style: WemanTypography.labelSmall.copyWith(
                                      fontWeight: FontWeight.w800,
                                      color: WemanColors.onSurface,
                                    ),
                                  ),
                                  TextSpan(
                                    text: 'active in Bengaluru & Hubli',
                                    style: WemanTypography.labelSmall.copyWith(
                                      color: WemanColors.textMuted,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
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
}
