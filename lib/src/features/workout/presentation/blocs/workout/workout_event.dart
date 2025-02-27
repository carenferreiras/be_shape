import 'package:equatable/equatable.dart';

import '../../../workout.dart';

abstract class WorkoutEvent extends Equatable {
  const WorkoutEvent();

  @override
  List<Object?> get props => [];
}

class AddWorkout extends WorkoutEvent {
  final Workout workout;

  const AddWorkout(this.workout);

  @override
  List<Object?> get props => [workout];
}

class UpdateWorkout extends WorkoutEvent {
  final Workout workout;

  const UpdateWorkout(this.workout);

  @override
  List<Object?> get props => [workout];
}

class DeleteWorkout extends WorkoutEvent {
  final String workoutId;
  final String userId;

  const DeleteWorkout(this.workoutId, this.userId);

  @override
  List<Object?> get props => [workoutId, userId];
}

class LoadUserWorkouts extends WorkoutEvent {
  final String userId;

  const LoadUserWorkouts(this.userId);

  @override
  List<Object?> get props => [userId];
}

class LoadWorkoutsByType extends WorkoutEvent {
  final WorkoutType type;

  const LoadWorkoutsByType(this.type);

  @override
  List<Object?> get props => [type];
}

class LoadWorkoutTemplates extends WorkoutEvent {
  const LoadWorkoutTemplates();
}

class SearchWorkouts extends WorkoutEvent {
  final String query;

  const SearchWorkouts(this.query);

  @override
  List<Object?> get props => [query];
}

class LoadWorkoutsByEquipment extends WorkoutEvent {
  final List<String> equipmentIds;

  const LoadWorkoutsByEquipment(this.equipmentIds);

  @override
  List<Object?> get props => [equipmentIds];
}

class LoadRecentWorkouts extends WorkoutEvent {
  final int limit;

  const LoadRecentWorkouts(this.limit);

  @override
  List<Object?> get props => [limit];
}