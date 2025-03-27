import 'package:flutter/material.dart';

import '../../../../core/core.dart';

class SearchMyFoodTab extends StatelessWidget {
  final TextEditingController searchController;
  final void Function(String)? onChanged;
  final void Function()? onPressed;

  const SearchMyFoodTab(
      {super.key,
      required this.searchController,
      this.onChanged,
      this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(BeShapeSizes.paddingMedium),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: searchController,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                suffixIcon: IconButton(
                    onPressed: onPressed,
                    icon: Icon(
                      Icons.search,
                      color: BeShapeColors.primary,
                    )),
                hintText: 'Pesquisar...',
                hintStyle: const TextStyle(color: Colors.grey),
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
              onChanged: onChanged,
            ),
          ),
          const SizedBox(width: 8),
          IconButton(
            icon: const Icon(Icons.add_circle_outline,
                color: BeShapeColors.primary),
            onPressed: () => Navigator.pushNamed(context, '/saved-food'),
          ),
        ],
      ),
    );
  }
}
