 import 'package:flutter/material.dart';

import '../core.dart';

/// 🔹 **Cores para Emoções**
  Color getEmotionColor(String emotion) {
    switch (emotion) {
      case 'Feliz':
        return BeShapeColors.accent;
      case 'Triste':
        return BeShapeColors.link;
      case 'Ansioso':
        return Colors.yellow;
      case 'Relaxado':
        return Colors.purple;
      case 'Cansado':
        return BeShapeColors.primary;
      default:
        return Colors.grey;
    }
  }  