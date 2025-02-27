
import 'package:be_shape_app/src/core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../features.dart';

class WaterIntakeCard extends StatelessWidget {
  final double weight;

  const WaterIntakeCard({
    super.key,
    required this.weight,
  });

  double get _recommendedIntake => weight * 35; // ml por kg

  void _showAddWaterDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AddWaterDialog(
        onAdd: (amount) {
          context.read<WaterBloc>().add(AddWater(amount));
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WaterBloc, WaterState>(
      builder: (context, state) {
        final currentIntake = state.currentIntake;
        final intakeProgress =
            (currentIntake / _recommendedIntake).clamp(0.0, 1.0);
        final remainingGlasses =
            ((_recommendedIntake - currentIntake) / 250).ceil();

        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.grey[900],
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: BeShapeColors.link.withOpacity(0.3)),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                BeShapeColors.link.withOpacity(0.2),
                BeShapeColors.background,
              ],
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Ingestão de Água',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    onPressed: () => _showAddWaterDialog(context),
                    icon: const Icon(Icons.add_circle_outline),
                    color: BeShapeColors.link,
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildProgressBar(intakeProgress),
                        const SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            _buildIntakeInfo(
                              'Consumido',
                              '${currentIntake.round()}ml',
                              Icons.water_drop,
                              BeShapeColors.link,
                            ),
                            _buildIntakeInfo(
                              'Meta',
                              '${_recommendedIntake.round()}ml',
                              Icons.flag,
                              BeShapeColors.success,
                            ),
                            _buildIntakeInfo(
                              'Restante',
                              '$remainingGlasses copos',
                              Icons.local_drink,
                              BeShapeColors.primary,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                  _buildWaterBottle(intakeProgress),
                ],
              ),
              const SizedBox(height: 16),
              _buildTips(),
            ],
          ),
        );
      },
    );
  }

  Widget _buildProgressBar(double progress) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '${(progress * 100).round()}% da meta diária',
          style: TextStyle(
            color: Colors.grey[400],
            fontSize: 14,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          height: 8,
          decoration: BoxDecoration(
            color: Colors.grey[800],
            borderRadius: BorderRadius.circular(4),
          ),
          child: FractionallySizedBox(
            widthFactor: progress,
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    BeShapeColors.link,
                    Colors.blue.shade300,
                  ],
                ),
                borderRadius: BorderRadius.circular(4),
                boxShadow: [
                  BoxShadow(
                    color: BeShapeColors.link.withOpacity(0.5),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildIntakeInfo(
      String label, String value, IconData icon, Color color) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withOpacity(0.2),
            shape: BoxShape.circle,
          ),
          child: Icon(
            icon,
            color: color,
            size: 20,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            color: color,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            color: Colors.grey[400],
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  Widget _buildWaterBottle(double progress) {
    return Container(
      width: 60,
      height: 120,
      decoration: BoxDecoration(
        color: BeShapeColors.link.withOpacity(0.1),
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(30),
          bottom: Radius.circular(30),
        ),
        border: Border.all(
          color: BeShapeColors.link.withOpacity(0.3),
          width: 2,
        ),
      ),
      clipBehavior: Clip.antiAlias, // Importante para conter a água
      child: Stack(
        children: [
          // Água
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            height: 120 *
                progress.clamp(0.0, 1.0), // Limita o progresso entre 0 e 1
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    BeShapeColors.link.withOpacity(0.2),
                    BeShapeColors.link.withOpacity(0.4),
                    BeShapeColors.link.withOpacity(0.6),
                  ],
                ),
                borderRadius: BorderRadius.vertical(
                  top: const Radius.circular(28),
                  bottom: progress >= 0.98
                      ? const Radius.circular(28)
                      : Radius.zero,
                ),
              ),
              child: CustomPaint(
                size: Size.infinite,
                painter: WaterWavePainter(
                  color: BeShapeColors.link.withOpacity(0.3),
                ),
              ),
            ),
          ),

         
        ],
      ),
    );
  }

  Widget _buildTips() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[850],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.amber.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.lightbulb_outline,
              color: Colors.amber,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Dica do dia',
                  style: TextStyle(
                    color: Colors.amber,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Mantenha uma garrafa de água próxima durante o dia para lembrar de se hidratar regularmente.',
                  style: TextStyle(
                    color: Colors.grey[400],
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}