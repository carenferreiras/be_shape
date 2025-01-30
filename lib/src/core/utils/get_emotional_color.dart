 import 'package:flutter/material.dart';

/// 🔹 **Cores para Emoções**
  Color getEmotionColor(String emotion) {
    switch (emotion) {
      case 'Feliz':
        return Colors.green;
      case 'Triste':
        return Colors.blue;
      case 'Ansioso':
        return Colors.yellow;
      case 'Relaxado':
        return Colors.purple;
      case 'Cansado':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }  