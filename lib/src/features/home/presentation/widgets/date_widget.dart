import 'package:be_shape_app/src/core/core.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

Widget dateWidet = Container(
  padding: const EdgeInsets.symmetric(
    horizontal: 16,
    vertical: 8,
  ),
  decoration: BoxDecoration(
    color: BeShapeColors.primary.withOpacity(0.2),
    borderRadius: BorderRadius.circular(12),
  ),
  child: Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      const Icon(
        Icons.calendar_today,
        color: BeShapeColors.primary,
        size: 20,
      ),
      const SizedBox(width: 8),
      Text(
        DateFormat('EEEE, MMMM d').format(DateTime.now()),
        style: const TextStyle(
          color: Colors.white,
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
    ],
  ),
);
