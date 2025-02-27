import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../core/core.dart';
import '../../../features.dart';

class MealCardWidget extends StatelessWidget {
    final Meal meal;
  final VoidCallback onDelete;
  const MealCardWidget({super.key, required this.meal, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Colors.grey[800]!,
          width: 1,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            // Show meal details
          },
          borderRadius: BorderRadius.circular(20),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: BeShapeColors.primary.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            DateFormat('HH:mm').format(meal.date),
                            style: const TextStyle(
                              color: BeShapeColors.primary,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        if (meal.isCompleted) ...[
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              color: BeShapeColors.accent.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Icon(
                              Icons.check,
                              color: BeShapeColors.accent,
                              size: 16,
                            ),
                          ),
                        ],
                      ],
                    ),
                    IconButton(
                      icon: const Icon(
                        Icons.delete_outline,
                        color: Colors.red,
                      ),
                      onPressed: onDelete,
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  meal.name,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    MacroInfo(
                      icon: Icons.local_fire_department,
                      value: meal.calories,
                      unit: 'kcal',
                      color: BeShapeColors.primary,
                    ),
                    MacroInfo(
                      icon: Icons.fitness_center,
                      value: meal.proteins,
                      unit: 'g',
                      color: BeShapeColors.link,
                      label: 'Protein',
                    ),
                    MacroInfo(
                      icon: Icons.grain,
                      value: meal.carbs,
                      unit: 'g',
                      color: BeShapeColors.accent,
                      label: 'Carbs',
                    ),
                    MacroInfo(
                      icon: Icons.opacity,
                      value: meal.fats,
                      unit: 'g',
                      color: Colors.red,
                      label: 'Fat',
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}