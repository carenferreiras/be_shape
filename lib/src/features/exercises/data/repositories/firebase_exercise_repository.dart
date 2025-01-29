// ignore_for_file: avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../features.dart';

class FirebaseExerciseRepository implements ExerciseRepository {
  final FirebaseFirestore _firestore;

  FirebaseExerciseRepository({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  @override
  Future<void> addExercise(Exercise exercise) async {
    try {
      final collectionRef = _firestore.collection('exercises');
      await collectionRef.doc(exercise.id).set({
        'id': exercise.id,
        'userId': exercise.userId,
        'name': exercise.name,
        'type': exercise.type,
        'duration': exercise.duration,
        'caloriesBurned': exercise.caloriesBurned,
        'date': Timestamp.fromDate(exercise.date), // Alterado para Timestamp
        'notes': exercise.notes,
      });
    } catch (e) {
      throw Exception('Failed to add exercise: $e');
    }
  }

  @override
  Future<void> updateExercise(Exercise exercise) async {
    await _firestore
        .collection('exercises')
        .doc(exercise.id)
        .update(exercise.toJson());
  }

  @override
  Future<void> deleteExercise(String id) async {
    await _firestore.collection('exercises').doc(id).delete();
  }

  @override
  Future<List<Exercise>> getExercisesByDate(DateTime date) async {
    try {
      final startOfDay =
          Timestamp.fromDate(DateTime(date.year, date.month, date.day));
      final endOfDay =
          Timestamp.fromDate(startOfDay.toDate().add(const Duration(days: 1)));

      final querySnapshot = await _firestore
          .collection('exercises')
          .where('date', isGreaterThanOrEqualTo: startOfDay)
          .where('date', isLessThan: endOfDay)
          .get();

      return querySnapshot.docs
          .map((doc) => Exercise.fromMap(doc.data()))
          .toList();
    } catch (e) {
      throw Exception('Failed to load exercises: $e');
    }
  }

  @override
  Future<List<Exercise>> getExercisesByDateRange(
      DateTime start, DateTime end) async {
    final snapshot = await _firestore
        .collection('exercises')
        .where('date', isGreaterThanOrEqualTo: start)
        .where('date', isLessThan: end)
        .get();

    return snapshot.docs.map((doc) => Exercise.fromJson(doc.data())).toList();
  }

  @override
  Future<List<Exercise>> getRecentExercises(int limit) async {
    final snapshot = await _firestore
        .collection('exercises')
        .orderBy('date', descending: true)
        .limit(limit)
        .get();

    return snapshot.docs.map((doc) => Exercise.fromJson(doc.data())).toList();
  }

  @override
  Future<double> getTotalCaloriesBurnedForDate(DateTime date) async {
    final exercises = await getExercisesByDate(date);
    double total = 0;
    for (final exercise in exercises) {
      total += exercise.caloriesBurned;
    }
    return total;
  }

  @override
  Future<Map<String, int>> getTotalDurationByType(DateTime date) async {
    final exercises = await getExercisesByDate(date);
    final Map<String, int> durationByType = {};

    for (final exercise in exercises) {
      durationByType[exercise.type] =
          (durationByType[exercise.type] ?? 0) + exercise.duration;
    }

    return durationByType;
  }

  @override
  Future<List<Exercise>> getExercisesByUser(String userId) async {
    try {
      final querySnapshot = await _firestore
          .collection('exercises')
          .where('userId', isEqualTo: userId)
          .orderBy('date', descending: true)
          .get();

      return querySnapshot.docs
          .map((doc) => Exercise.fromMap(doc.data()))
          .toList();
    } catch (e) {
      throw Exception('Failed to load exercises for user: $e');
    }
  }

  /// Obtém exercícios de um usuário específico para uma data específica
  @override

  /// Obtém exercícios para um usuário específico e uma data específica
  /// Obtém exercícios de um usuário específico para uma data específica
  Future<List<Exercise>> getExercisesForUserAndDate({
  required String userId,
  required DateTime date,
}) async {
  try {
    final startOfDay = Timestamp.fromDate(DateTime(date.year, date.month, date.day));
    final endOfDay = Timestamp.fromDate(
      startOfDay.toDate().add(const Duration(days: 1)),
    );

    // Esta consulta força a necessidade de um índice composto
    final querySnapshot = await _firestore
        .collection('exercises')
        .where('userId', isEqualTo: userId) // Filtro pelo userId
        .where('date', isGreaterThanOrEqualTo: startOfDay) // Data inicial
        .where('date', isLessThan: endOfDay) // Data final
        .orderBy('date', descending: true) // Ordenação
        .get();

    return querySnapshot.docs
        .map((doc) => Exercise.fromMap(doc.data()))
        .toList();
  } catch (e) {
    // Captura o erro e imprime no console
    print('Erro: $e');
    rethrow; // Repassa o erro para tratamento externo, se necessário
  }
}
}
