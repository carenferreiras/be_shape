import 'package:equatable/equatable.dart';

abstract class OpenFoodFactsEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class SearchFoodsEvent extends OpenFoodFactsEvent {
  final String query;

  SearchFoodsEvent(this.query);

  @override
  List<Object> get props => [query];
}