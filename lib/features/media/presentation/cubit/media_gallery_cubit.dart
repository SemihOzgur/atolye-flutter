import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/network/api_exception.dart';
import '../../data/media_repository.dart';
import 'media_gallery_state.dart';

class MediaGalleryCubit extends Cubit<MediaGalleryState> {
  MediaGalleryCubit(this._repository, this.workOrderId)
      : super(const MediaGalleryState());

  final IMediaRepository _repository;
  final int workOrderId;

  Future<void> load() async {
    emit(const MediaGalleryState());

    try {
      final items = await _repository.fetchMedia(workOrderId);
      if (isClosed) return;
      emit(MediaGalleryState(status: MediaGalleryStatus.loaded, items: items));
    } on ApiException catch (e) {
      if (isClosed) return;
      emit(
        MediaGalleryState(
          status: MediaGalleryStatus.error,
          errorMessage: e.detail ?? e.message,
        ),
      );
    }
  }

  Future<String?> delete(int mediaId) async {
    try {
      await _repository.deleteMedia(mediaId);
      await load();
      return null;
    } on ApiException catch (e) {
      return e.detail ?? e.message;
    }
  }
}
