import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../../../../core/core.dart';
import '../../../features.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    _loadTodayData();
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

  @override
  Widget build(BuildContext context) {
    final userId = context.read<AuthRepository>().currentUser?.uid;

    return Scaffold(
      backgroundColor: Colors.black,
      drawer: userId == null ? null : BeShapeDrawer(userId: userId),
      body: userId == null
          ? const Center(child: CircularProgressIndicator())
          : FutureBuilder(
              future: context.read<UserRepository>().getUserProfile(userId),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
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
                          const SizedBox(height: 24),
                          CustomTitle(
  title: 'Relatórios Emocionais',
  onTap: ()=>_navigateToEmotionReportScreen()
),
                          // Today's Date
                          dateWidet,
                          const SizedBox(height: 24),
                          FitnessMetrics(userProfile: userProfile),
                          const SizedBox(height: 24),
                          CustomTitle(
                            title: 'Macros Progress',
                            onTap: () =>
                                Navigator.pushNamed(context, '/saved-food'),
                          ),
                          const SizedBox(height: 16),
                          MealCard(userProfile: userProfile),
                          const SizedBox(height: 32),

                          /// 📌 **Sessão de Hábitos do Dia**
                          CustomTitle(
                            title: 'Hábitos do Dia',
                            onTap: () =>
                                Navigator.pushNamed(context, '/habits'),
                          ),
                          const SizedBox(height: 16),
                          _buildDailyHabitsSection(),
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

  /// 📌 **Constrói a Lista de Hábitos do Dia**
  Widget _buildDailyHabitsSection() {
    return BlocBuilder<HabitBloc, HabitState>(
      builder: (context, state) {
        if (state is HabitsLoading) {
          return const Center(child: CircularProgressIndicator());
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
            height: 200, // 🛑 Define um tamanho fixo para exibir os hábitos horizontalmente
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: state.habits.length,
              itemBuilder: (context, index) {
                final habit = state.habits[index];
                return Container(
                  width: 160, // Define a largura de cada card
                  margin: const EdgeInsets.only(right: 16),
                  child: HabitCard(habit: habit,),
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

  /// 📌 **Navegar para a Tela de Relatórios Emocionais**
  void _navigateToEmotionReportScreen() {
  final state = context.read<HabitBloc>().state;
  if (state is HabitsLoaded) {
    final List<Habit> habits = state.habits.cast<Habit>(); // 🔹 Converte para List<Habit>

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EmotionReportScreen(habits: habits),
      ),
    );
  }
}
}