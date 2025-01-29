// ignore_for_file: avoid_print

import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

import '../../habit.dart';


class HabitService implements HabitRepository {

  static const String keyPrefix = 'habits_';

  String _getStorageKey(String date) {
    return '$keyPrefix$date';
  }


  @override
  @override
Future<void> saveHabits(List<Habit> habits) async {
  final prefs = await SharedPreferences.getInstance();
  if (habits.isEmpty) {
    await prefs.remove(_getStorageKey(DateTime.now().toString().split(" ")[0])); // 🔥 Remove a chave se não houver hábitos
    print("All habits deleted for this date.");
    return;
  }

  final String date = habits.isNotEmpty ? habits.first.date : "";
  if (date.isEmpty) return;

  List<String> habitsJson =
      habits.map((habit) => jsonEncode(habit.toJson())).toList();
  await prefs.setStringList(_getStorageKey(date), habitsJson);
  print("Habits saved successfully for date $date: ${habits.length}");
}

  @override
  Future<List<Habit>> loadHabits(String date) async {
     final prefs = await SharedPreferences.getInstance();
    List<String>? habitsJson = prefs.getStringList(_getStorageKey(date));
    if (habitsJson == null) {
      print("No habits found for date $date");
      return [];
    }
    return habitsJson
        .map((habitJson) => Habit.fromJson(jsonDecode(habitJson)))
        .toList();
  }
}