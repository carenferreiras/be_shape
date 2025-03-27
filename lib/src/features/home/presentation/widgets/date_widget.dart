import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../core/core.dart';

Widget dateWidet = Container(
  padding: const EdgeInsets.symmetric(
    horizontal: 16,
    vertical: 8,
  ),
  decoration: BoxDecoration(
    color: BeShapeColors.primary.withValues(alpha: (0.2)),
    borderRadius: BorderRadius.circular(12),
  ),
  child: Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      const Icon(
        Icons.calendar_today,
        color: BeShapeColors.primary,
        size: 10,
      ),
      const SizedBox(width: 8),
      Text(
        DateFormat('EEEE, MMMM d').format(DateTime.now()),
        style: const TextStyle(
          color: Colors.white,
          // fontWeight: FontWeight.normal,
        ),
      ),
    ],
  ),
);
