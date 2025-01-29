import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../features.dart';

class CompleteMealBanner extends StatelessWidget {
  final List<Meal> mealsForDate;
  const CompleteMealBanner(
      {super.key, required this.mealsForDate});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 8,
        ),
        decoration: BoxDecoration(
          color: Colors.green.withOpacity(0.2),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: Colors.green.withOpacity(0.3),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.check_circle,
              color: Colors.green,
              size: 20,
            ),
            const SizedBox(width: 8),
            Text(
              mealsForDate.first.isAutoCompleted
                  ? 'Day Auto-Completed'
                  : 'Day Completed',
              style: const TextStyle(
                color: Colors.green,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(width: 8),
            Text(
              DateFormat('HH:mm').format(
                mealsForDate.first.completedAt ?? DateTime.now(),
              ),
              style: TextStyle(
                color: Colors.green.withOpacity(0.7),
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
