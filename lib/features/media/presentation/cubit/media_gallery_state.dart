import '../../../work_order/data/dto/media_file_dto.dart';

enum MediaGalleryStatus { loading, loaded, error }

class MediaGalleryState {
  const MediaGalleryState({
    this.status = MediaGalleryStatus.loading,
    this.items = const <MediaFileDto>[],
    this.errorMessage,
  });

  final MediaGalleryStatus status;
  final List<MediaFileDto> items;
  final String? errorMessage;

  List<MediaFileDto> forStage(String stage) =>
      items.where((item) => item.stage == stage).toList();
}
