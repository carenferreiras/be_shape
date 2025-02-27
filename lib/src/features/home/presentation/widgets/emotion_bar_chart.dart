import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import '../../../../core/core.dart';
import '../../../features.dart';

class EmotionBarChart extends StatelessWidget {
  const EmotionBarChart({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HabitBloc, HabitState>(
      builder: (context, state) {
        if (state is HabitsLoading) {
          return const Center(child: SpinKitWaveSpinner(color: BeShapeColors.primary,));
        } else if (state is HabitsLoaded) {
          final emotionCounts = _getEmotionCounts(state.habits);
          final total =
              emotionCounts.values.fold(0, (sum, value) => sum + value);

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: emotionCounts.entries.map((entry) {
              final emotion = entry.key;
              final count = entry.value;
              final percentage = total > 0 ? (count / total * 100).round() : 0;

              return Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: EmotionBar(
                  emotion: emotion,
                  percentage: percentage,
                  count: count,
                  color: getEmotionColor(emotion),
                ),
              );
            }).toList(),
          );
        }
        return const SizedBox.shrink();
      },
    );
  }
   /// 🔹 **Calcula as Emoções**
  Map<String, int> _getEmotionCounts(List<Habit> habits) {
    final emotionCounts = <String, int>{};

    for (final habit in habits) {
      for (final checkIn in habit.checkIns) {
        emotionCounts[checkIn.emotion] =
            (emotionCounts[checkIn.emotion] ?? 0) + 1;
      }
    }

    return emotionCounts;
  }

}