import 'package:flutter_bloc/flutter_bloc.dart';

import '../../ai_assistent.dart';


class AIAssistantBloc extends Bloc<AIAssistantEvent, AIAssistantState> {
  final OpenAIService _aiService;

  AIAssistantBloc({required OpenAIService aiService})
      : _aiService = aiService,
        super(const AIAssistantState()) {
    on<GetSuggestions>(_onGetSuggestions);
  }

  Future<void> _onGetSuggestions(
    GetSuggestions event,
    Emitter<AIAssistantState> emit,
  ) async {
    try {
      emit(state.copyWith(isLoading: true));

      final suggestions = await _aiService.generateSuggestions(
        goal: event.userProfile.goal,
        weight: event.userProfile.weight,
        height: event.userProfile.height,
        currentCalories: event.currentCalories,
        targetCalories: event.userProfile.tdee,
        currentProtein: event.currentProtein,
        targetProtein: event.userProfile.macroTargets.proteins,
        currentCarbs: event.currentCarbs,
        targetCarbs: event.userProfile.macroTargets.carbs,
        currentFat: event.currentFat,
        targetFat: event.userProfile.macroTargets.fats,
        waterIntake: event.waterIntake,
        exerciseMinutes: event.exerciseMinutes,
      );

      emit(state.copyWith(
        isLoading: false,
        suggestions: suggestions,
      ));
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        error: e.toString(),
      ));
    }
  }
}