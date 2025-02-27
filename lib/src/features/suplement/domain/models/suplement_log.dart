import 'package:json_annotation/json_annotation.dart';

@JsonSerializable()
class SupplementLog {
  final String id;
  final String userId;
  final String supplementId;
  final DateTime takenAt;
  final double dosage;
  final String unit;
  final String? notes;
  final bool skipped;
  final String? skipReason;

  const SupplementLog({
    required this.id,
    required this.userId,
    required this.supplementId,
    required this.takenAt,
    required this.dosage,
    required this.unit,
    this.notes,
    this.skipped = false,
    this.skipReason,
  });

  factory SupplementLog.fromJson(Map<String, dynamic> json) {
    return SupplementLog(
      id: json['id'] as String,
      userId: json['userId'] as String,
      supplementId: json['supplementId'] as String,
      takenAt: DateTime.parse(json['takenAt'] as String),
      dosage: (json['dosage'] as num).toDouble(),
      unit: json['unit'] as String,
      notes: json['notes'] as String?,
      skipped: json['skipped'] as bool? ?? false,
      skipReason: json['skipReason'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'supplementId': supplementId,
      'takenAt': takenAt.toIso8601String(),
      'dosage': dosage,
      'unit': unit,
      'notes': notes,
      'skipped': skipped,
      'skipReason': skipReason,
    };
  }

  SupplementLog copyWith({
    String? id,
    String? userId,
    String? supplementId,
    DateTime? takenAt,
    double? dosage,
    String? unit,
    String? notes,
    bool? skipped,
    String? skipReason,
  }) {
    return SupplementLog(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      supplementId: supplementId ?? this.supplementId,
      takenAt: takenAt ?? this.takenAt,
      dosage: dosage ?? this.dosage,
      unit: unit ?? this.unit,
      notes: notes ?? this.notes,
      skipped: skipped ?? this.skipped,
      skipReason: skipReason ?? this.skipReason,
    );
  }
}