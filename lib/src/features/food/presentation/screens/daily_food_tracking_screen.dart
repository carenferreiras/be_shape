import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:intl/intl.dart';

import '../../../features.dart';

class DailyFoodTrackingScreen extends StatefulWidget {
  const DailyFoodTrackingScreen({super.key});

  @override
  State<DailyFoodTrackingScreen> createState() =>
      _DailyFoodTrackingScreenState();
}

class _DailyFoodTrackingScreenState extends State<DailyFoodTrackingScreen> {
  DateTime _selectedDate = DateTime.now();
  Timer? _midnightTimer;

  @override
  void initState() {
    super.initState();
    _loadData();
    _setupMidnightCheck();
  }

  void _setupMidnightCheck() {
    final now = DateTime.now();
    final tomorrow = DateTime(now.year, now.month, now.day + 1);
    final timeUntilMidnight = tomorrow.difference(now);

    _midnightTimer = Timer(timeUntilMidnight, () {
      _handleMidnight();
    });
  }

  Future<void> _handleMidnight() async {
    final userId = context.read<AuthRepository>().currentUser?.uid;
    if (userId != null) {
      await _autoCompletePreviousDay();

      setState(() {
        _selectedDate = DateTime.now();
      });
      _loadData();
    }

    _setupMidnightCheck();
  }

  Future<void> _autoCompletePreviousDay() async {
    final userId = context.read<AuthRepository>().currentUser?.uid;
    if (userId == null) return;

    final state = context.read<MealBloc>().state;
    if (state.meals.isNotEmpty) {
      final yesterday = DateTime.now().subtract(const Duration(days: 1));
      await _completeDailyTracking(userId, yesterday, true);
    }
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
              primary: Colors.orange,
              onPrimary: Colors.white,
              surface: Color(0xFF303030),
              onSurface: Colors.white,
            ),
            dialogBackgroundColor: const Color(0xFF303030),
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
      await context.read<DailyReportRepository>().saveDailyReport(report);

