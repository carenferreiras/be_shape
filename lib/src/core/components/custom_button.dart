import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import '../core.dart';




class BeShapeCustomButton extends StatelessWidget {
  final bool isLoading;
  final Function()? onPressed;
  final String label;
  final IconData? icon;
  final bool? isTransparent;
  const BeShapeCustomButton({
    super.key,
    this.onPressed,
    this.icon,
    this.isTransparent = false,
    required this.label,
    required this.isLoading,
    
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: isTransparent == false? BeShapeColors.primary : BeShapeColors.transparent, 
          shape: RoundedRectangleBorder(
            side:  BorderSide(color: isTransparent == false? BeShapeColors.transparent: BeShapeColors.primary),
            borderRadius:
                BorderRadius.circular(BeShapeSizes.borderRadiusMedium),
          ),
          padding:
              const EdgeInsets.symmetric(vertical: BeShapeSizes.paddingMedium),
        ),
        child: isLoading
            ? const SpinKitThreeBounce(
                color: BeShapeColors.background,
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if(icon != null)
                  Icon(icon ?? Icons.arrow_forward_ios, color: BeShapeColors.background),
                  Text(
                    label,
                    style: const TextStyle(
                      color: BeShapeColors.background,
                      fontSize: BeShapeSizes.paddingMedium,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(width: BeShapeSizes.paddingSmall),
                  if(icon == null)
                  const Icon(Icons.arrow_forward_ios, color: BeShapeColors.background)
                ],
              ),
      ),
    );
  }
}
