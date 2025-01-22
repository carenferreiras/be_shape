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
    );
  }
}

class MacroTargets {
  final double proteins;
  final double carbs;
  final double fats;

  const MacroTargets({
    required this.proteins,
    required this.carbs,
    required this.fats,
  });

  factory MacroTargets.fromTDEE(double tdee, double weight) {
    // Calculate macro targets based on TDEE and weight
    final proteins = weight * 2.2; // 2.2g per kg of body weight
    final fats = (tdee * 0.25) / 9; // 25% of calories from fats
    final carbs = (tdee * 0.45) / 4; // 45% of calories from carbs

    return MacroTargets(
      proteins: proteins,
      carbs: carbs,
      fats: fats,
    );
  }

  factory MacroTargets.fromJson(Map<String, dynamic> json) {
    return MacroTargets(
      proteins: json['proteins'] as double,
      carbs: json['carbs'] as double,
      fats: json['fats'] as double,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'proteins': proteins,
      'carbs': carbs,
      'fats': fats,
    };
  }

  MacroTargets copyWith({
    double? proteins,
    double? carbs,
    double? fats,
  }) {
    return MacroTargets(
      proteins: proteins ?? this.proteins,
      carbs: carbs ?? this.carbs,
      fats: fats ?? this.fats,
    );
  }
}