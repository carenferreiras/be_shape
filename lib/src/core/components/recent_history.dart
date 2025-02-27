import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';

import '../../features/features.dart';
import '../core.dart';

class RecentHistory extends StatelessWidget {
  final UserProfile userProfile;

  const RecentHistory({
    super.key,
    required this.userProfile,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Recent Reports',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextButton.icon(
                onPressed: () {
                  Navigator.pushNamed(context, '/reports');
                },
                icon: Icon(
                  Icons.history,
                  color: BeShapeColors.primary,
                  size: 20,
                ),
                label: Text(
                  'View All',
                  style: TextStyle(
                    color: BeShapeColors.primary,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          FutureBuilder(
            future: context.read<DailyReportRepository>().getUserReports(
              context.read<AuthRepository>().currentUser!.uid,
            ),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: SpinKitWaveSpinner(color: BeShapeColors.primary,),
                );
              }

              if (snapshot.hasError) {
                return Center(
                  child: Text(
                    'Error loading reports',
                    style: TextStyle(color: Colors.grey[500]),
                  ),
                );
              }

              final reports = snapshot.data ?? [];
              if (reports.isEmpty) {
                return Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.grey[800],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.history,
                        color: Colors.grey,
                        size: 20,
                      ),
                      SizedBox(width: 8),
                      Text(
                        'No reports yet',
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                );
              }

              // Sort reports by date and take only the last 2
              reports.sort((a, b) => b.date.compareTo(a.date));
              final recentReports = reports.take(2).toList();

              return Column(
                children: recentReports.map((report) {
                  final caloriePercentage = (report.totalCalories / report.targetCalories * 100).round();
                  final proteinPercentage = (report.totalProteins / report.targetProteins * 100).round();
                  final carbsPercentage = (report.totalCarbs / report.targetCarbs * 100).round();
                  final fatsPercentage = (report.totalFats / report.targetFats * 100).round();

                  return Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.grey[800],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              DateFormat('MMM d').format(report.date),
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: _getCalorieColor(caloriePercentage).withOpacity(0.2),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                '$caloriePercentage% of goal',
                                style: TextStyle(
                                  color: _getCalorieColor(caloriePercentage),
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            _MacroStat(
                              label: 'Protein',
                              percentage: proteinPercentage,
                              color: BeShapeColors.link,
                            ),
                            _MacroStat(
                              label: 'Carbs',
                              percentage: carbsPercentage,
                              color: BeShapeColors.accent,
                            ),
                            _MacroStat(
                              label: 'Fat',
                              percentage: fatsPercentage,
                              color: Colors.red,
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                }).toList(),
              );
            },
          ),
        ],
      ),
    );
  }

  Color _getCalorieColor(int percentage) {
    if (percentage < 80) return Colors.red;
    if (percentage < 95) return BeShapeColors.primary;
    if (percentage <= 105) return BeShapeColors.accent;
    return Colors.red;
  }
}

class _MacroStat extends StatelessWidget {
  final String label;
  final int percentage;
  final Color color;

  const _MacroStat({
    required this.label,
    required this.percentage,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Colors.grey,
            fontSize: 12,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          '$percentage%',
          style: TextStyle(
            color: color,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}