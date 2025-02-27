import 'package:equatable/equatable.dart';

class WaterState extends Equatable {
  final double currentIntake;
  final bool isLoading;
  final String? error;

  const WaterState({
    this.currentIntake = 0,
    this.isLoading = false,
    this.error,
  });

  WaterState copyWith({
    double? currentIntake,
    bool? isLoading,
    String? error,
  }) {
    return WaterState(
      currentIntake: currentIntake ?? this.currentIntake,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }

  @override
  List<Object?> get props => [currentIntake, isLoading, error];
}