import 'package:equatable/equatable.dart';

import '../../../food.dart';

class FavoriteFoodState extends Equatable {
  final List<FoodProduct> favoriteFoods;
  final bool isLoading;
  final String? errorMessage;

  const FavoriteFoodState({
    required this.favoriteFoods,
    this.isLoading = false,
    this.errorMessage,
  });

  FavoriteFoodState copyWith({
    List<FoodProduct>? favoriteFoods,
    bool? isLoading,
    String? errorMessage,
  }) {
    return FavoriteFoodState(
      favoriteFoods: favoriteFoods ?? this.favoriteFoods,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [favoriteFoods, isLoading, errorMessage];
}