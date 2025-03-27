import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../../features.dart';

class WorkoutStatisticsScreen extends StatefulWidget {
  const WorkoutStatisticsScreen({super.key});

  @override
  State<WorkoutStatisticsScreen> createState() =>
      _WorkoutStatisticsScreenState();
}

class _WorkoutStatisticsScreenState extends State<WorkoutStatisticsScreen> {
  @override
  void initState() {
    super.initState();
    _loadWorkouts();
  }

  void _loadWorkouts() {
    final userId = context.read<AuthBloc>().currentUserId;
    if (userId != null) {
      context.read<WorkoutBloc>().add(LoadUserWorkouts(userId));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('Estatísticas de Treino'),
        backgroundColor: Colors.black,
      ),
      body: BlocBuilder<WorkoutBloc, WorkoutState>(
        builder: (context, state) {
          if (state.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state.workouts.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.blue.withValues(alpha: (0.2)),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.bar_chart,
                      color: Colors.blue,
                      size: 48,
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Nenhum dado disponível',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Complete alguns treinos para ver estatísticas',
                    style: TextStyle(
                      color: Colors.grey[400],
                      fontSize: 16,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            );
          }

          final stats = _calculateStatistics(state.workouts);

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildOverviewCard(stats),
                const SizedBox(height: 24),
                _buildWorkoutTypeDistribution(stats),
                const SizedBox(height: 24),
                _buildMuscleGroupDistribution(stats),
                const SizedBox(height: 24),
                _buildMonthlyProgress(stats),
              ],
            ),
          );
        },
      ),
    );
  }

  Map<String, dynamic> _calculateStatistics(List<Workout> workouts) {
    final stats = <String, dynamic>{};

    // Total workouts
    stats['totalWorkouts'] = workouts.length;

    // Total duration
    stats['totalDuration'] = workouts.fold<int>(
      0,
      (sum, workout) => sum + workout.estimatedDuration,
    );

    // Average duration
    stats['averageDuration'] = stats['totalDuration'] ~/ workouts.length;

    // Workout type distribution
    final typeDistribution = <WorkoutType, int>{};
    for (final workout in workouts) {
      typeDistribution[workout.type] =
          (typeDistribution[workout.type] ?? 0) + 1;
    }
    stats['typeDistribution'] = typeDistribution;

    // Muscle group distribution
    final muscleDistribution = <String, int>{};
    for (final workout in workouts) {
      for (final muscle in workout.targetMuscles) {
        muscleDistribution[muscle] = (muscleDistribution[muscle] ?? 0) + 1;
      }
    }
    stats['muscleDistribution'] = muscleDistribution;

    // Monthly progress
    final monthlyProgress = <String, int>{};
    for (final workout in workouts) {
      final month = DateFormat('MM/yyyy').format(workout.createdAt);
      monthlyProgress[month] = (monthlyProgress[month] ?? 0) + 1;
    }
    stats['monthlyProgress'] = monthlyProgress;

    return stats;
  }

  Widget _buildOverviewCard(Map<String, dynamic> stats) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.blue..withValues(alpha: (0.3))),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Visão Geral',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildOverviewStat(
                'Total de Treinos',
                stats['totalWorkouts'].toString(),
                Icons.fitness_center,
                Colors.blue,
              ),
              _buildOverviewStat(
                'Tempo Total',
                '${stats['totalDuration'] ~/ 60} min',
                Icons.timer,
                Colors.green,
              ),
              _buildOverviewStat(
                'Média por Treino',
                '${stats['averageDuration'] ~/ 60} min',
                Icons.av_timer,
                Colors.orange,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildOverviewStat(
    String label,
    String value,
    IconData icon,
    Color color,
  ) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: color.withValues(alpha: (0.2)),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: color, size: 24),
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: TextStyle(
            color: color,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            color: Colors.grey[400],
            fontSize: 12,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildWorkoutTypeDistribution(Map<String, dynamic> stats) {
    final distribution = stats['typeDistribution'] as Map<WorkoutType, int>;
    final total = distribution.values.fold<int>(0, (sum, count) => sum + count);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Distribuição por Tipo',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          ...distribution.entries.map((entry) {
            final percentage = (entry.value / total * 100).round();
            return Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      flex: 3,
                      child: Text(
                        _getWorkoutTypeName(entry.key),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 7,
                      child: Column(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(4),
                            child: LinearProgressIndicator(
                              value: entry.value / total,
                              backgroundColor: Colors.grey[800],
                              valueColor: AlwaysStoppedAnimation<Color>(
                                _getTypeColor(entry.key),
                              ),
                              minHeight: 8,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Align(
                            alignment: Alignment.centerRight,
                            child: Text(
                              '$percentage%',
                              style: TextStyle(
                                color: _getTypeColor(entry.key),
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
              ],
            );
          }).toList(),
        ],
      ),
    );
  }

  Widget _buildMuscleGroupDistribution(Map<String, dynamic> stats) {
    final distribution = stats['muscleDistribution'] as Map<String, int>;
    final sortedMuscles = distribution.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Grupos Musculares Mais Trabalhados',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          ...sortedMuscles.take(5).map((entry) {
            return Container(
              margin: const EdgeInsets.only(bottom: 12),
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
                      color: Colors.green.withValues(alpha: (0.2)),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.fitness_center,
                      color: Colors.green,
                      size: 16,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      entry.key,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.green.withValues(alpha: (0.2)),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      '${entry.value} treinos',
                      style: const TextStyle(
                        color: Colors.green,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ],
      ),
    );
  }

  Widget _buildMonthlyProgress(Map<String, dynamic> stats) {
    final progress = stats['monthlyProgress'] as Map<String, int>;
    final sortedMonths = progress.entries.toList()
      ..sort((a, b) => a.key.compareTo(b.key));

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Progresso Mensal',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 200,
            child: _MonthlyChart(data: sortedMonths),
          ),
        ],
      ),
    );
  }

  String _getWorkoutTypeName(WorkoutType type) {
    switch (type) {
      case WorkoutType.strength:
        return 'Força';
      case WorkoutType.hypertrophy:
        return 'Hipertrofia';
      case WorkoutType.endurance:
        return 'Resistência';
      case WorkoutType.cardio:
        return 'Cardio';
      case WorkoutType.flexibility:
        return 'Flexibilidade';
      case WorkoutType.circuit:
        return 'Circuito';
      case WorkoutType.hiit:
        return 'HIIT';
    }
  }

  Color _getTypeColor(WorkoutType type) {
    switch (type) {
      case WorkoutType.strength:
        return Colors.blue;
      case WorkoutType.hypertrophy:
        return Colors.purple;
      case WorkoutType.endurance:
        return Colors.green;
      case WorkoutType.cardio:
        return Colors.orange;
      case WorkoutType.flexibility:
        return Colors.cyan;
      case WorkoutType.circuit:
        return Colors.yellow;
      case WorkoutType.hiit:
        return Colors.red;
    }
  }
}

