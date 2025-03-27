import 'package:flutter/material.dart';

import '../../../../core/core.dart';
import '../../../auth/auth.dart';

class NutritionSummaryCard extends StatelessWidget {
  final double remaining;
  final double totalCalories;
  final double targetCalories;
  final double totalProteins;
  final UserProfile userProfile;
  final double totalCarbs;
  final double totalFats;
  const NutritionSummaryCard(
      {super.key,
      required this.remaining,
      required this.totalCalories,
      required this.targetCalories,
      required this.totalProteins,
      required this.userProfile,
      required this.totalCarbs,
      required this.totalFats});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
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
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: BeShapeColors.primary.withValues(alpha: (0.2)),
        ),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Restante',
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${remaining.round()}',
                    style: TextStyle(
                      color: remaining < 0 ? Colors.red : BeShapeColors.accent,
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'kcal',
                    style: TextStyle(
                      color: remaining < 0 ? Colors.red : BeShapeColors.accent,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  _buildCalorieInfo(
                    'Consumido',
                    totalCalories,
                    BeShapeColors.primary,
                  ),
                  const SizedBox(width: 24),
                  _buildCalorieInfo(
                    'Máximo',
                    targetCalories,
                    BeShapeColors.link,
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 24),
          _buildMacroProgress(
            'Proteína',
            totalProteins,
            userProfile.macroTargets.proteins,
            BeShapeColors.link,
          ),
          const SizedBox(height: 12),
          _buildMacroProgress(
            'Carboidrato',
            totalCarbs,
            userProfile.macroTargets.carbs,
            BeShapeColors.accent,
          ),
          const SizedBox(height: 12),
          _buildMacroProgress(
            'Gordura',
            totalFats,
            userProfile.macroTargets.fats,
            Colors.red,
          ),
        ],
      ),
    );
  }

  Widget _buildCalorieInfo(String label, double value, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Colors.grey,
            fontSize: 14,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          '${value.round()}',
          style: TextStyle(
            color: color,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          'kcal',
          style: TextStyle(
            color: color,
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  Widget _buildMacroProgress(
    String label,
    double value,
    double target,
    Color color,
  ) {
    final progress = (value / target).clamp(0.0, 1.0);
    final percentage = (progress * 100).round();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
              ),
            ),
            Text(
              '${value.round()}/${target.round()}g',
              style: TextStyle(
                color: color,
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Stack(
          children: [
            Container(
              height: 8,
              decoration: BoxDecoration(
                color: color.withValues(alpha: (0.2)),
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
        const SizedBox(height: 4),
        Align(
          alignment: Alignment.centerRight,
          child: Text(
            '$percentage%',
            style: TextStyle(
              color: color,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}
