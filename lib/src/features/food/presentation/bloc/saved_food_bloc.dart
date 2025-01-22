import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../features.dart';

class SavedFoodBloc extends Bloc<SavedFoodEvent, SavedFoodState> {
  final SavedFoodRepository _repository;

  SavedFoodBloc({required SavedFoodRepository repository})
      : _repository = repository,
        super(const SavedFoodState()) {
    on<AddSavedFood>(_onAddSavedFood);
    on<UpdateSavedFood>(_onUpdateSavedFood);
    on<DeleteSavedFood>(_onDeleteSavedFood);
    on<LoadUserSavedFoods>(_onLoadUserSavedFoods);
    on<SearchSavedFoods>(_onSearchSavedFoods);
    on<LoadPublicSavedFoods>(_onLoadPublicSavedFoods);
  }

  Future<void> _onAddSavedFood(
    AddSavedFood event,
    Emitter<SavedFoodState> emit,
  ) async {
    try {
      emit(state.copyWith(isLoading: true));
      await _repository.addSavedFood(event.food);
      final foods = await _repository.getUserSavedFoods();
      emit(state.copyWith(isLoading: false, foods: foods));
    } catch (e) {
      emit(state.copyWith(isLoading: false, error: e.toString()));
    }
  }

  Future<void> _onUpdateSavedFood(
    UpdateSavedFood event,
    Emitter<SavedFoodState> emit,
  ) async {
    try {
      emit(state.copyWith(isLoading: true));
      await _repository.updateSavedFood(event.food);
      final foods = await _repository.getUserSavedFoods();
      emit(state.copyWith(isLoading: false, foods: foods));
    } catch (e) {
      emit(state.copyWith(isLoading: false, error: e.toString()));
    }
  }

  Future<void> _onDeleteSavedFood(
    DeleteSavedFood event,
    Emitter<SavedFoodState> emit,
  ) async {
    try {
      emit(state.copyWith(isLoading: true));
      await _repository.deleteSavedFood(event.foodId);
      final foods = await _repository.getUserSavedFoods();
      emit(state.copyWith(isLoading: false, foods: foods));
    } catch (e) {
      emit(state.copyWith(isLoading: false, error: e.toString()));
    }
  }

  Future<void> _onLoadUserSavedFoods(
    LoadUserSavedFoods event,
    Emitter<SavedFoodState> emit,
  ) async {
    try {
      emit(state.copyWith(isLoading: true));
      final foods = await _repository.getUserSavedFoods();
      emit(state.copyWith(isLoading: false, foods: foods));
    } catch (e) {
      emit(state.copyWith(isLoading: false, error: e.toString()));
    }
  }

  Future<void> _onSearchSavedFoods(
    SearchSavedFoods event,
    Emitter<SavedFoodState> emit,
  ) async {
    try {
      emit(state.copyWith(isLoading: true));
      final foods = await _repository.searchSavedFoods(event.query);
      emit(state.copyWith(isLoading: false, foods: foods));
    } catch (e) {
      emit(state.copyWith(isLoading: false, error: e.toString()));
    }
  }

  Future<void> _onLoadPublicSavedFoods(
    LoadPublicSavedFoods event,
    Emitter<SavedFoodState> emit,
  ) async {
    try {
      emit(state.copyWith(isLoading: true));
      final foods = await _repository.getPublicSavedFoods();
      emit(state.copyWith(isLoading: false, foods: foods));
    } catch (e) {
      emit(state.copyWith(isLoading: false, error: e.toString()));
    }
  }
}