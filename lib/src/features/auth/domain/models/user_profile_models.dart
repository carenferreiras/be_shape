import '../../auth.dart';

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
  final String? profileImageUrl; 

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
    this.bmr = 0.0,
    this.tdee = 0.0,
    this.activityLevel = 1.2,
    this.profileImageUrl,
    MacroTargets? macroTargets,
  }) : macroTargets = macroTargets ?? MacroTargets.fromTDEE(tdee, weight);

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
      profileImageUrl: json['profileImageUrl'] as String?,
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
    };
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
    );
  }
}

