import 'package:equatable/equatable.dart';

import '../../../workout.dart';

class WorkoutState extends Equatable {
  final bool isLoading;
  final List<Workout> workouts;
  final List<Workout> templates;
  final String? error;

  const WorkoutState({
    this.isLoading = false,
    this.workouts = const [],
    this.templates = const [],
    this.error,
  });

  WorkoutState copyWith({
    bool? isLoading,
    List<Workout>? workouts,
    List<Workout>? templates,
    String? error,
  }) {
    return WorkoutState(
      isLoading: isLoading ?? this.isLoading,
      workouts: workouts ?? this.workouts,
      templates: templates ?? this.templates,
      error: error ?? this.error,
    );
  }

  @override
  List<Object?> get props => [isLoading, workouts, templates, error];
}