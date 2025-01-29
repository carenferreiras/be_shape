class ProgressPhoto {
  final String id;
  final String userId;
  final String photoUrl;
  final DateTime date;
  final String type;
  final double weight;
  final Map<String, double>? measurements;
  final String? notes;

  ProgressPhoto({
    required this.id,
    required this.userId,
    required this.photoUrl,
    required this.date,
    required this.type,
    required this.weight,
    this.measurements,
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
      notes: notes ?? this.notes,
    );
  }
}