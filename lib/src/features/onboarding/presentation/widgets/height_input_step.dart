
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../features.dart';
import '../../../../core/core.dart';

class HeightInputStep extends StatelessWidget {
  const HeightInputStep({super.key});

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
                'What is your height?',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  height: 1.2,
                ),
              ),
              const SizedBox(height: 32),
              Center(
                child: Text(
                  '${(state.height ?? 170).round()}',
                  style: const TextStyle(
                    fontSize: 96,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
              const Center(
                child: Text(
                  'cm',
                  style: TextStyle(
                    fontSize: 24,
                    color: Colors.grey,
                  ),
                ),
              ),
              const SizedBox(height: 32),
              _buildHeightSlider(context, state),
            ],
          ),
        );
      },
    );
  }

  Widget _buildHeightSlider(BuildContext context, OnboardingState state) {
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
            value: state.height ?? 170,
            min: 140,
            max: 220,
            divisions: 80,
            label: '${(state.height ?? 170).round()}',
            onChanged: (value) {
              context.read<OnboardingBloc>().add(UpdateHeight(value));
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Text(
                '140',
                style: TextStyle(color: Colors.grey),
              ),
              Text(
                '220',
                style: TextStyle(color: Colors.grey),
              ),
            ],
          ),
        ),
      ],
    );
  }
}