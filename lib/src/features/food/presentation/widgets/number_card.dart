import 'package:flutter/material.dart';

import '../../../../core/core.dart';

class NumberCard extends StatelessWidget {
   final IconData icon;
    final String number;
    final String measure;
    final String name;
    final Color color;
  const NumberCard({super.key, required this.icon, required this.number, required this.measure, required this.name, required this.color});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 120,
      child: Card(
        color: color.withOpacity(0.2),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(BeShapeSizes.paddingMedium)),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    icon,
                    size: 12,
                    color: color,
                  ),
                  SizedBox(width: 4,),
                  Text(
                    number,
                    style: TextStyle(
                        color: color,
                        fontWeight: FontWeight.bold,
                        fontSize: 12),
                  ),
                  SizedBox(
                    width: 2,
                  ),
                  Text(
                    measure,
                    style: TextStyle(color: color, fontSize: 10),
                  ),
                ],
              ),
              Text(
                name,
                style: TextStyle(
                    color: color, fontWeight: FontWeight.bold, fontSize: 10),
              ),
            ],
          ),
        ),
      ),
    );
  }
}