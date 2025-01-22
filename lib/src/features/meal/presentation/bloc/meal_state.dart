import '../../../features.dart';

class MealState {
  final bool isLoading;
  final List<Meal> meals;
  final String? error;

  const MealState({
    this.isLoading = false,
    this.meals = const [],
    this.error,
  });

  MealState copyWith({
    bool? isLoading,
    List<Meal>? meals,
    String? error,
  }) {
    return MealState(
      isLoading: isLoading ?? this.isLoading,
      meals: meals ?? this.meals,
      error: error ?? this.error,
    );
  }
}
