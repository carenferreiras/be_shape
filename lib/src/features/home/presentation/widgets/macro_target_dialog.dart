import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/core.dart';
import '../../../features.dart';

class MacroTargetDialog extends StatelessWidget {
   final BuildContext context;
   final String macro;
    final double currentValue;
    final UserProfile userProfile;
    final TextEditingController? controller;
  const MacroTargetDialog({super.key, required this.context, required this.macro, required this.currentValue, required this.userProfile, this.controller});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
        backgroundColor: Colors.grey[900],
        title: Text(
          'Set $macro Target',
          style: const TextStyle(color: Colors.white),
        ),
        content: TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            labelText: 'Target (g)',
            labelStyle: const TextStyle(color: Colors.grey),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey[700]!),
            ),
            focusedBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: BeShapeColors.primary),
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              final newValue = double.tryParse(controller!.text);
              if (newValue != null) {
                final updatedMacros = MacroTargets(
                  proteins: macro == 'Protein'
                      ? newValue
                      : userProfile.macroTargets.proteins,
                  carbs: macro == 'Carbs'
                      ? newValue
                      : userProfile.macroTargets.carbs,
                  fats:
                      macro == 'Fat' ? newValue : userProfile.macroTargets.fats,
                );

                final updatedProfile = userProfile.copyWith(
                  macroTargets: updatedMacros,
                );

                await context
                    .read<UserRepository>()
                    .updateUserProfile(updatedProfile);

                if (context.mounted) {
                  Navigator.pop(context);
                  // Refresh the screen
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const HomeScreen(),
                    ),
                  );
                }
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: BeShapeColors.primary,
            ),
            child: const Text('Save'),
          ),
        ],
      );
  }
}