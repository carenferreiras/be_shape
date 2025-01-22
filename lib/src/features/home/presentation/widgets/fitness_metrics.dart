import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../features.dart';


class FitnessMetrics extends StatelessWidget {
  final UserProfile userProfile;

  const FitnessMetrics({
    super.key,
    required this.userProfile,
  });

  double _calculateTargetCalories() {
    switch (userProfile.goal.toLowerCase()) {
      case 'lose_weight':
        return userProfile.tdee - 500;
      case 'bulk':
        return userProfile.tdee + 300;
      default:
        return userProfile.tdee;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MealBloc, MealState>(
      builder: (context, state) {
        final targetCalories = _calculateTargetCalories();
        final consumedCalories = state.meals.fold<double>(
          0,
          (sum, meal) => sum + meal.calories,
        );
        final remainingCalories = targetCalories - consumedCalories;

        return Row(
          children: [
            Expanded(
              child: _MetricCard(
                title: 'Remaining',
                value: '${remainingCalories.round()} kcal',
                color: remainingCalories < 0 ? Colors.red : Colors.green,
                icon: Icons.local_fire_department,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _MetricCard(
                title: 'Target',
                value: '${targetCalories.round()} kcal',
                color: Colors.orange,
                icon: Icons.track_changes,
              ),
            ),
          ],
        );
      },
    );
  }
}

class _MetricCard extends StatelessWidget {
  final String title;
  final String value;
  final Color color;
  final IconData icon;

  const _MetricCard({
    required this.title,
    required this.value,
    required this.color,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: TextStyle(
                  color: color,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Icon(
                icon,
                color: color,
                size: 20,
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              color: color,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}