import '../../../features.dart';

abstract class MealEvent {
  const MealEvent();
}

class AddMeal extends MealEvent {
  final Meal meal;
  const AddMeal(this.meal);
}

class UpdateMeal extends MealEvent {
  final Meal meal;
  const UpdateMeal(this.meal);
}

class DeleteMeal extends MealEvent {
  final String mealId;
  const DeleteMeal(this.mealId);
}

class LoadMealsForDate extends MealEvent {
  final DateTime date;
  const LoadMealsForDate(this.date);
}

class LoadRecentMeals extends MealEvent {
  final int limit;
  const LoadRecentMeals(this.limit);
}

class CompleteDailyTracking extends MealEvent {
  final String userId;
  final DateTime date;
  final bool isAutoCompleted;

  const CompleteDailyTracking(
    this.userId,
    this.date, {
    this.isAutoCompleted = false,
  });
}

class LoadCompletedMeals extends MealEvent {
  final String userId;
  const LoadCompletedMeals(this.userId);
}
class ResetDailyMeals extends MealEvent {
  const ResetDailyMeals();
}
