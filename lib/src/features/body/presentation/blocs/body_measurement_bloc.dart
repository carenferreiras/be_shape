import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../features.dart';

class BodyMeasurementBloc extends Bloc<BodyMeasurementEvent, BodyMeasurementState> {
  final BodyMeasurementRepository _repository;

  BodyMeasurementBloc({required BodyMeasurementRepository repository})
      : _repository = repository,
        super(const BodyMeasurementState()) {
    on<AddMeasurement>(_onAddMeasurement);
    on<UpdateMeasurement>(_onUpdateMeasurement);
    on<DeleteMeasurement>(_onDeleteMeasurement);
    on<LoadUserMeasurements>(_onLoadUserMeasurements);
    on<LoadMeasurementsByDateRange>(_onLoadMeasurementsByDateRange);
  }

  Future<void> _onAddMeasurement(
    AddMeasurement event,
    Emitter<BodyMeasurementState> emit,
  ) async {
    try {
      emit(state.copyWith(isLoading: true));
      await _repository.addMeasurement(event.measurement);
      final measurements = await _repository.getUserMeasurements(event.measurement.userId);
      emit(state.copyWith(
        isLoading: false,
        measurements: measurements,
      ));
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        error: e.toString(),
      ));
    }
  }

  Future<void> _onUpdateMeasurement(
    UpdateMeasurement event,
    Emitter<BodyMeasurementState> emit,
  ) async {
    try {
      emit(state.copyWith(isLoading: true));
      await _repository.updateMeasurement(event.measurement);
      final measurements = await _repository.getUserMeasurements(event.measurement.userId);
      emit(state.copyWith(
        isLoading: false,
        measurements: measurements,
      ));
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        error: e.toString(),
      ));
    }
  }

  Future<void> _onDeleteMeasurement(
    DeleteMeasurement event,
    Emitter<BodyMeasurementState> emit,
  ) async {
    try {
      emit(state.copyWith(isLoading: true));
      await _repository.deleteMeasurement(event.measurementId);
      final measurements = await _repository.getUserMeasurements(event.userId);
      emit(state.copyWith(
        isLoading: false,
        measurements: measurements,
      ));
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        error: e.toString(),
      ));
    }
  }

  Future<void> _onLoadUserMeasurements(
    LoadUserMeasurements event,
    Emitter<BodyMeasurementState> emit,
  ) async {
    try {
      emit(state.copyWith(isLoading: true));
      final measurements = await _repository.getUserMeasurements(event.userId);
      emit(state.copyWith(
        isLoading: false,
        measurements: measurements,
      ));
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        error: e.toString(),
      ));
    }
  }

  Future<void> _onLoadMeasurementsByDateRange(
    LoadMeasurementsByDateRange event,
    Emitter<BodyMeasurementState> emit,
  ) async {
    try {
      emit(state.copyWith(isLoading: true));
      final measurements = await _repository.getMeasurementsByDateRange(
        event.userId,
        event.start,
        event.end,
      );
      emit(state.copyWith(
        isLoading: false,
        measurements: measurements,
      ));
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        error: e.toString(),
      ));
    }
  }
}
