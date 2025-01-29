import '../../water.dart';

abstract class WaterRepository {
  Future<void> updateWaterIntake(int intake);
  Future<WaterIntake> getCurrentIntake();
  Future<void> removeWaterEntry(WaterEntry entry);
}
