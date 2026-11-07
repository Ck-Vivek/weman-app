import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Individual recorded workout entry in the demo telemetry system.
class WemanWorkoutRecord {
  final String id;
  final String workoutName;
  final DateTime completedAt;
  final int durationMinutes;
  final int caloriesBurned;
  final int completedSets;
  final int totalSets;
  final String exerciseName;
  final int xpEarned;
  final int heartRateAvg;

  const WemanWorkoutRecord({
    required this.id,
    required this.workoutName,
    required this.completedAt,
    required this.durationMinutes,
    required this.caloriesBurned,
    required this.completedSets,
    required this.totalSets,
    required this.exerciseName,
    this.xpEarned = 250,
    this.heartRateAvg = 138,
  });
}

/// State representation for user workout telemetry, stats, and recorded history.
class WorkoutTelemetryState {
  final List<WemanWorkoutRecord> workoutHistory;
  final int dailySteps; // Demo sensor metric
  final int stepGoal; // Demo benchmark
  final int baseActiveMinutes;
  final int baseCaloriesBurned;
  final int baseCompletedWorkouts;
  final int currentStreakDays;
  final DateTime? lastWorkoutDate;
  final double distanceKm;

  const WorkoutTelemetryState({
    required this.workoutHistory,
    this.dailySteps = 11420,
    this.stepGoal = 12000,
    this.baseActiveMinutes = 52,
    this.baseCaloriesBurned = 640,
    this.baseCompletedWorkouts = 184,
    this.currentStreakDays = 18,
    this.lastWorkoutDate,
    this.distanceKm = 6.8,
  });

  /// Total accumulated active minutes combining baseline and recorded sessions.
  int get activeMinutes {
    final sessionMinutes =
        workoutHistory.fold<int>(0, (sum, w) => sum + w.durationMinutes);
    return baseActiveMinutes + sessionMinutes;
  }

  /// Total calories burned combining baseline and recorded session estimates.
  int get caloriesBurned {
    final sessionKcal =
        workoutHistory.fold<int>(0, (sum, w) => sum + w.caloriesBurned);
    return baseCaloriesBurned + sessionKcal;
  }

  /// Total lifetime completed workouts for Profile.
  int get totalCompletedWorkouts =>
      baseCompletedWorkouts + workoutHistory.length;

  /// Workouts completed today for Fitness Tracker session progression banner.
  int get todayCompletedWorkouts {
    final now = DateTime.now();
    final todayCount = workoutHistory.where((w) {
      return w.completedAt.year == now.year &&
          w.completedAt.month == now.month &&
          w.completedAt.day == now.day;
    }).length;
    // 1 baseline completed earlier today + any newly logged workouts today
    return 1 + todayCount;
  }

  WorkoutTelemetryState copyWith({
    List<WemanWorkoutRecord>? workoutHistory,
    int? dailySteps,
    int? stepGoal,
    int? baseActiveMinutes,
    int? baseCaloriesBurned,
    int? baseCompletedWorkouts,
    int? currentStreakDays,
    DateTime? lastWorkoutDate,
    double? distanceKm,
  }) {
    return WorkoutTelemetryState(
      workoutHistory: workoutHistory ?? this.workoutHistory,
      dailySteps: dailySteps ?? this.dailySteps,
      stepGoal: stepGoal ?? this.stepGoal,
      baseActiveMinutes: baseActiveMinutes ?? this.baseActiveMinutes,
      baseCaloriesBurned: baseCaloriesBurned ?? this.baseCaloriesBurned,
      baseCompletedWorkouts:
          baseCompletedWorkouts ?? this.baseCompletedWorkouts,
      currentStreakDays: currentStreakDays ?? this.currentStreakDays,
      lastWorkoutDate: lastWorkoutDate ?? this.lastWorkoutDate,
      distanceKm: distanceKm ?? this.distanceKm,
    );
  }
}

/// State notifier managing workout telemetry, duplicate detection, and streak logic.
class WorkoutTelemetryNotifier extends StateNotifier<WorkoutTelemetryState> {
  WorkoutTelemetryNotifier() : super(_initialState);

