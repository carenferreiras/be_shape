import 'package:be_shape_app/src/features/features.dart';
import 'package:flutter/material.dart';

import '../../../../core/core.dart';

class MyFoodsCardTab extends StatelessWidget {
  final Key dimissibleKey;
  final void Function(DismissDirection)? onDismissed;
  final void Function()? onTapSelectExistingFood;
  final SavedFood food;
  const MyFoodsCardTab(
      {super.key,
      required this.dimissibleKey,
      this.onDismissed,
      this.onTapSelectExistingFood,
      required this.food});

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: dimissibleKey,
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        color: Colors.red,
        child: const Icon(
          Icons.delete,
          color: Colors.white,
        ),
      ),
      onDismissed: onDismissed,
      child: Container(
        margin: const EdgeInsets.symmetric(
          horizontal: BeShapeSizes.paddingMedium,
          vertical: 4,
        ),
        decoration: BoxDecoration(
          color: Colors.grey[900],
          borderRadius: BorderRadius.circular(12),
        ),
        child: ListTile(
          onTap: onTapSelectExistingFood,
          leading: Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: Colors.grey[800],
              borderRadius: BorderRadius.circular(8),
            ),
            child: food.photoUrl != null
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                      food.photoUrl!,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return const Icon(
                          Icons.restaurant_menu,
                          color: Colors.white,
                        );
                      },
                    ),
                  )
                : const Icon(
                    Icons.restaurant_menu,
                    color: Colors.white,
                  ),
          ),
          title: Text(
            food.name,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (food.brand != null)
                Text(
                  food.brand!,
                  style: const TextStyle(
                    color: Colors.grey,
                  ),
                ),
              Text(
                'P: ${food.proteins.round()}g  C: ${food.carbs.round()}g  F: ${food.fats.round()}g',
                style: const TextStyle(
                  color: Colors.grey,
                ),
              ),
            ],
          ),
          trailing: Text(
            '${food.calories.round()} kcal',
            style: const TextStyle(
              color: BeShapeColors.primary,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
