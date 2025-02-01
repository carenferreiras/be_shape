import 'package:flutter/material.dart';

import '../../../../core/core.dart';
import '../../../auth/auth.dart';

class IdealValuesCard extends StatelessWidget {
  final UserProfile userProfile;

  const IdealValuesCard({Key? key, required this.userProfile}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    /// 🔹 **Valores Diretos do Perfil**
    double tdee = userProfile.tdee; // 🔹 TDEE armazenado no Firestore
    MacroTargets macroTargets = userProfile.macroTargets; // 🔹 Pegamos os macros salvos

    /// 🔹 **Meta de Água**
    double waterIntake = userProfile.weight * 35; // 35ml por kg de peso

    return Card(
      color: BeShapeColors.primary.withOpacity(0.1),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
           
            const SizedBox(height: 12),

            /// 🔹 **Valores Nutricionais**
            _buildInfoRow(background: BeShapeColors.primary, icon: "🔥",label: "Calorias Ideais:",value:"${tdee.toStringAsFixed(0)} kcal" ),
            _buildInfoRow(label: 'Proteína:', value: '${macroTargets.proteins.toStringAsFixed(1)}g', icon: '🍗', background: Colors.blue),
            _buildInfoRow(label: 'Gordura:', value: '${macroTargets.fats.toStringAsFixed(1)}g', icon: '🥑', background: Colors.yellow),
            _buildInfoRow(label: 'Carboidratos', value: '${macroTargets.carbs.toStringAsFixed(1)}g', icon: '🍞', background: Colors.green),

            const SizedBox(height: 12),

            /// 💧 **Meta de Água**
            _buildInfoRow(label: 'Consumo de Água:', value: '${waterIntake.toStringAsFixed(0)} ml', icon: '💧', background: Colors.grey),

            const SizedBox(height: 12),

            /// 🏋️‍♂️ **Sugestão de Atividade**
            Text(
              "🏋️‍♂️ Para melhores resultados, mantenha-se ativo e siga sua meta diária!",
              style: TextStyle(
                color: Colors.white70,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(
   {
    required String label, required String value,
   required  String icon,required Color background,
   }

    ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Card(
                color: background.withOpacity(0.2),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(icon),
                ),
              ),
              SizedBox(width: 10,),
               Text(
            label,
            style: TextStyle(
              color: Colors.white70,
              fontSize: 14,
            ),
          ),
            ],
          ),
          Text(
            value,
            style: TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}