import 'package:flutter/material.dart';

import '../core.dart';

class EmptyListComponent extends StatelessWidget {
  final String title;
  final String subTitle;
  final IconData? icon;
  final String? buttonText;
  const EmptyListComponent({super.key, required this.title, this.icon, required this.subTitle, this.buttonText});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon ?? Icons.no_food,
            size: 64,
            color: Colors.grey[700],
          ),
          const SizedBox(height: BeShapeSizes.paddingMedium),
          Text(
            title,
            style: TextStyle(
              color: Colors.grey[500],
              fontSize: 18,
            ),
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              subTitle,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 14,
              ),
            ),
          ),
          const SizedBox(height: BeShapeSizes.paddingMedium),
          buttonText != null?
          ElevatedButton.icon(
            onPressed: () => Navigator.pushNamed(context, '/saved-food'),
            icon: const Icon(Icons.add),
            label:  Text(buttonText ?? ''),
            style: ElevatedButton.styleFrom(
              backgroundColor: BeShapeColors.primary,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(
                horizontal: 24,
                vertical: 12,
              ),
            ),
          ): SizedBox.shrink()
        ],
      ),
    );
  }
}
