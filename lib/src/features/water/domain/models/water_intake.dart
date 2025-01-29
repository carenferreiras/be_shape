import '../../water.dart';

class WaterIntake {
  final DateTime date;
  final int totalIntake;
  final List<WaterEntry> entries;

  WaterIntake({
    required this.date,
    required this.totalIntake,
    List<WaterEntry>? entries,
  }) : entries = entries ?? []; // Inicializa como lista vazia se nulo
}