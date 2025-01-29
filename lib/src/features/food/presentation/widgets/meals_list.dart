import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../features.dart';

class MealsList extends StatelessWidget {
  final List<Meal> mealsForDate;
  const MealsList({super.key, required this.mealsForDate});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 1,
      child: mealsForDate.isEmpty
          ? Center(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.restaurant_menu,
                      size: 64,
                      color: Colors.grey[700],
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'No meals added yet',
                      style: TextStyle(
                        color: Colors.grey[500],
                        fontSize: 18,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Start tracking your meals by adding food',
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            )
          : ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: mealsForDate.length,
              padding: const EdgeInsets.all(16),
              itemBuilder: (context, index) {
                final meal = mealsForDate[index];
                return MealCardWidget(
                  meal: meal,
                  onDelete: () {
                    context.read<MealBloc>().add(DeleteMeal(meal.id));
                  },
                );
              },
            ),
    );
  }
}
