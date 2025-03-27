import 'package:equatable/equatable.dart';

import '../../../food.dart';

abstract class FavoriteFoodEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoadFavoriteFoods extends FavoriteFoodEvent {}

class AddFavoriteFood extends FavoriteFoodEvent {
  final FoodProduct food;
  AddFavoriteFood(this.food);

  @override
  List<Object?> get props => [food];
}

class RemoveFavoriteFood extends FavoriteFoodEvent {
  final FoodProduct food;
  RemoveFavoriteFood(this.food);

  @override
  List<Object?> get props => [food];
}