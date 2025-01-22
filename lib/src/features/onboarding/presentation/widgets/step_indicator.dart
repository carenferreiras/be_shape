import 'package:flutter/material.dart';

import '../../../../core/core.dart';

class StepIndicator extends StatelessWidget {
  final int currentStep;
  final int totalSteps;

  const StepIndicator({
    super.key,
    required this.currentStep,
    required this.totalSteps,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        totalSteps,
        (index) => Container(
          width: index == currentStep ? 24.0 : 8.0,
          height: 8.0,
          margin: const EdgeInsets.symmetric(horizontal: 4.0),
          decoration: BoxDecoration(
            color: index == currentStep ? BeShapeColors.primary : Colors.grey[800],
            borderRadius: BorderRadius.circular(4.0),
          ),
        ),
      ),
    );
  }
}