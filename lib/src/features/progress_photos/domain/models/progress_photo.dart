class ProgressPhoto {
  final String id;
  final String userId;
  final String photoUrl;
  final DateTime date;
  final String type;
  final double weight;
  final Map<String, double>? measurements;
  final Map<String, double>? skinfolds; // Novo campo para dobras cutâneas
  final String? notes;

  ProgressPhoto({
    required this.id,
    required this.userId,
    required this.photoUrl,
    required this.date,
    required this.type,
    required this.weight,
    this.measurements,
    this.skinfolds, // Novo campo
    this.notes,
  });

  factory ProgressPhoto.fromJson(Map<String, dynamic> json) {
    return ProgressPhoto(
      id: json['id'] as String,
      userId: json['userId'] as String,
      photoUrl: json['photoUrl'] as String,
      date: DateTime.parse(json['date'] as String),
      type: json['type'] as String,
      weight: json['weight'] as double,
      measurements: (json['measurements'] as Map<String, dynamic>?)?.map(
        (key, value) => MapEntry(key, value as double),
      ),
      skinfolds: (json['skinfolds'] as Map<String, dynamic>?)?.map(
        (key, value) => MapEntry(key, value as double),
      ),
      notes: json['notes'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'photoUrl': photoUrl,
      'date': date.toIso8601String(),
      'type': type,
      'weight': weight,
      'measurements': measurements,
      'skinfolds': skinfolds,
      'notes': notes,
    };
  }

  ProgressPhoto copyWith({
    String? id,
    String? userId,
    String? photoUrl,
    DateTime? date,
    String? type,
    double? weight,
    Map<String, double>? measurements,
    Map<String, double>? skinfolds,
    String? notes,
  }) {
    return ProgressPhoto(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      photoUrl: photoUrl ?? this.photoUrl,
      date: date ?? this.date,
      type: type ?? this.type,
      weight: weight ?? this.weight,
      measurements: measurements ?? this.measurements,
      skinfolds: skinfolds ?? this.skinfolds,
      notes: notes ?? this.notes,
    );
  }

  // Calcula o percentual de gordura usando a fórmula de Jackson & Pollock
  double? calculateBodyFat() {
    if (skinfolds == null) return null;

    final chest = skinfolds!['chest'] ?? 0;
    final abdominal = skinfolds!['abdominal'] ?? 0;
    final thigh = skinfolds!['thigh'] ?? 0;
    final triceps = skinfolds!['triceps'] ?? 0;
    final suprailiac = skinfolds!['suprailiac'] ?? 0;
    final subscapular = skinfolds!['subscapular'] ?? 0;

    // Soma das dobras
    final sum = chest + abdominal + thigh + triceps + suprailiac + subscapular;

    // Densidade corporal (fórmula de Jackson & Pollock)
    final density = 1.112 - (0.00043499 * sum) + 
                   (0.00000055 * sum * sum) - 
                   (0.00028826 * 25); // Usando idade média de 25 anos

    // Percentual de gordura (fórmula de Siri)
    return ((4.95 / density) - 4.5) * 100;
  }
}