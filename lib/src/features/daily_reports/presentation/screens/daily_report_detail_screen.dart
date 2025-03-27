import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../../core/core.dart';
import '../../../features.dart';

class DailyReportDetailScreen extends StatelessWidget {
  final DailyReport report;

  const DailyReportDetailScreen({
    super.key,
    required this.report,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text(DateFormat('MMMM d, y').format(report.date)),
        backgroundColor: Colors.black,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSummaryCard(),
            const SizedBox(height: 16),
            _buildMacrosCard(),
            if (report.notes != null) ...[
              const SizedBox(height: 16),
              _buildNotesCard(),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryCard() {
    final caloriePercentage =
        (report.totalCalories / report.targetCalories * 100).round();

    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey[800]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Daily Summary',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: _getStatusColor(caloriePercentage)
                      .withValues(alpha: (0.2)),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      _getStatusIcon(caloriePercentage),
                      color: _getStatusColor(caloriePercentage),
                      size: 16,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      _getStatusText(caloriePercentage),
                      style: TextStyle(
                        color: _getStatusColor(caloriePercentage),
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildCalorieInfo(
                'Consumed',
                report.totalCalories,
                BeShapeColors.primary,
              ),
              Container(
                height: 50,
                width: 1,
                color: Colors.grey[800],
              ),
              _buildCalorieInfo(
                'Target',
                report.targetCalories,
                BeShapeColors.link,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMacrosCard() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey[800]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Macronutrients',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 24),
          _buildMacroProgress(
            'Protein',
            report.totalProteins,
            report.targetProteins,
            BeShapeColors.link,
          ),
          const SizedBox(height: 16),
          _buildMacroProgress(
            'Carbs',
            report.totalCarbs,
            report.targetCarbs,
            BeShapeColors.accent,
          ),
          const SizedBox(height: 16),
          _buildMacroProgress(
            'Fat',
            report.totalFats,
            report.targetFats,
            Colors.red,
          ),
        ],
      ),
    );
  }

  Widget _buildNotesCard() {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey[800]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Notes',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            report.notes!,
            style: TextStyle(
              color: Colors.grey[300],
              fontSize: 16,
              height: 1.5,
            ),
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
        const SizedBox(height: 8),
        Text(
          value.round().toString(),
          style: TextStyle(
            color: color,
            fontSize: 32,
            fontWeight: FontWeight.bold,
          ),
        ),
        const Text(
          'kcal',
          style: TextStyle(
            color: Colors.grey,
            fontSize: 14,
          ),
        ),
      ],
    );
  }

  Widget _buildMacroProgress(
    String label,
    double value,
    double target,
    Color color,
  ) {
    final percentage = (value / target * 100).clamp(0.0, 100.0);

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
                fontSize: 16,
              ),
            ),
            Text(
              '${percentage.round()}%',
              style: TextStyle(
                color: color,
                fontSize: 16,
                fontWeight: FontWeight.bold,
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
                color: Colors.grey[800],
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            FractionallySizedBox(
              widthFactor: percentage / 100,
              child: Container(
                height: 8,
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '${value.round()}g consumed',
              style: TextStyle(
                color: Colors.grey[400],
                fontSize: 14,
              ),
            ),
            Text(
              'Target: ${target.round()}g',
              style: TextStyle(
                color: Colors.grey[400],
                fontSize: 14,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Color _getStatusColor(int percentage) {
    if (percentage < 80) return Colors.red;
    if (percentage < 95) return BeShapeColors.primary;
    if (percentage <= 105) return BeShapeColors.accent;
    return Colors.red;
  }

  IconData _getStatusIcon(int percentage) {
    if (percentage >= 95 && percentage <= 105) {
      return Icons.check_circle;
    }
    if (percentage < 80 || percentage > 105) {
      return Icons.warning;
    }
    return Icons.info_outline;
  }

  String _getStatusText(int percentage) {
    if (percentage >= 95 && percentage <= 105) {
      return 'On Target';
    }
    if (percentage < 80) {
      return 'Under Target';
    }
    if (percentage > 105) {
      return 'Over Target';
    }
    return 'Near Target';
  }
}
