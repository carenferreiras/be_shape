import 'package:flutter/material.dart';

import '../core.dart';

Color getEmotionColorBar(String emotion) {
  switch (emotion) {
    case 'Feliz':
      return BeShapeColors.accent.withValues(alpha: (0.2));
    case 'Triste':
      return BeShapeColors.link.withValues(alpha: (0.2));
    case 'Ansioso':
      return Colors.yellow.withValues(alpha: (0.2));
    case 'Relaxado':
      return Colors.purple.withValues(alpha: (0.2));
    case 'Cansado':
      return BeShapeColors.primary.withValues(alpha: (0.2));
    default:
      return Colors.grey;
  }
}
