import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../../features.dart';

class FirebaseSavedFoodRepository implements SavedFoodRepository {
  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;

  FirebaseSavedFoodRepository({
    FirebaseFirestore? firestore,
    FirebaseAuth? auth,
  })  : _firestore = firestore ?? FirebaseFirestore.instance,
        _auth = auth ?? FirebaseAuth.instance;

  @override
  Future<void> addSavedFood(SavedFood food) async {
    try {
      final userId = _auth.currentUser?.uid;
      if (userId == null) {
        throw Exception('User not authenticated');
      }

      final docRef = _firestore.collection('saved_foods').doc();
      final foodWithId = food.copyWith(
        id: docRef.id,
        userId: userId,
      );

      await docRef.set(foodWithId.toJson());
    } catch (e) {
      print('Error adding saved food: $e');
      rethrow;
    }
  }

  @override
  Future<void> updateSavedFood(SavedFood food) async {
    try {
      final userId = _auth.currentUser?.uid;
      if (userId == null) {
        throw Exception('User not authenticated');
      }

      await _firestore
          .collection('saved_foods')
          .doc(food.id)
          .update(food.toJson());
    } catch (e) {
      print('Error updating saved food: $e');
      rethrow;
    }
  }

  @override
  Future<void> deleteSavedFood(String id) async {
    try {
      final userId = _auth.currentUser?.uid;
      if (userId == null) {
        throw Exception('User not authenticated');
      }

      await _firestore.collection('saved_foods').doc(id).delete();
    } catch (e) {
      print('Error deleting saved food: $e');
      rethrow;
    }
  }

  @override
  Future<List<SavedFood>> getUserSavedFoods() async {
    try {
      final userId = _auth.currentUser?.uid;
      if (userId == null) {
        throw Exception('User not authenticated');
      }

      final snapshot = await _firestore
          .collection('saved_foods')
          .where('userId', isEqualTo: userId)
          .orderBy('name')
          .get();

      return snapshot.docs.map((doc) {
        final data = Map<String, dynamic>.from(doc.data());
        data['id'] = doc.id;
        return SavedFood.fromJson(data);
      }).toList();
    } catch (e) {
      print('Error getting user saved foods: $e');
      rethrow;
    }
  }

  @override
  Future<List<SavedFood>> searchSavedFoods(String query) async {
    try {
      final userId = _auth.currentUser?.uid;
      if (userId == null) {
        throw Exception('User not authenticated');
      }

      // Buscar alimentos do usuário e públicos
      final snapshot = await _firestore
          .collection('saved_foods')
          .where(Filter.or(
            Filter('userId', isEqualTo: userId),
            Filter('isPublic', isEqualTo: true),
          ))
          .get();

      final foods = snapshot.docs.map((doc) {
        final data = Map<String, dynamic>.from(doc.data());
        data['id'] = doc.id;
        return SavedFood.fromJson(data);
      }).toList();

      // Filtrar por query
      if (query.isEmpty) return foods;

      final lowercaseQuery = query.toLowerCase();
      return foods.where((food) {
        final lowercaseName = food.name.toLowerCase();
        final lowercaseBrand = food.brand?.toLowerCase() ?? '';
        return lowercaseName.contains(lowercaseQuery) ||
            lowercaseBrand.contains(lowercaseQuery);
      }).toList();
    } catch (e) {
      print('Error searching saved foods: $e');
      rethrow;
    }
  }

  @override
  Future<List<SavedFood>> getPublicSavedFoods() async {
    try {
      final snapshot = await _firestore
          .collection('saved_foods')
          .where('isPublic', isEqualTo: true)
          .orderBy('name')
          .get();

      return snapshot.docs.map((doc) {
        final data = Map<String, dynamic>.from(doc.data());
        data['id'] = doc.id;
        return SavedFood.fromJson(data);
      }).toList();
    } catch (e) {
      print('Error getting public saved foods: $e');
      rethrow;
    }
  }
}