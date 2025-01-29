import 'package:flutter/material.dart';

import '../core.dart';

class BeShapeCustomTextField extends StatefulWidget {
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final String labelText;
  final String hintText;
  final IconData? icon;
  final bool isObscure;
  final void Function(String?)? onSaved;

  const BeShapeCustomTextField({
    super.key,
    this.controller,
    this.validator,
    this.icon,
    this.isObscure = false,
    this.onSaved,
    required this.labelText,
    required this.hintText,
  });

  @override
  State<BeShapeCustomTextField> createState() => _BeShapeCustomTextFieldState();
}

class _BeShapeCustomTextFieldState extends State<BeShapeCustomTextField> {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      validator: widget.validator,
      obscureText: widget.isObscure,
      decoration: InputDecoration(
        suffixIcon: 
        widget.isObscure?
        IconButton(
          icon: Icon(
            widget.isObscure ? Icons.visibility : Icons.visibility_off,
          ),
          onPressed: () {
            setState(() {
              !widget.isObscure;
            });
          },
        ): null,

        labelText: widget.labelText,
        labelStyle: const TextStyle(color: Colors.grey),
        hintText: widget.hintText,
        hintStyle: const TextStyle(color: Colors.grey),
        prefixIcon: Icon(widget.icon, color: BeShapeColors.primary),
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
      onSaved: widget.onSaved,
    );
  }
}
