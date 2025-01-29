import 'package:flutter/material.dart';
import '../../habit.dart';

class EmotionReportScreen extends StatelessWidget {
  final List<Habit> habits;

  const EmotionReportScreen({required this.habits, super.key});

  @override
  Widget build(BuildContext context) {
    final emotionCounts = _getEmotionCounts(habits);
    final total = emotionCounts.values.fold(0, (sum, value) => sum + value);
    final emotionData = emotionCounts.entries
        .map((entry) => EmotionData(entry.key, entry.value))
        .toList();

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 16),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.grey[800],
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Row(
              children: [
                Icon(Icons.calendar_today, color: Colors.white, size: 16),
                SizedBox(width: 8),
                Text("Jan", style: TextStyle(color: Colors.white)),
              ],
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Emotion Stats",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 32),

            /// 🔹 **Barras de Emoções**
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: emotionData.map((data) {
                final percentage = (data.count / total * 100).round();
                return _buildEmotionBar(
                  percentage: percentage,
                  color: _getEmotionColor(data.emotion),
                  icon: _getEmotionIcon(data.emotion), 
                  emotion: data.emotion,
                );
              }).toList(),
            ),
            const SizedBox(height: 32),

            /// 🔹 **Detalhes das Emoções**
            ...emotionData.map((data) {
              final color = _getEmotionColor(data.emotion);
              final value = "${data.count} vezes";
              return Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: _buildEmotionDetailRow(
                  color: color,
                  label: data.emotion,
                  value: value,
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  /// 🔹 **Barras de Emoções**
  Widget _buildEmotionBar({
    required int percentage,
    required Color color,
    required IconData icon,
    required String emotion,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Column(
        children: [
          Container(
            height: 150,
            width: 70,
            decoration: BoxDecoration(
              color: _getEmotionColorBar(emotion),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Stack(
              alignment: Alignment.bottomCenter,
              children: [
                Container(
                  height: (percentage / 100) * 150, // Altura proporcional ao percentual
                  width: 70,
                  decoration: BoxDecoration(
                    color: color,
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                Align(
                  alignment: Alignment.topCenter,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Icon(icon, color: Colors.white, size: 20),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            "$percentage%",
            style: const TextStyle(color: Colors.white, fontSize: 14),
          ),
        ],
      ),
    );
  }

  /// 🔹 **Detalhes das Emoções**
  Widget _buildEmotionDetailRow({
    required Color color,
    required String label,
    required String value,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            CircleAvatar(
              radius: 6,
              backgroundColor: color,
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: const TextStyle(color: Colors.white, fontSize: 16),
            ),
          ],
        ),
        Text(
          value,
          style: const TextStyle(color: Colors.grey, fontSize: 16),
        ),
      ],
    );
  }

  /// 🔹 **Ícones para Emoções**
  IconData _getEmotionIcon(String emotion) {
    switch (emotion) {
      case 'Feliz':
        return Icons.sentiment_very_satisfied;
      case 'Triste':
        return Icons.sentiment_dissatisfied;
      case 'Ansioso':
        return Icons.sentiment_neutral;
      case 'Relaxado':
        return Icons.self_improvement;
      case 'Cansado':
        return Icons.battery_alert;
      default:
        return Icons.help_outline;
    }
  }

  /// 🔹 **Cores para Emoções**
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

   /// 🔹 **Cores para Emoções**
  Color _getEmotionColorBar(String emotion) {
    switch (emotion) {
      case 'Feliz':
        return Colors.green.withOpacity(0.2);
      case 'Triste':
        return Colors.blue.withOpacity(0.2);
      case 'Ansioso':
        return Colors.yellow.withOpacity(0.2);
      case 'Relaxado':
        return Colors.purple.withOpacity(0.2);
      case 'Cansado':
        return Colors.orange.withOpacity(0.2);
      default:
        return Colors.grey.withOpacity(0.2);
    }
  }

  /// 🔹 **Contagem de Emoções**
  Map<String, int> _getEmotionCounts(List<Habit> habits) {
    final emotionCounts = <String, int>{};

    for (final habit in habits) {
      for (final checkIn in habit.checkIns) {
        emotionCounts[checkIn.emotion] = (emotionCounts[checkIn.emotion] ?? 0) + 1;
      }
    }

    return emotionCounts;
  }
}

/// 📌 **Modelo de Dados para Gráfico**
class EmotionData {
  final String emotion;
  final int count;

  EmotionData(this.emotion, this.count);
}