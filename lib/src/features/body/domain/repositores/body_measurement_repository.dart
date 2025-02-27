import '../../../features.dart';

abstract class BodyMeasurementRepository {
  Future<void> addMeasurement(BodyMeasurement measurement);
  Future<void> updateMeasurement(BodyMeasurement measurement);
  Future<void> deleteMeasurement(String id);
  Future<List<BodyMeasurement>> getUserMeasurements(String userId);
  Future<List<BodyMeasurement>> getMeasurementsByDateRange(
    String userId,
    DateTime start,
    DateTime end,
  );
  Future<BodyMeasurement?> getLatestMeasurement(String userId);
}