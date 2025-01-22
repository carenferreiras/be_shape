import '../../../features.dart';

class SavedFoodState {
  final bool isLoading;
  final List<SavedFood> foods;
  final String? error;

  const SavedFoodState({
    this.isLoading = false,
    this.foods = const [],
    this.error,
  });

  SavedFoodState copyWith({
    bool? isLoading,
    List<SavedFood>? foods,
    String? error,
  }) {
    return SavedFoodState(
      isLoading: isLoading ?? this.isLoading,
      foods: foods ?? this.foods,
      error: error ?? this.error,
    );
  }
}