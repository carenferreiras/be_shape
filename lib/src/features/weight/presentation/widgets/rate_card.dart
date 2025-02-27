import 'package:flutter/material.dart';

import '../../../../core/core.dart';

class RateCard extends StatelessWidget {
  
  final String heartRate;
  final Color color;
  final IconData icon;
  final String title;
  final String? meause;
  final double? height;
  final double? weight;

  const RateCard({Key? key, required this.heartRate, required this.color, required this.icon, required this.title, this.meause, this.height, this.weight}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        height: height,
        width: weight,
        decoration: BoxDecoration(
          color: color.withOpacity(0.2),
          borderRadius: BorderRadius.circular(16.0),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(2, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
             Icon(
              icon,
              color: color,
              size: 24,
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "$heartRate",
                  style:  TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),

                Text(
                  meause ?? ' kcal',
                  style:  TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
             Text(
              title,
              style: TextStyle(
                fontSize: 14,
                color: const Color.fromARGB(255, 255, 251, 251),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

