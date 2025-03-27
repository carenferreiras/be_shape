import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../features/auth/auth.dart';

class FoodSuggestionService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<Map<String, dynamic>>> getSuggestedFoods(UserProfile user) async {
    final macroTargets = user.macroTargets;

    // 1. Buscar alimentos no Firestore
    final querySnapshot = await _firestore.collection('foods').get();
    List<Map<String, dynamic>> allFoods =
        querySnapshot.docs.map((doc) => doc.data()).toList();

    // 2. Filtrar e ordenar alimentos flexíveis
    List<Map<String, dynamic>> suggestedFoods = _selectFlexibleFoods(allFoods, macroTargets);

    return suggestedFoods;
  }

  List<Map<String, dynamic>> _selectFlexibleFoods(
      List<Map<String, dynamic>> foods, MacroTargets macroTargets) {
    
    double toleranceFactor = 0.50; // 15% de margem de flexibilidade

    // Criar uma lista de alimentos dentro da faixa de tolerância
    List<Map<String, dynamic>> filteredFoods = foods.where((food) {
      double protein = food['proteinas'] ?? 0.0;
      double carbs = food['carboidratos'] ?? 0.0;
      double fats = food['gordura_total'] ?? 0.0;

      return _isWithinRange(protein, macroTargets.proteins, toleranceFactor) &&
             _isWithinRange(carbs, macroTargets.carbs, toleranceFactor) &&
             _isWithinRange(fats, macroTargets.fats, toleranceFactor);
    }).toList();

    // Ordenar alimentos dentro da faixa de tolerância, priorizando os mais próximos
    filteredFoods.sort((a, b) {
      double scoreA = _calculateFoodScore(a, macroTargets);
      double scoreB = _calculateFoodScore(b, macroTargets);
      return scoreA.compareTo(scoreB); // Menor score = alimento melhor ajustado
    });

    return filteredFoods.take(7).toList(); // Retorna os 7 melhores alimentos
  }

  bool _isWithinRange(double value, double target, double toleranceFactor) {
    double min = target * (1 - toleranceFactor);
    double max = target * (1 + toleranceFactor);
    return value >= min && value <= max;
  }

  double _calculateFoodScore(Map<String, dynamic> food, MacroTargets targets) {
    double proteinDiff = ((food['proteinas'] ?? 0) - targets.proteins).abs();
    double carbDiff = ((food['carboidratos'] ?? 0) - targets.carbs).abs();
    double fatDiff = ((food['gordura_total'] ?? 0) - targets.fats).abs(); 
    // Score ponderado (proteínas são mais importantes que carboidratos e gorduras)
    return (proteinDiff * 1.2) + (carbDiff * 1.0) + (fatDiff * 0.8);
  }
}