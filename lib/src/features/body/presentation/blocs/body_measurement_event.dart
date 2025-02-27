import 'package:equatable/equatable.dart';

import '../../../features.dart';

abstract class BodyMeasurementEvent extends Equatable {
  const BodyMeasurementEvent();

  @override
  List<Object?> get props => [];
}

class AddMeasurement extends BodyMeasurementEvent {
  final BodyMeasurement measurement;

  const AddMeasurement(this.measurement);

  @override
  List<Object?> get props => [measurement];
}

class UpdateMeasurement extends BodyMeasurementEvent {
  final BodyMeasurement measurement;

  const UpdateMeasurement(this.measurement);

  @override
  List<Object?> get props => [measurement];
}

class DeleteMeasurement extends BodyMeasurementEvent {
  final String measurementId;
  final String userId;

  const DeleteMeasurement(this.measurementId, this.userId);

  @override
  List<Object?> get props => [measurementId, userId];
}

class LoadUserMeasurements extends BodyMeasurementEvent {
  final String userId;

  const LoadUserMeasurements(this.userId);

  @override
  List<Object?> get props => [userId];
}

class LoadMeasurementsByDateRange extends BodyMeasurementEvent {
  final String userId;
  final DateTime start;
  final DateTime end;

  const LoadMeasurementsByDateRange(this.userId, this.start, this.end);

  @override
  List<Object?> get props => [userId, start, end];
}