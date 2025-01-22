import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../features.dart';
import '../../../../core/core.dart';

class GenderSelectionStep extends StatelessWidget {
  const GenderSelectionStep({super.key});

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
                'What is your gender?',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  height: 1.2,
                ),
              ),
              const SizedBox(height: 32),
              _buildGenderCard(
                context,
                'male',
                'assets/images/male.png',
                state.selectedGender == 'male',
              ),
              const SizedBox(height: 16),
              _buildGenderCard(
                context,
                'female',
                'assets/images/woman.png',
                state.selectedGender == 'female',
              ),
              const SizedBox(height: 16),
              TextButton(
                onPressed: () {
                  context.read<OnboardingBloc>().add(const UpdateGender('skip'));
                },
                child: const Text(
                  'Prefer to skip, thanks!',
                  style: TextStyle(color: BeShapeColors.primary),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildGenderCard(
    BuildContext context,
    String gender,
    String image,
    bool isSelected,
  ) {
    return GestureDetector(
      onTap: () {
        context.read<OnboardingBloc>().add(UpdateGender(gender));
      },
      child: Container(
        height: 120,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? BeShapeColors.primary : Colors.transparent,
            width: 2,
          ),
        ),
        child: Stack(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(14),
              child: Image.asset(
                image,
                width: double.infinity,
                height: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(14),
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Colors.black.withOpacity(0.7),
                  ],
                ),
              ),
            ),
            Positioned(
              left: 16,
              bottom: 16,
              child: Row(
                children: [
                  Icon(
                    gender == 'male' ? Icons.male : Icons.female,
                    color: Colors.white,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    gender == 'male' ? 'Male' : 'Female',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            if (isSelected)
              Positioned(
                right: 16,
                top: 16,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: const BoxDecoration(
                    color: BeShapeColors.primary,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.check,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}