class _MonthlyChart extends StatelessWidget {
  final List<MapEntry<String, int>> data;

  const _MonthlyChart({required this.data});

  @override
  Widget build(BuildContext context) {
    final maxValue = data.map((e) => e.value).reduce((a, b) => a > b ? a : b);

    return CustomPaint(
      painter: _ChartPainter(
        data: data,
        maxValue: maxValue,
      ),
      child: Container(),
    );
  }
}

class _ChartPainter extends CustomPainter {
  final List<MapEntry<String, int>> data;
  final int maxValue;

  _ChartPainter({
    required this.data,
    required this.maxValue,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.blue
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    final path = Path();
    final width = size.width / (data.length - 1);
    final scale = size.height / maxValue;

    // Draw grid
    final gridPaint = Paint()
      ..color = Colors.grey[800]!
      ..strokeWidth = 1;

    for (var i = 0; i <= 4; i++) {
      final y = size.height - (i * size.height / 4);
      canvas.drawLine(
        Offset(0, y),
        Offset(size.width, y),
        gridPaint,
      );
    }

    // Draw line chart
    path.moveTo(0, size.height - data.first.value * scale);

    for (var i = 1; i < data.length; i++) {
      path.lineTo(
        i * width,
        size.height - data[i].value * scale,
      );
    }

    canvas.drawPath(path, paint);

    // Draw points
    final pointPaint = Paint()
      ..color = Colors.blue
      ..style = PaintingStyle.fill;

    for (var i = 0; i < data.length; i++) {
      canvas.drawCircle(
        Offset(
          i * width,
          size.height - data[i].value * scale,
        ),
        4,
        pointPaint,
      );
    }

    // Draw labels
    final textStyle = TextStyle(
      color: Colors.grey[400],
      fontSize: 10,
    );
    final textPainter = TextPainter();

    for (var i = 0; i < data.length; i++) {
      textPainter.text = TextSpan(
        text: data[i].key,
        style: textStyle,
      );
      textPainter.layout();
      textPainter.paint(
        canvas,
        Offset(
          i * width - textPainter.width / 2,
          size.height + 4,
        ),
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