      // Marca as refeições como completadas
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
   bottomNavigationBar: NavigationBar(
        backgroundColor: Colors.grey[900],
        selectedIndex: 2, // Nutrition tab selected
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.fitness_center),
            label: 'Workouts',
          ),
          NavigationDestination(
            icon: Icon(Icons.restaurant_menu),
            label: 'Nutrition',
          ),
          NavigationDestination(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
        onDestinationSelected: (index) {
          switch (index) {
            case 0:
              Navigator.pushNamed(context, '/home'); // Changed from pushReplacementNamed to pushNamed
              break;
            case 2:
              // Already on nutrition tab
              break;
          }
        },
      ),
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('Daily Food Tracking'),
        backgroundColor: Colors.black,
        actions: [
          IconButton(
            icon: const Icon(Icons.calendar_today),
            onPressed: () => _selectDate(context),
          ),
          IconButton(
            icon: const Icon(Icons.history),
            onPressed: () => Navigator.pushNamed(context, '/meal-history'),
          ),
        ],
      ),
      body: FutureBuilder<UserProfile?>(
        future: context
            .read<UserRepository>()
            .getUserProfile(context.read<AuthRepository>().currentUser!.uid),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final userProfile = snapshot.data!;
          final targetCalories = userProfile.tdee;

          return BlocBuilder<MealBloc, MealState>(
            builder: (context, state) {
              if (state.isLoading) {
                return const Center(child: CircularProgressIndicator());
              }

              // Filtra as refeições pela data selecionada
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
              }).toList();

              // Ordena as refeições por hora
              mealsForDate.sort((a, b) => a.date.compareTo(b.date));

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

              final remainingCalories = targetCalories - totalCalories;

              return Column(
                children: [
                  // Adicionar banner de conclusão se houver refeições completadas
                  if (mealsForDate.any((meal) => meal.isCompleted))
                    Container(
                      margin: const EdgeInsets.only(bottom: 16),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.green.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: Colors.green.withOpacity(0.3),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.check_circle,
                            color: Colors.green,
                            size: 20,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            mealsForDate.first.isAutoCompleted
                                ? 'Day Auto-Completed'
                                : 'Day Completed',
                            style: const TextStyle(
                              color: Colors.green,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            DateFormat('HH:mm').format(
                              mealsForDate.first.completedAt ?? DateTime.now(),
                            ),
                            style: TextStyle(
                              color: Colors.green.withOpacity(0.7),
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  // Data e Resumo
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.grey[900],
                      borderRadius: const BorderRadius.vertical(
                        bottom: Radius.circular(16),
                      ),
                    ),
                    child: Column(
                      children: [
                        // Data
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.chevron_left,
                                  color: Colors.white),
                              onPressed: () {
                                setState(() {
                                  _selectedDate = _selectedDate
                                      .subtract(const Duration(days: 1));
                                });
                                _loadData();
                              },
                            ),
                            Text(
                              DateFormat('EEEE, MMMM d').format(_selectedDate),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.chevron_right,
                                  color: Colors.white),
                              onPressed: () {
                                setState(() {
                                  _selectedDate = _selectedDate
                                      .add(const Duration(days: 1));
                                });
                                _loadData();
                              },
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        // Calorias Restantes
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            _buildCalorieInfo(
                              'Remaining',
                              remainingCalories,
                              Colors.green,
                            ),
                            _buildCalorieInfo(
                              'Consumed',
                              totalCalories,
                              Colors.orange,
                            ),
                            _buildCalorieInfo(
                              'Target',
                              targetCalories,
                              Colors.blue,
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        // Macros Progress
                        Column(
                          children: [
                            _MacroProgressBar(
                              label: 'Protein',
                              consumed: totalProteins,
                              target: userProfile.macroTargets.proteins,
                              color: Colors.blue,
                            ),
                            const SizedBox(height: 8),
                            _MacroProgressBar(
                              label: 'Carbs',
                              consumed: totalCarbs,
                              target: userProfile.macroTargets.carbs,
                              color: Colors.green,
                            ),
                            const SizedBox(height: 8),
                            _MacroProgressBar(
                              label: 'Fat',
                              consumed: totalFats,
                              target: userProfile.macroTargets.fats,
                              color: Colors.red,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  // Lista de Refeições
                  Expanded(
                    child: mealsForDate.isEmpty
                        ? Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.restaurant_menu,
                                  size: 64,
                                  color: Colors.grey[700],
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  'No meals added for ${DateFormat('MMM d').format(_selectedDate)}',
                                  style: TextStyle(
                                    color: Colors.grey[500],
                                    fontSize: 18,
                                  ),
                                ),
                              ],
                            ),
                          )
                        : ListView.builder(
                            itemCount: mealsForDate.length,
                            padding: const EdgeInsets.all(16),
                            itemBuilder: (context, index) {
                              final meal = mealsForDate[index];
                              return _MealCard(
                                meal: meal,
                                onDelete: () {
                                  context.read<MealBloc>().add(
                                        DeleteMeal(meal.id),
                                      );
                                },
                              );
                            },
                          ),
                  ),
                ],
              );
            },
          );
        },
      ),
      floatingActionButton: SpeedDial(
        icon: Icons.add,
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
            child: const Icon(Icons.bookmark_add),
            backgroundColor: Colors.orange,
            foregroundColor: Colors.white,
            label: 'Add Saved Food',
            labelStyle: const TextStyle(fontSize: 16.0),
            onTap: () => Navigator.pushNamed(context, '/saved-food'),
          ),
          SpeedDialChild(
            child: const Icon(Icons.add),
            backgroundColor: Colors.blue,
            foregroundColor: Colors.white,
            label: 'Add New Food',
            labelStyle: const TextStyle(fontSize: 16.0),
            onTap: () => Navigator.pushNamed(context, '/add-food'),
          ),
          SpeedDialChild(
            child: const Icon(Icons.check),
            backgroundColor: Colors.green,
            foregroundColor: Colors.white,
            label: 'Complete Day',
            labelStyle: const TextStyle(fontSize: 16.0),
            onTap: () => _completeDailyTracking(),
          ),
        ],
      ),
    );
  }

  Widget _buildCalorieInfo(String label, double value, Color color) {
    return Column(
      children: [
        Text(
          label,
          style: TextStyle(
            color: color,
            fontSize: 14,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          '${value.round()}',
          style: TextStyle(
            color: color,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        const Text(
          'kcal',
          style: TextStyle(
            color: Colors.grey,
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _midnightTimer?.cancel();
    super.dispose();
  }
}

class _MacroProgressBar extends StatelessWidget {
  final String label;
  final double consumed;
  final double target;
  final Color color;

  const _MacroProgressBar({
    required this.label,
    required this.consumed,
    required this.target,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final progress = (consumed / target).clamp(0.0, 1.0);
    final percentage = (progress * 100).round();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
              ),
            ),
            Text(
              '${consumed.round()}/${target.round()}g ($percentage%)',
              style: const TextStyle(
                color: Colors.grey,
                fontSize: 12,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        LinearProgressIndicator(
          value: progress,
          backgroundColor: Colors.grey[800],
          valueColor: AlwaysStoppedAnimation<Color>(color),
        ),
      ],
    );
  }
}

class _MealCard extends StatelessWidget {
  final Meal meal;
  final VoidCallback onDelete;

  const _MealCard({
    required this.meal,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.grey[900],
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Text(
                      DateFormat('HH:mm').format(meal.date),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    if (meal.isCompleted) ...[
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: meal.isAutoCompleted
                              ? Colors.orange.withOpacity(0.2)
                              : Colors.green.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              meal.isAutoCompleted
                                  ? Icons.schedule
                                  : Icons.check_circle,
                              color: meal.isAutoCompleted
                                  ? Colors.orange
                                  : Colors.green,
                              size: 14,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              meal.isAutoCompleted ? 'Auto' : 'Done',
                              style: TextStyle(
                                color: meal.isAutoCompleted
                                    ? Colors.orange
                                    : Colors.green,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ],
                ),
                IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: onDelete,
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              meal.name,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _MacroBadge(
                  label: 'Calories',
                  value: meal.calories,
                  unit: 'kcal',
                  color: Colors.orange,
                ),
                _MacroBadge(
                  label: 'Protein',
                  value: meal.proteins,
                  unit: 'g',
                  color: Colors.blue,
                ),
                _MacroBadge(
                  label: 'Carbs',
                  value: meal.carbs,
                  unit: 'g',
                  color: Colors.green,
                ),
                _MacroBadge(
                  label: 'Fat',
                  value: meal.fats,
                  unit: 'g',
                  color: Colors.red,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _MacroBadge extends StatelessWidget {
  final String label;
  final double value;
  final String unit;
  final Color color;

  const _MacroBadge({
    required this.label,
    required this.value,
    required this.unit,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          label,
          style: TextStyle(
            color: color,
            fontSize: 12,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          '${value.round()}$unit',
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
