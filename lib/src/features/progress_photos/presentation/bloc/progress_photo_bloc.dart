import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../features.dart';

class ProgressPhotoBloc extends Bloc<ProgressPhotoEvent, ProgressPhotoState> {
  final ProgressPhotoRepository _repository;

  ProgressPhotoBloc({required ProgressPhotoRepository repository})
      : _repository = repository,
        super(const ProgressPhotoState()) {
    on<AddPhoto>(_onAddPhoto);
    on<DeletePhoto>(_onDeletePhoto);
    on<LoadPhotosByDate>(_onLoadPhotosByDate);
    on<LoadPhotosByType>(_onLoadPhotosByType);
  }

  Future<void> _onAddPhoto(
    AddPhoto event,
    Emitter<ProgressPhotoState> emit,
  ) async {
    try {
      emit(state.copyWith(isLoading: true));
      final photoUrl = await _repository.uploadPhoto(event.filePath);
      final photo = event.photo.copyWith(photoUrl: photoUrl);
      await _repository.addProgressPhoto(photo);
      final photos = await _repository.getProgressPhotosByDate(photo.date);
      emit(state.copyWith(isLoading: false, photos: photos));
    } catch (e) {
      emit(state.copyWith(isLoading: false, error: e.toString()));
    }
  }

  Future<void> _onDeletePhoto(
    DeletePhoto event,
    Emitter<ProgressPhotoState> emit,
  ) async {
    try {
      emit(state.copyWith(isLoading: true));
      await _repository.deleteProgressPhoto(event.photoId);
      final photos = await _repository.getProgressPhotosByDate(DateTime.now());
      emit(state.copyWith(isLoading: false, photos: photos));
    } catch (e) {
      emit(state.copyWith(isLoading: false, error: e.toString()));
    }
  }

  Future<void> _onLoadPhotosByDate(
    LoadPhotosByDate event,
    Emitter<ProgressPhotoState> emit,
  ) async {
    try {
      emit(state.copyWith(isLoading: true));
      final photos = await _repository.getProgressPhotosByDate(event.date);
      emit(state.copyWith(isLoading: false, photos: photos));
    } catch (e) {
      emit(state.copyWith(isLoading: false, error: e.toString()));
    }
  }

  Future<void> _onLoadPhotosByType(
    LoadPhotosByType event,
    Emitter<ProgressPhotoState> emit,
  ) async {
    try {
      emit(state.copyWith(isLoading: true));
      final photos = await _repository.getProgressPhotosByType(event.type);
      emit(state.copyWith(isLoading: false, photos: photos));
    } catch (e) {
      emit(state.copyWith(isLoading: false, error: e.toString()));
    }
  }
}