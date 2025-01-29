import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';

import '../../features/features.dart';
import '../core.dart';

class RecentMeals extends StatelessWidget {
  const RecentMeals({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Recent Meals',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            TextButton(
              onPressed: () {
                // Navigate to meals history
              },
              child: const Text('See All'),
            ),
          ],
        ),
        const SizedBox(height: 8),
        BlocBuilder<MealBloc, MealState>(
          builder: (context, state) {
            if (state.isLoading) {
              return const Center(child: SpinKitThreeBounce(color: BeShapeColors.primary,));
            }

            if (state.meals.isEmpty) {
              return const Center(
                child: Text('No meals recorded yet'),
              );
            }

            return ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: state.meals.length.clamp(0, 3), // Show max 3 recent meals
              itemBuilder: (context, index) {
                final meal = state.meals[index];
                return Card(
                  child: ListTile(
                    leading: meal.photoUrl != null
                        ? CircleAvatar(
                            backgroundImage: NetworkImage(meal.photoUrl!),
                          )
                        : CircleAvatar(
                            child: Icon(
                              Icons.restaurant,
                              color: Theme.of(context).colorScheme.onPrimary,
                            ),
                          ),
                    title: Text(meal.name),
                    subtitle: Text(
                      DateFormat('MMM d, h:mm a').format(meal.date),
                    ),
                    trailing: Text(
                      '${meal.calories.toStringAsFixed(0)} kcal',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                );
              },
            );
          },
        ),
      ],
    );
  }
}