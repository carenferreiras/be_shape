import '../../../features.dart';

abstract class MealRepository {
  Future<void> addMeal(Meal meal);
  Future<void> updateMeal(Meal meal);
  Future<void> deleteMeal(String id);
  Future<List<Meal>> getMealsByDate(DateTime date);
  Future<List<Meal>> getMealsByDateRange(DateTime start, DateTime end);
  Future<List<Meal>> getRecentMeals(int limit);
  Future<double> getTotalCaloriesForDate(DateTime date);
  Future<Map<String, double>> getMacrosForDate(DateTime date);
  Future<List<Meal>> getSavedMeals(String userId);
  Future<void> completeDailyTracking(String userId, DateTime date, {bool isAutoCompleted = false});
  Future<List<Meal>> getCompletedMeals(String userId);
}