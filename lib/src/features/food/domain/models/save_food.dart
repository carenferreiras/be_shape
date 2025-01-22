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
  final String? brand;
  final String? servingSize;
  final String? servingUnit;
  final bool isPublic;
  final String? photoUrl;
  final DateTime createdAt;

  SavedFood({
    required this.id,
    required this.userId,
    required this.name,
    required this.calories,
    required this.proteins,
    required this.carbs,
    required this.fats,
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
      servingSize: json['servingSize'] as String?,
      servingUnit: json['servingUnit'] as String?,
      isPublic: json['isPublic'] as bool? ?? false,
      photoUrl: json['photoUrl'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
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
    );
  }
}