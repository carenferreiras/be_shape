import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import '../../../features.dart';

class FavoriteFoodRepository {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<void> addFavorite(String userId, FoodProduct food) async {
    await _db
        .collection('users')
        .doc(userId)
        .collection('favorites')
        .doc(food.id) // ✅ Agora usa ID fixo
        .set(food.toJson());
  }

  Future<void> removeFavorite(String userId, String foodId) async {
    await _db
        .collection('users')
        .doc(userId)
        .collection('favorites')
        .doc(foodId) // ✅ Remover pelo ID correto
        .delete();
  }

  Future<List<FoodProduct>> getFavorites(String userId) async {
    try {
      var snapshot = await _db
          .collection('users')
          .doc(userId)
          .collection('favorites')
          .get();
      return snapshot.docs
          .map((doc) => FoodProduct.fromJson(doc.data()))
          .toList();
    } catch (e) {
      debugPrint("Erro ao buscar favoritos: $e");
      throw Exception('Erro ao buscar favoritos');
    }
  }
}
