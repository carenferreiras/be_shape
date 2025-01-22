import '../../../features.dart';

abstract class SavedFoodRepository {
  Future<void> addSavedFood(SavedFood food);
  Future<void> updateSavedFood(SavedFood food);
  Future<void> deleteSavedFood(String id);
  Future<List<SavedFood>> getUserSavedFoods();
  Future<List<SavedFood>> searchSavedFoods(String query);
  Future<List<SavedFood>> getPublicSavedFoods();
}