import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../food.dart';

class FavoriteFoodBloc extends Bloc<FavoriteFoodEvent, FavoriteFoodState> {
  final FavoriteFoodRepository favoriteFoodRepository;
  final String userId;

  FavoriteFoodBloc({required this.favoriteFoodRepository, required this.userId})
      : super(const FavoriteFoodState(favoriteFoods: [])) {
    on<LoadFavoriteFoods>(_onLoadFavorites);
    on<AddFavoriteFood>(_onAddFavorite);
    on<RemoveFavoriteFood>(_onRemoveFavorite);
    add(LoadFavoriteFoods()); 
  }

  Future<void> _onLoadFavorites(
      LoadFavoriteFoods event, Emitter<FavoriteFoodState> emit) async {
    emit(state.copyWith(isLoading: true));
    try {
      final favorites = await favoriteFoodRepository.getFavorites(userId);
      emit(state.copyWith(favoriteFoods: favorites, isLoading: false));
    } catch (e) {
      emit(state.copyWith(errorMessage: 'Erro ao carregar favoritos', isLoading: false));
    }
  }


  Future<void> _onAddFavorite(AddFavoriteFood event, Emitter<FavoriteFoodState> emit) async {
    await favoriteFoodRepository.addFavorite(userId, event.food);
    final updatedFavorites = List<FoodProduct>.from(state.favoriteFoods)..add(event.food);
    emit(state.copyWith(favoriteFoods: updatedFavorites));
  }

  Future<void> _onRemoveFavorite(RemoveFavoriteFood event, Emitter<FavoriteFoodState> emit) async {
    await favoriteFoodRepository.removeFavorite(userId, event.food.id);
    final updatedFavorites =
        state.favoriteFoods.where((f) => f.id != event.food.id).toList();
    emit(state.copyWith(favoriteFoods: updatedFavorites));
  }
}