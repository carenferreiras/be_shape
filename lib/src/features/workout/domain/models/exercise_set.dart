class ExerciseSet {
  final int reps;
  final double? weight;
  final int? duration;
  final String? intensity;
  final bool isCompleted;
  final int order;

  const ExerciseSet({
    required this.reps,
    this.weight,
    this.duration,
    this.intensity,
    this.isCompleted = false,
    required this.order,
  });

  factory ExerciseSet.fromJson(Map<String, dynamic> json) {
    return ExerciseSet(
      reps: json['reps'] as int,
      weight: json['weight'] as double?,
      duration: json['duration'] as int?,
      intensity: json['intensity'] as String?,
      isCompleted: json['isCompleted'] as bool? ?? false,
      order: json['order'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'reps': reps,
      'weight': weight,
      'duration': duration,
      'intensity': intensity,
      'isCompleted': isCompleted,
      'order': order,
    };
  }

  ExerciseSet copyWith({
    int? reps,
    double? weight,
    int? duration,
    String? intensity,
    bool? isCompleted,
    int? order,
  }) {
    return ExerciseSet(
      reps: reps ?? this.reps,
      weight: weight ?? this.weight,
      duration: duration ?? this.duration,
      intensity: intensity ?? this.intensity,
      isCompleted: isCompleted ?? this.isCompleted,
      order: order ?? this.order,
    );
  }
}