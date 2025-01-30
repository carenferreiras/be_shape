import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import '../../../../core/core.dart';
import '../../../features.dart';

class DailyHabitsSection extends StatelessWidget {
  const DailyHabitsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HabitBloc, HabitState>(
      builder: (context, state) {
        if (state is HabitsLoading) {
          return const Center(child: SpinKitThreeBounce(color: BeShapeColors.primary,));
        } else if (state is HabitsLoaded) {
          if (state.habits.isEmpty) {
            return const Center(
              child: Text(
                "Nenhum hábito registrado para hoje",
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
            );
          }

          return SizedBox(
            height:
                200, // 🛑 Define um tamanho fixo para exibir os hábitos horizontalmente
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: state.habits.length,
              itemBuilder: (context, index) {
                final habit = state.habits[index];
                return Container(
                  width: 160, // Define a largura de cada card
                  margin: const EdgeInsets.only(right: 16),
                  child: HabitCard(habit: habit),
                );
              },
            ),
          );
        } else if (state is HabitError) {
          return Center(
            child: Text(
              state.message,
              style: const TextStyle(color: Colors.red, fontSize: 16),
            ),
          );
        }
        return const SizedBox.shrink();
      },
    );
  }
}