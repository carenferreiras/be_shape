import 'package:cloud_firestore/cloud_firestore.dart';

class Exercise {
  final String id;
  final String userId;
  final String name;
  final String type;
  final int duration;
  final double caloriesBurned;
  final DateTime date;
  final String? notes;
  final List<String> equipmentIds;
  final List<String> equipmentNames;

  Exercise({
    required this.id,
    required this.userId,
    required this.name,
    required this.type,
    required this.duration,
    required this.caloriesBurned,
    required this.date,
    this.notes,
    required this.equipmentIds,
    required this.equipmentNames,
  });

  factory Exercise.fromJson(Map<String, dynamic> json) {
    return Exercise(
      id: json['id'] as String,
      userId: json['userId'] as String,
      name: json['name'] as String,
      type: json['type'] as String,
      duration: json['duration'] as int,
      caloriesBurned: (json['caloriesBurned'] as num).toDouble(),
      date: DateTime.parse(json['date'] as String),
      notes: json['notes'] as String?,
      equipmentIds: (json['equipmentIds'] as List<dynamic>?)?.map((e) => e as String).toList() ?? [],
      equipmentNames: (json['equipmentNames'] as List<dynamic>?)?.map((e) => e as String).toList() ?? [],
    );
  }

  factory Exercise.fromMap(Map<String, dynamic> map) {
    return Exercise(
      id: map['id'] as String,
      userId: map['userId'] as String,
      name: map['name'] as String,
      type: map['type'] as String,
      duration: map['duration'] is int
          ? map['duration'] as int
          : int.parse(map['duration'].toString()),
      caloriesBurned: map['caloriesBurned'] is double
          ? map['caloriesBurned'] as double
          : double.parse(map['caloriesBurned'].toString()),
      date: (map['date'] as Timestamp).toDate(),
      notes: map['notes'] as String?,
      equipmentIds: (map['equipmentIds'] as List<dynamic>?)?.map((e) => e as String).toList() ?? [],
      equipmentNames: (map['equipmentNames'] as List<dynamic>?)?.map((e) => e as String).toList() ?? [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'name': name,
      'type': type,
      'duration': duration,
      'caloriesBurned': caloriesBurned,
      'date': date.toIso8601String(),
      'notes': notes,
      'equipmentIds': equipmentIds,
      'equipmentNames': equipmentNames,
    };
  }

  Exercise copyWith({
    String? id,
    String? userId,
    String? name,
    String? type,
    int? duration,
    double? caloriesBurned,
    DateTime? date,
    String? notes,
    List<String>? equipmentIds,
    List<String>? equipmentNames,
  }) {
    return Exercise(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      name: name ?? this.name,
      type: type ?? this.type,
      duration: duration ?? this.duration,
      caloriesBurned: caloriesBurned ?? this.caloriesBurned,
      date: date ?? this.date,
      notes: notes ?? this.notes,
      equipmentIds: equipmentIds ?? this.equipmentIds,
      equipmentNames: equipmentNames ?? this.equipmentNames,
    );
  }
}