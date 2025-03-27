import '../../../features.dart';

class OpenFoodFactsRepository {
  final OpenFoodFactsService _service;

  OpenFoodFactsRepository(this._service);

  Future<List<FoodProduct>> searchFoods(String query) async {
    return await _service.getFoods(query);
  }
}