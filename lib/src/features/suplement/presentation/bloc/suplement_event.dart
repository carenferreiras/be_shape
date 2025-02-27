import 'package:equatable/equatable.dart';

import '../../suplement.dart';

abstract class SupplementEvent extends Equatable {
  const SupplementEvent();

  @override
  List<Object?> get props => [];
}

class AddSupplement extends SupplementEvent {
  final Supplement supplement;

  const AddSupplement(this.supplement);

  @override
  List<Object?> get props => [supplement];
}

class UpdateSupplement extends SupplementEvent {
  final Supplement supplement;

  const UpdateSupplement(this.supplement);

  @override
  List<Object?> get props => [supplement];
}

class DeleteSupplement extends SupplementEvent {
  final String supplementId;
  final String userId;

  const DeleteSupplement(this.supplementId, this.userId);

  @override
  List<Object?> get props => [supplementId, userId];
}

class LoadUserSupplements extends SupplementEvent {
  final String userId;

  const LoadUserSupplements(this.userId);

  @override
  List<Object?> get props => [userId];
}

class LoadActiveSupplements extends SupplementEvent {
  final String userId;

  const LoadActiveSupplements(this.userId);

  @override
  List<Object?> get props => [userId];
}

class LoadLowSupplements extends SupplementEvent {
  final String userId;

  const LoadLowSupplements(this.userId);

  @override
  List<Object?> get props => [userId];
}

class LogSupplementTaken extends SupplementEvent {
  final SupplementLog log;

  const LogSupplementTaken(this.log);

  @override
  List<Object?> get props => [log];
}

class LoadSupplementLogs extends SupplementEvent {
  final String supplementId;

  const LoadSupplementLogs(this.supplementId);

  @override
  List<Object?> get props => [supplementId];
}

class LoadSupplementLogsByDate extends SupplementEvent {
  final String userId;
  final DateTime date;

  const LoadSupplementLogsByDate(this.userId, this.date);

  @override
  List<Object?> get props => [userId, date];
}