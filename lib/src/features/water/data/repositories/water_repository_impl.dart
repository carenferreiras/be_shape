import 'dart:convert';

import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../water.dart';

class WaterRepositoryImpl implements WaterRepository {
  static const String _waterKey = 'daily_water_intake';
  static const String _entriesKey = 'daily_water_entries';
  static const String _dateKey = 'intake_date';

  @override
  Future<void> updateWaterIntake(int intake) async {
    final prefs = await SharedPreferences.getInstance();
    final today = DateTime.now();
    final currentDate = prefs.getString(_dateKey);

    // Inicializa as entradas de água
    List<WaterEntry> entries = [];
    int currentIntake = 0;

    // Se os dados forem do mesmo dia, carrega as entradas existentes
    if (currentDate == today.toIso8601String().split('T').first) {
      currentIntake = prefs.getInt(_waterKey) ?? 0;

      final entriesJson = prefs.getStringList(_entriesKey) ?? [];
      entries =
          entriesJson.map((e) => WaterEntry.fromJson(jsonDecode(e))).toList();
    }

    // Adiciona o novo registro
    currentIntake += intake;
    entries.add(WaterEntry(
      time: DateFormat('h:mm a').format(today),
      amount: intake,
    ));

    // Salva os dados no SharedPreferences
    await prefs.setInt(_waterKey, currentIntake);
    await prefs.setStringList(
      _entriesKey,
      entries.map((e) => jsonEncode(e.toJson())).toList(),
    );
    await prefs.setString(_dateKey, today.toIso8601String().split('T').first);
  }

  @override
  Future<WaterIntake> getCurrentIntake() async {
    final prefs = await SharedPreferences.getInstance();

    // Obtém o total de água consumida
    final currentIntake = prefs.getInt(_waterKey) ?? 0;

    // Obtém as entradas de água
    final entriesJson = prefs.getStringList(_entriesKey) ?? [];
    final entries =
        entriesJson.map((e) => WaterEntry.fromJson(jsonDecode(e))).toList();

    // Retorna os dados de consumo
    return WaterIntake(
      date: DateTime.now(),
      totalIntake: currentIntake,
      entries: entries, // Garante que entries seja sempre uma lista válida
    );
  }
  
  @override
  Future<void> removeWaterEntry(WaterEntry entry) {
    throw UnimplementedError();
  }

  
}
