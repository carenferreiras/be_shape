import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../../../features.dart';

class ReportsListScreen extends StatefulWidget {
  const ReportsListScreen({super.key});

  @override
  State<ReportsListScreen> createState() => _ReportsListScreenState();
}

class _ReportsListScreenState extends State<ReportsListScreen> {
  Future<List<DailyReport>>? _reportsFuture;

  @override
  void initState() {
    super.initState();
    _loadReports();
  }

  void _loadReports() {
    final userId = context.read<AuthRepository>().currentUser?.uid;
    if (userId != null) {
      setState(() {
        _reportsFuture = context.read<DailyReportRepository>().getUserReports(userId);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('Reports History'),
        backgroundColor: Colors.black,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadReports,
          ),
        ],
      ),
      body: FutureBuilder<List<DailyReport>>(
        future: _reportsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            debugPrint('Error loading reports: ${snapshot.error}');
            debugPrint('Error stack trace: ${snapshot.stackTrace}');
            
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.error_outline,
                    size: 64,
                    color: Colors.red[400],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Error loading reports',
                    style: TextStyle(
                      color: Colors.red[400],
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    snapshot.error.toString(),
                    style: const TextStyle(
                      color: Colors.grey,
                      fontSize: 14,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _loadReports,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red[400],
                    ),
                    child: const Text('Try Again'),
                  ),
                ],
              ),
            );
          }

          final reports = snapshot.data ?? [];

          if (reports.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.description,
                    size: 64,
                    color: Colors.grey[700],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No reports yet',
                    style: TextStyle(
                      color: Colors.grey[500],
                      fontSize: 18,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Complete your daily tracking to see reports here',
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 14,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            );
          }

          // Agrupar relatórios por mês
          final groupedReports = <String, List<DailyReport>>{};
          for (final report in reports) {
            final monthKey = DateFormat('MMMM y').format(report.date);
            groupedReports.putIfAbsent(monthKey, () => []).add(report);
          }

          return ListView.builder(
            itemCount: groupedReports.length,
            itemBuilder: (context, index) {
              final monthKey = groupedReports.keys.elementAt(index);
              final monthReports = groupedReports[monthKey]!;

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Text(
                      monthKey,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  ...monthReports.map((report) => _ReportCard(report: report)),
                ],
              );
            },
          );
        },
      ),
    );
  }
}

class _ReportCard extends StatelessWidget {
  final DailyReport report;

  const _ReportCard({required this.report});

  @override
  Widget build(BuildContext context) {
    final caloriePercentage = (report.totalCalories / report.targetCalories * 100).round();
    final proteinPercentage = (report.totalProteins / report.targetProteins * 100).round();
    final carbsPercentage = (report.totalCarbs / report.targetCarbs * 100).round();
    final fatsPercentage = (report.totalFats / report.targetFats * 100).round();

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: BorderRadius.circular(16),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            Navigator.pushNamed(
              context,
              '/report-details',
              arguments: report,
            );
          },
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      DateFormat('EEEE, MMM d').format(report.date),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: _getCalorieColor(caloriePercentage).withOpacity(0.2),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Text(
                        '$caloriePercentage% of goal',
                        style: TextStyle(
                          color: _getCalorieColor(caloriePercentage),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _MacroStat(
                      label: 'Protein',
                      percentage: proteinPercentage,
                      color: Colors.blue,
                    ),
                    _MacroStat(
                      label: 'Carbs',
                      percentage: carbsPercentage,
                      color: Colors.green,
                    ),
                    _MacroStat(
                      label: 'Fat',
                      percentage: fatsPercentage,
                      color: Colors.red,
                    ),
                  ],
                ),
                if (report.notes != null) ...[
                  const SizedBox(height: 16),
                  Text(
                    report.notes!,
                    style: const TextStyle(
                      color: Colors.grey,
                      fontSize: 14,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Color _getCalorieColor(int percentage) {
    if (percentage < 80) return Colors.red;
    if (percentage < 95) return Colors.orange;
    if (percentage <= 105) return Colors.green;
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