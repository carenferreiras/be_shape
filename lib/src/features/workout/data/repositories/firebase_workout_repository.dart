import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../features.dart';

class FirebaseWorkoutRepository implements WorkoutRepository {
  final FirebaseFirestore _firestore;

  FirebaseWorkoutRepository({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  @override
  Future<void> addWorkout(Workout workout) async {
    await _firestore
        .collection('workouts')
        .doc(workout.id)
        .set(workout.toFirestore());
  }

  @override
  Future<void> updateWorkout(Workout workout) async {
    await _firestore
        .collection('workouts')
        .doc(workout.id)
        .update(workout.toFirestore());
  }

  @override
  Future<void> deleteWorkout(String id) async {
    await _firestore.collection('workouts').doc(id).delete();
  }

  @override
  Future<List<Workout>> getUserWorkouts(String userId) async {
    final snapshot = await _firestore
        .collection('workouts')
        .where('userId', isEqualTo: userId)
        .where('isTemplate', isEqualTo: false)
        .orderBy('createdAt', descending: true)
        .get();

    return snapshot.docs
        .map((doc) => Workout.fromFirestore(doc))
        .toList();
  }

  @override
  Future<List<Workout>> getWorkoutsByType(WorkoutType type) async {
    final snapshot = await _firestore
        .collection('workouts')
        .where('type', isEqualTo: type.toString())
        .get();

    return snapshot.docs
        .map((doc) => Workout.fromFirestore(doc))
        .toList();
  }

  @override
  Future<List<Workout>> getWorkoutTemplates() async {
    final snapshot = await _firestore
        .collection('workouts')
        .where('isTemplate', isEqualTo: true)
        .get();

    return snapshot.docs
        .map((doc) => Workout.fromFirestore(doc))
        .toList();
  }

  @override
  Future<List<Workout>> searchWorkouts(String query) async {
    final snapshot = await _firestore
        .collection('workouts')
        .where('name', isGreaterThanOrEqualTo: query)
        .where('name', isLessThan: query + 'z')
        .get();

    return snapshot.docs
        .map((doc) => Workout.fromFirestore(doc))
        .toList();
  }

  @override
  Future<List<Workout>> getWorkoutsByEquipment(List<String> equipmentIds) async {
    final snapshot = await _firestore
        .collection('workouts')
        .where('requiredEquipment', arrayContainsAny: equipmentIds)
        .get();

    return snapshot.docs
        .map((doc) => Workout.fromFirestore(doc))
        .toList();
  }

  @override
  Future<List<Workout>> getRecentWorkouts(int limit) async {
    final snapshot = await _firestore
        .collection('workouts')
        .orderBy('createdAt', descending: true)
        .limit(limit)
        .get();

    return snapshot.docs
        .map((doc) => Workout.fromFirestore(doc))
        .toList();
  }

  @override
  Future<Workout?> getWorkoutById(String id) async {
    final doc = await _firestore.collection('workouts').doc(id).get();
    if (!doc.exists) return null;
    return Workout.fromFirestore(doc);
  }
}