import 'package:flutter/material.dart';

import '../core.dart';

class BeShapeOptionCard extends StatelessWidget {
    final IconData icon;
    final Color color;
    final String title;
    final String subtitle;
    final VoidCallback onTap;
    final bool?  changeIcon;
   
  const BeShapeOptionCard({super.key, 
  this.changeIcon =false,
  required this.icon, 
  required this.color, 
  required this.title, 
  required this.subtitle, 
  required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(BeShapeSizes.paddingMedium),
        decoration: BoxDecoration(
          color: const Color(0xFF1C1C1E), // Fundo cinza escuro
          borderRadius: BorderRadius.circular(BeShapeSizes.borderRadiusLarge),
        ),
        child: Row(
          children: [
            // Ícone
            CircleAvatar(
              radius: BeShapeSizes.paddingLarge,
              backgroundColor: color,
              child: Icon(icon, color: Colors.white),
            ),
            const SizedBox(width: BeShapeSizes.paddingMedium),
            // Título e Subtítulo
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: BeShapeSizes.paddingMedium,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: BeShapeSizes.paddingExtraSmall),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      color: Colors.grey,
                      fontSize: BeShapeSizes.fontMedium,
                    ),
                  ),
                ],
              ),
            ),
            // Ícone de navegação
            changeIcon == false?
            const Icon(Icons.arrow_forward_ios, color: Colors.grey, size: BeShapeSizes.iconSmall):
            const Icon(Icons.keyboard_arrow_down_rounded, color: Colors.grey, size: BeShapeSizes.iconMedium)
          ],
        ),
      ),
    );
  }
}