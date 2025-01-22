import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';


import '../../../features.dart';


class FirebaseMealRepository implements MealRepository {
  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;

  FirebaseMealRepository({
    FirebaseFirestore? firestore,
    FirebaseAuth? auth,
  })  : _firestore = firestore ?? FirebaseFirestore.instance,
        _auth = auth ?? FirebaseAuth.instance;

  @override
  Future<void> addMeal(Meal meal) async {
    try {
      final userId = _auth.currentUser?.uid;
      if (userId == null) {
        throw Exception('User not authenticated');
      }

      // Create a new document reference
      final docRef = _firestore.collection('meals').doc();
      
      // Add the document ID and user ID to the meal data
      final mealWithId = meal.copyWith(
        id: docRef.id,
        userId: userId,
      );
      
      // Save the meal
      await docRef.set(mealWithId.toJson());
    } catch (e) {
      print('Error adding meal: $e');
      rethrow;
    }
  }

  @override
  Future<void> updateMeal(Meal meal) async {
    try {
      final userId = _auth.currentUser?.uid;
      if (userId == null) {
        throw Exception('User not authenticated');
      }

      await _firestore.collection('meals').doc(meal.id).update(meal.toJson());
    } catch (e) {
      print('Error updating meal: $e');
      rethrow;
    }
  }

  @override
  Future<void> deleteMeal(String id) async {
    try {
      final userId = _auth.currentUser?.uid;
      if (userId == null) {
        throw Exception('User not authenticated');
      }

      await _firestore.collection('meals').doc(id).delete();
    } catch (e) {
      print('Error deleting meal: $e');
      rethrow;
    }
  }

  @override
  Future<List<Meal>> getMealsByDate(DateTime date) async {
    try {
      final userId = _auth.currentUser?.uid;
      if (userId == null) {
        throw Exception('User not authenticated');
      }

      final startOfDay = DateTime(date.year, date.month, date.day);
      final endOfDay = startOfDay.add(const Duration(days: 1));

      final snapshot = await _firestore
          .collection('meals')
          .where('userId', isEqualTo: userId)
          .where('date', isGreaterThanOrEqualTo: startOfDay.toIso8601String())
          .where('date', isLessThan: endOfDay.toIso8601String())
          .get();

      return snapshot.docs.map((doc) {
        final data = Map<String, dynamic>.from(doc.data());
        data['id'] = doc.id;
        return Meal.fromJson(data);
      }).toList();
    } catch (e) {
      print('Error getting meals by date: $e');
      rethrow;
    }
  }

  @override
  Future<List<Meal>> getMealsByDateRange(DateTime start, DateTime end) async {
    try {
      final userId = _auth.currentUser?.uid;
      if (userId == null) {
        throw Exception('User not authenticated');
      }

      final snapshot = await _firestore
          .collection('meals')
          .where('userId', isEqualTo: userId)
          .where('date', isGreaterThanOrEqualTo: start.toIso8601String())
          .where('date', isLessThan: end.toIso8601String())
          .get();

      return snapshot.docs.map((doc) {
        final data = Map<String, dynamic>.from(doc.data());
        data['id'] = doc.id;
        return Meal.fromJson(data);
      }).toList();
    } catch (e) {
      print('Error getting meals by date range: $e');
      rethrow;
    }
  }

  @override
  Future<List<Meal>> getRecentMeals(int limit) async {
    try {
      final userId = _auth.currentUser?.uid;
      if (userId == null) {
        throw Exception('User not authenticated');
      }

      final snapshot = await _firestore
          .collection('meals')
          .where('userId', isEqualTo: userId)
          .orderBy('date', descending: true)
          .limit(limit)
          .get();

      return snapshot.docs.map((doc) {
        final data = Map<String, dynamic>.from(doc.data());
        data['id'] = doc.id;
        return Meal.fromJson(data);
      }).toList();
    } catch (e) {
      print('Error getting recent meals: $e');
      rethrow;
    }
  }

  @override
  Future<double> getTotalCaloriesForDate(DateTime date) async {
    try {
      final meals = await getMealsByDate(date);
      return meals.fold<double>(0, (sum, meal) => sum + meal.calories);
    } catch (e) {
      print('Error getting total calories: $e');
      rethrow;
    }
  }

  @override
  Future<Map<String, double>> getMacrosForDate(DateTime date) async {
    try {
      final meals = await getMealsByDate(date);
      return {
        'proteins': meals.fold<double>(0, (sum, meal) => sum + meal.proteins),
        'carbs': meals.fold<double>(0, (sum, meal) => sum + meal.carbs),
        'fats': meals.fold<double>(0, (sum, meal) => sum + meal.fats),
      };
    } catch (e) {
      print('Error getting macros: $e');
      rethrow;
    }
  }

  @override
  Future<List<Meal>> getSavedMeals(String userId) async {
    try {
      final snapshot = await _firestore
          .collection('meals')
          .where('userId', isEqualTo: userId)
          .where('isSaved', isEqualTo: true)
          .orderBy('name')
          .get();

      return snapshot.docs.map((doc) {
        final data = Map<String, dynamic>.from(doc.data());
        data['id'] = doc.id;
        return Meal.fromJson(data);
      }).toList();
    } catch (e) {
      print('Error getting saved meals: $e');
      rethrow;
    }
  }

  @override
Future<void> completeDailyTracking(
  String userId,
  DateTime date, {
  bool isAutoCompleted = false,
}) async {
  try {
    final startOfDay = DateTime(date.year, date.month, date.day);
    final endOfDay = startOfDay.add(const Duration(days: 1));

    final snapshot = await _firestore
        .collection('meals')
        .where('userId', isEqualTo: userId)
        .where('date', isGreaterThanOrEqualTo: startOfDay.toIso8601String())
        .where('date', isLessThan: endOfDay.toIso8601String())
        .get();

    final batch = _firestore.batch();
    final completedAt = DateTime.now();

    for (final doc in snapshot.docs) {
      batch.update(doc.reference, {
        'isCompleted': true,
        'isAutoCompleted': isAutoCompleted,
        'completedAt': completedAt.toIso8601String(),
      });
    }

    await batch.commit();
  } catch (e) {
    print('Error completing daily tracking: $e');
    rethrow;
  }
}

  @override
  Future<List<Meal>> getCompletedMeals(String userId) async {
    try {
      final snapshot = await _firestore
          .collection('meals')
          .where('userId', isEqualTo: userId)
          .where('isCompleted', isEqualTo: true)
          .orderBy('completedAt', descending: true)
          .get();

      return snapshot.docs.map((doc) {
        final data = Map<String, dynamic>.from(doc.data());
        data['id'] = doc.id;
        return Meal.fromJson(data);
      }).toList();
    } catch (e) {
      print('Error getting completed meals: $e');
      rethrow;
    }
  }
}