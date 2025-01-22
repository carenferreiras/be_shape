import 'package:flutter/material.dart';

import '../core.dart';


class BeShapeCustomTextField extends StatelessWidget {
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final String labelText;
  final String hintText;
  final IconData? icon;
  final bool? isObscure;

  const BeShapeCustomTextField({
    super.key,
    this.controller,
    this.validator,
    this.icon,
    this.isObscure,
    required this.labelText,
    required this.hintText,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      validator: validator,
      obscureText: isObscure ?? false,
      decoration: InputDecoration(
        labelText: labelText,
        labelStyle: const TextStyle(color: Colors.grey),
        hintText: hintText,
        hintStyle: const TextStyle(color: Colors.grey),
        prefixIcon: Icon(icon, color: BeShapeColors.primary),
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: BeShapeColors.primary),
          borderRadius: BorderRadius.circular(BeShapeSizes.borderRadiusLarge),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: BeShapeColors.primary),
          borderRadius: BorderRadius.circular(BeShapeSizes.borderRadiusLarge),
        ),
        filled: true,
        fillColor: const Color(0xFF1C1C1E), // Fundo do campo
      ),
      style: const TextStyle(color: Colors.white),
    );
  }
}
