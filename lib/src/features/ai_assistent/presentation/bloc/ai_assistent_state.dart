import 'package:equatable/equatable.dart';

enum SuggestionType {
  nutrition,
  exercise,
  hydration,
  recovery,
}

enum Priority {
  low,
  medium,
  high,
}

class RecommendedExercise {
  final String name;
  final String sets;
  final List<String> tips;

  const RecommendedExercise({
    required this.name,
    required this.sets,
    required this.tips,
  });
}

class AISuggestion {
  final SuggestionType type;
  final String title;
  final String description;
  final List<String>? foods;
  final List<String>? tips;
  final List<RecommendedExercise>? exercises;
  final String icon;
  final Priority priority;

  const AISuggestion({
    required this.type,
    required this.title,
    required this.description,
    this.foods,
    this.tips,
    this.exercises,
    required this.icon,
    required this.priority,
  });
}

class AIAssistantState extends Equatable {
  final bool isLoading;
  final List<AISuggestion> suggestions;
  final String? error;

  const AIAssistantState({
    this.isLoading = false,
    this.suggestions = const [],
    this.error,
  });

  AIAssistantState copyWith({
    bool? isLoading,
    List<AISuggestion>? suggestions,
    String? error,
  }) {
    return AIAssistantState(
      isLoading: isLoading ?? this.isLoading,
      suggestions: suggestions ?? this.suggestions,
      error: error ?? this.error,
    );
  }

  @override
  List<Object?> get props => [isLoading, suggestions, error];
}