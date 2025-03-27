
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../../../../core/core.dart';

class MacronutrientPieChart extends StatelessWidget {
  final double proteins;
  final double carbs;
  final double fats;

  const MacronutrientPieChart({
    super.key,
    required this.proteins,
    required this.carbs,
    required this.fats,
  });

  @override
  Widget build(BuildContext context) {
    double total = proteins + carbs + fats;
    double proteinPercentage = (proteins / total) * 100;
    double carbPercentage = (carbs / total) * 100;
    double fatPercentage = (fats / total) * 100;

    return Column(
      children: [
        SizedBox(
          height: 200,
          child: PieChart(
            PieChartData(
              sectionsSpace: 2,
              centerSpaceRadius: 40,
              sections: [
                PieChartSectionData(
                  value: proteinPercentage,
                  title: '${proteinPercentage.toStringAsFixed(1)}%',
                  color: Colors.blue,
                  radius: 50,
                ),
                PieChartSectionData(
                  value: carbPercentage,
                  title: '${carbPercentage.toStringAsFixed(1)}%',
                  color: Colors.orange,
                  radius: 50,
                ),
                PieChartSectionData(
                  value: fatPercentage,
                  title: '${fatPercentage.toStringAsFixed(1)}%',
                  color: Colors.red,
                  radius: 50,
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildLegend(Colors.blue, "Proteínas"),
            _buildLegend(Colors.orange, "Carboidratos"),
            _buildLegend(Colors.red, "Gorduras"),
          ],
        ),
      ],
    );
  }

  Widget _buildLegend(Color color, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Row(
        children: [
          Container(width: 12, height: 12, color: color),
          const SizedBox(width: 5),
          Text(text, style:  TextStyle(fontSize: 14,color: BeShapeColors.textPrimary)),
        ],
      ),
    );
  }
}