// lib/src/features/home/widgets/bmi_chart.dart
import 'dart:math';

import 'package:flutter/material.dart';
import '../../../../core/core.dart';
import '../../../features.dart';

class BMIChart extends StatelessWidget {
  final List<BMIHistory> history;

  const BMIChart({
    super.key,
    required this.history,
  });

  @override
  Widget build(BuildContext context) {
    if (history.isEmpty) {
      return const SizedBox();
    }

    final sortedHistory = List<BMIHistory>.from(history)
      ..sort((a, b) => a.date.compareTo(b.date));

    final minBMI = sortedHistory.map((e) => e.bmi).reduce(min);
    final maxBMI = sortedHistory.map((e) => e.bmi).reduce(max);
    final range = maxBMI - minBMI;

    return Container(
      height: 200,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[850],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Expanded(
            child: CustomPaint(
              size: const Size(double.infinity, double.infinity),
              painter: _BMIChartPainter(
                history: sortedHistory,
                minBMI: minBMI,
                maxBMI: maxBMI,
                range: range,
              ),
            ),
          ),
          const SizedBox(height: 8),
          SizedBox(
            height: 20,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: List.generate(
                sortedHistory.length,
                (i) => Text(
                  '${sortedHistory[i].date.day}/${sortedHistory[i].date.month}',
                  style: TextStyle(
                    color: Colors.grey[400],
                    fontSize: 10,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _BMIChartPainter extends CustomPainter {
  final List<BMIHistory> history;
  final double minBMI;
  final double maxBMI;
  final double range;

  _BMIChartPainter({
    required this.history,
    required this.minBMI,
    required this.maxBMI,
    required this.range,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = BeShapeColors.primary
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    final path = Path();
    final width = size.width;
    final height = size.height;

    for (var i = 0; i < history.length; i++) {
      final x = i * (width / (history.length - 1));
      final normalizedBMI = (history[i].bmi - minBMI) / range;
      final y = height - (normalizedBMI * height);

      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }

    // Draw gradient fill
    final fillPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          BeShapeColors.primary.withOpacity(0.3),
          BeShapeColors.primary.withOpacity(0.1),
        ],
      ).createShader(Rect.fromLTWH(0, 0, width, height));

    final fillPath = Path.from(path)
      ..lineTo(width, height)
      ..lineTo(0, height)
      ..close();

    canvas.drawPath(fillPath, fillPaint);
    canvas.drawPath(path, paint);

    // Draw points
    final pointPaint = Paint()
      ..color = BeShapeColors.primary
      ..style = PaintingStyle.fill;

    for (var i = 0; i < history.length; i++) {
      final x = i * (width / (history.length - 1));
      final normalizedBMI = (history[i].bmi - minBMI) / range;
      final y = height - (normalizedBMI * height);

      canvas.drawCircle(Offset(x, y), 4, pointPaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
