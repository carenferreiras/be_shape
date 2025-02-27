import 'package:equatable/equatable.dart';

import '../../../features.dart';

abstract class AIAssistantEvent extends Equatable {
  const AIAssistantEvent();

  @override
  List<Object?> get props => [];
}

class GetSuggestions extends AIAssistantEvent {
  final UserProfile userProfile;
  final double currentCalories;
  final double currentProtein;
  final double currentCarbs;
  final double currentFat;
  final double waterIntake;
  final int exerciseMinutes;

  const GetSuggestions({
    required this.userProfile,
    required this.currentCalories,
    required this.currentProtein,
    required this.currentCarbs,
    required this.currentFat,
    required this.waterIntake,
    required this.exerciseMinutes,
  });

  @override
  List<Object?> get props => [
    userProfile,
    currentCalories,
    currentProtein,
    currentCarbs,
    currentFat,
    waterIntake,
    exerciseMinutes,
  ];
}