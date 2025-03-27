import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/core.dart';
import '../../../features.dart';

class ActivityLevelStep extends StatelessWidget {
  const ActivityLevelStep({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OnboardingBloc, OnboardingState>(
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.all(24.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'How active are you?',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    height: 1.2,
                  ),
                ),
                const SizedBox(height: 32),
                _buildActivityOption(
                  context,
                  'Sedentary',
                  'Little or no exercise',
                  Icons.weekend,
                  1.2,
                  state.activityLevel == 1.2,
                ),
                _buildActivityOption(
                  context,
                  'Lightly Active',
                  'Light exercise 1-3 days/week',
                  Icons.directions_walk,
                  1.375,
                  state.activityLevel == 1.375,
                ),
                _buildActivityOption(
                  context,
                  'Moderately Active',
                  'Moderate exercise 3-5 days/week',
                  Icons.directions_run,
                  1.55,
                  state.activityLevel == 1.55,
                ),
                _buildActivityOption(
                  context,
                  'Very Active',
                  'Hard exercise 6-7 days/week',
                  Icons.fitness_center,
                  1.725,
                  state.activityLevel == 1.725,
                ),
                _buildActivityOption(
                  context,
                  'Extra Active',
                  'Very hard exercise & physical job',
                  Icons.sports_martial_arts,
                  1.9,
                  state.activityLevel == 1.9,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildActivityOption(
    BuildContext context,
    String title,
    String subtitle,
    IconData icon,
    double level,
    bool isSelected,
  ) {
    return GestureDetector(
      onTap: () {
        context.read<OnboardingBloc>().add(UpdateActivityLevel(level));
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: isSelected
              ? BeShapeColors.primary.withValues(alpha: (0.1))
              : Colors.grey[900],
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? BeShapeColors.primary : Colors.transparent,
            width: 2,
          ),
        ),
        child: ListTile(
          leading: Icon(
            icon,
            color: isSelected ? BeShapeColors.primary : Colors.grey,
          ),
          title: Text(
            title,
            style: TextStyle(
              color: isSelected ? BeShapeColors.primary : Colors.white,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          subtitle: Text(
            subtitle,
            style: TextStyle(
              color: isSelected
                  ? BeShapeColors.primary.withValues(alpha: (0.7))
                  : Colors.grey,
            ),
          ),
          trailing: isSelected
              ? const Icon(
                  Icons.check_circle,
                  color: BeShapeColors.primary,
                )
              : null,
        ),
      ),
    );
  }
}
