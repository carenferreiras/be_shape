import 'dart:convert';
import 'package:http/http.dart' as http;

import '../../features.dart';

class OpenAIService {
  final String apiKey;
  final String baseUrl = 'https://api.openai.com/v1/chat/completions';

  OpenAIService({required this.apiKey});

   Future<String> generateChatResponse({
    required String message,
    required UserProfile userProfile,
    required List<String> context,
  }) async {
    try {
      final systemPrompt = '''
      You are an AI fitness and nutrition coach. Your role is to help users achieve their fitness goals by providing personalized advice based on their profile:

      User Profile:
      - Goal: ${userProfile.goal}
      - Weight: ${userProfile.weight}kg
      - Height: ${userProfile.height}cm
      - BMI: ${userProfile.bmi}
      - Daily Calorie Target: ${userProfile.tdee}
      - Activity Level: ${userProfile.activityLevel}
      - Macro Targets:
        * Protein: ${userProfile.macroTargets.proteins}g
        * Carbs: ${userProfile.macroTargets.carbs}g
        * Fat: ${userProfile.macroTargets.fats}g

      Provide helpful, actionable advice while maintaining a friendly and encouraging tone.
      Keep responses concise and focused on the user's question.
      ''';

      final response = await http.post(
        Uri.parse(baseUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $apiKey',
        },
        body: jsonEncode({
          'model': 'gpt-3.5-turbo',
          'messages': [
            {
              'role': 'system',
              'content': systemPrompt,
            },
            ...context.asMap().entries.map((e) => {
              'role': e.key % 2 == 0 ? 'user' : 'assistant',
              'content': e.value,
            }),
            {
              'role': 'user',
              'content': message,
            },
          ],
          'temperature': 0.7,
          'max_tokens': 500,
          'stream': false,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['choices'][0]['message']['content'] as String;
      } else {
        print('Error response: ${response.body}');
        throw Exception('Failed to generate response: ${response.statusCode}');
      }
    } catch (e) {
      print('Error generating chat response: $e');
      throw Exception('Failed to communicate with AI service');
    }
  }

  Future<List<AISuggestion>> generateSuggestions({
    required String goal,
    required double weight,
    required double height,
    required double currentCalories,
    required double targetCalories,
    required double currentProtein,
    required double targetProtein,
    required double currentCarbs,
    required double targetCarbs,
    required double currentFat,
    required double targetFat,
    required double waterIntake,
    required int exerciseMinutes,
  }) async {
    final prompt = _buildPrompt(
      goal: goal,
      weight: weight,
      height: height,
      currentCalories: currentCalories,
      targetCalories: targetCalories,
      currentProtein: currentProtein,
      targetProtein: targetProtein,
      currentCarbs: currentCarbs,
      targetCarbs: targetCarbs,
      currentFat: currentFat,
      targetFat: targetFat,
      waterIntake: waterIntake,
      exerciseMinutes: exerciseMinutes,
    );

    final response = await http.post(
      Uri.parse(baseUrl),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $apiKey',
      },
      body: jsonEncode({
        'model': 'gpt-4',
        'messages': [
          {
            'role': 'system',
            'content': 'You are a professional fitness and nutrition coach. Provide personalized suggestions based on the user\'s data.',
          },
          {
            'role': 'user',
            'content': prompt,
          },
        ],
        'temperature': 0.7,
        'max_tokens': 1000,
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final suggestions = _parseSuggestions(data['choices'][0]['message']['content']);
      return suggestions;
    } else {
      throw Exception('Failed to generate suggestions');
    }
  }

  String _buildPrompt({
    required String goal,
    required double weight,
    required double height,
    required double currentCalories,
    required double targetCalories,
    required double currentProtein,
    required double targetProtein,
    required double currentCarbs,
    required double targetCarbs,
    required double currentFat,
    required double targetFat,
    required double waterIntake,
    required int exerciseMinutes,
  }) {
    return '''
    Based on the following user data, provide personalized suggestions for nutrition, exercise, hydration, and recovery:

    Goal: $goal
    Weight: ${weight}kg
    Height: ${height}cm
    
    Current Progress:
    - Calories: $currentCalories / $targetCalories
    - Protein: $currentProtein / $targetProtein
    - Carbs: $currentCarbs / $targetCarbs
    - Fat: $currentFat / $targetFat
    - Water Intake: ${waterIntake}ml
    - Exercise Minutes: $exerciseMinutes

    Provide suggestions in the following format:
    [NUTRITION]
    Title:
    Description:
    Foods:
    - food1
    - food2
    Priority: (HIGH/MEDIUM/LOW)

    [EXERCISE]
    Title:
    Description:
    Exercises:
    - name: exercise1
      sets: sets1
      tips: tip1, tip2
    Priority: (HIGH/MEDIUM/LOW)

    [HYDRATION/RECOVERY]
    Title:
    Description:
    Tips:
    - tip1
    - tip2
    Priority: (HIGH/MEDIUM/LOW)
    ''';
  }

  List<AISuggestion> _parseSuggestions(String content) {
    final suggestions = <AISuggestion>[];
    final sections = content.split('[');

    for (final section in sections) {
      if (section.trim().isEmpty) continue;

      if (section.startsWith('NUTRITION]')) {
        suggestions.add(_parseNutritionSuggestion(section));
      } else if (section.startsWith('EXERCISE]')) {
        suggestions.add(_parseExerciseSuggestion(section));
      } else if (section.contains('HYDRATION]') || section.contains('RECOVERY]')) {
        suggestions.add(_parseGeneralSuggestion(section));
      }
    }

    return suggestions;
  }

  AISuggestion _parseNutritionSuggestion(String section) {
    final lines = section.split('\n');
    String title = '';
    String description = '';
    final foods = <String>[];
    Priority priority = Priority.medium;

    for (var i = 0; i < lines.length; i++) {
      final line = lines[i].trim();
      if (line.startsWith('Title:')) {
        title = line.substring(6).trim();
      } else if (line.startsWith('Description:')) {
        description = line.substring(12).trim();
      } else if (line.startsWith('- ')) {
        foods.add(line.substring(2).trim());
      } else if (line.startsWith('Priority:')) {
        priority = _parsePriority(line.substring(9).trim());
      }
    }

    return AISuggestion(
      type: SuggestionType.nutrition,
      title: title,
      description: description,
      foods: foods,
      icon: '🥗',
      priority: priority,
    );
  }

  AISuggestion _parseExerciseSuggestion(String section) {
    final lines = section.split('\n');
    String title = '';
    String description = '';
    final exercises = <RecommendedExercise>[];
    Priority priority = Priority.medium;

    String? currentExerciseName;
    String? currentExerciseSets;
    List<String> currentExerciseTips = [];

    for (var i = 0; i < lines.length; i++) {
      final line = lines[i].trim();
      if (line.startsWith('Title:')) {
        title = line.substring(6).trim();
      } else if (line.startsWith('Description:')) {
        description = line.substring(12).trim();
      } else if (line.startsWith('- name:')) {
        if (currentExerciseName != null) {
          exercises.add(RecommendedExercise(
            name: currentExerciseName,
            sets: currentExerciseSets ?? '',
            tips: currentExerciseTips,
          ));
        }
        currentExerciseName = line.substring(7).trim();
        currentExerciseTips = [];
      } else if (line.startsWith('sets:')) {
        currentExerciseSets = line.substring(5).trim();
      } else if (line.startsWith('tips:')) {
        currentExerciseTips = line.substring(5).split(',').map((e) => e.trim()).toList();
      } else if (line.startsWith('Priority:')) {
        priority = _parsePriority(line.substring(9).trim());
      }
    }

    if (currentExerciseName != null) {
      exercises.add(RecommendedExercise(
        name: currentExerciseName,
        sets: currentExerciseSets ?? '',
        tips: currentExerciseTips,
      ));
    }

    return AISuggestion(
      type: SuggestionType.exercise,
      title: title,
      description: description,
      exercises: exercises,
      icon: '💪',
      priority: priority,
    );
  }

  AISuggestion _parseGeneralSuggestion(String section) {
    final lines = section.split('\n');
    String title = '';
    String description = '';
    final tips = <String>[];
    Priority priority = Priority.medium;
    final type = section.contains('HYDRATION]') 
        ? SuggestionType.hydration 
        : SuggestionType.recovery;

    for (var i = 0; i < lines.length; i++) {
      final line = lines[i].trim();
      if (line.startsWith('Title:')) {
        title = line.substring(6).trim();
      } else if (line.startsWith('Description:')) {
        description = line.substring(12).trim();
      } else if (line.startsWith('- ')) {
        tips.add(line.substring(2).trim());
      } else if (line.startsWith('Priority:')) {
        priority = _parsePriority(line.substring(9).trim());
      }
    }

    return AISuggestion(
      type: type,
      title: title,
      description: description,
      tips: tips,
      icon: type == SuggestionType.hydration ? '💧' : '🌙',
      priority: priority,
    );
  }

  Priority _parsePriority(String priority) {
    switch (priority.toUpperCase()) {
      case 'HIGH':
        return Priority.high;
      case 'LOW':
        return Priority.low;
      default:
        return Priority.medium;
    }
  }
}