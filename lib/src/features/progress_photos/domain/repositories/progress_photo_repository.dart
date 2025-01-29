
import '../../../features.dart';

abstract class ProgressPhotoRepository {
  Future<void> addProgressPhoto(ProgressPhoto photo);
  Future<void> deleteProgressPhoto(String id);
  Future<List<ProgressPhoto>> getProgressPhotosByDate(DateTime date);
  Future<List<ProgressPhoto>> getProgressPhotosByDateRange(DateTime start, DateTime end);
  Future<List<ProgressPhoto>> getProgressPhotosByType(String type);
  Future<String> uploadPhoto(String filePath);
}