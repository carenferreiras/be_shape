import 'package:be_shape_app/src/features/features.dart';
import 'package:flutter/material.dart';


class ProfileDetails extends StatelessWidget {
  final bool isEditing;
  final TextEditingController weightController;
  final TextEditingController targetWeightController;
  final TextEditingController goalController;
  final UserProfile? userProfile;

  const ProfileDetails(
      {super.key,
      required this.isEditing,
      required this.weightController,
      required this.targetWeightController,
      required this.goalController,
      this.userProfile});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          EditableField(
              label: 'Peso Atual (kg)',
              controller: weightController,
              isEditing: isEditing),
          const SizedBox(height: 12),
          EditableField(
              label: 'Peso Alvo (kg)',
              controller: targetWeightController,
              isEditing: isEditing),
          const SizedBox(height: 12),
          EditableField(
              label: 'Objetivo',
              controller: goalController,
              isEditing: isEditing),
          const SizedBox(height: 12),
          InfoRow(
            label: 'Altura',
            value: "${userProfile!.height} cm",
          ),
          InfoRow(
            label: 'Nível de Atividade',
            value: userProfile!.activityLevel.toString(),
          ),
        ],
      ),
    );
  }
}
