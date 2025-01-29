import '../../../features.dart';

abstract class ExerciseRepository {
  Future<void> addExercise(Exercise exercise);
  Future<void> updateExercise(Exercise exercise);
  Future<void> deleteExercise(String id);
  Future<List<Exercise>> getExercisesByDate(DateTime date);
  Future<List<Exercise>> getExercisesByDateRange(DateTime start, DateTime end);
  Future<List<Exercise>> getRecentExercises(int limit);
  Future<double> getTotalCaloriesBurnedForDate(DateTime date);
  Future<Map<String, int>> getTotalDurationByType(DateTime date);
  Future<List<Exercise>> getExercisesByUser(String userId);
    Future<List<Exercise>> getExercisesForUserAndDate({
    required String userId,
    required DateTime date,
  }) ;

}