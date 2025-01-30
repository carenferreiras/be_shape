// ignore_for_file: unused_field

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';
import '../../../../core/core.dart';
import '../../../features.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  double _waterTarget = 2000; // Meta de água padrão
  int _waterIntake = 0;
  @override
  void initState() {
    super.initState();
    _loadTodayData();
    _loadUserWaterTarget();
  }


  void _loadTodayData() {
    final userId = context.read<AuthRepository>().currentUser?.uid;
    if (userId != null) {
      final today = DateTime.now();
      final formattedDate = DateFormat('yyyy-MM-dd').format(today);

      // Carregar refeições do dia
      context.read<MealBloc>().add(LoadMealsForDate(today));

      // Carregar hábitos do dia
      context.read<HabitBloc>().add(LoadHabitsEvent(formattedDate));
    }
  }

  /// 🔹 **Busca o perfil do usuário para definir a meta de água**
  Future<void> _loadUserWaterTarget() async {
    final userProfile = await context.read<AuthRepository>().getUserProfile();
    if (userProfile != null) {
      setState(() {
        _waterTarget = _calculateWaterTarget(userProfile.weight);
      });
    }
  }

  /// 🔹 **Calcula a meta de água baseada no peso corporal**
  double _calculateWaterTarget(double weight) {
    return weight * 35; // 35ml por kg
  }

  /// 🔹 **Mostra um diálogo para adicionar consumo de água**
  void _showAddWaterDialog() {
    final controller = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.grey[900],
          title: const Text('Adicionar Água',
              style: TextStyle(color: Colors.white)),
          content: TextField(
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
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancelar',
                  style: TextStyle(color: BeShapeColors.primary)),
            ),
            ElevatedButton(
              onPressed: () {
                final amount = int.tryParse(controller.text) ?? 0;
                if (amount > 0) {
                  setState(() {
                    _waterIntake += amount;
                  });

                  // Dispara o evento para atualizar o consumo de água no Bloc
                  context.read<WaterBloc>().add(AddWaterIntake(amount));

                  Navigator.pop(context);
                }
              },
              style: ElevatedButton.styleFrom(
                  backgroundColor: BeShapeColors.primary.withOpacity(0.2)),
              child: const Text(
                'Adicionar',
                style: TextStyle(color: BeShapeColors.primary),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final userId = context.read<AuthRepository>().currentUser?.uid;

    return Scaffold(
      backgroundColor: Colors.black,
      drawer: userId == null ? null : BeShapeDrawer(userId: userId),
      body: userId == null
          ? const Center(
              child: SpinKitThreeBounce(
              color: BeShapeColors.primary,
            ))
          : FutureBuilder(
              future: context.read<UserRepository>().getUserProfile(userId),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                      child: SpinKitThreeBounce(
                    color: BeShapeColors.primary,
                  ));
                }

                final userProfile = snapshot.data;
                if (userProfile == null) {
                  return const Center(child: Text('No user profile found'));
                }

                return SafeArea(
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Builder(
                                builder: (context) => Card(
                                  color: BeShapeColors.primary.withOpacity(0.2),
                                  child: IconButton(
                                    icon: const Icon(Icons.menu,
                                        color: BeShapeColors.primary),
                                    onPressed: () =>
                                        Scaffold.of(context).openDrawer(),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: UserHeader(userProfile: userProfile),
                              ),
                            ],
                          ),

                          const SizedBox(height: 16),

                          dateWidet,
                          const SizedBox(height: 24),
                          FitnessMetrics(userProfile: userProfile),
                          const SizedBox(height: 24),
                          CustomTitle(
                            title: 'Meal',
                            onTap: () =>
                                Navigator.pushNamed(context, '/saved-food'),
                          ),
                          const SizedBox(height: 16),
                          MealCard(userProfile: userProfile),
                          const SizedBox(height: 32),
                          CustomTitle(
                            title: 'Controle de Água',
                            onTap: () =>
                                Navigator.pushNamed(context, '/water-tracker'),
                          ),
                          const SizedBox(height: 16),
                          WaterReminderCard(
                            onPressed: _showAddWaterDialog,
                          ),
                          const SizedBox(height: 24),

                          /// 📌 **Sessão de Hábitos do Dia**
                          CustomTitle(
                            title: 'Hábitos',
                            onTap: () =>
                                Navigator.pushNamed(context, '/habits'),
                          ),
                          const SizedBox(height: 16),
                          DailyHabitsSection(),
                          const SizedBox(height: 24),
                          CustomTitle(
                            buttonTitle: 'Mais...',
                            title: 'Emoções',
                            onTap: () => _navigateToEmotionReportScreen(),
                          ),
                          const SizedBox(height: 16),

                          /// 📊 **Gráfico Horizontal de Emoções**
                          EmotionBarChart(),
                          const SizedBox(height: 24),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
      bottomNavigationBar: const BeShapeNavigatorBar(
        index: 0,
      ),
    );
  }

  /// 📌 **Navegar para a Tela de Relatórios Emocionais**
  void _navigateToEmotionReportScreen() {
    final state = context.read<HabitBloc>().state;
    if (state is HabitsLoaded) {
      final List<Habit> habits =
          state.habits.cast<Habit>(); // 🔹 Converte para List<Habit>

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => EmotionReportScreen(habits: habits),
        ),
      );
    }
  }
}
