import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import '../../../../core/core.dart';
import '../../../features.dart';

class WaterTrackerScreen extends StatefulWidget {
  const WaterTrackerScreen({super.key});

  @override
  _WaterTrackerScreenState createState() => _WaterTrackerScreenState();
}

class _WaterTrackerScreenState extends State<WaterTrackerScreen> {
  final FirebaseAuthRepository _authRepository = FirebaseAuthRepository();
  double _waterTarget = 2000; // Padrão antes da carga dos dados

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final userProfile = await _authRepository.getUserProfile();
    if (userProfile != null) {
      setState(() {
        _waterTarget = calculateWaterTarget(userProfile.weight);
      });
    }
  }

  double calculateWaterTarget(double weight) {
    return weight * 35; // 35ml por kg de peso corporal
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('Controle de Água'),
        backgroundColor: Colors.black,
      ),
      body: BlocBuilder<WaterBloc, WaterState>(
        builder: (context, state) {
          if (state is WaterLoading) {
            return const Center(child: SpinKitThreeBounce(color: BeShapeColors.primary,));
          } else if (state is WaterLoaded) {
            final intake = state.intake.totalIntake;
            final progress = intake / _waterTarget;

            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  _buildWaterProgress(intake, progress),
                  const SizedBox(height: 32),
                  _buildWaterIntakeList(state.intake.entries),
                  const SizedBox(height: 16),
                  _buildTargetCard(_waterTarget.toInt()), // Usa a meta baseada no peso
                ],
              ),
            );
          } else {
            return const Center(
              child: Text('Erro ao carregar dados.', style: TextStyle(color: Colors.red)),
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddWaterDialog(context),
        backgroundColor: Colors.blue,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  /// 🔵 **Gráfico Circular**
 /// 🔵 **Gráfico Circular com CustomPaint e Borda**
Widget _buildWaterProgress(int intake, double progress) {
  return Stack(
    alignment: Alignment.center,
    children: [
      // Adiciona a borda ao redor do ClipOval
      Container(
        width: 200,
        height: 200,
        decoration: BoxDecoration(
          shape: BoxShape.circle, // Garante que seja um círculo
          border: Border.all(
            color: Colors.blue.withOpacity(0.3), // Cor da borda
            width: 8, // Espessura da borda
          ),
        ),
        child: ClipOval(
          child: CustomPaint(
            size: const Size(200, 200),
            painter: ModernWaterPainter(progress),
          ),
        ),
      ),
      // Texto centralizado
      Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            '$intake ml',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const Text(
            'Meta',
            style: TextStyle(
              color: Colors.grey,
              fontSize: 16,
            ),
          ),
        ],
      ),
    ],
  );
}

  /// 📋 **Lista de Entradas de Água**
  Widget _buildWaterIntakeList(List<WaterEntry> entries) {
  if (entries.isEmpty) {
    return const Center(
      child: Text(
        "Nenhum registro de água ainda!",
        style: TextStyle(color: Colors.white, fontSize: 16),
      ),
    );
  }

  return Expanded(
    child: ListView.builder(
      itemCount: entries.length,
      itemBuilder: (context, index) {
        final entry = entries[index];

        return Dismissible(
          key: Key(entry.time), // Identificador único
          direction: DismissDirection.endToStart, // Arrastar para a esquerda
          onDismissed: (direction) {
            // Disparar evento de exclusão no Bloc
            context.read<WaterBloc>().add(DeleteWaterIntake(entry));

            // Exibir mensagem de exclusão
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Entrada de ${entry.amount} ml removida!'),
                backgroundColor: Colors.red,
              ),
            );
          },
          background: Container(
            color: Colors.red,
            alignment: Alignment.centerRight,
            padding: const EdgeInsets.only(right: 16),
            child: const Icon(Icons.delete, color: Colors.white),
          ),
          child: Container(
            margin: const EdgeInsets.symmetric(vertical: 8),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.grey[900],
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Icon(Icons.local_drink, color: Colors.blue),
                    const SizedBox(width: 8),
                    Text(
                      '${entry.amount} ml',
                      style: const TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ],
                ),
                Text(
                  entry.time,
                  style: const TextStyle(color: Colors.grey, fontSize: 14),
                ),
              ],
            ),
          ),
        );
      },
    ),
  );
}

  /// 🎯 **Meta Diária**
  Widget _buildTargetCard(int target) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'Meta Diária',
            style: TextStyle(color: Colors.white, fontSize: 16),
          ),
          Text(
            '$target ml',
            style: const TextStyle(color: Colors.blue, fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  /// 🟦 **Diálogo para Adicionar Entrada de Água**
  void _showAddWaterDialog(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    final controller = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.grey[900],
          title: const Text('Adicionar Água', style: TextStyle(color: Colors.white)),
          content: Form(
            key: formKey,
            child: TextFormField(
              controller: controller,
              style: const TextStyle(color: Colors.white),
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Quantidade (ml)',
                labelStyle: const TextStyle(color: Colors.grey),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.grey[800]!),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Colors.blue),
                ),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Informe a quantidade de água';
                }
                if (int.tryParse(value) == null || int.parse(value) <= 0) {
                  return 'Informe um valor válido';
                }
                return null;
              },
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancelar', style: TextStyle(color: Colors.grey)),
            ),
            ElevatedButton(
              onPressed: () {
                if (formKey.currentState!.validate()) {
                  final amount = int.parse(controller.text);

                  // Dispara o evento para adicionar entrada de água
                  context.read<WaterBloc>().add(AddWaterIntake(amount));

                  Navigator.pop(context);
                }
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
              child: const Text('Adicionar'),
            ),
          ],
        );
      },
    );
  }
}
