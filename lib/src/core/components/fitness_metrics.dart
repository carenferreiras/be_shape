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
      builder: (context, mealState) {
        return BlocBuilder<ExerciseBloc, ExerciseState>(
          builder: (context, exerciseState) {
            final targetCalories = _calculateTargetCalories();
            final consumedCalories = mealState.meals.fold<double>(
              0,
              (sum, meal) => sum + meal.calories,
            );
            final burnedCalories = exerciseState.exercises.fold<double>(
              0,
              (sum, exercise) => sum + exercise.caloriesBurned,
            );
            final remainingCalories = targetCalories + burnedCalories - consumedCalories;

            // Calculate total exercise duration
            final totalDuration = exerciseState.exercises.fold<int>(
              0,
              (sum, exercise) => sum + exercise.duration,
            );

            return Container(
              decoration: BoxDecoration(
                color: BeShapeColors.background,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(
                  color: BeShapeColors.primary.withOpacity(0.3),
                  width: 1,
                ),
              ),
              child: Column(
                children: [
                  // Calories Section
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          BeShapeColors.primary.withOpacity(0.2),
                         
                          BeShapeColors.background.withOpacity(0.4),
                        ],
                      ),
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(24),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Calorias Restantes',
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
                                    color: remainingCalories < 0 ? Colors.red : Colors.green,
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
                                      color: remainingCalories < 0 ? Colors.red : Colors.green,
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
                              'Consumidas',
                              consumedCalories,
                              BeShapeColors.primary,
                            ),
                            const SizedBox(width: 24),
                            _buildCalorieInfo(
                              'Queimadas',
                              burnedCalories,
                              Colors.orange,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  // Exercise Summary
                  if (exerciseState.exercises.isNotEmpty)
                    Container(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Exercícios de Hoje',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 6,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.orange.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Text(
                                  '$totalDuration min',
                                  style: const TextStyle(
                                    color: Colors.orange,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          ...exerciseState.exercises.map((exercise) => Container(
                            margin: const EdgeInsets.only(bottom: 8),
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.grey[850],
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: Colors.orange.withOpacity(0.2),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: const Icon(
                                    Icons.fitness_center,
                                    color: Colors.orange,
                                    size: 20,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        exercise.name,
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      Text(
                                        '${exercise.duration} min',
                                        style: const TextStyle(
                                          color: Colors.grey,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 6,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.orange.withOpacity(0.2),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Text(
                                    '${exercise.caloriesBurned.round()} kcal',
                                    style: const TextStyle(
                                      color: Colors.orange,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          )).toList(),
                          TextButton(
                            onPressed: () {
                              Navigator.pushNamed(context, '/add-exercise');
                            },
                            style: TextButton.styleFrom(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 24,
                                vertical: 12,
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.add_circle_outline,
                                  color: Colors.orange[300],
                                  size: 20,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  'Adicionar Exercício',
                                  style: TextStyle(
                                    color: Colors.orange[300],
                                  ),
                                ),
                              ],
                            ),
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