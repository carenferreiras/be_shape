// lib/src/features/profile/models/bmi_history.dart
class BMIHistory {
  final String id;
  final String userId;
  final double bmi;
  final double weight;
  final DateTime date;

  const BMIHistory({
    required this.id,
    required this.userId,
    required this.bmi,
    required this.weight,
    required this.date,
  });

  factory BMIHistory.fromJson(Map<String, dynamic> json) {
    return BMIHistory(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      bmi: (json['bmi'] as num).toDouble(),
      weight: (json['weight'] as num).toDouble(),
      date: DateTime.parse(json['date'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'bmi': bmi,
      'weight': weight,
      'date': date.toIso8601String(),
    };
  }
}
