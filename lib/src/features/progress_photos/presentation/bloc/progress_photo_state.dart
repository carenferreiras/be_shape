import '../../../features.dart';

class ProgressPhotoState {
  final bool isLoading;
  final List<ProgressPhoto> photos;
  final String? error;

  const ProgressPhotoState({
    this.isLoading = false,
    this.photos = const [],
    this.error,
  });

  ProgressPhotoState copyWith({
    bool? isLoading,
    List<ProgressPhoto>? photos,
    String? error,
  }) {
    return ProgressPhotoState(
      isLoading: isLoading ?? this.isLoading,
      photos: photos ?? this.photos,
      error: error ?? this.error,
    );
  }
}