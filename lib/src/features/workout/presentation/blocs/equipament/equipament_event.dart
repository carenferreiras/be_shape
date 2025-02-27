
import 'package:equatable/equatable.dart';

import '../../../workout.dart';

abstract class EquipmentEvent extends Equatable {
  const EquipmentEvent();

  @override
  List<Object?> get props => [];
}

class AddEquipment extends EquipmentEvent {
  final Equipment equipment;

  const AddEquipment(this.equipment);

  @override
  List<Object?> get props => [equipment];
}

class UpdateEquipment extends EquipmentEvent {
  final Equipment equipment;

  const UpdateEquipment(this.equipment);

  @override
  List<Object?> get props => [equipment];
}

class DeleteEquipment extends EquipmentEvent {
  final String equipmentId;
  final String userId;

  const DeleteEquipment(this.equipmentId, this.userId);

  @override
  List<Object?> get props => [equipmentId, userId];
}

class LoadUserEquipment extends EquipmentEvent {
  final String userId;

  const LoadUserEquipment(this.userId);

  @override
  List<Object?> get props => [userId];
}

class LoadEquipmentByCategory extends EquipmentEvent {
  final EquipmentCategory category;

  const LoadEquipmentByCategory(this.category);

  @override
  List<Object?> get props => [category];
}

class SearchEquipment extends EquipmentEvent {
  final String query;

  const SearchEquipment(this.query);

  @override
  List<Object?> get props => [query];
}