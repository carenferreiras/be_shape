import '../../../features.dart';

abstract class ProgressPhotoEvent {
  const ProgressPhotoEvent();
}

class AddPhoto extends ProgressPhotoEvent {
  final String filePath;
  final ProgressPhoto photo;
  const AddPhoto(this.filePath, this.photo);
}

class DeletePhoto extends ProgressPhotoEvent {
  final String photoId;
  const DeletePhoto(this.photoId);
}

class LoadPhotosByDate extends ProgressPhotoEvent {
  final DateTime date;
  const LoadPhotosByDate(this.date);
}

class LoadPhotosByType extends ProgressPhotoEvent {
  final String type;
  const LoadPhotosByType(this.type);
}