import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../features/features.dart';
import '../core.dart';

class FitnessMetrics extends StatelessWidget {
  final UserProfile userProfile;

  const FitnessMetrics({
    super.key,
    required this.userProfile,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MealBloc, MealState>(
      builder: (context, mealState) {
        return BlocBuilder<ExerciseBloc, ExerciseState>(
          builder: (context, exerciseState) {
            final targetCalories = userProfile.tdee;
            final consumedCalories = mealState.meals.fold<double>(
              0,
              (sum, meal) => sum + meal.calories,
            );

            final burnedCalories = exerciseState.exercises.fold<double>(
              0,
              (sum, exercise) => sum + exercise.caloriesBurned,
            );

            final remainingCalories = targetCalories + burnedCalories - consumedCalories;

            return Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24),
                border: Border.all(
                  color: BeShapeColors.primary.withOpacity(0.2),
                  width: 1,
                ),
              ),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: const BoxDecoration(
                     
                      borderRadius: BorderRadius.all(
                        Radius.circular(24),
                      ),
                    ),
                    child: Row(
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
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  '${remainingCalories.round()}',
                                  style: TextStyle(
                                    color: remainingCalories < 0
                                        ? Colors.red
                                        : Colors.green,
                                    fontSize: 32,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(width: 4),
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 4),
                                  child: Text(
                                    'kcal',
                                    style: TextStyle(
                                      color: remainingCalories < 0
                                          ? Colors.red
                                          : Colors.green,
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            _buildCalorieInfo(
                              'Consumido',
                              consumedCalories,
                              BeShapeColors.primary,
                            ),
                            const SizedBox(width: 24),
                            _buildCalorieInfo(
                              'Queimado',
                              burnedCalories,
                              Colors.orange,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
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
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              '${value.round()}',
              style: TextStyle(
                color: color,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(width: 2),
            Padding(
              padding: const EdgeInsets.only(bottom: 3),
              child: Text(
                'kcal',
                style: TextStyle(
                  color: color,
                  fontSize: 12,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}