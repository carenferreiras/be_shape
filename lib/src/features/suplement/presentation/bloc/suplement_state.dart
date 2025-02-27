import 'package:equatable/equatable.dart';

import '../../suplement.dart';

class SupplementState extends Equatable {
  final bool isLoading;
  final List<Supplement> supplements;
  final List<SupplementLog> logs;
  final String? error;

  const SupplementState({
    this.isLoading = false,
    this.supplements = const [],
    this.logs = const [],
    this.error,
  });

  SupplementState copyWith({
    bool? isLoading,
    List<Supplement>? supplements,
    List<SupplementLog>? logs,
    String? error,
  }) {
    return SupplementState(
      isLoading: isLoading ?? this.isLoading,
      supplements: supplements ?? this.supplements,
      logs: logs ?? this.logs,
      error: error ?? this.error,
    );
  }

  @override
  List<Object?> get props => [isLoading, supplements, logs, error];
}