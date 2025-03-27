import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:json_annotation/json_annotation.dart';

@JsonSerializable()
class BodyMeasurement {
  final String id;
  final String userId;
  final DateTime date;
  final double weight;
  final Map<String, double> measurements;
  final Map<String, double>? skinfolds;
  final String? notes;
  final double bmi;
  final double bodyFat;
  final String? photoUrl;
  final DateTime createdAt;

  BodyMeasurement({
    required this.id,
    required this.userId,
    required this.date,
    required this.weight,
    required this.measurements,
    this.skinfolds,
    this.notes,
    required this.bmi,
    required this.bodyFat,
    this.photoUrl,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  factory BodyMeasurement.fromJson(Map<String, dynamic> json) {
    return BodyMeasurement(
      id: json['id'] as String,
      userId: json['userId'] as String,
      date: (json['date'] is Timestamp) 
        ? (json['date'] as Timestamp).toDate()  // Converte Timestamp para DateTime
        : DateTime.parse(json['date'] as String), 
      weight: (json['weight'] as num).toDouble(),
      measurements: Map<String, double>.from(json['measurements'] as Map),
      skinfolds: json['skinfolds'] != null 
          ? Map<String, double>.from(json['skinfolds'] as Map) 
          : null,
      notes: json['notes'] as String?,
      bmi: (json['bmi'] as num).toDouble(),
      bodyFat: (json['bodyFat'] as num).toDouble(),
      photoUrl: json['photoUrl'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'date': date.toIso8601String(),
      'weight': weight,
      'measurements': measurements,
      'skinfolds': skinfolds,
      'notes': notes,
      'bmi': bmi,
      'bodyFat': bodyFat,
      'photoUrl': photoUrl,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  BodyMeasurement copyWith({
    String? id,
    String? userId,
    DateTime? date,
    double? weight,
    Map<String, double>? measurements,
    Map<String, double>? skinfolds,
    String? notes,
    double? bmi,
    double? bodyFat,
    String? photoUrl,
    DateTime? createdAt,
  }) {
    return BodyMeasurement(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      date: date ?? this.date,
      weight: weight ?? this.weight,
      measurements: measurements ?? this.measurements,
      skinfolds: skinfolds ?? this.skinfolds,
      notes: notes ?? this.notes,
      bmi: bmi ?? this.bmi,
      bodyFat: bodyFat ?? this.bodyFat,
      photoUrl: photoUrl ?? this.photoUrl,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}