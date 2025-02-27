import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../workout.dart';

class EquipmentBloc extends Bloc<EquipmentEvent, EquipmentState> {
  final EquipmentRepository _repository;

  EquipmentBloc({required EquipmentRepository repository})
      : _repository = repository,
        super(const EquipmentState()) {
    on<AddEquipment>(_onAddEquipment);
    on<UpdateEquipment>(_onUpdateEquipment);
    on<DeleteEquipment>(_onDeleteEquipment);
    on<LoadUserEquipment>(_onLoadUserEquipment);
    on<LoadEquipmentByCategory>(_onLoadEquipmentByCategory);
    on<SearchEquipment>(_onSearchEquipment);
  }

  Future<void> _onAddEquipment(
    AddEquipment event,
    Emitter<EquipmentState> emit,
  ) async {
    try {
      emit(state.copyWith(isLoading: true));
      await _repository.addEquipment(event.equipment);
      final equipment = await _repository.getUserEquipment(event.equipment.userId);
      emit(state.copyWith(
        isLoading: false,
        equipment: equipment,
      ));
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        error: e.toString(),
      ));
    }
  }

  Future<void> _onUpdateEquipment(
    UpdateEquipment event,
    Emitter<EquipmentState> emit,
  ) async {
    try {
      emit(state.copyWith(isLoading: true));
      await _repository.updateEquipment(event.equipment);
      final equipment = await _repository.getUserEquipment(event.equipment.userId);
      emit(state.copyWith(
        isLoading: false,
        equipment: equipment,
      ));
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        error: e.toString(),
      ));
    }
  }

  Future<void> _onDeleteEquipment(
    DeleteEquipment event,
    Emitter<EquipmentState> emit,
  ) async {
    try {
      emit(state.copyWith(isLoading: true));
      await _repository.deleteEquipment(event.equipmentId);
      final equipment = await _repository.getUserEquipment(event.userId);
      emit(state.copyWith(
        isLoading: false,
        equipment: equipment,
      ));
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        error: e.toString(),
      ));
    }
  }

  Future<void> _onLoadUserEquipment(
    LoadUserEquipment event,
    Emitter<EquipmentState> emit,
  ) async {
    try {
      emit(state.copyWith(isLoading: true));
      final equipment = await _repository.getUserEquipment(event.userId);
      emit(state.copyWith(
        isLoading: false,
        equipment: equipment,
      ));
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        error: e.toString(),
      ));
    }
  }

  Future<void> _onLoadEquipmentByCategory(
    LoadEquipmentByCategory event,
    Emitter<EquipmentState> emit,
  ) async {
    try {
      emit(state.copyWith(isLoading: true));
      final equipment = await _repository.getEquipmentByCategory(event.category);
      emit(state.copyWith(
        isLoading: false,
        equipment: equipment,
      ));
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        error: e.toString(),
      ));
    }
  }

  Future<void> _onSearchEquipment(
    SearchEquipment event,
    Emitter<EquipmentState> emit,
  ) async {
    try {
      emit(state.copyWith(isLoading: true));
      final equipment = await _repository.searchEquipment(event.query);
      emit(state.copyWith(
        isLoading: false,
        equipment: equipment,
      ));
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        error: e.toString(),
      ));
    }
  }
}