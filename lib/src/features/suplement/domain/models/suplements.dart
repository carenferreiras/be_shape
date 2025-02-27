import 'package:intl/intl.dart';
import 'package:json_annotation/json_annotation.dart';

enum SupplementType {
  protein,
  creatine,
  bcaa,
  preworkout,
  vitamin,
  mineral,
  omega3,
  other
}

enum DosageUnit {
  grams,
  milligrams,
  milliliters,
  units,
  capsules,
  scoops
}

@JsonSerializable()
class Supplement {
  final String id;
  final String userId;
  final String name;
  final SupplementType type;
  final String brand;
  final double dosage;
  final DosageUnit unit;
  final String? servingSize;
  final List<DateTime> scheduledTimes;
  final String? notes;
  final DateTime startDate;
  final DateTime? endDate;
  final bool isActive;
  final Map<String, dynamic>? nutritionInfo;
  final String? photoUrl;
  final DateTime createdAt;
  final DateTime? lastTakenAt;
  final int daysSupply;
  final List<String>? warnings;
  final Map<String, bool> daysOfWeek;

   Supplement({
    required this.id,
    required this.userId,
    required this.name,
    required this.type,
    required this.brand,
    required this.dosage,
    required this.unit,
    this.servingSize,
    required this.scheduledTimes,
    this.notes,
    required this.startDate,
    this.endDate,
    this.isActive = true,
    this.nutritionInfo,
    this.photoUrl,
    DateTime? createdAt,
    this.lastTakenAt,
    required this.daysSupply,
    this.warnings,
    required this.daysOfWeek,
  }) : createdAt = createdAt ?? DateTime.now();

  factory Supplement.fromJson(Map<String, dynamic> json) {
    return Supplement(
      id: json['id'] as String,
      userId: json['userId'] as String,
      name: json['name'] as String,
      type: SupplementType.values.firstWhere(
        (e) => e.toString() == json['type'],
      ),
      brand: json['brand'] as String,
      dosage: (json['dosage'] as num).toDouble(),
      unit: DosageUnit.values.firstWhere(
        (e) => e.toString() == json['unit'],
      ),
      servingSize: json['servingSize'] as String?,
      scheduledTimes: (json['scheduledTimes'] as List<dynamic>)
          .map((e) => DateTime.parse(e as String))
          .toList(),
      notes: json['notes'] as String?,
      startDate: DateTime.parse(json['startDate'] as String),
      endDate: json['endDate'] != null 
          ? DateTime.parse(json['endDate'] as String)
          : null,
      isActive: json['isActive'] as bool? ?? true,
      nutritionInfo: json['nutritionInfo'] as Map<String, dynamic>?,
      photoUrl: json['photoUrl'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
      lastTakenAt: json['lastTakenAt'] != null
          ? DateTime.parse(json['lastTakenAt'] as String)
          : null,
      daysSupply: json['daysSupply'] as int,
      warnings: (json['warnings'] as List<dynamic>?)?.cast<String>(),
      daysOfWeek: (json['daysOfWeek'] as Map<String, dynamic>).map(
        (key, value) => MapEntry(key, value as bool),
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'name': name,
      'type': type.toString(),
      'brand': brand,
      'dosage': dosage,
      'unit': unit.toString(),
      'servingSize': servingSize,
      'scheduledTimes': scheduledTimes.map((dt) => dt.toIso8601String()).toList(),
      'notes': notes,
      'startDate': startDate.toIso8601String(),
      'endDate': endDate?.toIso8601String(),
      'isActive': isActive,
      'nutritionInfo': nutritionInfo,
      'photoUrl': photoUrl,
      'createdAt': createdAt.toIso8601String(),
      'lastTakenAt': lastTakenAt?.toIso8601String(),
      'daysSupply': daysSupply,
      'warnings': warnings,
      'daysOfWeek': daysOfWeek,
    };
  }

  Supplement copyWith({
    String? id,
    String? userId,
    String? name,
    SupplementType? type,
    String? brand,
    double? dosage,
    DosageUnit? unit,
    String? servingSize,
    List<DateTime>? scheduledTimes,
    String? notes,
    DateTime? startDate,
    DateTime? endDate,
    bool? isActive,
    Map<String, dynamic>? nutritionInfo,
    String? photoUrl,
    DateTime? createdAt,
    DateTime? lastTakenAt,
    int? daysSupply,
    List<String>? warnings,
    Map<String, bool>? daysOfWeek,
  }) {
    return Supplement(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      name: name ?? this.name,
      type: type ?? this.type,
      brand: brand ?? this.brand,
      dosage: dosage ?? this.dosage,
      unit: unit ?? this.unit,
      servingSize: servingSize ?? this.servingSize,
      scheduledTimes: scheduledTimes ?? this.scheduledTimes,
      notes: notes ?? this.notes,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      isActive: isActive ?? this.isActive,
      nutritionInfo: nutritionInfo ?? this.nutritionInfo,
      photoUrl: photoUrl ?? this.photoUrl,
      createdAt: createdAt ?? this.createdAt,
      lastTakenAt: lastTakenAt ?? this.lastTakenAt,
      daysSupply: daysSupply ?? this.daysSupply,
      warnings: warnings ?? this.warnings,
      daysOfWeek: daysOfWeek ?? this.daysOfWeek,
    );
  }

  // Calcula quantos dias restam do suplemento
  int get daysRemaining {
    if (endDate == null) return daysSupply;
    return endDate!.difference(DateTime.now()).inDays;
  }

  // Verifica se o suplemento está quase acabando
  bool get isRunningLow => daysRemaining <= 7;

  // Verifica se é dia de tomar o suplemento
  bool shouldTakeToday() {
    final today = DateTime.now();
    final weekday = DateFormat('EEEE').format(today).toLowerCase();
    return daysOfWeek[weekday] ?? false;
  }

  // Verifica se está na hora de tomar
  bool isTimeToTake() {
    final now = DateTime.now();
    return scheduledTimes.any((time) {
      final scheduleDateTime = DateTime(
        now.year,
        now.month,
        now.day,
        time.hour,
        time.minute,
      );
      return now.difference(scheduleDateTime).abs() <= const Duration(minutes: 30);
    });
  }

  // Verifica se já foi tomado hoje
  bool get takenToday {
    if (lastTakenAt == null) return false;
    final now = DateTime.now();
    return lastTakenAt!.year == now.year &&
           lastTakenAt!.month == now.month &&
           lastTakenAt!.day == now.day;
  }
}