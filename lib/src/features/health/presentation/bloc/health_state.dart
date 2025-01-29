
import '../../health.dart';

abstract class HealthState {}

class HealthInitial extends HealthState {}

class HealthLoading extends HealthState {}

class HealthLoaded extends HealthState {
  final List<HealthData> data;

  HealthLoaded(this.data);
}

class HealthError extends HealthState {
  final String message;

  HealthError(this.message);
}