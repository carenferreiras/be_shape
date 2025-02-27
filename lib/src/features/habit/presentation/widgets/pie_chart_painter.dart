import 'dart:math';

import 'package:flutter/material.dart';

import '../../../../core/core.dart';

class PieChartPainter extends CustomPainter {
  final Map<String, int> data;
  final int total;

  PieChartPainter(this.data, this.total);

  @override
  void paint(Canvas canvas, Size size) {
    if (total == 0) return; // Evita erro caso não tenha dados

    final paint = Paint()..style = PaintingStyle.fill;
    double startAngle = -pi / 2; // Começa no topo

    data.forEach((emotion, value) {
      final sweepAngle = (value / total) * 2 * pi;
      paint.color = _getEmotionColor(emotion);
      canvas.drawArc(
        Rect.fromCircle(center: size.center(Offset.zero), radius: size.width / 2),
        startAngle,
        sweepAngle,
        true,
        paint,
      );
      startAngle += sweepAngle;
    });
  }
/// 🔹 **Define cores para cada emoção**
Color _getEmotionColor(String emotion) {
  switch (emotion) {
    case 'Feliz':
      return BeShapeColors.accent;
    case 'Triste':
      return BeShapeColors.link;
    case 'Ansioso':
      return Colors.yellow;
    case 'Relaxado':
      return Colors.purple;
    case 'Cansado':
      return BeShapeColors.primary;
    default:
      return Colors.grey;
  }
}
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}