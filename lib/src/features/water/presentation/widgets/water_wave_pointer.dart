import 'dart:math';
import 'package:flutter/material.dart';

class WaterWavePainter extends CustomPainter {
  final Color color;
  final double _animationValue = 0;

  WaterWavePainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final path = Path();
    final width = size.width;
    final height = size.height;

    path.moveTo(0, height);
    
    // Primeira onda
    for (double i = 0; i <= width; i++) {
      path.lineTo(
        i,
        height - sin((i / width * 2 * pi) + _animationValue) * 4,
      );
    }

    path.lineTo(width, height);
    path.close();
    
    canvas.drawPath(path, paint);

    // Segunda onda com offset
    final path2 = Path();
    path2.moveTo(0, height);
    
    for (double i = 0; i <= width; i++) {
      path2.lineTo(
        i,
        height - sin((i / width * 2 * pi) + _animationValue + pi) * 3,
      );
    }

    path2.lineTo(width, height);
    path2.close();
    
    canvas.drawPath(path2, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}