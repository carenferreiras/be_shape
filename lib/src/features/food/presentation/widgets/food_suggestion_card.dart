import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../features.dart';
import '../../../../core/core.dart';

class FoodSuggestionCard extends StatelessWidget {
  final UserProfile userProfile;

  const FoodSuggestionCard({super.key, required this.userProfile});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FoodSuggestionBloc, FoodSuggestionState>(
      builder: (context, state) {
        if (state is FoodSuggestionLoading) {
          return const Center(
            child: Padding(
              padding: EdgeInsets.all(20),
              child: CircularProgressIndicator(color: BeShapeColors.primary),
            ),
          );
        } else if (state is FoodSuggestionError) {
          return Center(
            child: Text(
              state.message,
              style: const TextStyle(color: Colors.red),
            ),
          );
        } else if (state is FoodSuggestionLoaded) {
          final suggestions = state.suggestions;

          return Container(
            decoration: BoxDecoration(
              color: BeShapeColors.background,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(
                color: BeShapeColors.primary.withValues(alpha: (0.3)),
                width: 1,
              ),
            ),
            child: Column(
              children: [
                _buildHeader(),
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      _buildMacroSection(
                          'Proteínas',
                          userProfile.macroTargets.proteins,
                          suggestions['proteina'] ?? [],
                          Colors.blue,
                          'proteina'),
                      const SizedBox(height: 20),
                      _buildMacroSection(
                          'Carboidratos',
                          userProfile.macroTargets.carbs,
                          suggestions['carboidrato'] ?? [],
                          Colors.green,
                          'carboidrato'),
                      const SizedBox(height: 20),
                      _buildMacroSection(
                        'Gorduras Boas',
                        userProfile.macroTargets.fats,
                        suggestions['gordura'] ?? [],
                        Colors.red,
                        'gordura',
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        }
        return const Center(child: Text('Nenhuma sugestão disponível.'));
      },
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            BeShapeColors.primary.withValues(alpha: (0.2)),
            BeShapeColors.primary.withValues(alpha: (0.05)),
          ],
        ),
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(24),
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: BeShapeColors.primary.withValues(alpha: (0.2)),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.restaurant_menu,
              color: BeShapeColors.primary,
              size: 24,
            ),
          ),
          const SizedBox(width: 16),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Sugestões de Alimentos',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Para atingir suas metas diárias',
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMacroSection(
    String title,
    double target,
    List<Map<String, dynamic>> suggestions,
    Color color,
    String
        macroKey, 
  ) {
    double total = _calculateTotal(suggestions, macroKey);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: color.withValues(alpha: (0.2)),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                Icons.restaurant,
                color: color,
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Spacer(),
            Text(
              '${target.round()}g',
              style: TextStyle(
                color: color,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                BeShapeColors.primary.withValues(alpha: (0.2)),
                BeShapeColors.primary.withValues(alpha: (0.05)),
              ],
            ),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
                color: BeShapeColors.primary..withValues(alpha: (0.3))),
          ),
          child: ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            padding: const EdgeInsets.all(12),
            itemCount: suggestions.length,
            separatorBuilder: (context, index) => Divider(
              color: Colors.grey[800],
              height: 16,
            ),
            itemBuilder: (context, index) {
              final food = suggestions[index];
              final double value =
                  _safeParseDouble(food[macroKey]); 

              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AddFoodScreen(
                        initialFoodData: food,
                      ),
                    ),
                  );
                },
                child: Row(
                  children: [
                    Icon(Icons.menu, color: color, size: 24),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        food['nome_alimento'] ?? 'Alimento Desconhecido',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    Text(
                      '${value.toStringAsFixed(2)}g',
                      style: TextStyle(
                        color: color,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Total:',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
              Text(
                '${total.toStringAsFixed(2)}g',
                style: TextStyle(
                  color: color,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  double _calculateTotal(List<Map<String, dynamic>> foods, String macroKey) {
    return foods.fold(
        0.0, (sum, food) => sum + _safeParseDouble(food[macroKey]));
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
}
