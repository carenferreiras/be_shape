import 'package:flutter/material.dart';

import '../../../features.dart';

class WorkoutCard extends StatelessWidget {
  final UserProfile userProfile;

  const WorkoutCard({
    super.key,
    required this.userProfile,
  });

  String _getWorkoutTitle() {
    switch (userProfile.goal.toLowerCase()) {
      case 'lose_weight':
        return 'Fat Burning HIIT';
      case 'bulk':
        return 'Upper Strength';
      case 'endurance':
        return 'Endurance Training';
      default:
        return 'Daily Workout';
    }
  }

  @override
  Widget build(BuildContext context) {
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
                'Workouts',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                '(25)',
                style: TextStyle(
                  color: Colors.grey[400],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: Colors.grey[800],
                ),
                child: const Icon(
                  Icons.fitness_center,
                  color: Colors.white,
                  size: 40,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _getWorkoutTitle(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        _WorkoutStat(
                          icon: Icons.timer,
                          value: '25min',
                        ),
                        const SizedBox(width: 16),
                        _WorkoutStat(
                          icon: Icons.local_fire_department,
                          value: '${(userProfile.tdee * 0.15).round()}kcal',
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.orange,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.play_arrow,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _WorkoutStat extends StatelessWidget {
  final IconData icon;
  final String value;

  const _WorkoutStat({
    required this.icon,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          icon,
          color: Colors.grey[400],
          size: 16,
        ),
        const SizedBox(width: 4),
        Text(
          value,
          style: TextStyle(
            color: Colors.grey[400],
          ),
        ),
      ],
    );
  }
}