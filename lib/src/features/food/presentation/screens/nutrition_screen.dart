import 'dart:io';
import 'package:flutter/material.dart';

class NutritionScreen extends StatelessWidget {
  final File imageFile;
  final String extractedText;
  final Map<String, String> nutritionData;

  const NutritionScreen({
    Key? key,
    required this.imageFile,
    required this.extractedText,
    required this.nutritionData,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Tabela Nutricional")),
      body: Column(
        children: [
          Image.file(imageFile, height: 200),
          Expanded(
            child: ListView(
              children: nutritionData.entries.map((entry) {
                return ListTile(
                  title: Text(entry.key),
                  subtitle: Text("${entry.value}"),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}