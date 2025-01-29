import '../../water.dart';

abstract class WaterState {}

class WaterInitial extends WaterState {}

class WaterLoading extends WaterState {}

class WaterLoaded extends WaterState {
  final WaterIntake intake;

  WaterLoaded(this.intake);
}
class WaterError extends WaterState {
  final String message;

  WaterError(this.message);
}