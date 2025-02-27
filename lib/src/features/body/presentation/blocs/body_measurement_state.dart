import 'package:equatable/equatable.dart';

import '../../../features.dart';

class BodyMeasurementState extends Equatable {
  final bool isLoading;
  final List<BodyMeasurement> measurements;
  final String? error;

  const BodyMeasurementState({
    this.isLoading = false,
    this.measurements = const [],
    this.error,
  });

  BodyMeasurementState copyWith({
    bool? isLoading,
    List<BodyMeasurement>? measurements,
    String? error,
  }) {
    return BodyMeasurementState(
      isLoading: isLoading ?? this.isLoading,
      measurements: measurements ?? this.measurements,
      error: error ?? this.error,
    );
  }

  @override
  List<Object?> get props => [isLoading, measurements, error];
}