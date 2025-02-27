// lib/src/features/weight/bloc/weight_event.dart
abstract class WeightEvent {
  const WeightEvent();
}

class InitializeWeight extends WeightEvent {
  const InitializeWeight();
}

class TargetWeightUpdated extends WeightEvent {
  final double newTargetWeight;
  const TargetWeightUpdated(this.newTargetWeight);
}

class WeightUpdated extends WeightEvent {
  final double newWeight;
  const WeightUpdated(this.newWeight);
}

class LoadWeightHistory extends WeightEvent {
  const LoadWeightHistory();
}
