import 'package:flutter/material.dart';

import '../core.dart';

Color getEmotionColorBar(String emotion) {
    switch (emotion) {
      case 'Feliz':
        return BeShapeColors.accent.withOpacity(0.2);
      case 'Triste':
        return BeShapeColors.link.withOpacity(0.2);
      case 'Ansioso':
        return Colors.yellow.withOpacity(0.2);
      case 'Relaxado':
        return Colors.purple.withOpacity(0.2);
      case 'Cansado':
        return BeShapeColors.primary.withOpacity(0.2);
      default:
        return Colors.grey;
    }
  }