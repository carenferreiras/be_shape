import 'package:be_shape_app/src/features/home/presentation/widgets/bmi_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import '../../../../core/core.dart';
import '../../../features.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _loadInitialData();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _loadInitialData();
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _loadInitialData();
  }

  Future<void> _loadInitialData() async {
    final userId = context.read<AuthRepository>().currentUser?.uid;
    if (userId != null) {
      try {
        // Carrega o perfil atualizado
        final profile =
            await context.read<UserRepository>().getUserProfile(userId);
        if (profile != null && mounted) {
          // Atualiza o AuthBloc com o perfil atualizado
          context
              .read<AuthBloc>()
              .add(AuthStateChanged(true, userProfile: profile));

          // Atualiza o WeightBloc
          context.read<WeightBloc>().add(WeightUpdated(profile.weight));
          context
              .read<WeightBloc>()
              .add(TargetWeightUpdated(profile.targetWeight));
        }
// Carregar dados para o AI Assistant
        final userProfile = context.read<AuthBloc>().state.userProfile;
        if (userProfile != null) {
          context.read<AIAssistantBloc>().add(GetSuggestions(
                userProfile: userProfile,
                currentCalories: 0, // Você pode pegar isso do MealBloc
                currentProtein: 0, // Você pode pegar isso do MealBloc
                currentCarbs: 0, // Você pode pegar isso do MealBloc
                currentFat: 0, // Você pode pegar isso do MealBloc
                waterIntake: context.read<WaterBloc>().state.currentIntake,
                exerciseMinutes: 0, // Você pode pegar isso do ExerciseBloc
              ));
        }
        // Carrega outros dados
        final today = DateTime.now();
        if (mounted) {
          context.read<MealBloc>().add(LoadMealsForDate(today));
          context.read<ExerciseBloc>().add(LoadExercisesForDate(today));
          context.read<HabitBloc>().add(LoadHabitsEvent(today.toString()));
          context.read<WaterBloc>().add(LoadWaterIntake());
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Erro ao carregar dados: $e')),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        // Listener para WeightBloc
        BlocListener<WeightBloc, WeightState>(
          listener: (context, weightState) {
            if (weightState.isSuccess) {
              // Usando isSuccess ao invés de WeightStatus
              _loadInitialData(); // Recarrega dados quando o peso é atualizado
            }
          },
        ),
        // Listener para AuthBloc
        BlocListener<AuthBloc, AuthState>(
          listener: (context, authState) {
            if (authState.error != null) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(authState.error!)),
              );
            }
          },
        ),
      ],
      child: BlocBuilder<AuthBloc, AuthState>(
        builder: (context, authState) {
          if (authState.isLoading) {
            return const Scaffold(
              body: Center(
                child: SpinKitWaveSpinner(
                  color: BeShapeColors.primary,
                ),
              ),
            );
          }

          if (!authState.isAuthenticated || authState.userProfile == null) {
            return const LoginScreen();
          }

          final userProfile = authState.userProfile!;

          return Scaffold(
            backgroundColor: Colors.black,
            drawer: BeShapeDrawer(userId: userProfile.id),
            body: RefreshIndicator(
              onRefresh: _loadInitialData,
              child: SafeArea(
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Header com Menu e Perfil
                        Row(
                          children: [
                            Builder(
                              builder: (context) => IconButton(
                                icon: const Icon(Icons.menu,
                                    color: BeShapeColors.primary),
                                onPressed: () =>
                                    Scaffold.of(context).openDrawer(),
                              ),
                            ),
                            Expanded(
                              child: UserHeader(userProfile: userProfile),
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),

                        // Data Atual
                        dateWidet,
                        const SizedBox(height: 24),

                        // Seção de Progresso
                        CustomTitle(
                          icon: Icons.account_circle,
                          title: '',
                          buttonTitle: 'Perfil',
                          onTap: () => Navigator.pushNamed(context, '/profile'),
                        ),
                        const SizedBox(height: 16),
                        BMICard(
                          userProfile: userProfile,
                          onWeightUpdated: _loadInitialData,
                        ),
                        const SizedBox(height: 24),
                        // const AIAssistantCard(),
                        // Métricas
                        const Text(
                          'Métricas',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 16),
                        FitnessMetrics(userProfile: userProfile),
                        const SizedBox(height: 24),

                        // Seção de Alimentos
                        CustomTitle(
                          title: 'Alimentos',
                          buttonTitle: 'Adicionar',
                          onTap: () =>
                              Navigator.pushNamed(context, '/add-food'),
                        ),
                        const SizedBox(height: 16),
                        const MealCard(),
                        const SizedBox(height: 24),
                        // Seção de Água
                        CustomTitle(
                          title: 'Controle de Água',
                          icon: Icons.water_drop_rounded,
                        ),
                        const SizedBox(height: 16),
                        WaterIntakeCard(
                          weight: userProfile.weight,
                        ),
                        const SizedBox(height: 24),                    
                        // Sugestões de Alimentos
                        const CustomTitle(
                          title: 'Sugestão de Alimentos',
                          buttonTitle: '',
                          icon: Icons.format_list_numbered_rtl_sharp,
                        ),
                        const SizedBox(height: 16),
                        IdealValuesCard(userProfile: userProfile,),
                        const SizedBox(height: 24),

                        // Seção de Hábitos
                        CustomTitle(
                          title: 'Hábitos',
                          onTap: () => Navigator.pushNamed(context, '/habits'),
                        ),
                        const SizedBox(height: 16),
                        const DailyHabitsSection(),
                        const SizedBox(height: 24),

                        // Seção de Emoções
                        CustomTitle(
                          buttonTitle: 'Mais...',
                          title: 'Emoções',
                          onTap: _navigateToEmotionReportScreen,
                        ),
                        const SizedBox(height: 16),
                        const EmotionBarChart(),
                        const SizedBox(height: 32),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            bottomNavigationBar: const BeShapeNavigatorBar(index: 0),
             floatingActionButton: SpeedDial(
            icon: Icons.chat_bubble_outline,
            activeIcon: Icons.close,
            backgroundColor: Colors.blue,
            foregroundColor: Colors.white,
            activeBackgroundColor: Colors.red,
            activeForegroundColor: Colors.white,
            buttonSize: const Size(56.0, 56.0),
            visible: true,
            closeManually: false,
            curve: Curves.bounceIn,
            overlayColor: Colors.black,
            overlayOpacity: 0.5,
            elevation: 8.0,
            shape: const CircleBorder(),
            children: [
              SpeedDialChild(
                child: const Icon(Icons.psychology),
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
                label: 'AI Coach',
                labelStyle: const TextStyle(fontSize: 16.0),
                onTap: () => _showAIChat(context, userProfile),
              ),
              SpeedDialChild(
                child: const Icon(Icons.fitness_center),
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
                label: 'Treino',
                labelStyle: const TextStyle(fontSize: 16.0),
                onTap: () => _showWorkoutSuggestions(context, userProfile),
              ),
              SpeedDialChild(
                child: const Icon(Icons.restaurant_menu),
                backgroundColor: BeShapeColors.primary,
                foregroundColor: Colors.white,
                label: 'Nutrição',
                labelStyle: const TextStyle(fontSize: 16.0),
                onTap: () => _showNutritionSuggestions(context, userProfile),
              ),
            ],
          ),
          );
        },
      ),
    );
  }

  void _navigateToEmotionReportScreen() {
    final state = context.read<HabitBloc>().state;
    if (state is HabitsLoaded) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => EmotionReportScreen(habits: state.habits),
        ),
      );
    }
  }
    void _showAIChat(BuildContext context, UserProfile userProfile) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AIChatScreen(userProfile: userProfile),
      ),
    );
  }

  void _showWorkoutSuggestions(BuildContext context, UserProfile userProfile) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AIWorkoutScreen(userProfile: userProfile),
      ),
    );
  }

  void _showNutritionSuggestions(BuildContext context, UserProfile userProfile) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AINutritionScreen(userProfile: userProfile),
      ),
    );
  }
}
