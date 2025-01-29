import 'package:flutter/material.dart';
import '../../habit.dart';

class Habit {
  final String title;
  int progress;
  final HabitCategory category;
  final String date; // Formato: "YYYY-MM-DD"
  final List<EmotionCheckIn> checkIns;
  
  Habit(
      {required this.title,
      required this.progress,
      required this.category,
      required this.date,
      this.checkIns = const []});

  Habit copyWith({
    String? title,
    int? progress,
    HabitCategory? category,
    String? date,
    List<EmotionCheckIn>? checkIns,
  }) {
    return Habit(
      title: title ?? this.title,
      progress: progress ?? this.progress,
      category: category ?? this.category,
      date: date ?? this.date,
      checkIns: checkIns ?? this.checkIns,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'progress': progress,
      'category': {
        'name': category.name,
        'color': category.color.value,
        'icon': category.icon.codePoint,
      },
      'checkIns': checkIns.map((e) => e.toJson()).toList(),
      'date': date,
    };
  }

  factory Habit.fromJson(Map<String, dynamic> json) {
    return Habit(
      title: json['title'],
      progress: json['progress'],
      category: HabitCategory(
        name: json['category']['name'],
        color: Color(json['category']['color']),
        icon: IconData(json['category']['icon'], fontFamily: 'MaterialIcons'),
      ),
      checkIns: (json['checkIns'] as List<dynamic>?)
              ?.map((e) => EmotionCheckIn.fromJson(e))
              .toList() ??
          [],
      date: json['date'],
    );
  }
}
