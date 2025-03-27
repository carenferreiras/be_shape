import 'package:dio/dio.dart';
import '../../../features.dart';

class OpenFoodFactsService {
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: 'https://world.openfoodfacts.org',
      connectTimeout: Duration(seconds: 10),
      receiveTimeout: Duration(seconds: 10),
    ),
  );

  Future<List<FoodProduct>> getFoods(String searchQuery) async {
    try {
      final response = await _dio.get(
        '/cgi/search.pl',
        queryParameters: {
          'search_terms': searchQuery,
          'json': 1,
          'lc': 'pt', 
        },
      );

      if (response.statusCode == 200) {
        final data = response.data;
        if (data != null && data['products'] != null) {
          return List<FoodProduct>.from(
            data['products'].map((json) => FoodProduct.fromJson(json)),
          );
        }
      }
      throw Exception('No data found');
    } catch (e) {
      throw Exception('Error fetching food data: $e');
    }
  }
}