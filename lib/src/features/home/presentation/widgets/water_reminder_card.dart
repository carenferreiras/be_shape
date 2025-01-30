import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import '../../../../core/core.dart';
import '../../../features.dart';

class WaterReminderCard extends StatelessWidget {
  final dynamic Function()? onPressed;
  WaterReminderCard({super.key, this.onPressed});

  @override
  Widget build(BuildContext context) {
    double _waterTarget = 2000; // Meta de água padrão
    int _waterIntake = 0;

    return BlocBuilder<WaterBloc, WaterState>(
      builder: (context, state) {
        if (state is WaterLoading) {
          return const Center(
              child: SpinKitThreeBounce(
            color: BeShapeColors.primary,
          ));
        } else if (state is WaterLoaded) {
          _waterIntake = state.intake.totalIntake;
          final progress = _waterIntake / _waterTarget;

          return Card(
            color: Colors.blue[900]!.withOpacity(0.2),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "💧 Mantenha-se Hidratado!",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Consumo Atual: $_waterIntake ml / ${_waterTarget.toInt()} ml",
                    style: const TextStyle(color: Colors.white, fontSize: 14),
                  ),
                  const SizedBox(height: 8),
                  LinearProgressIndicator(
                    value: progress.clamp(0.0, 1.0),
                    backgroundColor: Colors.blue[700]!.withOpacity(0.3),
                    valueColor:
                        const AlwaysStoppedAnimation<Color>(Colors.blue),
                  ),
                  const SizedBox(height: 12),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            "Não se esqueça de beber água regularmente!",
                            style:
                                TextStyle(color: Colors.white70, fontSize: 12),
                          ),
                          SizedBox(
                            width: 4,
                          ),
                          Icon(
                            Icons.water_drop_rounded,
                            color: Colors.blue,
                            size: 10,
                          )
                        ],
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      BeShapeCustomButton(
                        buttonColor: Colors.blue.withOpacity(0.5),
                        buttonTitleColor: Colors.blue,
                        label: '+ Água',
                        icon: Icons.water_drop_outlined,
                        isLoading: false,
                        onPressed: onPressed,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        }
        return const SizedBox.shrink();
      },
    );
  }
}
