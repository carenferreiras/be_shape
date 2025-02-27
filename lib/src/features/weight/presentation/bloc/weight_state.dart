// lib/src/features/weight/bloc/weight_state.dart
import '../../../features.dart';

class WeightState {
  final double startWeight;
  final double currentWeight;
  final double previousWeight;
  final double targetWeight;
  final double bmr;
  final double tdee;
  final List<WeightHistory> weightHistory;
  final bool isSuccess;
  final String? error;

  const WeightState({
    required this.startWeight,
    required this.currentWeight,
    required this.previousWeight,
    required this.targetWeight,
    required this.bmr,
    required this.tdee,
    required this.weightHistory,
    this.isSuccess = false,
    this.error,
  });

  WeightState copyWith({
    double? startWeight,
    double? currentWeight,
    double? previousWeight,
    double? targetWeight,
    double? bmr,
    double? tdee,
    List<WeightHistory>? weightHistory,
    bool? isSuccess,
    String? error,
  }) {
    return WeightState(
      startWeight: startWeight ?? this.startWeight,
      currentWeight: currentWeight ?? this.currentWeight,
      previousWeight: previousWeight ?? this.previousWeight,
      targetWeight: targetWeight ?? this.targetWeight,
      bmr: bmr ?? this.bmr,
      tdee: tdee ?? this.tdee,
      weightHistory: weightHistory ?? this.weightHistory,
      isSuccess: isSuccess ?? this.isSuccess,
      error: error ?? this.error,
    );
  }

  // Factory constructor for initial state
  factory WeightState.initial() {
    return const WeightState(
      startWeight: 0,
      currentWeight: 0,
      previousWeight: 0,
      targetWeight: 0,
      bmr: 0,
      tdee: 0,
      weightHistory: [],
      isSuccess: false,
    );
  }
}
