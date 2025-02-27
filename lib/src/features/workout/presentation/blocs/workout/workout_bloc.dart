import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../workout.dart';

class WorkoutBloc extends Bloc<WorkoutEvent, WorkoutState> {
  final WorkoutRepository _repository;

  WorkoutBloc({required WorkoutRepository repository})
      : _repository = repository,
        super(const WorkoutState()) {
    on<AddWorkout>(_onAddWorkout);
    on<UpdateWorkout>(_onUpdateWorkout);
    on<DeleteWorkout>(_onDeleteWorkout);
    on<LoadUserWorkouts>(_onLoadUserWorkouts);
    on<LoadWorkoutsByType>(_onLoadWorkoutsByType);
    on<LoadWorkoutTemplates>(_onLoadWorkoutTemplates);
    on<SearchWorkouts>(_onSearchWorkouts);
    on<LoadWorkoutsByEquipment>(_onLoadWorkoutsByEquipment);
    on<LoadRecentWorkouts>(_onLoadRecentWorkouts);
  }

  Future<void> _onAddWorkout(
    AddWorkout event,
    Emitter<WorkoutState> emit,
  ) async {
    try {
      emit(state.copyWith(isLoading: true));
      await _repository.addWorkout(event.workout);
      final workouts = await _repository.getUserWorkouts(event.workout.userId);
      emit(state.copyWith(
        isLoading: false,
        workouts: workouts,
      ));
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        error: e.toString(),
      ));
    }
  }

  Future<void> _onUpdateWorkout(
    UpdateWorkout event,
    Emitter<WorkoutState> emit,
  ) async {
    try {
      emit(state.copyWith(isLoading: true));
      await _repository.updateWorkout(event.workout);
      final workouts = await _repository.getUserWorkouts(event.workout.userId);
      emit(state.copyWith(
        isLoading: false,
        workouts: workouts,
      ));
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        error: e.toString(),
      ));
    }
  }

  Future<void> _onDeleteWorkout(
    DeleteWorkout event,
    Emitter<WorkoutState> emit,
  ) async {
    try {
      emit(state.copyWith(isLoading: true));
      await _repository.deleteWorkout(event.workoutId);
      final workouts = await _repository.getUserWorkouts(event.userId);
      emit(state.copyWith(
        isLoading: false,
        workouts: workouts,
      ));
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        error: e.toString(),
      ));
    }
  }

  Future<void> _onLoadUserWorkouts(
    LoadUserWorkouts event,
    Emitter<WorkoutState> emit,
  ) async {
    try {
      emit(state.copyWith(isLoading: true));
      final workouts = await _repository.getUserWorkouts(event.userId);
      emit(state.copyWith(
        isLoading: false,
        workouts: workouts,
      ));
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        error: e.toString(),
      ));
    }
  }

  Future<void> _onLoadWorkoutsByType(
    LoadWorkoutsByType event,
    Emitter<WorkoutState> emit,
  ) async {
    try {
      emit(state.copyWith(isLoading: true));
      final workouts = await _repository.getWorkoutsByType(event.type);
      emit(state.copyWith(
        isLoading: false,
        workouts: workouts,
      ));
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        error: e.toString(),
      ));
    }
  }

  Future<void> _onLoadWorkoutTemplates(
    LoadWorkoutTemplates event,
    Emitter<WorkoutState> emit,
  ) async {
    try {
      emit(state.copyWith(isLoading: true));
      final templates = await _repository.getWorkoutTemplates();
      emit(state.copyWith(
        isLoading: false,
        templates: templates,
      ));
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        error: e.toString(),
      ));
    }
  }

  Future<void> _onSearchWorkouts(
    SearchWorkouts event,
    Emitter<WorkoutState> emit,
  ) async {
    try {
      emit(state.copyWith(isLoading: true));
      final workouts = await _repository.searchWorkouts(event.query);
      emit(state.copyWith(
        isLoading: false,
        workouts: workouts,
      ));
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        error: e.toString(),
      ));
    }
  }

  Future<void> _onLoadWorkoutsByEquipment(
    LoadWorkoutsByEquipment event,
    Emitter<WorkoutState> emit,
  ) async {
    try {
      emit(state.copyWith(isLoading: true));
      final workouts = await _repository.getWorkoutsByEquipment(event.equipmentIds);
      emit(state.copyWith(
        isLoading: false,
        workouts: workouts,
      ));
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        error: e.toString(),
      ));
    }
  }

  Future<void> _onLoadRecentWorkouts(
    LoadRecentWorkouts event,
    Emitter<WorkoutState> emit,
  ) async {
    try {
      emit(state.copyWith(isLoading: true));
      final workouts = await _repository.getRecentWorkouts(event.limit);
      emit(state.copyWith(
        isLoading: false,
        workouts: workouts,
      ));
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        error: e.toString(),
      ));
    }
  }
}