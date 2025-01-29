class EmotionCheckIn {
  final String emotion; // Nome da emoção
  final String date; // Data do check-in

  EmotionCheckIn({required this.emotion, required this.date});

  Map<String, dynamic> toJson() => {
        'emotion': emotion,
        'date': date,
      };

  static EmotionCheckIn fromJson(Map<String, dynamic> json) => EmotionCheckIn(
        emotion: json['emotion'],
        date: json['date'],
      );
}