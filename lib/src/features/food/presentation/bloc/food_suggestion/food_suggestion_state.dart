
import 'package:equatable/equatable.dart';

abstract class FoodSuggestionState extends Equatable {
  @override
  List<Object?> get props => [];
}

class FoodSuggestionLoading extends FoodSuggestionState {}

class FoodSuggestionLoaded extends FoodSuggestionState {
  final Map<String, List<Map<String, dynamic>>> suggestions;

  FoodSuggestionLoaded(this.suggestions);

  @override
  List<Object?> get props => [suggestions];
}

class FoodSuggestionError extends FoodSuggestionState {
  final String message;

  FoodSuggestionError(this.message);

  @override
  List<Object?> get props => [message];
}