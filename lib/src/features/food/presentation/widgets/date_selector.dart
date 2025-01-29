import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../core/core.dart';

class DateSelector extends StatelessWidget {
  final void Function()? selectedDateOnPressed;
  final void Function()? leftButtonOnPressed;
  final void Function()? rightButtonOnPressed;

  final DateTime date;

  const DateSelector(
      {super.key,
      this.selectedDateOnPressed,
      this.leftButtonOnPressed,
      required this.date,
      this.rightButtonOnPressed});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 12,
      ),
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey[800]!),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
              icon: const Icon(Icons.chevron_left, color: Colors.white),
              onPressed: leftButtonOnPressed),
          GestureDetector(
            onTap: selectedDateOnPressed,
            child: Column(
              children: [
                Text(
                  DateFormat('EEEE').format(date),
                  style: const TextStyle(
                    color: BeShapeColors.primary,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  DateFormat('MMMM d, y').format(date),
                  style: TextStyle(
                    color: Colors.grey[400],
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.chevron_right, color: Colors.white),
            onPressed: rightButtonOnPressed,
          ),
        ],
      ),
    );
  }
}
