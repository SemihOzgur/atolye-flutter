import 'package:flutter_test/flutter_test.dart';
import 'package:leather_care_admin/core/network/api_exception.dart';
import 'package:leather_care_admin/features/media/presentation/cubit/media_gallery_cubit.dart';
import 'package:leather_care_admin/features/media/presentation/cubit/media_gallery_state.dart';
import 'package:leather_care_admin/features/work_order/data/dto/media_file_dto.dart';

import '../../fakes/fake_media_repository.dart';

void main() {
  late FakeMediaRepository repository;

  setUp(() {
    repository = FakeMediaRepository();
  });

  MediaFileDto buildMedia({required int id, required String stage}) {
    return MediaFileDto(
      id: id,
      mediaType: 'PHOTO',
      stage: stage,
      viewUrl: 'https://minio.local/view/$id',
      createdAt: DateTime(2026, 1, 1),
    );
  }

  test('load populates items on success', () async {
    repository.mediaToReturn = [
      buildMedia(id: 1, stage: 'BEFORE'),
      buildMedia(id: 2, stage: 'AFTER'),
    ];
    final cubit = MediaGalleryCubit(repository, 7);

    await cubit.load();

    expect(cubit.state.status, MediaGalleryStatus.loaded);
    expect(cubit.state.items, hasLength(2));
    expect(cubit.state.forStage('BEFORE'), hasLength(1));
    expect(cubit.state.forStage('DETAIL'), isEmpty);
  });

  test('load emits error state with the ApiException detail', () async {
    repository.exceptionToThrow = ApiException(
      message: 'Internal Server Error',
      detail: 'Medya listesi alınamadı.',
      statusCode: 500,
    );
    final cubit = MediaGalleryCubit(repository, 7);

    await cubit.load();

    expect(cubit.state.status, MediaGalleryStatus.error);
    expect(cubit.state.errorMessage, 'Medya listesi alınamadı.');
  });

  test('delete removes the media and reloads on success', () async {
    repository.mediaToReturn = [buildMedia(id: 1, stage: 'BEFORE')];
    final cubit = MediaGalleryCubit(repository, 7);
    await cubit.load();

    repository.mediaToReturn = [];
    final error = await cubit.delete(1);

    expect(error, isNull);
    expect(repository.lastDeletedMediaId, 1);
    expect(cubit.state.items, isEmpty);
  });

  test('delete returns the ApiException detail without reloading on failure', () async {
    repository.mediaToReturn = [buildMedia(id: 1, stage: 'BEFORE')];
    final cubit = MediaGalleryCubit(repository, 7);
    await cubit.load();

    repository.exceptionToThrow = ApiException(
      message: 'Bad Request',
      detail: 'SMS zaten gönderildi, medya silinemiyor.',
      statusCode: 400,
    );

    final error = await cubit.delete(1);

    expect(error, 'SMS zaten gönderildi, medya silinemiyor.');
    expect(cubit.state.items, hasLength(1));
  });
}
