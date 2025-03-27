import 'dart:math' show pow;

import '../../../features.dart';

class UserProfile {
  final String id;
  final String name;
  final int age;
  final String gender;
  final double height;
  final double weight;
  final double targetWeight;
  final String goal;
  final Map<String, double> measurements;
  final double bmr;
  final double tdee;
  final double activityLevel;
  final MacroTargets macroTargets;
  final String? profileImageUrl; // New field
  final List<Map<String, dynamic>> weightHistory; // ✅ Histórico de peso
  final List<FoodProduct> favoriteFoods;

  UserProfile({
    required this.id,
    required this.name,
    required this.age,
    required this.gender,
    required this.height,
    required this.weight,
    required this.targetWeight,
    required this.goal,
    required this.measurements,
    this.favoriteFoods = const [], // ✅ Inicializa vazia
    this.bmr = 0.0,
    this.tdee = 0.0,
    this.activityLevel = 1.2,
    MacroTargets? macroTargets,
    this.weightHistory = const [],
    this.profileImageUrl, // New parameter
  }) : macroTargets = macroTargets ?? MacroTargets.fromTDEE(tdee, weight);

  double get bmi => weight / (pow((height / 100), 2));

  String get bmiClassification {
    final bmi = this.bmi;
    if (bmi < 16) return 'Magreza grave';
    if (bmi < 17) return 'Magreza moderada';
    if (bmi < 18.5) return 'Magreza leve';
    if (bmi < 25) return 'Peso normal';
    if (bmi < 30) return 'Sobrepeso';
    if (bmi < 35) return 'Obesidade Grau I';
    if (bmi < 40) return 'Obesidade Grau II';
    return 'Obesidade Grau III';
  }

  String get bmiColor {
    final bmi = this.bmi;
    if (bmi < 18.5) return '#FFA726';
    if (bmi < 25) return '#66BB6A';
    if (bmi < 30) return '#FFA726';
    return '#EF5350';
  }

  double get idealWeight {
    final heightInMeters = height / 100;
    final minIdealWeight = 18.5 * (heightInMeters * heightInMeters);
    final maxIdealWeight = 24.9 * (heightInMeters * heightInMeters);
    return (minIdealWeight + maxIdealWeight) / 2;
  }

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      id: json['id'] as String,
      name: json['name'] as String,
      age: json['age'] as int,
      gender: json['gender'] as String,
      height: json['height'] as double,
      weight: json['weight'] as double,
      targetWeight: json['targetWeight'] as double,
      goal: json['goal'] as String,
      measurements: (json['measurements'] as Map<String, dynamic>).map(
        (key, value) => MapEntry(key, value as double),
      ),
      bmr: json['bmr'] as double? ?? 0.0,
      tdee: json['tdee'] as double? ?? 0.0,
      activityLevel: json['activityLevel'] as double? ?? 1.2,
      macroTargets: json['macroTargets'] != null
          ? MacroTargets.fromJson(json['macroTargets'] as Map<String, dynamic>)
          : null,
      profileImageUrl: json['profileImageUrl'] as String?, // Added to fromJson
      weightHistory: (json['weightHistory'] as List<dynamic>?)
              ?.map((e) => e as Map<String, dynamic>)
              .toList() ??
          [],
      favoriteFoods: (json['favoriteFoods'] as List<dynamic>?)
              ?.map(
                  (food) => FoodProduct.fromJson(food as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'age': age,
      'gender': gender,
      'height': height,
      'weight': weight,
      'targetWeight': targetWeight,
      'goal': goal,
      'measurements': measurements,
      'bmr': bmr,
      'tdee': tdee,
      'activityLevel': activityLevel,
      'macroTargets': macroTargets.toJson(),
      'profileImageUrl': profileImageUrl,
      'weightHistory': weightHistory,
      'favoriteFoods': favoriteFoods.map((food) => food.toJson()).toList()
    };
  }

  UserProfile addFavorite(FoodProduct food) {
    return copyWith(favoriteFoods: [...favoriteFoods, food]);
  }

  UserProfile removeFavorite(FoodProduct food) {
    return copyWith(
      favoriteFoods: favoriteFoods.where((f) => f.name != food.name).toList(),
    );
  }

  UserProfile copyWith({
    String? id,
    String? name,
    int? age,
    String? gender,
    double? height,
    double? weight,
    double? targetWeight,
    String? goal,
    Map<String, double>? measurements,
    double? bmr,
    double? tdee,
    double? activityLevel,
    MacroTargets? macroTargets,
    String? profileImageUrl,
    double? bmi,
    List<Map<String, dynamic>>? weightHistory,
    List<FoodProduct>? favoriteFoods,
  }) {
    return UserProfile(
      id: id ?? this.id,
      name: name ?? this.name,
      age: age ?? this.age,
      gender: gender ?? this.gender,
      height: height ?? this.height,
      weight: weight ?? this.weight,
      targetWeight: targetWeight ?? this.targetWeight,
      goal: goal ?? this.goal,
      measurements: measurements ?? this.measurements,
      bmr: bmr ?? this.bmr,
      tdee: tdee ?? this.tdee,
      activityLevel: activityLevel ?? this.activityLevel,
      macroTargets: macroTargets ?? this.macroTargets,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
      weightHistory: weightHistory ?? this.weightHistory,
      favoriteFoods: favoriteFoods ?? this.favoriteFoods,
    );
  }
}
