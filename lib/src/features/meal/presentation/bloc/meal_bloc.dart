import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../features.dart';


class MealBloc extends Bloc<MealEvent, MealState> {
  final MealRepository _mealRepository;

  MealBloc({required MealRepository mealRepository})
      : _mealRepository = mealRepository,
        super(const MealState()) {
    on<AddMeal>(_onAddMeal);
    on<UpdateMeal>(_onUpdateMeal);
    on<DeleteMeal>(_onDeleteMeal);
    on<LoadMealsForDate>(_onLoadMealsForDate);
    on<LoadRecentMeals>(_onLoadRecentMeals);
    on<CompleteDailyTracking>(_onCompleteDailyTracking);
    on<LoadCompletedMeals>(_onLoadCompletedMeals);
    on<ResetDailyMeals>(_onResetDailyMeals);
  }

  Future<void> _onAddMeal(AddMeal event, Emitter<MealState> emit) async {
    try {
      emit(state.copyWith(isLoading: true));
      await _mealRepository.addMeal(event.meal);
      final meals = await _mealRepository.getMealsByDate(event.meal.date);
      emit(state.copyWith(isLoading: false, meals: meals));
    } catch (e) {
      emit(state.copyWith(isLoading: false, error: e.toString()));
    }
  }

  Future<void> _onUpdateMeal(UpdateMeal event, Emitter<MealState> emit) async {
    try {
      emit(state.copyWith(isLoading: true));
      await _mealRepository.updateMeal(event.meal);
      final meals = await _mealRepository.getMealsByDate(event.meal.date);
      emit(state.copyWith(isLoading: false, meals: meals));
    } catch (e) {
      emit(state.copyWith(isLoading: false, error: e.toString()));
    }
  }

 Future<void> _onDeleteMeal(
  DeleteMeal event,
  Emitter<MealState> emit,
) async {
  try {
    // Primeiro, emite o estado atual com loading
    emit(state.copyWith(isLoading: true));
    
    // Executa a deleção no repositório
    await _mealRepository.deleteMeal(event.mealId);
    
    // Atualiza a lista de refeições localmente removendo o item deletado
    final updatedMeals = state.meals.where((meal) => meal.id != event.mealId).toList();
    
    // Emite o novo estado com a lista atualizada
    emit(state.copyWith(
      isLoading: false,
      meals: updatedMeals,
    ));
  } catch (e) {
    emit(state.copyWith(
      isLoading: false,
      error: e.toString(),
    ));
  }
}

  Future<void> _onLoadMealsForDate(
    LoadMealsForDate event,
    Emitter<MealState> emit,
  ) async {
    try {
      emit(state.copyWith(isLoading: true));
      final meals = await _mealRepository.getMealsByDate(event.date);
      emit(state.copyWith(isLoading: false, meals: meals));
    } catch (e) {
      emit(state.copyWith(isLoading: false, error: e.toString()));
    }
  }

  Future<void> _onLoadRecentMeals(
    LoadRecentMeals event,
    Emitter<MealState> emit,
  ) async {
    try {
      emit(state.copyWith(isLoading: true));
      final meals = await _mealRepository.getRecentMeals(event.limit);
      emit(state.copyWith(isLoading: false, meals: meals));
    } catch (e) {
      emit(state.copyWith(isLoading: false, error: e.toString()));
    }
  }

  Future<void> _onCompleteDailyTracking(
    CompleteDailyTracking event,
    Emitter<MealState> emit,
  ) async {
    try {
      emit(state.copyWith(isLoading: true));
      await _mealRepository.completeDailyTracking(event.userId, event.date);
      emit(state.copyWith(isLoading: false, meals: []));
    } catch (e) {
      emit(state.copyWith(isLoading: false, error: e.toString()));
    }
  }

  Future<void> _onLoadCompletedMeals(
    LoadCompletedMeals event,
    Emitter<MealState> emit,
  ) async {
    try {
      emit(state.copyWith(isLoading: true));
      final completedMeals = await _mealRepository.getCompletedMeals(event.userId);
      emit(state.copyWith(isLoading: false, meals: completedMeals));
    } catch (e) {
      emit(state.copyWith(isLoading: false, error: e.toString()));
    }
  }

  Future<void> _onResetDailyMeals(
    ResetDailyMeals event,
    Emitter<MealState> emit,
  ) async {
    emit(const MealState()); // Reset completo do estado
  }
}