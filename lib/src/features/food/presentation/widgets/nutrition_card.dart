import 'package:flutter/material.dart';

import '../../../../core/core.dart';

class NutritionCard extends StatelessWidget {
  final TextEditingController caloriesController;
  final TextEditingController proteinsController;
  final TextEditingController carbsController;
  final TextEditingController fatsController;

  const NutritionCard({
    required this.caloriesController,
    required this.proteinsController,
    required this.carbsController,
    required this.fatsController,
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
          const SizedBox(height: 16),
          _buildNutritionInput(
            'Calories',
            caloriesController,
            BeShapeColors.primary,
            'kcal',
          ),
          const SizedBox(height: 12),
          _buildNutritionInput(
            'Protein',
            proteinsController,
            Colors.blue,
            'g',
          ),
          const SizedBox(height: 12),
          _buildNutritionInput(
            'Carbs',
            carbsController,
            Colors.green,
            'g',
          ),
          const SizedBox(height: 12),
          _buildNutritionInput(
            'Fat',
            fatsController,
            Colors.red,
            'g',
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
    return Row(
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
                borderSide: BorderSide(color: color.withOpacity(0.3)),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: color),
              ),
              filled: true,
              fillColor: color.withOpacity(0.1),
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
    );
  }
  
  

}