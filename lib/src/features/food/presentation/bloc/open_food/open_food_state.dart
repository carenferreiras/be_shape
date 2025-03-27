import 'package:be_shape_app/src/features/food/domain/models/open_food_product_model.dart';
import 'package:equatable/equatable.dart';

abstract class OpenFoodFactsState extends Equatable {
  @override
  List<Object> get props => [];
}

class OpenFoodFactsInitial extends OpenFoodFactsState {}

class OpenFoodFactsLoading extends OpenFoodFactsState {}

class OpenFoodFactsLoaded extends OpenFoodFactsState {
  final List<FoodProduct> foods;

  OpenFoodFactsLoaded(this.foods);

  @override
  List<Object> get props => [foods];
}

class OpenFoodFactsError extends OpenFoodFactsState {
  final String message;

  OpenFoodFactsError(this.message);

  @override
  List<Object> get props => [message];
}