import 'package:flutter/material.dart';

import '../../../../core/core.dart';
import '../../../features.dart';

class ProfileDetails extends StatelessWidget {
  final bool isEditing;
  final TextEditingController weightController;
  final TextEditingController targetWeightController;
  final Widget goalDropdown;
  final UserProfile userProfile;

  const ProfileDetails({
    super.key,
    required this.isEditing,
    required this.weightController,
    required this.targetWeightController,
    required this.goalDropdown,
    required this.userProfile,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Detalhes do Perfil",
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),

          /// 🔹 **Peso Atual**
          _buildEditableField("Peso Atual (kg)", weightController, isEditing),

          const SizedBox(height: 12),

          /// 🔹 **Peso Alvo**
          _buildEditableField("Peso Alvo (kg)", targetWeightController, isEditing),

          const SizedBox(height: 12),

          /// 🔹 **Objetivo (Dropdown quando editando)**
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Objetivo",
                style: TextStyle(color: Colors.grey, fontSize: 16),
              ),
              SizedBox(width: 120, child: goalDropdown),
            ],
          ),
           InfoRow(
            label: 'Altura',
            value: "${userProfile.height} cm",
          ),
          InfoRow(
            label: 'Nível de Atividade',
            value: userProfile.activityLevel.toString(),
          ),
        ],
      ),
    );
  }

  Widget _buildEditableField(String label, TextEditingController controller, bool isEditing) {
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