import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../features.dart';
import '../../../../core/core.dart';

class GoalSelectionStep extends StatelessWidget {
  const GoalSelectionStep({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OnboardingBloc, OnboardingState>(
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "What's your fitness\ngoal/target?",
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  height: 1.2,
                ),
              ),
              const SizedBox(height: 32),
              _buildGoalOption(
                context,
                'I wanna lose weight',
                Icons.fitness_center,
                state.selectedGoal == 'lose_weight',
                'lose_weight',
              ),
              _buildGoalOption(
                context,
                'I wanna try AI Coach',
                Icons.psychology,
                state.selectedGoal == 'ai_coach',
                'ai_coach',
              ),
              _buildGoalOption(
                context,
                'I wanna get bulks',
                Icons.sports_gymnastics,
                state.selectedGoal == 'bulk',
                'bulk',
              ),
              _buildGoalOption(
                context,
                'I wanna gain endurance',
                Icons.directions_run,
                state.selectedGoal == 'endurance',
                'endurance',
              ),
              _buildGoalOption(
                context,
                'Just trying out the app! 👍',
                Icons.thumb_up,
                state.selectedGoal == 'try_out',
                'try_out',
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildGoalOption(
    BuildContext context,
    String title,
    IconData icon,
    bool isSelected,
    String goalValue,
  ) {
    return GestureDetector(
      onTap: () {
        context.read<OnboardingBloc>().add(UpdateGoal(goalValue));
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: isSelected ? BeShapeColors.primary.withOpacity(0.1) : Colors.grey[900],
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