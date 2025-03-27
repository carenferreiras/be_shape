import 'package:flutter/material.dart';

import '../../../../core/core.dart';
import '../../../features.dart';

class WeightCard extends StatelessWidget {
  final String tdee;
  final String tbm;

  const WeightCard({Key? key, required this.tdee, required this.tbm})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            BeShapeColors.primary.withValues(alpha: (0.2)),
            BeShapeColors.background.withValues(alpha: (0.05)),
          ],
        ),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: BeShapeColors.primary,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header com nome e foto do usuário
            Row(
              children: [
                CircleAvatar(
                  radius: 24,
                  backgroundImage: NetworkImage(
                    'https://via.placeholder.com/150', // Substitua pela imagem do usuário
                  ),
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: const [
                        Text(
                          "Makise Kurisu",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(width: 6),
                        // Icon(
                        //   Icons.food_bank,
                        //   color: Colors.blue,
                        //   size: 16,
                        // ),
                      ],
                    ),
                    const Text(
                      "Posted 3m ago",
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Imagem da postagem
            Row(
              // mainAxisAlignment: MainAxisAlignment.center,
              children: [
                RateCard(
                  heartRate: tbm,
                  color: BeShapeColors.error,
                  icon: Icons.local_fire_department,
                  title: 'TBM',
                ),
                RateCard(
                  heartRate: tdee,
                  color: const Color.fromARGB(255, 3, 167, 8),
                  icon: Icons.directions_run,
                  title: 'TDEE',
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Footer com estatísticas
            // Row(
            //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //   children: [
            //     Row(
            //       children: [
            //         const Icon(Icons.visibility, color: Colors.grey, size: 18),
            //         const SizedBox(width: 4),
            //         const Text(
            //           "5,874",
            //           style: TextStyle(color: Colors.grey, fontSize: 14),
            //         ),
            //         const SizedBox(width: 16),
            //         const Icon(Icons.favorite, color: Colors.red, size: 18),
            //         const SizedBox(width: 4),
            //         const Text(
            //           "215",
            //           style: TextStyle(color: Colors.grey, fontSize: 14),
            //         ),
            //         const SizedBox(width: 16),
            //         const Icon(Icons.comment, color: BeShapeColors.primary, size: 18),
            //         const SizedBox(width: 4),
            //         const Text(
            //           "11",
            //           style: TextStyle(color: Colors.grey, fontSize: 14),
            //         ),
            //       ],
            //     ),
            //     Row(
            //       children: const [
            //         Icon(Icons.save, color: Colors.white, size: 18),
            //         SizedBox(width: 4),
            //         Text(
            //           "Save",
            //           style: TextStyle(color: Colors.white, fontSize: 14),
            //         ),
            //       ],
            //     ),
            //   ],
            // ),
          ],
        ),
      ),
    );
  }
}
