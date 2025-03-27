import 'package:flutter/material.dart';

import '../../../../core/core.dart';

class NutritionCard extends StatelessWidget {
  final TextEditingController caloriesController;
  final TextEditingController proteinsController;
  final TextEditingController carbsController;
  final TextEditingController fatsController;
  final TextEditingController fibersController;
  final TextEditingController sodiumController;
  final TextEditingController waterController;
  final TextEditingController ironController;
  final TextEditingController calciumController;

  const NutritionCard({
    required this.caloriesController,
    required this.proteinsController,
    required this.carbsController,
    required this.fatsController,
    required this.fibersController,
    required this.sodiumController,
    required this.waterController,
    required this.ironController,
    required this.calciumController,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Nutrition Facts',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 24),
          _buildNutritionInput(
            'Caloria',
            caloriesController,
            BeShapeColors.primary,
            'kcal',
          ),
          _buildNutritionInput(
            'Proteina',
            proteinsController,
            BeShapeColors.link,
            'g',
          ),
          _buildNutritionInput(
            'Caboidrato',
            carbsController,
            BeShapeColors.accent,
            'g',
          ),
          _buildNutritionInput(
            'Gordura',
            fatsController,
            BeShapeColors.error,
            'g',
          ),
          _buildNutritionInput(
            'Fibras',
            fibersController,
            BeShapeColors.purble,
            'g',
          ),
          _buildNutritionInput(
            'Sódio',
            sodiumController,
            BeShapeColors.warning,
            'mg',
          ),
          _buildNutritionInput(
            'Cálcio',
            calciumController,
            BeShapeColors.brown,
            'mg',
          ),
          _buildNutritionInput(
            'Água',
            waterController,
            BeShapeColors.blue,
            '%',
          ),
          _buildNutritionInput(
            'Ferro',
            ironController,
            BeShapeColors.grey,
            'mg',
          ),
        ],
      ),
    );
  }

  Widget _buildNutritionInput(
    String label,
    TextEditingController controller,
    Color color,
    String unit,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: const TextStyle(
                color: Colors.grey,
                fontSize: 16,
              ),
            ),
          ),
          Expanded(
            child: TextFormField(
              controller: controller,
              style: TextStyle(color: color),
              textAlign: TextAlign.center,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                suffix: Text(
                  unit,
                  style: const TextStyle(color: Colors.grey),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide:
                      BorderSide(color: color..withValues(alpha: (0.3))),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: color),
                ),
                filled: true,
                fillColor: color.withValues(alpha: (0.1)),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Required';
                }
                return null;
              },
            ),
          ),
        ],
      ),
    );
  }
}
