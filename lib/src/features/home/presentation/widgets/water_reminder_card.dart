import 'package:flutter/material.dart';

import '../../../../core/core.dart';

class WaterReminderCard extends StatelessWidget {
  final dynamic Function()? onPressed;
  final double progress;
  final int waterIntake;
  final double waterTarget;
  WaterReminderCard(
      {super.key,
      this.onPressed,
      required this.progress,
      required this.waterIntake,
      required this.waterTarget});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: BeShapeColors.link.withValues(alpha: (0.2)),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
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
              "Consumo Atual: $waterIntake ml / ${waterTarget.toInt()} ml",
              style: const TextStyle(color: Colors.white, fontSize: 14),
            ),
            const SizedBox(height: 8),
            LinearProgressIndicator(
              borderRadius: BorderRadius.circular(8),
              value: progress.clamp(0.0, 1.0),
              backgroundColor: BeShapeColors.link.withValues(alpha: (0.3)),
              valueColor:
                  const AlwaysStoppedAnimation<Color>(BeShapeColors.link),
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
                      style: TextStyle(color: Colors.white70, fontSize: 12),
                    ),
                    SizedBox(
                      width: 4,
                    ),
                    Icon(
                      Icons.water_drop_rounded,
                      color: BeShapeColors.link,
                      size: 10,
                    )
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                BeShapeCustomButton(
                  buttonColor: BeShapeColors.link.withValues(alpha: (0.5)),
                  buttonTitleColor: BeShapeColors.link,
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
}
