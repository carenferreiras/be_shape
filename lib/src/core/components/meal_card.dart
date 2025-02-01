import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../core.dart';
import '../../features/features.dart';

class MealCard extends StatelessWidget {
  const MealCard({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, authState) {
        final userId = context.read<AuthRepository>().currentUser?.uid;

        if (userId == null) {
          return const Center(child: Text("Usuário não autenticado"));
        }

        return FutureBuilder<UserProfile?>(
          future: context.read<UserRepository>().getUserProfile(userId),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                  child: CircularProgressIndicator(color: BeShapeColors.primary));
            }

            final userProfile = snapshot.data;
            if (userProfile == null) {
              return const Center(child: Text("Perfil do usuário não encontrado"));
            }

            return BlocBuilder<MealBloc, MealState>(
              builder: (context, state) {
                // 🔹 **Calcula os Macros Consumidos**
                double consumedProtein = 0;
                double consumedCarbs = 0;
                double consumedFat = 0;

                for (final meal in state.meals) {
                  consumedProtein += meal.proteins;
                  consumedCarbs += meal.carbs;
                  consumedFat += meal.fats;
                }

                // 🔹 **Agora Pegamos os Macros Direto da Collection `user`**
                final macroTargets = userProfile.macroTargets;

                return Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        BeShapeColors.primary.withOpacity(0.2),
                        BeShapeColors.primary.withOpacity(0.05),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(
                      color: BeShapeColors.primary.withOpacity(0.2),
                    ),
                  ),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          children: [
                            _buildMacroProgress(
                              'Proteína',
                              consumedProtein,
                              macroTargets.proteins, // 🔹 Agora pegamos os dados reais
                              Colors.blue,
                              Icons.fitness_center,
                            ),
                            const SizedBox(height: 20),
                            _buildMacroProgress(
                              'Carboidrato',
                              consumedCarbs,
                              macroTargets.carbs, // 🔹 Agora pegamos os dados reais
                              Colors.green,
                              Icons.grain,
                            ),
                            const SizedBox(height: 20),
                            _buildMacroProgress(
                              'Gordura',
                              consumedFat,
                              macroTargets.fats, // 🔹 Agora pegamos os dados reais
                              Colors.orange,
                              Icons.opacity,
                            ),
                          ],
                        ),
                      ),
                      
                    ],
                  ),
                );
              },
            );
          },
        );
      },
    );
  }

  Widget _buildMacroProgress(
    String label,
    double consumed,
    double target,
    Color color,
    IconData icon,
  ) {
    final progress = (consumed / target).clamp(0.0, 1.0);
    final percentage = (progress * 100).round();
    final remaining = target - consumed;

    return Column(
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: color.withOpacity(0.15),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                icon,
                color: color,
                size: 20,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        label,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: color.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          '$percentage%',
                          style: TextStyle(
                            color: color,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '${consumed.round()}/${target.round()}g',
                        style: TextStyle(
                          color: color,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Text(
                        '${remaining.round()}g Restante',
                        style: TextStyle(
                          color: Colors.grey[400],
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Stack(
                    children: [
                      Container(
                        height: 8,
                        decoration: BoxDecoration(
                          color: color.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                      FractionallySizedBox(
                        widthFactor: progress,
                        child: Container(
                          height: 8,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                              colors: [
                                color,
                                color.withOpacity(0.8),
                              ],
                            ),
                            borderRadius: BorderRadius.circular(4),
                            boxShadow: [
                              BoxShadow(
                                color: color.withOpacity(0.3),
                                blurRadius: 8,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}