// lib/src/features/weight/models/weight_history.dart
class WeightHistory {
  final String id;
  final String userId;
  final double weight;
  final double bmi;
  final DateTime date;
  final DateTime createdAt;

  WeightHistory({
    required this.id,
    required this.userId,
    required this.weight,
    required this.bmi,
    required this.date,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  factory WeightHistory.fromJson(Map<String, dynamic> json) {
    return WeightHistory(
      id: json['id'] as String,
      userId: json['userId'] as String,
      weight: (json['weight'] as num).toDouble(),
      bmi: (json['bmi'] as num).toDouble(),
      date: DateTime.parse(json['date'] as String),
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'weight': weight,
      'bmi': bmi,
      'date': date.toIso8601String(),
      'createdAt': createdAt.toIso8601String(),
    };
  }

  WeightHistory copyWith({
    String? id,
    String? userId,
    double? weight,
    double? bmi,
    DateTime? date,
    DateTime? createdAt,
  }) {
    return WeightHistory(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      weight: weight ?? this.weight,
      bmi: bmi ?? this.bmi,
      date: date ?? this.date,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
