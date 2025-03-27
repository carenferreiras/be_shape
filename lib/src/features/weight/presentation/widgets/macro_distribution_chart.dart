import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class MacroDistributionChart extends StatefulWidget {
  final double proteins;
  final double carbs;
  final double fats;

  const MacroDistributionChart({
    super.key,
    required this.proteins,
    required this.carbs,
    required this.fats,
  });

  @override
  State<MacroDistributionChart> createState() => _MacroDistributionChartState();
}

class _MacroDistributionChartState extends State<MacroDistributionChart> {
  int _touchedIndex = -1;

  @override
  Widget build(BuildContext context) {
    final total = widget.proteins + widget.carbs + widget.fats;

    return Column(
      children: [
        SizedBox(
          height: 250,
          child: PieChart(
            PieChartData(
              sectionsSpace: 4, // Espaço entre os setores
              centerSpaceRadius: 50, // Espaço central do gráfico
              borderData: FlBorderData(show: false),
              pieTouchData: PieTouchData(
                touchCallback: (FlTouchEvent event, pieTouchResponse) {
                  setState(() {
                    _touchedIndex =
                        pieTouchResponse?.touchedSection?.touchedSectionIndex ??
                            -1;
                  });
                },
              ),
              sections: _chartSections(total),
            ),
          ),
        ),
        const SizedBox(height: 16),
        // _buildLegend(),
      ],
    );
  }

  List<PieChartSectionData> _chartSections(double total) {
    return [
      _buildSection(0, "Proteínas", widget.proteins, total, Colors.blue,Icons.abc),
      _buildSection(1, "Carboidratos", widget.carbs, total, Colors.green, Icons.wallet),
      _buildSection(2, "Gorduras", widget.fats, total, Colors.red, Icons.offline_bolt),
    ];
  }

  PieChartSectionData _buildSection(
    int index,
    String title,
    double value,
    double total,
    Color color,
    IconData icon,
  ) {
    final isTouched = _touchedIndex == index;
    final fontSize = isTouched ? 18.0 : 14.0;
    final radius = isTouched ? 70.0 : 60.0;
    final percentage = ((value / total) * 100).round();

    return PieChartSectionData(
        color: color,
        value: value,
        title: isTouched ? '$percentage%' : '',
        radius: radius,
        titleStyle: TextStyle(
          fontSize: fontSize,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
        // badgeWidget: _Badge(icon, size: radius, borderColor: color),
        );
  }
}

// ignore: unused_element
class _Badge extends StatelessWidget {
  const _Badge(
    this.icon, {
    required this.size,
    required this.borderColor,
  });
  final IconData icon;
  final double size;
  final Color borderColor;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: PieChart.defaultDuration,
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        border: Border.all(
          color: borderColor,
          width: 2,
        ),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: Colors.black.withAlpha(5),
            offset: const Offset(3, 3),
            blurRadius: 3,
          ),
        ],
      ),
      padding: EdgeInsets.all(size * .15),
      child: Center(child: Icon(icon)),
    );
  }
}
