import 'package:flutter/material.dart';

class MacroInfo extends StatelessWidget {
  final IconData icon;
  final double value;
  final String unit;
  final Color color;
  final String? label;

  const MacroInfo({
    super.key,
    required this.icon,
    required this.value,
    required this.unit,
    required this.color,
    this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withOpacity(0.2),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            icon,
            color: color,
            size: 20,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          '${value.round()}$unit',
          style: TextStyle(
            color: color,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        if (label != null)
          Text(
            label!,
            style: const TextStyle(
              color: Colors.grey,
              fontSize: 12,
            ),
          ),
      ],
    );
  }
}
