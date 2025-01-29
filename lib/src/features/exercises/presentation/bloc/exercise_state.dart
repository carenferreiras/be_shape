import '../../../features.dart';

class ExerciseState {
  final bool isLoading;
  final List<Exercise> exercises;
  final String? error;

  const ExerciseState({
    this.isLoading = false,
    this.exercises = const [],
    this.error,
  });

  ExerciseState copyWith({
    bool? isLoading,
    List<Exercise>? exercises,
    String? error,
  }) {
    return ExerciseState(
      isLoading: isLoading ?? this.isLoading,
      exercises: exercises ?? this.exercises,
      error: error ?? this.error,
    );
  }
}