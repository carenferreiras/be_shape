import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import '../../../../core/core.dart';
import '../../../features.dart';

class DailyFoodTrackingScreen extends StatefulWidget {
  const DailyFoodTrackingScreen({super.key});

  @override
  State<DailyFoodTrackingScreen> createState() =>
      _DailyFoodTrackingScreenState();
}

class _DailyFoodTrackingScreenState extends State<DailyFoodTrackingScreen> {
  DateTime _selectedDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    _loadData();
    _setupMidnightCheck();
  }

  void _setupMidnightCheck() {
    final now = DateTime.now();
    final tomorrow = DateTime(now.year, now.month, now.day + 1);
    tomorrow.difference(now);
  }

  void _loadData() {
    final userId = context.read<AuthRepository>().currentUser?.uid;
    if (userId != null) {
      // Normaliza a data para comparar apenas ano, mês e dia
      final normalizedDate = DateTime(
        _selectedDate.year,
        _selectedDate.month,
        _selectedDate.day,
      );

      context.read<MealBloc>().add(LoadMealsForDate(normalizedDate));
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.dark(
              primary: BeShapeColors.primary,
              onPrimary: Colors.white,
              surface: Color(0xFF303030),
              onSurface: Colors.white,
            ), dialogTheme: DialogThemeData(backgroundColor: const Color(0xFF303030)),
          ),
          child: child!,
        );
      },
    );

    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
      _loadData();
    }
  }

  Future<void> _completeDailyTracking([
    String? userId,
    DateTime? date,
    bool isAutoCompleted = false,
  ]) async {
    userId ??= context.read<AuthRepository>().currentUser?.uid;
    date ??= _selectedDate;

    if (userId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('User not authenticated'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    try {
      final userProfile =
          await context.read<UserRepository>().getUserProfile(userId);
      if (userProfile == null) {
        throw Exception('User profile not found');
      }

      // ignore: use_build_context_synchronously
      final state = context.read<MealBloc>().state;

      // Filtra as refeições do dia
      final mealsForDate = state.meals.where((meal) {
        final mealDate = DateTime(
          meal.date.year,
          meal.date.month,
          meal.date.day,
        );
        final selectedDate = DateTime(
          date!.year,
          date.month,
          date.day,
        );
        return mealDate.isAtSameMomentAs(selectedDate);
      }).toList();

      // Calcula totais
      double totalCalories = 0;
      double totalProteins = 0;
      double totalCarbs = 0;
      double totalFats = 0;

      for (final meal in mealsForDate) {
        totalCalories += meal.calories;
        totalProteins += meal.proteins;
        totalCarbs += meal.carbs;
        totalFats += meal.fats;
      }

      // Cria o relatório
      final report = DailyReport(
        id: DateTime.now().toString(),
        userId: userId,
        date: date,
        totalCalories: totalCalories,
        totalProteins: totalProteins,
        totalCarbs: totalCarbs,
        totalFats: totalFats,
        targetCalories: userProfile.tdee,
        targetProteins: userProfile.macroTargets.proteins,
        targetCarbs: userProfile.macroTargets.carbs,
        targetFats: userProfile.macroTargets.fats,
      );

      // Salva o relatório
      // ignore: use_build_context_synchronously
      await context.read<DailyReportRepository>().saveDailyReport(report);

      // Marca as refeições como completadas
      // ignore: use_build_context_synchronously
      context.read<MealBloc>().add(CompleteDailyTracking(
            userId,
            date,
            isAutoCompleted: isAutoCompleted,
          ));

      if (mounted) {
        // Mostra mensagem de sucesso
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              isAutoCompleted
                  ? 'Previous day automatically completed'
                  : 'Daily tracking completed!',
            ),
            backgroundColor: Colors.green,
          ),
        );

        // Navega para a tela de relatórios
        if (!isAutoCompleted) {
          Navigator.pushReplacementNamed(context, '/reports');
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black,
        appBar: BeShapeAppBar(
          title: 'Controle de Alimentos',
          hasLeading: false,
          actionIconPressed: () =>
              Navigator.pushNamed(context, '/meal-history'),
          actionIcon: Icons.history,
        ),
        body: FutureBuilder<UserProfile?>(
          future: context
              .read<UserRepository>()
              .getUserProfile(context.read<AuthRepository>().currentUser!.uid),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Center(
                child: SpinKitThreeBounce(color: BeShapeColors.primary),
              );
            }

            final userProfile = snapshot.data!;
            final targetCalories = userProfile.tdee;

            return BlocBuilder<MealBloc, MealState>(builder: (context, state) {
              return BlocBuilder<ExerciseBloc, ExerciseState>(
                builder: (context, exerciseState) {
                  if (state.isLoading) {
                    return Center(
                      child: SpinKitThreeBounce(color: BeShapeColors.primary),
                    );
                  }

                  // Filter meals by selected date
                  final mealsForDate = state.meals.where((meal) {
                    final mealDate = DateTime(
                      meal.date.year,
                      meal.date.month,
                      meal.date.day,
                    );
                    final selectedDate = DateTime(
                      _selectedDate.year,
                      _selectedDate.month,
                      _selectedDate.day,
                    );
                    return mealDate.isAtSameMomentAs(selectedDate);
                  }).toList()
                    ..sort((a, b) => a.date.compareTo(b.date));

                  exerciseState.exercises.where((exercise) {
                    final exerciseDate = DateTime(
                      exercise.date.year,
                      exercise.date.month,
                      exercise.date.day,
                    );
                    return exerciseDate.isAtSameMomentAs(_selectedDate);
                  }).toList();
                  // Calculate totals
                  double totalCalories = 0;
                  double totalProteins = 0;
                  double totalCarbs = 0;
                  double totalFats = 0;

                  for (final meal in mealsForDate) {
                    totalCalories += meal.calories;
                    totalProteins += meal.proteins;
                    totalCarbs += meal.carbs;
                    totalFats += meal.fats;
                  }

                  final burnedCalories = exerciseState.exercises.fold<double>(
                    0,
                    (sum, exercise) => sum + exercise.caloriesBurned,
                  );
                  final consumedCalories = state.meals.fold<double>(
                    0,
                    (sum, meal) => sum + meal.calories,
                  );

                  final remaining =
                      targetCalories + burnedCalories - consumedCalories;

                  return SingleChildScrollView(
                    child: SizedBox(
                      height: MediaQuery.of(context).size.height * 8,
                      width: double.infinity,
                      child: Column(
                        children: [
                          // Date Selector
                          DateSelector(
                            selectedDateOnPressed: () => _selectDate(context),
                            rightButtonOnPressed: () {
                              setState(() {
                                _selectedDate =
                                    _selectedDate.add(const Duration(days: 1));
                              });
                              _loadData();
                            },
                            leftButtonOnPressed: () {
                              setState(() {
                                _selectedDate = _selectedDate
                                    .subtract(const Duration(days: 1));
                              });
                              _loadData();
                            },
                            date: _selectedDate,
                          ),

                          // Adicionar banner de conclusão se houver refeições completadas
                          if (mealsForDate.any((meal) => meal.isCompleted))
                            CompleteMealBanner(mealsForDate: mealsForDate),

                          // Nutrition Summary Card
                          NutritionSummaryCard(
                              remaining: remaining,
                              totalCalories: totalCalories,
                              targetCalories: targetCalories,
                              totalProteins: totalProteins,
                              userProfile: userProfile,
                              totalCarbs: totalCarbs,
                              totalFats: totalFats),

                          const SizedBox(height: 24),
                          const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 16),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Refeições',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          // Meals List
                          Expanded(
                            flex: 1,
                            child: mealsForDate.isEmpty
                                ? Center(
                                    child: SingleChildScrollView(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Icon(
                                            Icons.restaurant_menu,
                                            size: 64,
                                            color: Colors.grey[700],
                                          ),
                                          const SizedBox(height: 16),
                                          Text(
                                            'No meals added yet',
                                            style: TextStyle(
                                              color: Colors.grey[500],
                                              fontSize: 18,
                                            ),
                                          ),
                                          const SizedBox(height: 8),
                                          Text(
                                            'Start tracking your meals by adding food',
                                            style: TextStyle(
                                              color: Colors.grey[600],
                                              fontSize: 14,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  )
                                : ListView.builder(
                                    shrinkWrap: true,
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    itemCount: mealsForDate.length,
                                    padding: const EdgeInsets.all(16),
                                    itemBuilder: (context, index) {
                                      final meal = mealsForDate[index];
                                      return MealCardWidget(
                                        meal: meal,
                                        onDelete: () {
                                          context
                                              .read<MealBloc>()
                                              .add(DeleteMeal(meal.id));
                                        },
                                      );
                                    },
                                  ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            });
          },
        ),
        floatingActionButton: CustomFloatingButton(
          onTap: () => _completeDailyTracking(),
        ),
        bottomNavigationBar: const BeShapeNavigatorBar(index: 2));
  }
}
