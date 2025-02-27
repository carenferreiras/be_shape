import 'package:flutter/material.dart';
import 'dart:math';

class MacroDistributionChart extends StatelessWidget {
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
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1,
      child: CustomPaint(
        painter: _MacroChartPainter(
          proteins: proteins,
          carbs: carbs,
          fats: fats,
        ),
      ),
    );
  }
}

class _MacroChartPainter extends CustomPainter {
  final double proteins;
  final double carbs;
  final double fats;

  _MacroChartPainter({
    required this.proteins,
    required this.carbs,
    required this.fats,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final total = proteins + carbs + fats;
    final center = Offset(size.width / 2, size.height / 2);
    final radius = min(size.width, size.height) / 2;

    // Calculate angles
    final proteinAngle = 2 * pi * (proteins / total);
    final carbsAngle = 2 * pi * (carbs / total);
    final fatsAngle = 2 * pi * (fats / total);

    var startAngle = -pi / 2;

    // Draw proteins section
    _drawSection(
      canvas,
      center,
      radius,
      startAngle,
      startAngle + proteinAngle,
      Colors.blue,
      '${(proteins / total * 100).round()}%',
    );
    startAngle += proteinAngle;

    // Draw carbs section
    _drawSection(
      canvas,
      center,
      radius,
      startAngle,
      startAngle + carbsAngle,
      Colors.green,
      '${(carbs / total * 100).round()}%',
    );
    startAngle += carbsAngle;

    // Draw fats section
    _drawSection(
      canvas,
      center,
      radius,
      startAngle,
      startAngle + fatsAngle,
      Colors.red,
      '${(fats / total * 100).round()}%',
    );
  }

  void _drawSection(
    Canvas canvas,
    Offset center,
    double radius,
    double startAngle,
    double endAngle,
    Color color,
    String percentage,
  ) {
    final paint = Paint()
      ..style = PaintingStyle.fill
      ..color = color;

    final path = Path()
      ..moveTo(center.dx, center.dy)
      ..arcTo(
        Rect.fromCircle(center: center, radius: radius),
        startAngle,
        endAngle - startAngle,
        false,
      )
      ..close();

    canvas.drawPath(path, paint);

    // Draw percentage text
    final midAngle = startAngle + (endAngle - startAngle) / 2;
    final textRadius = radius * 0.7;
    final textX = center.dx + textRadius * cos(midAngle);
    final textY = center.dy + textRadius * sin(midAngle);

    final textPainter = TextPainter(
      text: TextSpan(
        text: percentage,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 14,
          fontWeight: FontWeight.bold,
        ),
      ),
      textDirection: TextDirection.ltr,
      textAlign: TextAlign.center,
    );

    textPainter.layout();
    textPainter.paint(
      canvas,
      Offset(
        textX - textPainter.width / 2,
        textY - textPainter.height / 2,
      ),
    );
  }
  
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    // TODO: implement shouldRepaint
    throw UnimplementedError();
  }
}