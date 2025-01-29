
// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../features.dart';
import '../../../../core/core.dart';

class AgeInputStep extends StatelessWidget {
  const AgeInputStep({super.key});

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
                'How old are you?',
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
                  '${state.age ?? 25}',
                  style: const TextStyle(
                    fontSize: 96,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
              const Center(
                child: Text(
                  'years',
                  style: TextStyle(
                    fontSize: 24,
                    color: Colors.grey,
                  ),
                ),
              ),
              const SizedBox(height: 32),
              _buildAgeSlider(context, state),
            ],
          ),
        );
      },
    );
  }

  Widget _buildAgeSlider(BuildContext context, OnboardingState state) {
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
            value: (state.age ?? 25).toDouble(),
            min: 13,
            max: 100,
            divisions: 87,
            label: '${state.age ?? 25}',
            onChanged: (value) {
              context.read<OnboardingBloc>().add(UpdateAge(value.round()));
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Text(
                '13',
                style: TextStyle(color: Colors.grey),
              ),
              Text(
                '100',
                style: TextStyle(color: Colors.grey),
              ),
            ],
          ),
        ),
      ],
    );
  }
}