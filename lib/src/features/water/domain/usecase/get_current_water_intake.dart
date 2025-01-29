import '../../water.dart';

class GetCurrentWaterIntake {
  final WaterRepository repository;

  GetCurrentWaterIntake(this.repository);

  Future<WaterIntake> call() async {
    return await repository.getCurrentIntake();
  }
}