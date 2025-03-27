import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../features/habit/habit.dart';

class HabitCard extends StatelessWidget {
  final Habit habit;
  const HabitCard({super.key, required this.habit});

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: habit.category.color.withValues(alpha: (0.1)),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: (0.1)),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child:
            Column(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
          CircleAvatar(
            backgroundColor: habit.category.color,
            radius: 30,
            child: Icon(
              habit.category.icon,
              size: 30,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          Flexible(
            child: Text(
              habit.title,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: habit.category.color,
              ),
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            "${habit.progress}%",
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          ElevatedButton(
            onPressed: () {
              if (habit.progress < 100) {
                final updatedHabit = habit.copyWith(
                  progress:
                      habit.progress + 10 > 100 ? 100 : habit.progress + 10,
                );

                context.read<HabitBloc>().add(UpdateHabitEvent(updatedHabit));

                // Abre a tela para check-in emocional
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => EmotionCheckInScreen(
                      onSaveEmotion: (emotion) {
                        final checkIn = EmotionCheckIn(
                          emotion: emotion,
                          date: habit.date,
                        );

                        // Chama o evento AddEmotionCheckInEvent
                        context.read<HabitBloc>().add(
                              AddEmotionCheckInEvent(habit, checkIn),
                            );
                      },
                    ),
                  ),
                );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: habit.category.color,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text("+10%", style: TextStyle(color: Colors.white)),
          )
        ]));
  }
}
