import '../../water.dart';

class UpdateWaterIntake {
  final WaterRepository repository;

  UpdateWaterIntake(this.repository);

  Future<void> call(int intake) async {
    await repository.updateWaterIntake(intake);
  }
}