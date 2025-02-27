import 'package:equatable/equatable.dart';

import '../../../workout.dart';

class EquipmentState extends Equatable {
  final bool isLoading;
  final List<Equipment> equipment;
  final String? error;

  const EquipmentState({
    this.isLoading = false,
    this.equipment = const [],
    this.error,
  });

  EquipmentState copyWith({
    bool? isLoading,
    List<Equipment>? equipment,
    String? error,
  }) {
    return EquipmentState(
      isLoading: isLoading ?? this.isLoading,
      equipment: equipment ?? this.equipment,
      error: error ?? this.error,
    );
  }

  @override
  List<Object?> get props => [isLoading, equipment, error];
}