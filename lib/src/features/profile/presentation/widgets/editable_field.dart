import 'package:flutter/material.dart';

import '../../../../core/core.dart';

class EditableField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final bool isEditing;
  const EditableField(
      {super.key,
      required this.label,
      required this.controller,
      required this.isEditing});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(color: Colors.grey, fontSize: 16)),
        isEditing
            ? SizedBox(
                width: 100,
                child: TextField(
                  controller: controller,
                  keyboardType: TextInputType.number,
                  style: const TextStyle(
                      color: Colors.white, fontWeight: FontWeight.w700),
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(color: BeShapeColors.primary),
                    ),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 8),
                  ),
                ),
              )
            : Text(
                controller.text,
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w700),
              ),
      ],
    );
  }
}
