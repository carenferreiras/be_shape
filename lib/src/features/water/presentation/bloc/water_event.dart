import '../../water.dart';

abstract class WaterEvent {}

class AddWaterIntake extends WaterEvent {
  final int amount;

  AddWaterIntake(this.amount);
}

class LoadWaterIntake extends WaterEvent {}
class DeleteWaterIntake extends WaterEvent {
  final WaterEntry entry;

  DeleteWaterIntake(this.entry);
}