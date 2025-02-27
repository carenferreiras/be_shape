import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../features.dart';
import '../../../../core/core.dart';

class WeightInputStep extends StatelessWidget {
  const WeightInputStep({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OnboardingBloc, OnboardingState>(
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'What is your weight?',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  height: 1.2,
                ),
              ),
              const SizedBox(height: 32),
              Row(
                children: [
                  _buildUnitButton(
                    context,
                    'kg',
                    state.weightUnit == 'kg',
                  ),
                  const SizedBox(width: 16),
                  _buildUnitButton(
                    context,
                    'lbs',
                    state.weightUnit == 'lbs',
                  ),
                ],
              ),
              const SizedBox(height: 32),
              Center(
                child: Text(
                  state.weight.toStringAsFixed(1),
                  style: const TextStyle(
                    fontSize: 96,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
              Center(
                child: Text(
                  state.weightUnit,
                  style: const TextStyle(
                    fontSize: 24,
                    color: Colors.grey,
                  ),
                ),
              ),
              const SizedBox(height: 32),
              _buildWeightSlider(context, state),
            ],
          ),
        );
      },
    );
  }

  Widget _buildUnitButton(BuildContext context, String unit, bool isSelected) {
    return Expanded(
      child: GestureDetector(
        onTap: () {
          context.read<OnboardingBloc>().add(UpdateWeightUnit(unit));
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isSelected ? BeShapeColors.link : Colors.grey[900],
            borderRadius: BorderRadius.circular(30),
          ),
          child: Text(
            unit,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: isSelected ? Colors.white : Colors.grey,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildWeightSlider(BuildContext context, OnboardingState state) {
    final minWeight = state.weightUnit == 'kg' ? 40.0 : 88.0;
    final maxWeight = state.weightUnit == 'kg' ? 200.0 : 440.0;

    return Column(
      children: [
        SliderTheme(
          data: SliderTheme.of(context).copyWith(
            activeTrackColor: BeShapeColors.primary,
            inactiveTrackColor: Colors.grey[800],
            thumbColor: Colors.white,
            overlayColor: BeShapeColors.primary.withOpacity(0.2),
            valueIndicatorColor: BeShapeColors.primary,
            valueIndicatorTextStyle: const TextStyle(color: Colors.white),
            showValueIndicator: ShowValueIndicator.always,
          ),
          child: Slider(
            value: state.weight,
            min: minWeight,
            max: maxWeight,
            divisions: 160,
            label: state.weight.toStringAsFixed(1),
            onChanged: (value) {
              context.read<OnboardingBloc>().add(UpdateWeight(value));
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                minWeight.toStringAsFixed(0),
                style: const TextStyle(color: Colors.grey),
              ),
              Text(
                maxWeight.toStringAsFixed(0),
                style: const TextStyle(color: Colors.grey),
              ),
            ],
          ),
        ),
      ],
    );
  }
}