import 'package:flutter/material.dart';

import '../../../../core/core.dart';

class AddFoodButtonTab extends StatelessWidget {
  const AddFoodButtonTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.no_food,
            size: 64,
            color: Colors.grey[700],
          ),
          const SizedBox(height: BeShapeSizes.paddingMedium),
          Text(
            'No saved foods yet',
            style: TextStyle(
              color: Colors.grey[500],
              fontSize: 18,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Save foods by marking them as favorites',
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 14,
            ),
          ),
          const SizedBox(height: BeShapeSizes.paddingMedium),
          ElevatedButton.icon(
            onPressed: () => Navigator.pushNamed(context, '/saved-food'),
            icon: const Icon(Icons.add),
            label: const Text('Add New Food'),
            style: ElevatedButton.styleFrom(
              backgroundColor: BeShapeColors.primary,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(
                horizontal: 24,
                vertical: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
