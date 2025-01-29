import '../../../features.dart';

abstract class SavedFoodEvent {
  const SavedFoodEvent();
}

class AddSavedFood extends SavedFoodEvent {
  final SavedFood food;
  const AddSavedFood(this.food);
}

class UpdateSavedFood extends SavedFoodEvent {
  final SavedFood food;
  const UpdateSavedFood(this.food);
}

class DeleteSavedFood extends SavedFoodEvent {
  final String foodId;
  const DeleteSavedFood(this.foodId);
}

class LoadUserSavedFoods extends SavedFoodEvent {
  const LoadUserSavedFoods();
}

class SearchSavedFoods extends SavedFoodEvent {
  final String query;
  const SearchSavedFoods(this.query);
}

class LoadPublicSavedFoods extends SavedFoodEvent {
  const LoadPublicSavedFoods();
}

class SelectedDate extends SavedFoodEvent{
  const SelectedDate();
}