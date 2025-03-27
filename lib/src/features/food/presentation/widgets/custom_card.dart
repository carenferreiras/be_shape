import 'package:flutter/material.dart';

import '../../../../core/core.dart';
import '../../../features.dart';

class CustomCard extends StatelessWidget {
  final IconData caloriesIcon;
  final IconData proteinIcon;
  final IconData fibersIcon;
  final IconData fatIcon;
  final String calories;
  final String carbo;
  final String fibers;
  final String foodName;
  final String classification;
  final String protein;
  final String fat;
  final String sodium;
  final String qnt;
  final String water;
  final String iron;
  final String calcium;
  final IconData favoriteIcon;
  final Color? favoriteColorIcon;
  final void Function()? onPressed;
  final void Function()? cardOnTap;
  final String? image;

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
      required this.data,
      required this.fatIcon,
      required this.protein,
      required this.fat,
      required this.sodium,
      required this.qnt,
      required this.water,
      required this.calcium,
      required this.iron,
      required this.onPressed,
      required this.favoriteIcon,
      this.favoriteColorIcon,
      this.cardOnTap,
      this.image});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
              builder: (_) => FoodDetailScreen(
                    foodImage: image ?? '',
                    foodName: foodName,
                    protein: protein,
                    carbs: carbo,
                    fat: fat,
                    calories: '',
                  ))),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.centerRight,
            colors: [
              BeShapeColors.background.withValues(alpha: (0.7)),
              BeShapeColors.background.withValues(alpha: (0.7)),
              BeShapeColors.background.withValues(alpha: (0.6)),
              BeShapeColors.background.withValues(alpha: (0.7)),
            ],
          ),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: BeShapeColors.primary.withValues(alpha: (0.3)),
          ),
        ),
        margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 6),
        child: Padding(
          padding: const EdgeInsets.only(
              left: BeShapeSizes.paddingMedium,
              top: 8,
              right: BeShapeSizes.paddingMedium,
              bottom: BeShapeSizes.paddingMedium),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              margin: EdgeInsets.only(left: 8),
                              height: 50,
                              width: 50,
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                    image: NetworkImage(
                                        image ?? BeShapeImages.logo2),
                                    fit: BoxFit.cover),
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            // CircleAvatar(
                            //   backgroundImage: image,

                            // ),
                            SizedBox(
                              width: 6,
                            ),
                            Container(
                              width: MediaQuery.of(context).size.width * 0.6,
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
                            IconButton(
                                icon: Icon(
                                  favoriteIcon,
                                  color: favoriteColorIcon,
                                ),
                                onPressed: onPressed),
                          ],
                        ),
                        Card(
                          color: BeShapeColors.primary.withValues(alpha: (0.2)),
                          child: Expanded(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 4, horizontal: 8),
                              child: Text(
                                classification,
                                maxLines: 2,
                                style: TextStyle(
                                    overflow: TextOverflow.ellipsis,
                                    color: BeShapeColors.primary,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12),
                              ),
                            ),
                          ),
                        ),
                        // Text(
                        //   'Qntd: ${qnt}',
                        //   maxLines: 2,
                        //   style: const TextStyle(
                        //       color: BeShapeColors.textSecondary,
                        //       fontWeight: FontWeight.bold,
                        //       fontSize: 12,
                        //       overflow: TextOverflow.ellipsis),
                        // ),
                      ],
                    ),
                  ],
                ),
              ),
              Wrap(
                alignment: WrapAlignment.start,
                children: [
                  NumberCard(
                      icon: proteinIcon,
                      number: protein,
                      measure: 'g',
                      name: 'Proteínas',
                      color: BeShapeColors.link),
                  NumberCard(
                      icon: caloriesIcon,
                      number: calories,
                      measure: 'kcal',
                      name: 'Calorias',
                      color: BeShapeColors.primary),
                  NumberCard(
                      icon: proteinIcon,
                      number: carbo,
                      measure: 'g',
                      name: 'Carboidratos',
                      color: BeShapeColors.accent),
                  NumberCard(
                      icon: fibersIcon,
                      number: fibers,
                      measure: ' g',
                      name: 'Fibras',
                      color: BeShapeColors.purble),
                  NumberCard(
                      icon: fatIcon,
                      number: fat,
                      measure: ' g',
                      name: 'Gorduras',
                      color: BeShapeColors.error),
                  NumberCard(
                      icon: fatIcon,
                      number: sodium,
                      measure: ' g',
                      name: 'Gordura Saturada',
                      color: BeShapeColors.warning),
                  NumberCard(
                      icon: caloriesIcon,
                      number: calcium,
                      measure: ' mg',
                      name: 'Cálcio',
                      color: BeShapeColors.brown),
                  NumberCard(
                      icon: caloriesIcon,
                      number: water,
                      measure: 'g',
                      name: 'Açucar',
                      color: BeShapeColors.backgroundLight),
                  NumberCard(
                      icon: caloriesIcon,
                      number: iron,
                      measure: 'mg',
                      name: 'Ferro',
                      color: BeShapeColors.grey),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
