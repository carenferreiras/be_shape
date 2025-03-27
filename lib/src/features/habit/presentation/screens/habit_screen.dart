import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';

import '../../../../core/core.dart';
import '../../habit.dart';

class HabitsScreen extends StatefulWidget {
  const HabitsScreen({super.key});

  @override
  State<HabitsScreen> createState() => _HabitsScreenState();
}

class _HabitsScreenState extends State<HabitsScreen> {
  DateTime _selectedDate = DateTime.now(); // Data selecionada

  @override
  void initState() {
    super.initState();
    _loadHabitsForDate();
  }

  void _onDateSelected(DateTime pickedDate) {
    setState(() {
      _selectedDate = pickedDate;
      _loadHabitsForDate();
    });
  }

  void _loadHabitsForDate() {
    context.read<HabitBloc>().add(LoadHabitsEvent(_formatDate(_selectedDate)));
  }

  String _formatDate(DateTime date) {
    return DateFormat('yyyy-MM-dd').format(date);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: BeShapeColors.background,
      appBar: const BeShapeAppBar(
        title: 'Hábitos',
        actionIcon: Icons.free_breakfast,
      ),
      body: Column(
        children: [
          _buildDateSelector(),
          Expanded(
            child: BlocBuilder<HabitBloc, HabitState>(
              builder: (context, state) {
                if (state is HabitsLoading) {
                  return const Center(
                      child: SpinKitWaveSpinner(
                    color: BeShapeColors.primary,
                  ));
                } else if (state is HabitsLoaded) {
                  final habits = state.habits;
                  return Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: GridView.builder(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 16,
                        mainAxisSpacing: 16,
                      ),
                      itemCount: habits.length,
                      itemBuilder: (context, index) {
                        final habit = habits[index];
                        return HabitCard(
                          habit: habit,
                        );
                      },
                    ),
                  );
                } else if (state is HabitError) {
                  return Center(child: Text(state.message));
                }
                return const Center(child: Text("No habits for this day"));
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _navigateToAddHabit(context),
        backgroundColor: BeShapeColors.primary.withValues(alpha: (0.2)),
        child: const Icon(
          Icons.add,
          color: BeShapeColors.primary,
        ),
      ),
    );
  }

  /// 📆 **Seletor de Data**
  Widget _buildDateSelector() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => _onDateSelected(
                _selectedDate.subtract(const Duration(days: 1))),
          ),
          Text(
            DateFormat('EEEE, MMM dd, yyyy').format(_selectedDate),
            style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: BeShapeColors.backgroundLight),
          ),
          IconButton(
            icon: const Icon(Icons.arrow_forward),
            onPressed: () =>
                _onDateSelected(_selectedDate.add(const Duration(days: 1))),
          ),
        ],
      ),
    );
  }

  /// 📌 **Navegar para a Tela de Adicionar Hábito**
  Future<void> _navigateToAddHabit(BuildContext context) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            AddHabitScreen(selectedDate: _formatDate(_selectedDate)),
      ),
    );
  }
}
