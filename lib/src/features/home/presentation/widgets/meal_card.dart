import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../../features.dart';

class MealCard extends StatelessWidget {
  final UserProfile userProfile;

  const MealCard({
    super.key,
    required this.userProfile,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MealBloc, MealState>(
      builder: (context, state) {
        // Calculate consumed macros
        double consumedProtein = 0;
        double consumedCarbs = 0;
        double consumedFat = 0;

        for (final meal in state.meals) {
          consumedProtein += meal.proteins;
          consumedCarbs += meal.carbs;
          consumedFat += meal.fats;
        }

        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.grey[900],
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Macros Progress',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextButton.icon(
                    onPressed: () {
                      Navigator.pushNamed(context, '/saved-food');
                    },
                    icon: Icon(
                      Icons.add_circle_outline,
                      color: Colors.orange[300],
                      size: 20,
                    ),
                    label: Text(
                      'Add Meal',
                      style: TextStyle(
                        color: Colors.orange[300],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              _MacroProgressBar(
                label: 'Protein',
                consumed: consumedProtein,
                target: userProfile.macroTargets.proteins,
                color: Colors.blue[300]!,
                unit: 'g',
              ),
              const SizedBox(height: 12),
              _MacroProgressBar(
                label: 'Carbs',
                consumed: consumedCarbs,
                target: userProfile.macroTargets.carbs,
                color: Colors.green[300]!,
                unit: 'g',
              ),
              const SizedBox(height: 12),
              _MacroProgressBar(
                label: 'Fat',
                consumed: consumedFat,
                target: userProfile.macroTargets.fats,
                color: Colors.orange[300]!,
                unit: 'g',
              ),
              const SizedBox(height: 24),
            ],
          ),
        );
      },
    );
  }
}

class _MacroProgressBar extends StatelessWidget {
  final String label;
  final double consumed;
  final double target;
  final Color color;
  final String unit;

  const _MacroProgressBar({
    required this.label,
    required this.consumed,
    required this.target,
    required this.color,
    required this.unit,
  });

  @override
  Widget build(BuildContext context) {
    final progress = (consumed / target).clamp(0.0, 1.0);
    final percentage = (progress * 100).round();
    final remaining = target - consumed;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: const TextStyle(
                color: Colors.grey,
                fontSize: 14,
              ),
            ),
            Text(
              '${consumed.round()}/${target.round()} $unit (${remaining.round()} left)',
              style: TextStyle(
                color: color,
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Stack(
          children: [
            Container(
              height: 8,
              decoration: BoxDecoration(
                color: Colors.grey[800],
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            FractionallySizedBox(
              widthFactor: progress,
              child: Container(
                height: 8,
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 2),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text(
              '$percentage%',
              style: TextStyle(
                color: color.withOpacity(0.8),
                fontSize: 12,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _HistoryItem extends StatelessWidget {
  final Meal meal;

  const _HistoryItem({required this.meal});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[800],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.grey[700],
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(
              Icons.history,
              color: Colors.white,
              size: 16,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  DateFormat('MMM d, yyyy').format(meal.date),
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'P: ${meal.proteins.round()}g  C: ${meal.carbs.round()}g  F: ${meal.fats.round()}g',
                  style: const TextStyle(
                    color: Colors.grey,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          Text(
            '${meal.calories.round()} kcal',
            style: const TextStyle(
              color: Colors.orange,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}