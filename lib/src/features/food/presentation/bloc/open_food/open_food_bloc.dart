import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../features.dart';


class OpenFoodFactsBloc extends Bloc<OpenFoodFactsEvent, OpenFoodFactsState> {
  final OpenFoodFactsRepository repository;

  OpenFoodFactsBloc(this.repository) : super(OpenFoodFactsInitial()) {
    on<SearchFoodsEvent>(_onSearchFoods);
  }

  Future<void> _onSearchFoods(
      SearchFoodsEvent event, Emitter<OpenFoodFactsState> emit) async {
    emit(OpenFoodFactsLoading());
    try {
      final foods = await repository.searchFoods(event.query);
      emit(OpenFoodFactsLoaded(foods));
    } catch (e) {
      emit(OpenFoodFactsError(e.toString()));
    }
  }
}