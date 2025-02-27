import 'dart:math';
import 'package:flutter/material.dart';

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
    return CustomPaint(
      painter: _MacroDistributionPainter(
        proteins: proteins,
        carbs: carbs,
        fats: fats,
      ),
      child: Container(),
    );
  }
}

class _MacroDistributionPainter extends CustomPainter {
  final double proteins;
  final double carbs;
  final double fats;

  _MacroDistributionPainter({
    required this.proteins,
    required this.carbs,
    required this.fats,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final total = proteins + carbs + fats;
    final center = Offset(size.width / 2, size.height / 2);
    final radius = min(size.width, size.height) * 0.4;
    
    var startAngle = -pi / 2;

    // Draw proteins segment
    _drawSegment(
      canvas,
      center,
      radius,
      startAngle,
      startAngle + (2 * pi * proteins / total),
      Colors.blue,
    );
    startAngle += 2 * pi * proteins / total;

    // Draw carbs segment
    _drawSegment(
      canvas,
      center,
      radius,
      startAngle,
      startAngle + (2 * pi * carbs / total),
      Colors.green,
    );
    startAngle += 2 * pi * carbs / total;

    // Draw fats segment
    _drawSegment(
      canvas,
      center,
      radius,
      startAngle,
      startAngle + (2 * pi * fats / total),
      Colors.red,
    );

    // Draw center circle
    final centerPaint = Paint()
      ..color = Colors.grey[900]!
      ..style = PaintingStyle.fill;
    
    canvas.drawCircle(center, radius * 0.6, centerPaint);

    // Draw percentages
    _drawPercentages(canvas, center, radius, total);
  }

  void _drawSegment(
    Canvas canvas,
    Offset center,
    double radius,
    double startAngle,
    double endAngle,
    Color color,
  ) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      startAngle,
      endAngle - startAngle,
      true,
      paint,
    );
  }

  void _drawPercentages(Canvas canvas, Offset center, double radius, double total) {
    final textStyle = TextStyle(
      color: Colors.grey[400],
      fontSize: 14,
      fontWeight: FontWeight.bold,
    );

    final proteinPercent = (proteins / total * 100).round();
    final carbsPercent = (carbs / total * 100).round();
    final fatsPercent = (fats / total * 100).round();

    final textPainter = TextPainter(
      textDirection: TextDirection.ltr,
      textAlign: TextAlign.center,
    );

    // Proteins percentage
    textPainter.text = TextSpan(
      text: '$proteinPercent%',
      style: textStyle,
    );
    textPainter.layout();
    textPainter.paint(
      canvas,
      Offset(
        center.dx - textPainter.width / 2,
        center.dy - radius * 0.2,
      ),
    );

    // Carbs percentage
    textPainter.text = TextSpan(
      text: '$carbsPercent%',
      style: textStyle,
    );
    textPainter.layout();
    textPainter.paint(
      canvas,
      Offset(
        center.dx - textPainter.width / 2,
        center.dy,
      ),
    );

    // Fats percentage
    textPainter.text = TextSpan(
      text: '$fatsPercent%',
      style: textStyle,
    );
    textPainter.layout();
    textPainter.paint(
      canvas,
      Offset(
        center.dx - textPainter.width / 2,
        center.dy + radius * 0.2,
      ),
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}