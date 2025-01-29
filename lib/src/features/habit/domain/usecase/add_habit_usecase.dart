import '../../habit.dart';

class AddHabit {
  final HabitRepository repository;

  AddHabit(this.repository);

  Future<void> call(Habit habit) async {
    // Carrega os hábitos existentes
    final currentHabits = await repository.loadHabits(habit.date);

    // Adiciona o novo hábito à lista
    currentHabits.add(habit);

    // Salva a lista atualizada
    await repository.saveHabits(currentHabits);
  }
}