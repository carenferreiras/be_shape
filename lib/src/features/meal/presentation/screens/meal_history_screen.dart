import 'package:be_shape_app/src/core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../../features.dart';

class MealHistoryScreen extends StatefulWidget {
  const MealHistoryScreen({super.key});

  @override
  State<MealHistoryScreen> createState() => _MealHistoryScreenState();
}

class _MealHistoryScreenState extends State<MealHistoryScreen> {
  @override
  void initState() {
    super.initState();
    final userId = context.read<AuthRepository>().currentUser?.uid;
    if (userId != null) {
      context.read<MealBloc>().add(LoadCompletedMeals(userId));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: const BeShapeAppBar(title:'Histórico de refeições',actionIcon: Icons.receipt_long,),
      body: BlocBuilder<MealBloc, MealState>(
        builder: (context, state) {
          if (state.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          final completedMeals = state.meals
              .where((meal) => meal.isCompleted)
              .toList()
            ..sort((a, b) => b.completedAt!.compareTo(a.completedAt!));

          if (completedMeals.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.history,
                    size: 64,
                    color: Colors.grey[700],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No meal history yet',
                    style: TextStyle(
                      color: Colors.grey[500],
                      fontSize: 18,
                    ),
                  ),
                ],
              ),
            );
          }

          // Group meals by date
          final groupedMeals = <DateTime, List<Meal>>{};
          for (final meal in completedMeals) {
            final date = DateTime(
              meal.date.year,
              meal.date.month,
              meal.date.day,
            );
            groupedMeals.putIfAbsent(date, () => []).add(meal);
          }

          return ListView.builder(
            itemCount: groupedMeals.length,
            itemBuilder: (context, index) {
              final date = groupedMeals.keys.elementAt(index);
              final meals = groupedMeals[date]!;
              
              // Calculate daily totals
              double totalCalories = 0;
              double totalProteins = 0;
              double totalCarbs = 0;
              double totalFats = 0;

              for (final meal in meals) {
                totalCalories += meal.calories;
                totalProteins += meal.proteins;
                totalCarbs += meal.carbs;
                totalFats += meal.fats;
              }

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      DateFormat('EEEE, MMMM d').format(date),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 16),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.grey[900],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Daily Total',
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 14,
                              ),
                            ),
                            Text(
                              '${totalCalories.round()} kcal',
                              style: const TextStyle(
                                color: Colors.orange,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            _MacroSummary(
                              label: 'Protein',
                              value: totalProteins,
                              color: Colors.blue,
                            ),
                            _MacroSummary(
                              label: 'Carbs',
                              value: totalCarbs,
                              color: Colors.green,
                            ),
                            _MacroSummary(
                              label: 'Fat',
                              value: totalFats,
                              color: Colors.red,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  ...meals.map((meal) => _MealHistoryItem(meal: meal)),
                  const Divider(color: Colors.grey),
                ],
              );
            },
          );
        },
      ),
    );
  }
}

class _MacroSummary extends StatelessWidget {
  final String label;
  final double value;
  final Color color;

  const _MacroSummary({
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          '${value.round()}g',
          style: TextStyle(
            color: color,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: const TextStyle(
            color: Colors.grey,
            fontSize: 12,
          ),
        ),
      ],
    );
  }
}

class _MealHistoryItem extends StatelessWidget {
  final Meal meal;

  const _MealHistoryItem({required this.meal});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.grey[800],
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(
              Icons.restaurant,
              color: Colors.white,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  meal.name,
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