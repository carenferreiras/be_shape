import 'package:be_shape_app/src/features/features.dart';
import 'package:flutter/material.dart';

import '../../../../core/core.dart';

class CustomCard extends StatelessWidget {
  final IconData caloriesIcon;
  final IconData proteinIcon;
  final IconData fibersIcon;
  final String calories;
  final String carbo;
  final String fibers;
  final String foodName;
  final String classification;
  final Map<String, dynamic> data;
  CustomCard(
      {super.key,
      required this.caloriesIcon,
      required this.proteinIcon,
      required this.fibersIcon,
      required this.calories,
      required this.carbo,
      required this.fibers,
      required this.foodName,
      required this.classification, 
      required this.data});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 170,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.centerRight,
          colors: [
            BeShapeColors.background.withOpacity(0.7),
            BeShapeColors.background.withOpacity(0.7),
            BeShapeColors.background.withOpacity(0.6),
            BeShapeColors.background.withOpacity(0.7),
          ],
        ),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: BeShapeColors.primary.withOpacity(0.3),
        ),
      ),
      margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
      child: Padding(
        padding: const EdgeInsets.only(
            left: BeShapeSizes.paddingMedium,
            top: 8,
            bottom: BeShapeSizes.paddingMedium),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Wrap(
              alignment: WrapAlignment.start,
              children: [
                NumberCard(
                    icon: caloriesIcon,
                    number: calories,
                    measure: 'kcal',
                    name: 'Calorias',
                    color: Colors.orange),
                NumberCard(
                    icon: proteinIcon,
                    number: carbo,
                    measure: 'g',
                    name: 'Carboidratos',
                    color: Colors.blue),
                NumberCard(
                    icon: fibersIcon,
                    number: fibers,
                    measure: 'g',
                    name: 'Fibras',
                    color: Colors.green),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width * 0.8,
                      child: Text(
                        foodName,
                        maxLines: 2,
                        style: const TextStyle(
                            color: BeShapeColors.textPrimary,
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            overflow: TextOverflow.ellipsis),
                      ),
                    ),
                    Card(
                      color: BeShapeColors.primary.withOpacity(0.2),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 4, horizontal: 8),
                        child: Text(
                          classification,
                          style: TextStyle(
                              color: BeShapeColors.primary,
                              fontWeight: FontWeight.bold,
                              fontSize: 12),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
