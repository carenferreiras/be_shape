import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class WeightProgressChart extends StatelessWidget {
  final List<Map<String, dynamic>> history;

  const WeightProgressChart({required this.history, super.key});

  @override
  Widget build(BuildContext context) {
    if (history.isEmpty) {
      return const Center(
        child: Text("Nenhum dado disponível.",
            style: TextStyle(color: Colors.grey)),
      );
    }

    final spots = _generateSpots();
    final minX = spots.first.x;
    final maxX = spots.last.x;
    final minY =
        spots.map((spot) => spot.y).reduce((a, b) => a < b ? a : b) - 3;
    final maxY =
        spots.map((spot) => spot.y).reduce((a, b) => a > b ? a : b) + 3;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: _boxDecoration(Colors.blue),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Evolução do Peso",
            style: TextStyle(
                color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 250,
            child: LineChart(
              LineChartData(
                backgroundColor: Colors.black,
                gridData: _getGridData(),
                titlesData: _getTitlesData(),
                borderData: FlBorderData(show: false),
                minX: minX,
                maxX: maxX,
                minY: minY,
                maxY: maxY,
                lineBarsData: [
                  LineChartBarData(
                    spots: spots,
                    isCurved: true,
                    color: Colors.blueAccent,
                    barWidth: 5,
                    isStrokeCapRound: true,
                    belowBarData: BarAreaData(
                      show: true,
                      color: Colors.blueAccent.withValues(alpha: (0.2)),
                    ),
                    dotData: FlDotData(
                      show: true,
                      getDotPainter: (spot, percent, barData, index) {
                        return FlDotCirclePainter(
                          radius: 6,
                          color: Colors.orangeAccent,
                          strokeWidth: 2,
                          strokeColor: Colors.white,
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<FlSpot> _generateSpots() {
    final baseTime =
        DateTime.parse(history.first['date']).millisecondsSinceEpoch.toDouble();

    return history.map((entry) {
      final time =
          DateTime.parse(entry['date']).millisecondsSinceEpoch.toDouble();
      final weight = (entry['weight'] as num).toDouble();
      return FlSpot((time - baseTime) / (1000 * 60 * 60 * 24), weight);
    }).toList();
  }

  FlTitlesData _getTitlesData() {
    return FlTitlesData(
      bottomTitles: AxisTitles(
        sideTitles: SideTitles(
          showTitles: true,
          reservedSize: 50, 
          interval: 3, 
          getTitlesWidget: (value, meta) {
            final index = value.toInt();
            if (index >= 0 && index < history.length) {
              final date = DateTime.parse(history[index]['date']);
              return Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Transform.rotate(
                  angle: -0.4, // Inclina o texto para melhor leitura
                  child: Text(
                    DateFormat('dd/MM').format(date),
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              );
            }
            return Container();
          },
        ),
      ),
      leftTitles: AxisTitles(
        sideTitles: SideTitles(
          showTitles: true,
          getTitlesWidget: (value, meta) => Padding(
            padding: const EdgeInsets.only(right: 8),
            child: Text(
              "${value.toInt()} kg",
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.bold),
            ),
          ),
          reservedSize: 50,
          interval: 2, 
        ),
      ),
      rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
      topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
    );
  }

  FlGridData _getGridData() {
    return FlGridData(
      show: true,
      drawVerticalLine: true,
      drawHorizontalLine: true,
      getDrawingHorizontalLine: (value) =>
          FlLine(color: Colors.grey.withValues(alpha: (0.3)), strokeWidth: 1),
      getDrawingVerticalLine: (value) =>
          FlLine(color: Colors.grey.withValues(alpha: (0.3)), strokeWidth: 1),
    );
  }

  BoxDecoration _boxDecoration(Color color) {
    return BoxDecoration(
      color: color.withValues(alpha: (0.2)),
      borderRadius: BorderRadius.circular(12),
      border: Border.all(color: color),
    );
  }
}
