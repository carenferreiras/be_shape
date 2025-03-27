import 'package:json_annotation/json_annotation.dart';

@JsonSerializable()
class SavedFood {
  final String id;
  final String userId;
  final String name;
  final double calories;
  final double proteins;
  final double carbs;
  final double fats;
  final double water;
  final double calsium;
  final double sodium;
  final double fiber;
  final double iron;
  final String? brand;
  final String? servingSize;
  final String? servingUnit;
  final bool isPublic;
  final String? photoUrl;
  final DateTime createdAt;
  final String? classification;


  SavedFood({
    required this.id,
    required this.userId,
    required this.name,
    required this.calories,
    required this.proteins,
    required this.carbs,
    required this.fats,
    required this.water,
    required this.calsium, 
    required this.sodium, 
    required this.fiber, 
    required this.iron, 
    this.classification,
    this.brand,
    this.servingSize,
    this.servingUnit,
    this.isPublic = false,
    this.photoUrl,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  factory SavedFood.fromJson(Map<String, dynamic> json) {
    return SavedFood(
      id: json['id'] as String,
      userId: json['userId'] as String,
      name: json['name'] as String,
      calories: (json['calories'] as num).toDouble(),
      proteins: (json['proteins'] as num).toDouble(),
      carbs: (json['carbs'] as num).toDouble(),
      fats: (json['fats'] as num).toDouble(),
      brand: json['brand'] as String?,
      classification: json['classification'] as String?,
      servingSize: json['servingSize'] as String?,
      servingUnit: json['servingUnit'] as String?,
      isPublic: json['isPublic'] as bool? ?? false,
      photoUrl: json['photoUrl'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
      calsium: (json['calsium'] as num).toDouble(),
      fiber: (json['fiber'] as num).toDouble(),
      iron: (json['iron'] as num).toDouble(),
      sodium: (json['sodium'] as num).toDouble(),
      water: (json['water'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'name': name,
      'calories': calories,
      'proteins': proteins,
      'carbs': carbs,
      'fats': fats,
      'brand': brand,
      'servingSize': servingSize,
      'servingUnit': servingUnit,
      'isPublic': isPublic,
      'photoUrl': photoUrl,
      'createdAt': createdAt.toIso8601String(),
      'classification':classification,
    };
  }

  SavedFood copyWith({
    String? id,
    String? userId,
    String? name,
    double? calories,
    double? proteins,
    double? carbs,
    double? fats,
    double? calcium,
    double? water,
    double? fiber,
    double? sodium,
    double? iron,
    String? brand,
    String? servingSize,
    String? servingUnit,
    bool? isPublic,
    String? photoUrl,
    DateTime? createdAt,
  }) {
    return SavedFood(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      name: name ?? this.name,
      calories: calories ?? this.calories,
      proteins: proteins ?? this.proteins,
      carbs: carbs ?? this.carbs,
      fats: fats ?? this.fats,
      brand: brand ?? this.brand,
      servingSize: servingSize ?? this.servingSize,
      servingUnit: servingUnit ?? this.servingUnit,
      isPublic: isPublic ?? this.isPublic,
      photoUrl: photoUrl ?? this.photoUrl,
      createdAt: createdAt ?? this.createdAt,
      water: water ?? this.water ,
      sodium: sodium ?? this.sodium,
      calsium:calsium,
      fiber: fiber ?? this.fiber,
      iron: iron ?? this.iron,
      classification: classification,
    );
  }
}