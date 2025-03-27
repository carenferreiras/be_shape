import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../../features.dart';

class FoodSuggestionBloc
    extends Bloc<FoodSuggestionEvent, FoodSuggestionState> {
  final FirebaseFirestore firestore;

  FoodSuggestionBloc({required this.firestore})
      : super(FoodSuggestionLoading()) {
    on<LoadFoodSuggestions>(_onLoadFoodSuggestions);
  }

  Future<void> _onLoadFoodSuggestions(
      LoadFoodSuggestions event, Emitter<FoodSuggestionState> emit) async {
    emit(FoodSuggestionLoading());

    try {
      final querySnapshot = await firestore.collection('foods').get();
      List<Map<String, dynamic>> allFoods =
          querySnapshot.docs.map((doc) => doc.data()).toList();

      MacroTargets targets = event.userProfile.macroTargets;

      // Filtrando os alimentos de acordo com os macros
      List<Map<String, dynamic>> proteins =
          _filterByMacro(allFoods, 'proteina', targets.proteins);
      List<Map<String, dynamic>> carbs =
          _filterByMacro(allFoods, 'carboidrato', targets.carbs);
      List<Map<String, dynamic>> fats =
          _filterByMacro(allFoods, 'gordura', targets.fats);

      emit(FoodSuggestionLoaded({
        'proteina': proteins,
        'carboidrato': carbs,
        'gordura': fats,
      }));
    } catch (e) {
      emit(FoodSuggestionError('Erro ao carregar sugestões de alimentos: $e'));
    }
  }

  double _safeParseDouble(dynamic value) {
    if (value == null || value == 'NA') return 0.0;
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is String) {
      return double.tryParse(value.replaceAll(',', '.')) ?? 0.0;
    }
    return 0.0;
  }

  List<Map<String, dynamic>> _filterByMacro(
      List<Map<String, dynamic>> foods, String macro, double target) {
    double toleranceFactor = 0.40; // 40% de tolerância

    // Ordenamos os alimentos pela proximidade ao target
    foods.sort((a, b) {
      double aValue = (_safeParseDouble(a[macro]) - target).abs();
      double bValue = (_safeParseDouble(b[macro]) - target).abs();
      return aValue.compareTo(bValue);
    });

    // Filtramos os alimentos que já estão dentro da faixa desejada
    List<Map<String, dynamic>> filtered = foods
        .where((food) {
          double value = _safeParseDouble(food[macro]);
          return value >= target * (1 - toleranceFactor) &&
              value <= target * (1 + toleranceFactor);
        })
        .take(3) // Pega no máximo 3 diretos
        .toList();

    // Se já temos 3 sugestões individuais, retornamos
    if (filtered.length >= 3) {
      return filtered;
    }

    // Se não houver alimentos suficientes, buscamos combinações eficientes
    return filtered +
        _findBestCombination(foods, macro, target, 3 - filtered.length);
  }

  List<Map<String, dynamic>> _findBestCombination(
      List<Map<String, dynamic>> foods,
      String macro,
      double target,
      int needed) {
    List<Map<String, dynamic>> bestCombination = [];
    double bestDifference = double.infinity;

    for (int i = 0; i < foods.length; i++) {
      for (int j = i + 1; j < foods.length; j++) {
        double sum = _safeParseDouble(foods[i][macro]) +
            _safeParseDouble(foods[j][macro]);
        double diff = (target - sum).abs();

        if (diff < bestDifference && sum <= target * 1.4) {
          bestDifference = diff;
          bestCombination = [foods[i], foods[j]];
        }
      }
    }

    return bestCombination.take(needed).toList();
  }
}
