import 'package:flutter/material.dart';

import '../core.dart';

class ActivityChart extends StatelessWidget {
  const ActivityChart({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Atividades',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Row(
                children: [
                  _DaySelector(
                    day: 'M',
                    isSelected: false,
                  ),
                  _DaySelector(
                    day: 'T',
                    isSelected: false,
                  ),
                  _DaySelector(
                    day: 'W',
                    isSelected: false,
                  ),
                  _DaySelector(
                    day: 'T',
                    isSelected: true,
                  ),
                  _DaySelector(
                    day: 'F',
                    isSelected: false,
                  ),
                  _DaySelector(
                    day: 'Todos',
                    isSelected: false,
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 24),
          SizedBox(
            height: 200,
            child: _CustomActivityChart(
              data: [
                ActivityData(hour: 0, calories: 500),
                ActivityData(hour: 4, calories: 1000),
                ActivityData(hour: 8, calories: 800),
                ActivityData(hour: 12, calories: 1200),
                ActivityData(hour: 16, calories: 1500),
                ActivityData(hour: 20, calories: 1000),
                ActivityData(hour: 23, calories: 800),
              ],
            ),
          ),
          const SizedBox(height: 16),
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _CalorieStat(
                icon: Icons.local_fire_department,
                value: '1,548',
                label: 'kcal',
                color: BeShapeColors.primary,
              ),
              _CalorieStat(
                icon: Icons.timer,
                value: '7,853',
                label: 'steps',
                color: BeShapeColors.link,
              ),
              _CalorieStat(
                icon: Icons.lightbulb_outline,
                value: '8',
                label: 'suggestions',
                color: BeShapeColors.accent,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _CustomActivityChart extends StatelessWidget {
  final List<ActivityData> data;

  const _CustomActivityChart({required this.data});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: const Size(double.infinity, 200),
      painter: _ChartPainter(data),
    );
  }
}

class _ChartPainter extends CustomPainter {
  final List<ActivityData> data;

  _ChartPainter(this.data);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = BeShapeColors.primary
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    final fillPaint = Paint()
      ..color = BeShapeColors.primary.withOpacity(0.1)
      ..style = PaintingStyle.fill;

    final path = Path();
    final fillPath = Path();

    // Scale factors
    final xScale = size.width / 23; // 24 hours
    final yScale = size.height / 2000; // Max calories

    // Move to first point
    final firstPoint = Offset(
      data[0].hour * xScale,
      size.height - (data[0].calories * yScale),
    );
    path.moveTo(firstPoint.dx, firstPoint.dy);
    fillPath.moveTo(firstPoint.dx, size.height);
    fillPath.lineTo(firstPoint.dx, firstPoint.dy);

    // Create curved path through points
    for (int i = 1; i < data.length; i++) {
      final current = Offset(
        data[i].hour * xScale,
        size.height - (data[i].calories * yScale),
      );
      final previous = Offset(
        data[i - 1].hour * xScale,
        size.height - (data[i - 1].calories * yScale),
      );
      
      final controlPoint1 = Offset(
        previous.dx + (current.dx - previous.dx) / 2,
        previous.dy,
      );
      final controlPoint2 = Offset(
        previous.dx + (current.dx - previous.dx) / 2,
        current.dy,
      );
      
      path.cubicTo(
        controlPoint1.dx, controlPoint1.dy,
        controlPoint2.dx, controlPoint2.dy,
        current.dx, current.dy,
      );
      fillPath.cubicTo(
        controlPoint1.dx, controlPoint1.dy,
        controlPoint2.dx, controlPoint2.dy,
        current.dx, current.dy,
      );
    }

    // Complete fill path
    fillPath.lineTo(data.last.hour * xScale, size.height);
    fillPath.close();

    // Draw fill and line
    canvas.drawPath(fillPath, fillPaint);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class ActivityData {
  final int hour;
  final double calories;

  ActivityData({required this.hour, required this.calories});
}

class _DaySelector extends StatelessWidget {
  final String day;
  final bool isSelected;

  const _DaySelector({
    required this.day,
    required this.isSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: isSelected ? BeShapeColors.primary : Colors.transparent,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        day,
        style: TextStyle(
          color: isSelected ? Colors.white : Colors.grey,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        ),
      ),
    );
  }
}

class _CalorieStat extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;
  final Color color;

  const _CalorieStat({
    required this.icon,
    required this.value,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          icon,
          color: color,
          size: 20,
        ),
        const SizedBox(width: 8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              value,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              label,
              style: const TextStyle(
                color: Colors.grey,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ],
    );
  }
}