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
  
    final proteins = weight * 2.2;
    final fats = (tdee * 0.25) / 9; 
    final carbs = (tdee * 0.45) / 4;

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