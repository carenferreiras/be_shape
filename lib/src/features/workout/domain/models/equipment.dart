import 'package:cloud_firestore/cloud_firestore.dart';

enum EquipmentCategory {
  freeWeight,
  resistance,
  cardio,
  calisthenics,
  machine,
  recovery,
  explosive,
  cable,         // Cabos/Polias
  bodyweight,    // Peso corporal
  functional,    // Equipamentos funcionais
  accessory,     // Acessórios

}

class Equipment {
  final String id;
  final String userId;
  final String name;
  final EquipmentCategory category;
  final String description;
  final List<String> muscleGroups;
  final List<String> exercises;
  final String? imageUrl;
  final DateTime createdAt;

   Equipment({
    required this.id,
    required this.userId,
    required this.name,
    required this.category,
    required this.description,
    required this.muscleGroups,
    required this.exercises,
    this.imageUrl,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  factory Equipment.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Equipment(
      id: doc.id,
      userId: data['userId'] as String,
      name: data['name'] as String,
      category: EquipmentCategory.values.firstWhere(
        (e) => e.toString() == data['category'],
      ),
      description: data['description'] as String,
      muscleGroups: (data['muscleGroups'] as List<dynamic>).cast<String>(),
      exercises: (data['exercises'] as List<dynamic>).cast<String>(),
      imageUrl: data['imageUrl'] as String?,
      createdAt: (data['createdAt'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'userId': userId,
      'name': name,
      'category': category.toString(),
      'description': description,
      'muscleGroups': muscleGroups,
      'exercises': exercises,
      'imageUrl': imageUrl,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }

  Equipment copyWith({
    String? id,
    String? userId,
    String? name,
    EquipmentCategory? category,
    String? description,
    List<String>? muscleGroups,
    List<String>? exercises,
    String? imageUrl,
    DateTime? createdAt,
  }) {
    return Equipment(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      name: name ?? this.name,
      category: category ?? this.category,
      description: description ?? this.description,
      muscleGroups: muscleGroups ?? this.muscleGroups,
      exercises: exercises ?? this.exercises,
      imageUrl: imageUrl ?? this.imageUrl,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}