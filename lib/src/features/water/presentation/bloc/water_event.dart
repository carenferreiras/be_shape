import 'package:equatable/equatable.dart';

abstract class WaterEvent extends Equatable {
  const WaterEvent();

  @override
  List<Object?> get props => [];
}

class AddWater extends WaterEvent {
  final double amount;

  const AddWater(this.amount);

  @override
  List<Object?> get props => [amount];
}

class LoadWaterIntake extends WaterEvent {}

class ResetWaterIntake extends WaterEvent {}