  static final DateTime _now = DateTime.now();

  static final WemanWorkoutRecord _baselineWorkout = WemanWorkoutRecord(
    id: 'baseline-workout-core-1',
    workoutName: 'Morning Mobility & Core Flow',
    completedAt: _now.subtract(const Duration(hours: 3)),
    durationMinutes: 20,
    caloriesBurned: 140,
    completedSets: 3,
    totalSets: 3,
    exerciseName: 'Bird Dogs & Plank Holds',
    xpEarned: 150,
    heartRateAvg: 122,
  );

  static final WorkoutTelemetryState _initialState = WorkoutTelemetryState(
    workoutHistory: [_baselineWorkout],
    dailySteps: 11420,
    stepGoal: 12000,
    baseActiveMinutes: 52,
    baseCaloriesBurned: 640,
    baseCompletedWorkouts: 184,
    currentStreakDays: 18,
    lastWorkoutDate: _now.subtract(const Duration(hours: 3)),
    distanceKm: 6.8,
  );

  /// Checks if two dates fall on the exact same calendar day.
  static bool isSameCalendarDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  /// Checks if [current] is the immediate consecutive calendar day after [previous].
  static bool isConsecutiveDay(DateTime previous, DateTime current) {
    final prevDate = DateTime(previous.year, previous.month, previous.day);
    final currDate = DateTime(current.year, current.month, current.day);
    return currDate.difference(prevDate).inDays == 1;
  }

  /// Logs a completed workout.
  ///
  /// Prevents duplicates (by ID or rapid re-submission within 5 seconds).
  /// Updates active minutes, calories, workout count, and streak according to consistent rules.
  /// Returns `true` if logged successfully, or `false` if rejected as a duplicate.
  bool logCompletedWorkout(WemanWorkoutRecord record) {
    // 1. Guard against duplicate ID
    if (state.workoutHistory.any((w) => w.id == record.id)) {
      return false;
    }

    // 2. Guard against rapid re-submission with same workout name within 5 seconds
    final isRapidDuplicate = state.workoutHistory.any((w) =>
        w.workoutName == record.workoutName &&
        record.completedAt.difference(w.completedAt).abs() <
            const Duration(seconds: 5));
    if (isRapidDuplicate) {
      return false;
    }

    // 3. Compute new streak based on calendar day progression
    int newStreak = state.currentStreakDays;
    final lastDate = state.lastWorkoutDate;

    if (lastDate == null) {
      newStreak = state.currentStreakDays + 1;
    } else if (isSameCalendarDay(lastDate, record.completedAt)) {
      // Already met the training streak requirement for this calendar day.
      // Do not arbitrarily increment streak for multiple workouts on the same day.
      newStreak = state.currentStreakDays;
    } else if (isConsecutiveDay(lastDate, record.completedAt)) {
      // Completed on consecutive calendar day -> increment streak.
      newStreak = state.currentStreakDays + 1;
    } else if (record.completedAt.isAfter(lastDate)) {
      final prevDate = DateTime(lastDate.year, lastDate.month, lastDate.day);
      final currDate = DateTime(record.completedAt.year,
          record.completedAt.month, record.completedAt.day);
      if (currDate.difference(prevDate).inDays > 1) {
        // Gap of more than 1 day in the future -> streak resets to 1.
        newStreak = 1;
      }
    }

    state = state.copyWith(
      workoutHistory: [record, ...state.workoutHistory],
      currentStreakDays: newStreak,
      lastWorkoutDate: record.completedAt,
    );

    return true;
  }

  /// Resets state back to baseline (useful for testing).
  void reset() {
    state = _initialState;
  }
}

/// Global provider for workout telemetry and recorded workout history.
final workoutTelemetryProvider =
    StateNotifierProvider<WorkoutTelemetryNotifier, WorkoutTelemetryState>(
        (ref) {
  return WorkoutTelemetryNotifier();
});
