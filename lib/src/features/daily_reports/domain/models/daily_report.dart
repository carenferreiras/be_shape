// lib/domain/models/daily_report.dart

class DailyReport {
  final String id;
  final String userId;
  final DateTime date;
  final double totalCalories;
  final double totalProteins;
  final double totalCarbs;
  final double totalFats;
  final double targetCalories;
  final double targetProteins;
  final double targetCarbs;
  final double targetFats;
  final String? notes;
  final DateTime createdAt;
  final bool isAutoCompleted;
  final Map<String, dynamic>? metadata; // Para dados adicionais como humor, energia, etc.

  DailyReport({
    required this.id,
    required this.userId,
    required this.date,
    required this.totalCalories,
    required this.totalProteins,
    required this.totalCarbs,
    required this.totalFats,
    required this.targetCalories,
    required this.targetProteins,
    required this.targetCarbs,
    required this.targetFats,
    this.notes,
    this.isAutoCompleted = false,
    this.metadata,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  factory DailyReport.fromJson(Map<String, dynamic> json) {
    return DailyReport(
      id: json['id'] as String,
      userId: json['userId'] as String,
      date: DateTime.parse(json['date'] as String),
      totalCalories: (json['totalCalories'] as num).toDouble(),
      totalProteins: (json['totalProteins'] as num).toDouble(),
      totalCarbs: (json['totalCarbs'] as num).toDouble(),
      totalFats: (json['totalFats'] as num).toDouble(),
      targetCalories: (json['targetCalories'] as num).toDouble(),
      targetProteins: (json['targetProteins'] as num).toDouble(),
      targetCarbs: (json['targetCarbs'] as num).toDouble(),
      targetFats: (json['targetFats'] as num).toDouble(),
      notes: json['notes'] as String?,
      isAutoCompleted: json['isAutoCompleted'] as bool? ?? false,
      metadata: json['metadata'] as Map<String, dynamic>?,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'date': date.toIso8601String(),
      'totalCalories': totalCalories,
      'totalProteins': totalProteins,
      'totalCarbs': totalCarbs,
      'totalFats': totalFats,
      'targetCalories': targetCalories,
      'targetProteins': targetProteins,
      'targetCarbs': targetCarbs,
      'targetFats': targetFats,
      'notes': notes,
      'isAutoCompleted': isAutoCompleted,
      'metadata': metadata,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  DailyReport copyWith({
    String? id,
    String? userId,
    DateTime? date,
    double? totalCalories,
    double? totalProteins,
    double? totalCarbs,
    double? totalFats,
    double? targetCalories,
    double? targetProteins,
    double? targetCarbs,
    double? targetFats,
    String? notes,
    bool? isAutoCompleted,
    Map<String, dynamic>? metadata,
    DateTime? createdAt,
  }) {
    return DailyReport(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      date: date ?? this.date,
      totalCalories: totalCalories ?? this.totalCalories,
      totalProteins: totalProteins ?? this.totalProteins,
      totalCarbs: totalCarbs ?? this.totalCarbs,
      totalFats: totalFats ?? this.totalFats,
      targetCalories: targetCalories ?? this.targetCalories,
      targetProteins: targetProteins ?? this.targetProteins,
      targetCarbs: targetCarbs ?? this.targetCarbs,
      targetFats: targetFats ?? this.targetFats,
      notes: notes ?? this.notes,
      isAutoCompleted: isAutoCompleted ?? this.isAutoCompleted,
      metadata: metadata ?? this.metadata,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
