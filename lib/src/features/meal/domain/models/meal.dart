class Meal {
  final String id;
  final String userId;
  final String name;
  final double calories;
  final double proteins;
  final double carbs;
  final double fats;
  final DateTime date;
  final String? photoUrl;
  final String? notes;
  final bool isSaved;
  final bool isCompleted;
  final bool isAutoCompleted; // Novo campo
  final DateTime? completedAt;

  Meal({
    required this.id,
    required this.userId,
    required this.name,
    required this.calories,
    required this.proteins,
    required this.carbs,
    required this.fats,
    required this.date,
    this.photoUrl,
    this.notes,
    this.isSaved = false,
    this.isCompleted = false,
    this.isAutoCompleted = false, // Novo campo
    this.completedAt,
  });

  factory Meal.fromJson(Map<String, dynamic> json) {
    return Meal(
      id: json['id'] as String,
      userId: json['userId'] as String,
      name: json['name'] as String,
      calories: (json['calories'] as num).toDouble(),
      proteins: (json['proteins'] as num).toDouble(),
      carbs: (json['carbs'] as num).toDouble(),
      fats: (json['fats'] as num).toDouble(),
      date: DateTime.parse(json['date'] as String),
      photoUrl: json['photoUrl'] as String?,
      notes: json['notes'] as String?,
      isSaved: json['isSaved'] as bool? ?? false,
      isCompleted: json['isCompleted'] as bool? ?? false,
      isAutoCompleted: json['isAutoCompleted'] as bool? ?? false,
      completedAt: json['completedAt'] != null 
          ? DateTime.parse(json['completedAt'] as String)
          : null,
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
      'date': date.toIso8601String(),
      'photoUrl': photoUrl,
      'notes': notes,
      'isSaved': isSaved,
      'isCompleted': isCompleted,
      'isAutoCompleted': isAutoCompleted,
      'completedAt': completedAt?.toIso8601String(),
    };
  }

  Meal copyWith({
    String? id,
    String? userId,
    String? name,
    double? calories,
    double? proteins,
    double? carbs,
    double? fats,
    DateTime? date,
    String? photoUrl,
    String? notes,
    bool? isSaved,
    bool? isCompleted,
    bool? isAutoCompleted,
    DateTime? completedAt,
  }) {
    return Meal(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      name: name ?? this.name,
      calories: calories ?? this.calories,
      proteins: proteins ?? this.proteins,
      carbs: carbs ?? this.carbs,
      fats: fats ?? this.fats,
      date: date ?? this.date,
      photoUrl: photoUrl ?? this.photoUrl,
      notes: notes ?? this.notes,
      isSaved: isSaved ?? this.isSaved,
      isCompleted: isCompleted ?? this.isCompleted,
      isAutoCompleted: isAutoCompleted ?? this.isAutoCompleted,
      completedAt: completedAt ?? this.completedAt,
    );
  }
}