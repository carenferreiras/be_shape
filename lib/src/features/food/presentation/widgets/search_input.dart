import 'package:flutter/material.dart';

import '../../../../core/core.dart';

class SearchInput extends StatelessWidget {
  final TextEditingController controller;
  final String searchText;
  const SearchInput(
      {super.key, required this.controller, required this.searchText});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: TextField(
        style: TextStyle(color: BeShapeColors.textPrimary),
        controller: controller,
        decoration: InputDecoration(
          hintText: 'Pesquisar ${searchText}...',
          hintStyle: const TextStyle(color: Colors.grey),
          prefixIcon: const Icon(Icons.search, color: Colors.grey),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.grey[800]!),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: BeShapeColors.primary),
          ),
          filled: true,
          fillColor: Colors.grey[900],
        ),
      ),
    );
  }
}
