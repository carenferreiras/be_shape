import 'package:flutter/material.dart';

class BuildUnitSelector extends StatelessWidget {
  final void Function(String?)? onChanged;
  final String? value;
  const BuildUnitSelector({super.key, this.onChanged, this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[800]!),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          dropdownColor: Colors.grey[900],
          style: const TextStyle(color: Colors.white),
          items: ['g', 'ml', 'oz', 'cup'].map((String unit) {
            return DropdownMenuItem<String>(
              value: unit,
              child: Text(unit),
            );
          }).toList(),
          onChanged:onChanged,
        ),
      ),
    );
  }
}