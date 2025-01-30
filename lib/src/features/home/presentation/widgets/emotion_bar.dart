import 'package:flutter/material.dart';

import '../../../../core/core.dart';

class EmotionBar extends StatelessWidget {
  final String emotion;
  final int percentage;
  final int count;
  final Color color;
  const EmotionBar(
      {super.key,
      required this.emotion,
      required this.percentage,
      required this.count,
      required this.color});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CircleAvatar(
          radius: 6,
          backgroundColor: color,
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Stack(
            children: [
              Container(
                height: 20,
                decoration: BoxDecoration(
                  color: getEmotionColorBar(emotion),
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              Container(
                height: 20,
                width: percentage.toDouble() * 2, // Proporção para a barra
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 8),
        Text(
          "$count ($percentage%)",
          style: const TextStyle(color: Colors.white),
        ),
      ],
    );
  }
}
