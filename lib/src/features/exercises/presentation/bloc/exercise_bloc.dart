  import 'package:flutter_bloc/flutter_bloc.dart';

  import '../../../features.dart';

  class ExerciseBloc extends Bloc<ExerciseEvent, ExerciseState> {
  final ExerciseRepository _exerciseRepository;

  ExerciseBloc({required ExerciseRepository exerciseRepository})
      : _exerciseRepository = exerciseRepository,
        super(const ExerciseState()) {
    on<AddExercise>(_onAddExercise);
    on<UpdateExercise>(_onUpdateExercise);
    on<DeleteExercise>(_onDeleteExercise);
    on<LoadExercisesForDate>(_onLoadExercisesForDate);
    on<LoadRecentExercises>(_onLoadRecentExercises);
    on<LoadExercisesByUser>(_onLoadExercisesByUser);
        on<LoadExercisesForUserAndDate>(_onLoadExercisesForUserAndDate);

  }

  /// Adiciona um exercício e recarrega os exercícios do usuário logado
  Future<void> _onAddExercise(
    AddExercise event,
    Emitter<ExerciseState> emit,
  ) async {
    try {
      emit(state.copyWith(isLoading: true));
      await _exerciseRepository.addExercise(event.exercise);

      // Recarrega os exercícios para o usuário
      final exercises = await _exerciseRepository.getExercisesByUser(event.exercise.userId);

      emit(state.copyWith(isLoading: false, exercises: exercises));
    } catch (e) {
      emit(state.copyWith(isLoading: false, error: e.toString()));
    }
  }

  /// Atualiza um exercício e recarrega os exercícios do usuário logado
  Future<void> _onUpdateExercise(
    UpdateExercise event,
    Emitter<ExerciseState> emit,
  ) async {
    try {
      emit(state.copyWith(isLoading: true));
      await _exerciseRepository.updateExercise(event.exercise);

      // Recarrega os exercícios para o usuário
      final exercises = await _exerciseRepository.getExercisesByUser(event.exercise.userId);

      emit(state.copyWith(isLoading: false, exercises: exercises));
    } catch (e) {
      emit(state.copyWith(isLoading: false, error: e.toString()));
    }
  }

  /// Remove um exercício e recarrega os exercícios do usuário logado
Future<void> _onDeleteExercise(
  DeleteExercise event,
  Emitter<ExerciseState> emit,
) async {
  try {
    emit(state.copyWith(isLoading: true));
    await _exerciseRepository.deleteExercise(event.exerciseId);

    // Recarrega os exercícios do usuário após exclusão
    final exercises = await _exerciseRepository.getExercisesByUser(state.exercises.first.userId);

    emit(state.copyWith(isLoading: false, exercises: exercises));
  } catch (e) {
    emit(state.copyWith(isLoading: false, error: e.toString()));
  }
}

  /// Carrega exercícios para o usuário logado
  Future<void> _onLoadExercisesByUser(
    LoadExercisesByUser event,
    Emitter<ExerciseState> emit,
  ) async {
    try {
      emit(state.copyWith(isLoading: true));
      final exercises = await _exerciseRepository.getExercisesByUser(event.userId);
      emit(state.copyWith(isLoading: false, exercises: exercises));
    } catch (e) {
      emit(state.copyWith(isLoading: false, error: e.toString()));
    }
  }

  /// Carrega exercícios para uma data específica
  Future<void> _onLoadExercisesForDate(
    LoadExercisesForDate event,
    Emitter<ExerciseState> emit,
  ) async {
    try {
      emit(state.copyWith(isLoading: true));
      final exercises = await _exerciseRepository.getExercisesByDate(event.date);
      emit(state.copyWith(isLoading: false, exercises: exercises));
    } catch (e) {
      emit(state.copyWith(isLoading: false, error: e.toString()));
    }
  }

  /// Carrega exercícios mais recentes com limite
  Future<void> _onLoadRecentExercises(
    LoadRecentExercises event,
    Emitter<ExerciseState> emit,
  ) async {
    try {
      emit(state.copyWith(isLoading: true));
      final exercises = await _exerciseRepository.getRecentExercises(event.limit);
      emit(state.copyWith(isLoading: false, exercises: exercises));
    } catch (e) {
      emit(state.copyWith(isLoading: false, error: e.toString()));
    }
  }
  /// Manipulador para carregar exercícios de um usuário específico em uma data
  Future<void> _onLoadExercisesForUserAndDate(
    LoadExercisesForUserAndDate event,
    Emitter<ExerciseState> emit,
  ) async {
    try {
      emit(state.copyWith(isLoading: true));

      // Obter exercícios do usuário filtrados pela data
      final exercises = await _exerciseRepository.getExercisesForUserAndDate(
        userId: event.userId,
        date: event.date,
      );

      emit(state.copyWith(isLoading: false, exercises: exercises));
    } catch (e) {
      emit(state.copyWith(isLoading: false, error: e.toString()));
    }
  }
}