import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../features.dart';

enum WorkoutType {
  strength,
  hypertrophy, 
  endurance,
  cardio,
  flexibility,
  circuit,
  hiit,
}

class Workout {
  final String id;
  final String userId;
  final String name;
  final WorkoutType type;
  final String description;
  final List<WorkoutExercise> exercises;
  final int restBetweenSets;
  final int estimatedDuration;
  final String? notes;
  final DateTime createdAt;
  final List<String> requiredEquipment;
  final String difficulty;
  final List<String> targetMuscles;
  final bool isTemplate;
  final String? sharedBy;
  final DateTime? sharedAt;
  final int likesCount;
  final int viewsCount;

  const Workout({
    required this.id,
    required this.userId,
    required this.name,
    required this.type,
    required this.description,
    required this.exercises,
    required this.restBetweenSets,
    required this.estimatedDuration,
    this.notes,
    required this.createdAt,
    required this.requiredEquipment,
    required this.difficulty,
    required this.targetMuscles,
    this.isTemplate = false,
    this.sharedBy,
    this.sharedAt,
    this.likesCount = 0,
    this.viewsCount = 0,
  });

  factory Workout.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Workout(
      id: doc.id,
      userId: data['userId'] as String,
      name: data['name'] as String,
      type: WorkoutType.values.firstWhere(
        (e) => e.toString() == data['type'],
      ),
      description: data['description'] as String,
      exercises: (data['exercises'] as List<dynamic>)
          .map((e) => WorkoutExercise.fromJson(e as Map<String, dynamic>))
          .toList(),
      restBetweenSets: data['restBetweenSets'] as int,
      estimatedDuration: data['estimatedDuration'] as int,
      notes: data['notes'] as String?,
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      requiredEquipment: (data['requiredEquipment'] as List<dynamic>).cast<String>(),
      difficulty: data['difficulty'] as String,
      targetMuscles: (data['targetMuscles'] as List<dynamic>).cast<String>(),
      isTemplate: data['isTemplate'] as bool? ?? false,
      sharedBy: data['sharedBy'] as String?,
      sharedAt: data['sharedAt'] != null 
          ? (data['sharedAt'] as Timestamp).toDate()
          : null,
      likesCount: data['likesCount'] as int? ?? 0,
      viewsCount: data['viewsCount'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'userId': userId,
      'name': name,
      'type': type.toString(),
      'description': description,
      'exercises': exercises.map((e) => e.toJson()).toList(),
      'restBetweenSets': restBetweenSets,
      'estimatedDuration': estimatedDuration,
      'notes': notes,
      'createdAt': Timestamp.fromDate(createdAt),
      'requiredEquipment': requiredEquipment,
      'difficulty': difficulty,
      'targetMuscles': targetMuscles,
      'isTemplate': isTemplate,
      'sharedBy': sharedBy,
      'sharedAt': sharedAt != null ? Timestamp.fromDate(sharedAt!) : null,
      'likesCount': likesCount,
      'viewsCount': viewsCount,
    };
  }

  Workout copyWith({
    String? id,
    String? userId,
    String? name,
    WorkoutType? type,
    String? description,
    List<WorkoutExercise>? exercises,
    int? restBetweenSets,
    int? estimatedDuration,
    String? notes,
    DateTime? createdAt,
    List<String>? requiredEquipment,
    String? difficulty,
    List<String>? targetMuscles,
    bool? isTemplate,
    String? sharedBy,
    DateTime? sharedAt,
    int? likesCount,
    int? viewsCount,
  }) {
    return Workout(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      name: name ?? this.name,
      type: type ?? this.type,
      description: description ?? this.description,
      exercises: exercises ?? this.exercises,
      restBetweenSets: restBetweenSets ?? this.restBetweenSets,
      estimatedDuration: estimatedDuration ?? this.estimatedDuration,
      notes: notes ?? this.notes,
      createdAt: createdAt ?? this.createdAt,
      requiredEquipment: requiredEquipment ?? this.requiredEquipment,
      difficulty: difficulty ?? this.difficulty,
      targetMuscles: targetMuscles ?? this.targetMuscles,
      isTemplate: isTemplate ?? this.isTemplate,
      sharedBy: sharedBy ?? this.sharedBy,
      sharedAt: sharedAt ?? this.sharedAt,
      likesCount: likesCount ?? this.likesCount,
      viewsCount: viewsCount ?? this.viewsCount,
    );
  }
}

class WorkoutExercise {
  final String id;
  final String name;
  final String equipment;
  final List<String> muscleGroups;
  final List<ExerciseSet> sets;
  final String? notes;
  final String? videoUrl;
  final List<String>? tips;
  final int restTime;
  final int order;

  const WorkoutExercise({
    required this.id,
    required this.name,
    required this.equipment,
    required this.muscleGroups,
    required this.sets,
    this.notes,
    this.videoUrl,
    this.tips,
    required this.restTime,
    required this.order,
  });

  factory WorkoutExercise.fromJson(Map<String, dynamic> json) {
    return WorkoutExercise(
      id: json['id'] as String,
      name: json['name'] as String,
      equipment: json['equipment'] as String,
      muscleGroups: (json['muscleGroups'] as List<dynamic>).cast<String>(),
      sets: (json['sets'] as List<dynamic>)
          .map((e) => ExerciseSet.fromJson(e as Map<String, dynamic>))
          .toList(),
      notes: json['notes'] as String?,
      videoUrl: json['videoUrl'] as String?,
      tips: (json['tips'] as List<dynamic>?)?.cast<String>(),
      restTime: json['restTime'] as int,
      order: json['order'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'equipment': equipment,
      'muscleGroups': muscleGroups,
      'sets': sets.map((e) => e.toJson()).toList(),
      'notes': notes,
      'videoUrl': videoUrl,
      'tips': tips,
      'restTime': restTime,
      'order': order,
    };
  }

  // Add the copyWith method
  WorkoutExercise copyWith({
    String? id,
    String? name,
    String? equipment,
    List<String>? muscleGroups,
    List<ExerciseSet>? sets,
    String? notes,
    String? videoUrl,
    List<String>? tips,
    int? restTime,
    int? order,
  }) {
    return WorkoutExercise(
      id: id ?? this.id,
      name: name ?? this.name,
      equipment: equipment ?? this.equipment,
      muscleGroups: muscleGroups ?? this.muscleGroups,
      sets: sets ?? this.sets,
      notes: notes ?? this.notes,
      videoUrl: videoUrl ?? this.videoUrl,
      tips: tips ?? this.tips,
      restTime: restTime ?? this.restTime,
      order: order ?? this.order,
    );
  }
}
