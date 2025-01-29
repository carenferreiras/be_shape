import '../../habit.dart';

abstract class HabitRepository {
  Future<void> saveHabits(List<Habit> habits);
  Future<List<Habit>> loadHabits(String date);
}