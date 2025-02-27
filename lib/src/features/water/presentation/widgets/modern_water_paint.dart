import 'package:flutter/material.dart';

import '../../../../core/core.dart';

class ModernWaterPainter extends CustomPainter {
  final double progress;

  ModernWaterPainter(this.progress);

  @override
  void paint(Canvas canvas, Size size) {
    final Paint circlePaint = Paint()
      ..color = BeShapeColors.link.withOpacity(0.2)
      ..style = PaintingStyle.fill;

    final Paint waterPaint = Paint()
      ..shader = LinearGradient(
        colors: [BeShapeColors.link.withOpacity(0.7), BeShapeColors.link],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      ).createShader(Rect.fromCircle(
        center: size.center(Offset.zero),
        radius: size.width / 2,
      ))
      ..style = PaintingStyle.fill;

    canvas.drawCircle(size.center(Offset.zero), size.width / 2, circlePaint);

    final double waterHeight = size.height * (1 - progress.clamp(0.0, 1.0));

    final Path waterPath = Path()
      ..moveTo(0, size.height)
      ..lineTo(0, waterHeight)
      ..quadraticBezierTo(
        size.width / 4,
        waterHeight - 20,
        size.width / 2,
        waterHeight,
      )
      ..quadraticBezierTo(
        size.width * 3 / 4,
        waterHeight + 20,
        size.width,
        waterHeight,
      )
      ..lineTo(size.width, size.height)
      ..close();

    canvas.drawPath(waterPath, waterPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}