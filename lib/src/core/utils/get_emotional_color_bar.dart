import 'package:flutter/material.dart';

Color getEmotionColorBar(String emotion) {
    switch (emotion) {
      case 'Feliz':
        return Colors.green.withOpacity(0.2);
      case 'Triste':
        return Colors.blue.withOpacity(0.2);
      case 'Ansioso':
        return Colors.yellow.withOpacity(0.2);
      case 'Relaxado':
        return Colors.purple.withOpacity(0.2);
      case 'Cansado':
        return Colors.orange.withOpacity(0.2);
      default:
        return Colors.grey;
    }
  }