import 'package:flutter_bloc/flutter_bloc.dart';

import '../../suplement.dart';

class SupplementBloc extends Bloc<SupplementEvent, SupplementState> {
  final SupplementRepository _repository;

  SupplementBloc({required SupplementRepository repository})
      : _repository = repository,
        super(const SupplementState()) {
    on<AddSupplement>(_onAddSupplement);
    on<UpdateSupplement>(_onUpdateSupplement);
    on<DeleteSupplement>(_onDeleteSupplement);
    on<LoadUserSupplements>(_onLoadUserSupplements);
    on<LoadActiveSupplements>(_onLoadActiveSupplements);
    on<LoadLowSupplements>(_onLoadLowSupplements);
    on<LogSupplementTaken>(_onLogSupplementTaken);
    on<LoadSupplementLogs>(_onLoadSupplementLogs);
    on<LoadSupplementLogsByDate>(_onLoadSupplementLogsByDate);
  }

  Future<void> _onAddSupplement(
    AddSupplement event,
    Emitter<SupplementState> emit,
  ) async {
    try {
      emit(state.copyWith(isLoading: true));
      await _repository.addSupplement(event.supplement);
      final supplements = await _repository.getUserSupplements(event.supplement.userId);
      emit(state.copyWith(
        isLoading: false,
        supplements: supplements,
      ));
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        error: e.toString(),
      ));
    }
  }

  Future<void> _onUpdateSupplement(
    UpdateSupplement event,
    Emitter<SupplementState> emit,
  ) async {
    try {
      emit(state.copyWith(isLoading: true));
      await _repository.updateSupplement(event.supplement);
      final supplements = await _repository.getUserSupplements(event.supplement.userId);
      emit(state.copyWith(
        isLoading: false,
        supplements: supplements,
      ));
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        error: e.toString(),
      ));
    }
  }

  Future<void> _onDeleteSupplement(
    DeleteSupplement event,
    Emitter<SupplementState> emit,
  ) async {
    try {
      emit(state.copyWith(isLoading: true));
      await _repository.deleteSupplement(event.supplementId);
      final supplements = await _repository.getUserSupplements(event.userId);
      emit(state.copyWith(
        isLoading: false,
        supplements: supplements,
      ));
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        error: e.toString(),
      ));
    }
  }

  Future<void> _onLoadUserSupplements(
    LoadUserSupplements event,
    Emitter<SupplementState> emit,
  ) async {
    try {
      emit(state.copyWith(isLoading: true));
      final supplements = await _repository.getUserSupplements(event.userId);
      emit(state.copyWith(
        isLoading: false,
        supplements: supplements,
      ));
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        error: e.toString(),
      ));
    }
  }

  Future<void> _onLoadActiveSupplements(
    LoadActiveSupplements event,
    Emitter<SupplementState> emit,
  ) async {
    try {
      emit(state.copyWith(isLoading: true));
      final supplements = await _repository.getActiveSupplements(event.userId);
      emit(state.copyWith(
        isLoading: false,
        supplements: supplements,
      ));
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        error: e.toString(),
      ));
    }
  }

  Future<void> _onLoadLowSupplements(
    LoadLowSupplements event,
    Emitter<SupplementState> emit,
  ) async {
    try {
      emit(state.copyWith(isLoading: true));
      final supplements = await _repository.getLowSupplements(event.userId);
      emit(state.copyWith(
        isLoading: false,
        supplements: supplements,
      ));
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        error: e.toString(),
      ));
    }
  }

  Future<void> _onLogSupplementTaken(
    LogSupplementTaken event,
    Emitter<SupplementState> emit,
  ) async {
    try {
      emit(state.copyWith(isLoading: true));
      await _repository.logSupplementTaken(event.log);
      final logs = await _repository.getSupplementLogs(event.log.supplementId);
      emit(state.copyWith(
        isLoading: false,
        logs: logs,
      ));
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        error: e.toString(),
      ));
    }
  }

  Future<void> _onLoadSupplementLogs(
    LoadSupplementLogs event,
    Emitter<SupplementState> emit,
  ) async {
    try {
      emit(state.copyWith(isLoading: true));
      final logs = await _repository.getSupplementLogs(event.supplementId);
      emit(state.copyWith(
        isLoading: false,
        logs: logs,
      ));
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        error: e.toString(),
      ));
    }
  }

  Future<void> _onLoadSupplementLogsByDate(
    LoadSupplementLogsByDate event,
    Emitter<SupplementState> emit,
  ) async {
    try {
      emit(state.copyWith(isLoading: true));
      final logs = await _repository.getSupplementLogsByDate(
        event.userId,
        event.date,
      );
      emit(state.copyWith(
        isLoading: false,
        logs: logs,
      ));
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        error: e.toString(),
      ));
    }
  }
}