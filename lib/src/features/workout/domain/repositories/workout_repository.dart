import '../../workout.dart';

abstract class WorkoutRepository {
  Future<void> addWorkout(Workout workout);
  Future<void> updateWorkout(Workout workout);
  Future<void> deleteWorkout(String id);
  Future<List<Workout>> getUserWorkouts(String userId);
  Future<List<Workout>> getWorkoutsByType(WorkoutType type);
  Future<List<Workout>> getWorkoutTemplates();
  Future<List<Workout>> searchWorkouts(String query);
  Future<List<Workout>> getWorkoutsByEquipment(List<String> equipmentIds);
  Future<List<Workout>> getRecentWorkouts(int limit);
  Future<Workout?> getWorkoutById(String id);
}