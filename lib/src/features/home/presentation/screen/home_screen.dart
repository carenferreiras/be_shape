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
          title: const Text('Adicionar Água', style: TextStyle(color: Colors.white)),
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
              child: const Text('Cancelar', style: TextStyle(color: BeShapeColors.primary)),
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
              style: ElevatedButton.styleFrom(backgroundColor: BeShapeColors.primary.withOpacity(0.2)),
              child: const Text('Adicionar',style: TextStyle(color: BeShapeColors.primary),),
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
          ?  const Center(child: SpinKitThreeBounce(color: BeShapeColors.primary,))
          : FutureBuilder(
              future: context.read<UserRepository>().getUserProfile(userId),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: SpinKitThreeBounce(color: BeShapeColors.primary,));
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
                          _buildWaterReminderCard(),
                          const SizedBox(height: 24),

                          /// 📌 **Sessão de Hábitos do Dia**
                          CustomTitle(
                            title: 'Hábitos',
                            onTap: () =>
                                Navigator.pushNamed(context, '/habits'),
                          ),
                          const SizedBox(height: 16),
                          _buildDailyHabitsSection(),
                          const SizedBox(height: 24),
                          CustomTitle(
                            buttonTitle: 'Mais...',
                            title: 'Emoções',
                            onTap: () => _navigateToEmotionReportScreen(),
                          ),
                          const SizedBox(height: 16),

                          /// 📊 **Gráfico Horizontal de Emoções**
                          _buildEmotionBarChart(),

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

  /// 📊 **Gráfico Horizontal de Emoções**
  Widget _buildEmotionBarChart() {
    return BlocBuilder<HabitBloc, HabitState>(
      builder: (context, state) {
        if (state is HabitsLoading) {
          return const Center(child: SpinKitThreeBounce(color: BeShapeColors.primary,));
        } else if (state is HabitsLoaded) {
          final emotionCounts = _getEmotionCounts(state.habits);
          final total =
              emotionCounts.values.fold(0, (sum, value) => sum + value);

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: emotionCounts.entries.map((entry) {
              final emotion = entry.key;
              final count = entry.value;
              final percentage = total > 0 ? (count / total * 100).round() : 0;

              return Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: _buildEmotionBar(
                  emotion: emotion,
                  percentage: percentage,
                  count: count,
                  color: _getEmotionColor(emotion),
                ),
              );
            }).toList(),
          );
        }
        return const SizedBox.shrink();
      },
    );
  }

  /// 🔹 **Barra de Emoção Individual**
  Widget _buildEmotionBar({
    required String emotion,
    required int percentage,
    required int count,
    required Color color,
  }) {
    return Row(
      children: [
        CircleAvatar(
          radius: 6,
          backgroundColor: color,
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Stack(
            children: [
              Container(
                height: 20,
                decoration: BoxDecoration(
                  color: _getEmotionColorBar(emotion),
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              Container(
                height: 20,
                width: percentage.toDouble() * 2, // Proporção para a barra
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 8),
        Text(
          "$count ($percentage%)",
          style: const TextStyle(color: Colors.white),
        ),
      ],
    );
  }

  /// 🔹 **Calcula as Emoções**
  Map<String, int> _getEmotionCounts(List<Habit> habits) {
    final emotionCounts = <String, int>{};

    for (final habit in habits) {
      for (final checkIn in habit.checkIns) {
        emotionCounts[checkIn.emotion] =
            (emotionCounts[checkIn.emotion] ?? 0) + 1;
      }
    }

    return emotionCounts;
  }

  /// 🔹 **Cores para Emoções**
  Color _getEmotionColor(String emotion) {
    switch (emotion) {
      case 'Feliz':
        return Colors.green;
      case 'Triste':
        return Colors.blue;
      case 'Ansioso':
        return Colors.yellow;
      case 'Relaxado':
        return Colors.purple;
      case 'Cansado':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }

  /// 🔹 **Cores para Emoções**
  Color _getEmotionColorBar(String emotion) {
    switch (emotion) {
      case 'Feliz':
        return Colors.green.withOpacity(0.2);
      case 'Triste':
        return Colors.blue.withOpacity(0.2);
      case 'Ansioso':
        return Colors.yellow.withOpacity(0.2);
      case 'Relaxado':
        return Colors.purple.withOpacity(0.2);
      case 'Cansado':
        return Colors.orange.withOpacity(0.2);
      default:
        return Colors.grey;
    }
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

  /// 📌 **Constrói a Lista de Hábitos do Dia**
  Widget _buildDailyHabitsSection() {
    return BlocBuilder<HabitBloc, HabitState>(
      builder: (context, state) {
        if (state is HabitsLoading) {
          return const Center(child: SpinKitThreeBounce(color: BeShapeColors.primary,));
        } else if (state is HabitsLoaded) {
          if (state.habits.isEmpty) {
            return const Center(
              child: Text(
                "Nenhum hábito registrado para hoje",
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
            );
          }

          return SizedBox(
            height:
                200, // 🛑 Define um tamanho fixo para exibir os hábitos horizontalmente
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: state.habits.length,
              itemBuilder: (context, index) {
                final habit = state.habits[index];
                return Container(
                  width: 160, // Define a largura de cada card
                  margin: const EdgeInsets.only(right: 16),
                  child: HabitCard(habit: habit),
                );
              },
            ),
          );
        } else if (state is HabitError) {
          return Center(
            child: Text(
              state.message,
              style: const TextStyle(color: Colors.red, fontSize: 16),
            ),
          );
        }
        return const SizedBox.shrink();
      },
    );
  }
   /// 💧 **Card de Lembrete de Água**
  Widget _buildWaterReminderCard() {
    return BlocBuilder<WaterBloc, WaterState>(
      builder: (context, state) {
        if (state is WaterLoading) {
          return const Center(child: SpinKitThreeBounce(color: BeShapeColors.primary,));
        } else if (state is WaterLoaded) {
          _waterIntake = state.intake.totalIntake;
          final progress = _waterIntake / _waterTarget;

          return Card(
            color: Colors.blue[900]!.withOpacity(0.2),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "💧 Mantenha-se Hidratado!",
                    style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
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
                    valueColor: const AlwaysStoppedAnimation<Color>(Colors.blue),
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
                          SizedBox(width: 4,),
                          Icon(Icons.water_drop_rounded,color: Colors.blue,size: 10,)
                        ],
                      ),
                      const SizedBox(height: 20,),
                      BeShapeCustomButton(
                        buttonColor: Colors.blue.withOpacity(0.5),
                        buttonTitleColor: Colors.blue,
                        label: '+ Água', 
                        icon: Icons.water_drop_outlined,
                        isLoading: false,
                        onPressed: _showAddWaterDialog,
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
