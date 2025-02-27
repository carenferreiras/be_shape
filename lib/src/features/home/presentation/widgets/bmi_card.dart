import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/core.dart';
import '../../../features.dart';

class BMICard extends StatelessWidget {
  final UserProfile userProfile;
  final VoidCallback onWeightUpdated;

  const BMICard({
    super.key,
    required this.userProfile,
    required this.onWeightUpdated,
  });

  Color _getBMIColor(double bmi) {
    if (bmi < 18.5) return BeShapeColors.primary; // Abaixo do peso
    if (bmi < 25) return Colors.green; // Peso normal
    if (bmi < 30) return BeShapeColors.primary; // Sobrepeso
    return Colors.red; // Obesidade
  }

  String _getBMIClassification(double bmi) {
    if (bmi < 16) return 'Magreza grave';
    if (bmi < 17) return 'Magreza moderada';
    if (bmi < 18.5) return 'Magreza leve';
    if (bmi < 25) return 'Peso normal';
    if (bmi < 30) return 'Sobrepeso';
    if (bmi < 35) return 'Obesidade Grau I';
    if (bmi < 40) return 'Obesidade Grau II';
    return 'Obesidade Grau III';
  }

  String _getBMIRecommendation(double bmi) {
    if (bmi < 18.5) {
      return 'Procure aumentar sua ingestão calórica e fazer exercícios de força.';
    }
    if (bmi < 25) {
      return 'Seu peso está ideal! Mantenha os bons hábitos.';
    }
    if (bmi < 30) {
      return 'Considere reduzir um pouco as calorias e aumentar a atividade física.';
    }
    return 'Recomendamos consultar um profissional de saúde para um plano personalizado.';
  }

  Future<void> _updateWeight(BuildContext context) async {
    final controller =
        TextEditingController(text: userProfile.weight.toString());

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.grey[900],
        title: const Text(
          'Atualizar Peso Atual',
          style: TextStyle(color: Colors.white),
        ),
        content: TextField(
          controller: controller,
          style: const TextStyle(color: Colors.white),
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            labelText: 'Peso (kg)',
            labelStyle: const TextStyle(color: Colors.grey),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey[800]!),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(24),
              borderSide: BorderSide(color: Colors.blue),
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'Cancelar',
              style: TextStyle(color: Colors.grey),
            ),
          ),
          ElevatedButton(
            onPressed: () async {
              final newWeight = double.tryParse(controller.text);
              if (newWeight != null && newWeight > 0) {
                try {
                  // Atualiza o perfil do usuário
                  final updatedProfile =
                      userProfile.copyWith(weight: newWeight);
                  await context
                      .read<UserRepository>()
                      .updateUserProfile(updatedProfile);

                  // Atualiza o WeightBloc
                  context.read<WeightBloc>().add(WeightUpdated(newWeight));

                  // Força atualização do AuthBloc para refletir as mudanças
                  if (context.mounted) {
                    final userId =
                        context.read<AuthRepository>().currentUser?.uid;
                    if (userId != null) {
                      final refreshedProfile = await context
                          .read<UserRepository>()
                          .getUserProfile(userId);
                      context.read<AuthBloc>().add(AuthStateChanged(true,
                          userProfile: refreshedProfile));
                    }
                  }

                  if (context.mounted) {
                    Navigator.pop(context);

                    // Mostra feedback de sucesso
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Peso atualizado com sucesso!'),
                        backgroundColor: Colors.green,
                      ),
                    );
                  }
                } catch (e) {
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Erro ao atualizar peso: $e'),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                }
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
            ),
            child: const Text('Atualizar'),
          ),
        ],
      ),
    );
  }

  String _formatNumber(double number) {
    return number.toStringAsFixed(1);
  }

  @override
  Widget build(BuildContext context) {
    final bmiColor = _getBMIColor(userProfile.bmi);
    final bmiClass = _getBMIClassification(userProfile.bmi);
    final recommendation = _getBMIRecommendation(userProfile.bmi);

    // Format the numbers
    final formattedBMI = _formatNumber(userProfile.bmi);
    final formattedWeight = _formatNumber(userProfile.weight);
    final formattedIdealWeight = _formatNumber(userProfile.idealWeight);
    final formattedTargetWeight = _formatNumber(userProfile.targetWeight);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            BeShapeColors.primary.withOpacity(0.2),
            BeShapeColors.background.withOpacity(0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: BeShapeColors.primary.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: bmiColor.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.monitor_weight,
                  color: bmiColor,
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Text(
                  'Índice de Massa Corporal (IMC)',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Seu IMC',
                    style: TextStyle(
                      color: Colors.grey[400],
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    formattedBMI,
                    style: TextStyle(
                      color: bmiColor,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: bmiColor.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  bmiClass,
                  style: TextStyle(
                    color: bmiColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.grey[850],
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.info_outline,
                  color: bmiColor,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    recommendation,
                    style: const TextStyle(
                      color: Colors.grey,
                      fontSize: 14,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                onTap: () => _updateWeight(context),
                child: _buildInfoItem(
                  'Peso Atual',
                  '${formattedWeight}kg',
                  Colors.blue,
                  true,
                ),
              ),
              _buildInfoItem(
                'Peso Ideal',
                '${formattedIdealWeight}kg',
                Colors.green,
                false,
              ),
              _buildInfoItem(
                'Meta',
                '${formattedTargetWeight}kg',
                BeShapeColors.primary,
                false,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInfoItem(
      String label, String value, Color color, bool isEditable) {
    return Column(
      children: [
        Text(
          label,
          style: TextStyle(
            color: Colors.grey[400],
            fontSize: 12,
          ),
        ),
        const SizedBox(height: 4),
        Row(
          children: [
            Text(
              value,
              style: TextStyle(
                color: color,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            if (isEditable) ...[
              const SizedBox(width: 4),
              Icon(
                Icons.edit,
                color: color,
                size: 14,
              ),
            ],
          ],
        ),
      ],
    );
  }
}
