import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import '../../habit.dart';
import 'dart:ui'; // ✅ Importação correta

class EmotionReportScreen extends StatelessWidget {
  final List<Habit> habits;

  const EmotionReportScreen({required this.habits, super.key});

  @override
  Widget build(BuildContext context) {
    final emotionCounts = _getEmotionCounts(habits);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Relatórios Emocionais"),
        backgroundColor: Colors.black,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Distribuição de Emoções",
              style: TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            _buildEmotionPieChart(emotionCounts),
            const SizedBox(height: 24),
            const Text(
              "Estatísticas Detalhadas",
              style: TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView(
                children: emotionCounts.entries.map((entry) {
                  return ListTile(
                    title: Text(
                      "${entry.key}: ${entry.value} vezes",
                      style: const TextStyle(color: Colors.white),
                    ),
                    leading: const Icon(
                      Icons.emoji_emotions,
                      color: Colors.orange,
                    ),
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// 📊 **Gráfico de Pizza para as Emoções**
  Widget _buildEmotionPieChart(Map<String, int> emotionCounts) {
    final sections = emotionCounts.entries
        .map(
          (entry) => PieChartSectionData(
  value: entry.value.toDouble(),
  title: entry.key,
  color: _getEmotionColor(entry.key).withOpacity(1), // ✅ Garantindo opacidade correta
  radius: 50,
)
        )
        .toList();

    return PieChart(
      PieChartData(
        sections: sections,
        centerSpaceRadius: 40,
        borderData: FlBorderData(show: false),
      ),
    );
  }

  /// 📊 **Calcula a Contagem de Emoções**
  Map<String, int> _getEmotionCounts(List<Habit> habits) {
    final emotionCounts = <String, int>{};

    for (final habit in habits) {
      for (final checkIn in habit.checkIns) {
        emotionCounts[checkIn.emotion] = (emotionCounts[checkIn.emotion] ?? 0) + 1;
      }
    }

    return emotionCounts;
  }

  /// 🔹 **Define cores para cada emoção**
  Color _getEmotionColor(String emotion) {
    switch (emotion) {
      case 'Feliz':
        return Colors.green;
      case 'Triste':
        return Colors.blue;
      case 'Ansioso':
        return Colors.yellow;
      case 'Relaxado':
        return Colors.purple;
      case 'Cansado':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }
}