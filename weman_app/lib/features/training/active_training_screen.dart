import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/demo_state/demo_state.dart';
import '../../core/theme/weman_colors.dart';

class ActiveTrainingScreen extends ConsumerStatefulWidget {
  const ActiveTrainingScreen({super.key});

  @override
  ConsumerState<ActiveTrainingScreen> createState() =>
      _ActiveTrainingScreenState();
}

class _ActiveTrainingScreenState extends ConsumerState<ActiveTrainingScreen> {
  bool _hasLoggedCompletion = false;
  int _secondsLeft = 45;
  final int _totalInterval = 45;
  bool _isRunning = true;
  Timer? _timer;

  int _currentSet = 2;
  final int _totalSets = 4;
  final List<bool> _completedSets = [true, false, false, false];

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (_secondsLeft > 0) {
        setState(() => _secondsLeft--);
      } else {
        setState(() => _isRunning = false);
        t.cancel();
      }
    });
  }

  void _togglePlayPause() {
    setState(() {
      _isRunning = !_isRunning;
      if (_isRunning) {
        _startTimer();
      } else {
        _timer?.cancel();
      }
    });
  }

  void _adjustTime(int delta) {
    setState(() {
      _secondsLeft = (_secondsLeft + delta).clamp(0, 300);
    });
  }

  void _completeSet() {
    setState(() {
      if (_currentSet <= _totalSets) {
        _completedSets[_currentSet - 1] = true;
        if (_currentSet < _totalSets) {
          _currentSet++;
          _secondsLeft = 45;
          _isRunning = true;
          _startTimer();
        } else {
          _showWorkoutFinishedDialog();
        }
      }
    });
  }

  void _showWorkoutFinishedDialog() {
    _timer?.cancel();
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        backgroundColor: WemanColors.surfaceWhite,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Row(
          children: [
            Icon(Icons.emoji_events, color: WemanColors.neonLime, size: 28),
            SizedBox(width: 8),
            Text(
              'Session Finished!',
              style: TextStyle(fontWeight: FontWeight.w800, fontSize: 18),
            ),
          ],
        ),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'All 4 sets of Hanging Leg Raises completed with strict tempo!',
              style: TextStyle(fontSize: 14, color: WemanColors.onSurface),
            ),
            SizedBox(height: 12),
            Text(
              '• Est. Calories: 420 kcal (Demo)\n• Heart Rate Avg: 138 BPM\n• Experience Gained: +250 XP',
              style: TextStyle(fontSize: 13, color: WemanColors.secondary),
            ),
          ],
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              if (!_hasLoggedCompletion) {
                _hasLoggedCompletion = true;
                final record = WemanWorkoutRecord(
                  id: 'workout-${DateTime.now().millisecondsSinceEpoch}',
                  workoutName: 'Hanging Leg Raises & Core Circuit',
                  completedAt: DateTime.now(),
                  durationMinutes: 24,
                  caloriesBurned: 420,
                  completedSets: _completedSets.where((c) => c).length,
                  totalSets: _totalSets,
                  exerciseName: 'Hanging Leg Raises',
                  xpEarned: 250,
                  heartRateAvg: 138,
                );
                ref
                    .read(workoutTelemetryProvider.notifier)
                    .logCompletedWorkout(record);
              }
              Navigator.of(ctx).pop();
              if (Navigator.of(context).canPop()) {
                Navigator.of(context).pop();
              } else {
                context.pop();
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: WemanColors.neonLime,
              foregroundColor: WemanColors.onSurface,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            child: const Text(
              'LOG & RETURN TO HUB',
              style: TextStyle(fontWeight: FontWeight.w800),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final timerRatio = _totalInterval > 0
        ? (_secondsLeft / _totalInterval).clamp(0.0, 1.0)
        : 0.0;

    return Scaffold(
      backgroundColor: WemanColors.surface,
      appBar: AppBar(
        backgroundColor: WemanColors.surface.withValues(alpha: 0.95),
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: WemanColors.onSurface),
          onPressed: () {
            if (Navigator.canPop(context)) {
              Navigator.pop(context);
            } else {
              context.pop();
            }
          },
        ),
        title: const Text(
          'Active Training Session',
          style: TextStyle(
            color: WemanColors.onSurface,
            fontWeight: FontWeight.w700,
            fontSize: 17,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.send_outlined, color: WemanColors.onSurface),
            onPressed: () => context.push('/inbox'),
          ),
          IconButton(
            icon: const Icon(Icons.info_outline, color: WemanColors.onSurface),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(bottom: 120),
        child: Column(
          children: [
            // Top Session Pulse Strip
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Column(
                children: [
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
                              color: WemanColors.neonLime,
                            ),
                          ),
                          const SizedBox(width: 6),
                          const Text(
                            'EXERCISE 2 OF 5',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w800,
                              color: WemanColors.onSurface,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: WemanColors.surfaceContainerHigh,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: const Row(
                          children: [
                            Icon(
                              Icons.timer,
                              size: 14,
                              color: WemanColors.deepMoss,
                            ),
                            SizedBox(width: 4),
                            Text(
                              '12:45 / 28:00',
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w700,
                                color: WemanColors.onSurface,
                              ),
                            ),
                          ],
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          if (Navigator.of(context).canPop()) {
                            Navigator.of(context).pop();
                          } else {
                            context.pop();
                          }
                        },
                        borderRadius: BorderRadius.circular(12),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: WemanColors.surfaceContainerLow,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Row(
                            children: [
                              Text(
                                'EXIT',
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w700,
                                  color: WemanColors.secondary,
                                ),
                              ),
                              SizedBox(width: 4),
                              Icon(
                                Icons.logout,
                                size: 12,
                                color: WemanColors.secondary,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),

                  // Segmented Track Progress Indicator (5 segments)
                  Row(
                    children: List.generate(5, (idx) {
                      final isFilled = idx < 2;
                      return Expanded(
                        child: Container(
                          margin: const EdgeInsets.symmetric(horizontal: 2),
                          height: 5,
                          decoration: BoxDecoration(
                            color: isFilled
                                ? WemanColors.neonLime
                                : WemanColors.surfaceContainerHigh,
                            borderRadius: BorderRadius.circular(3),
                          ),
                        ),
                      );
                    }),
                  ),
                ],
              ),
            ),

            // Hero Visual Framing Card
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Container(
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
                    // Exercise Header
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: WemanColors.surface,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: const Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.fitness_center,
                                    size: 11,
                                    color: WemanColors.secondary,
                                  ),
                                  SizedBox(width: 4),
                                  Text(
                                    'CORE HYPERTROPHY',
                                    style: TextStyle(
                                      fontSize: 9,
                                      fontWeight: FontWeight.w700,
                                      color: WemanColors.secondary,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 4),
                            const Text(
                              'Hanging Leg Raises',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w800,
                                color: WemanColors.onSurface,
                              ),
                            ),
                            const Text(
                              'Upper & Lower Core Isolation',
                              style: TextStyle(
                                fontSize: 12,
                                color: WemanColors.secondary,
                              ),
                            ),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: WemanColors.charcoal,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                'SET $_currentSet OF $_totalSets',
                                style: const TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w800,
                                  color: Colors.white,
                                  letterSpacing: 0.5,
                                ),
                              ),
                            ),
                            const SizedBox(height: 2),
                            const Text(
                              '12 Reps • RPE 8.5',
                              style: TextStyle(
                                fontSize: 10,
                                color: WemanColors.secondary,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // Live Radial Countdown
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        SizedBox(
                          width: 170,
                          height: 170,
                          child: CircularProgressIndicator(
                            value: timerRatio,
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
                            const Text(
                              'INTERVAL REST',
                              style: TextStyle(
                                fontSize: 9,
                                fontWeight: FontWeight.w700,
                                color: WemanColors.secondary,
                                letterSpacing: 0.5,
                              ),
                            ),
                            Text(
                              '00:${_secondsLeft.toString().padLeft(2, '0')}',
                              style: const TextStyle(
                                fontSize: 36,
                                fontWeight: FontWeight.w800,
                                color: WemanColors.onSurface,
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 6,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: WemanColors.softLime,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Text(
                                'PACED PACE',
                                style: TextStyle(
                                  fontSize: 8,
                                  fontWeight: FontWeight.w800,
                                  color: WemanColors.deepMoss,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),

                    // Quick Set Adjusters
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _buildAdjustButton('-10s', () => _adjustTime(-10)),
                        const SizedBox(width: 12),
                        const Text('•',
                            style: TextStyle(color: WemanColors.secondary)),
                        const SizedBox(width: 12),
                        _buildAdjustButton('+15s', () => _adjustTime(15)),
                      ],
                    ),
                    const SizedBox(height: 14),

                    // Set 1 Verified Pill
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: WemanColors.surface,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Row(
                            children: [
                              Icon(
                                Icons.check_circle,
                                size: 16,
                                color: WemanColors.deepMoss,
                              ),
                              SizedBox(width: 8),
                              Text(
                                'Set 1: 15 reps completed',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
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
                              color: WemanColors.surfaceContainerHigh,
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: const Text(
                              'Verified',
                              style: TextStyle(
                                fontSize: 9,
                                color: WemanColors.secondary,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 8),

                    // Coach Tip Pill
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: WemanColors.surfaceContainerHigh,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(
                            Icons.tips_and_updates,
                            size: 16,
                            color: WemanColors.deepMoss,
                          ),
                          SizedBox(width: 8),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'MOVEMENT CUE',
                                  style: TextStyle(
                                    fontSize: 9,
                                    fontWeight: FontWeight.w700,
                                    color: WemanColors.onSurface,
                                    letterSpacing: 0.5,
                                  ),
                                ),
                                SizedBox(height: 2),
                                Text(
                                  'Exhale as knees reach hip level. Control the descent to avoid swinging.',
                                  style: TextStyle(
                                    fontSize: 11,
                                    color: WemanColors.secondary,
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
              ),
            ),
            const SizedBox(height: 12),

            // Biometrics Row
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  // Heart Rate
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: WemanColors.surfaceWhite,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.red.withValues(alpha: 0.1),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.favorite,
                              color: Colors.redAccent,
                              size: 20,
                            ),
                          ),
                          const SizedBox(width: 10),
                          const Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '138 BPM',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                              Text(
                                'Zone 3 • Aerobic',
                                style: TextStyle(
                                  fontSize: 9,
                                  fontWeight: FontWeight.w700,
                                  color: WemanColors.deepMoss,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  // Muscle Focus
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: WemanColors.surfaceWhite,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: const BoxDecoration(
                              color: WemanColors.surface,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.accessibility_new,
                              size: 20,
                              color: WemanColors.onSurface,
                            ),
                          ),
                          const SizedBox(width: 10),
                          const Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Rectus Abs',
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w800,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                                Text(
                                  'Activation: High',
                                  style: TextStyle(
                                    fontSize: 9,
                                    color: WemanColors.secondary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),

            // Sets Checklist
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: WemanColors.surfaceWhite,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Target Set Breakdown',
                      style:
                          TextStyle(fontSize: 13, fontWeight: FontWeight.w700),
                    ),
                    const SizedBox(height: 8),
                    ...List.generate(_totalSets, (index) {
                      final setNum = index + 1;
                      final isCompleted = _completedSets[index];
                      final isCurrent = _currentSet == setNum && !isCompleted;
                      return Container(
                        margin: const EdgeInsets.only(bottom: 6),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: isCurrent
                              ? WemanColors.softLime
                              : WemanColors.surface,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  isCompleted
                                      ? Icons.check_circle
                                      : Icons.radio_button_unchecked,
                                  size: 16,
                                  color: isCompleted
                                      ? WemanColors.deepMoss
                                      : WemanColors.secondary,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  'Set $setNum: 12-15 reps',
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: isCurrent
                                        ? FontWeight.w700
                                        : FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                            Text(
                              isCompleted
                                  ? 'Done'
                                  : isCurrent
                                      ? 'Active Set'
                                      : 'Upcoming',
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w700,
                                color: isCompleted
                                    ? WemanColors.deepMoss
                                    : WemanColors.secondary,
                              ),
                            ),
                          ],
                        ),
                      );
                    }),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomSheet: Container(
        padding: EdgeInsets.only(
          left: 16,
          right: 16,
          top: 10,
          bottom: MediaQuery.of(context).padding.bottom + 10,
        ),
        decoration: BoxDecoration(
          color: WemanColors.surfaceWhite,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, -3),
            ),
          ],
        ),
        child: Row(
          children: [
            // Prev button
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: WemanColors.surfaceContainerHigh,
                borderRadius: BorderRadius.circular(25),
              ),
              child: IconButton(
                icon: const Icon(Icons.skip_previous, size: 22),
                onPressed: () {},
              ),
            ),
            const SizedBox(width: 12),

            // Play / Pause button
            GestureDetector(
              onTap: _togglePlayPause,
              child: Container(
                width: 60,
                height: 60,
                decoration: const BoxDecoration(
                  color: WemanColors.neonLime,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  _isRunning ? Icons.pause : Icons.play_arrow,
                  size: 32,
                  color: WemanColors.onSurface,
                ),
              ),
            ),
            const SizedBox(width: 12),

            // Complete Set button
            Expanded(
              child: SizedBox(
                height: 50,
                child: ElevatedButton(
                  onPressed: _completeSet,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: WemanColors.charcoal,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                    elevation: 0,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        _currentSet == _totalSets
                            ? 'FINISH WORKOUT'
                            : 'COMPLETE SET',
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.5,
                        ),
                      ),
                      const SizedBox(width: 4),
                      const Icon(Icons.check, size: 18),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAdjustButton(String label, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        decoration: BoxDecoration(
          color: WemanColors.surface,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          label,
          style: const TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w700,
            color: WemanColors.secondary,
          ),
        ),
      ),
    );
  }
}
