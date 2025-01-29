

import '../../habit.dart';

class LoadHabits {
  final HabitRepository repository;

  LoadHabits(this.repository);

  Future<List<Habit>> call(String date) async {
    return await repository.loadHabits(date);
  }
}