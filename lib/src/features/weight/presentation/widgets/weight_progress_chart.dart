import 'package:flutter/material.dart';


class WeightProgressChart extends StatelessWidget {
  final double currentWeight;
  final double targetWeight;
  final double initialWeight;

  const WeightProgressChart({
    super.key,
    required this.currentWeight,
    required this.targetWeight,
    required this.initialWeight,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _WeightChartPainter(
        currentWeight: currentWeight,
        targetWeight: targetWeight,
        initialWeight: initialWeight,
      ),
      child: Container(),
    );
  }
}

class _WeightChartPainter extends CustomPainter {
  final double currentWeight;
  final double targetWeight;
  final double initialWeight;

  _WeightChartPainter({
    required this.currentWeight,
    required this.targetWeight,
    required this.initialWeight,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.grey[800]!
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;

    // Draw grid
    _drawGrid(canvas, size, paint);

    // Draw weight line
    paint.color = Colors.blue;
    paint.strokeWidth = 2;

    final path = Path();
    final points = _generatePoints();
    
    if (points.isNotEmpty) {
      path.moveTo(0, _getYPosition(points[0], size));
      
      for (int i = 1; i < points.length; i++) {
        final x = (i / (points.length - 1)) * size.width;
        final y = _getYPosition(points[i], size);
        
        if (i == points.length - 1) {
          path.lineTo(x, y);
        } else {
          final nextX = ((i + 1) / (points.length - 1)) * size.width;
          final nextY = _getYPosition(points[i + 1], size);
          
          final controlX1 = x + (nextX - x) / 3;
          final controlX2 = x + 2 * (nextX - x) / 3;
          
          path.cubicTo(
            controlX1, y,
            controlX2, nextY,
            nextX, nextY,
          );
        }
      }
    }

    canvas.drawPath(path, paint);

    // Draw target line
    paint.color = Colors.orange.withOpacity(0.5);
    paint.strokeWidth = 1;
    paint.strokeCap = StrokeCap.round;
    
    final targetY = _getYPosition(targetWeight, size);
    final dashWidth = 5.0;
    final dashSpace = 5.0;
    double startX = 0;
    
    while (startX < size.width) {
      canvas.drawLine(
        Offset(startX, targetY),
        Offset(startX + dashWidth, targetY),
        paint,
      );
      startX += dashWidth + dashSpace;
    }

    // Draw points
    final pointPaint = Paint()
      ..color = Colors.blue
      ..style = PaintingStyle.fill;

    for (int i = 0; i < points.length; i++) {
      final x = (i / (points.length - 1)) * size.width;
      final y = _getYPosition(points[i], size);
      
      canvas.drawCircle(Offset(x, y), 4, pointPaint);
      
      if (i == points.length - 1) {
        canvas.drawCircle(Offset(x, y), 6, Paint()
          ..color = Colors.white
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2);
      }
    }
  }

  void _drawGrid(Canvas canvas, Size size, Paint paint) {
    // Horizontal lines
    for (int i = 0; i <= 4; i++) {
      final y = i * (size.height / 4);
      canvas.drawLine(
        Offset(0, y),
        Offset(size.width, y),
        paint,
      );
    }

    // Vertical lines
    for (int i = 0; i <= 6; i++) {
      final x = i * (size.width / 6);
      canvas.drawLine(
        Offset(x, 0),
        Offset(x, size.height),
        paint,
      );
    }
  }

  double _getYPosition(double weight, Size size) {
    final minWeight = targetWeight - 5;
    final maxWeight = initialWeight + 5;
    final range = maxWeight - minWeight;
    
    return size.height - ((weight - minWeight) / range * size.height);
  }

  List<double> _generatePoints() {
    // Simula pontos de progresso
    final points = <double>[];
    final steps = 7;
    
    for (int i = 0; i < steps; i++) {
      if (i == 0) {
        points.add(initialWeight);
      } else if (i == steps - 1) {
        points.add(currentWeight);
      } else {
        final progress = i / (steps - 1);
        points.add(initialWeight - (initialWeight - currentWeight) * progress);
      }
    }
    
    return points;
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}