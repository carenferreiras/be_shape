import 'package:flutter/material.dart';

import '../../../../core/core.dart';

class CustomTitle extends StatelessWidget {
  final String title;
  final void Function()? onTap;

  const CustomTitle({super.key, required this.title, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(12),
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 8,
              ),
              decoration: BoxDecoration(
                color: BeShapeColors.primary.withOpacity(0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Row(
                children: [
                  Icon(
                    Icons.add_circle_outline,
                    color: BeShapeColors.primary,
                    size: 18,
                  ),
                  SizedBox(width: 8),
                  Text(
                    'Add Meal',
                    style: TextStyle(
                      color: BeShapeColors.primary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
