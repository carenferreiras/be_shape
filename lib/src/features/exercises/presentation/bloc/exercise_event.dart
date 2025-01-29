import '../../../features.dart';

abstract class ExerciseEvent {
  const ExerciseEvent();
}

class AddExercise extends ExerciseEvent {
  final Exercise exercise;
  const AddExercise(this.exercise);
}

class UpdateExercise extends ExerciseEvent {
  final Exercise exercise;
  const UpdateExercise(this.exercise);
}

class DeleteExercise extends ExerciseEvent {
  final String exerciseId;
  const DeleteExercise(this.exerciseId);
}

class LoadExercisesForDate extends ExerciseEvent {
  final DateTime date;
  const LoadExercisesForDate(this.date);
}

class LoadRecentExercises extends ExerciseEvent {
  final int limit;
  const LoadRecentExercises(this.limit);
}

class LoadExercisesByUser extends ExerciseEvent {
  final String userId;

  LoadExercisesByUser(this.userId);

  List<Object> get props => [userId];
}
class LoadExercisesForUserAndDate extends ExerciseEvent {
  final String userId;
  final DateTime date;

  LoadExercisesForUserAndDate(this.userId, this.date);

  List<Object?> get props => [userId, date];
}