import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:leather_care_admin/core/network/api_exception.dart';
import 'package:leather_care_admin/features/media/data/dto/request_media_upload_response_dto.dart';
import 'package:leather_care_admin/features/media/data/media_conversion_service.dart';
import 'package:leather_care_admin/features/media/presentation/cubit/media_upload_cubit.dart';
import 'package:leather_care_admin/features/media/presentation/cubit/upload_task.dart';

import '../../fakes/fake_media_conversion_service.dart';
import '../../fakes/fake_media_repository.dart';

void main() {
  late FakeMediaRepository repository;
  late FakeMediaConversionService conversionService;
  late Directory tempDir;

  setUp(() async {
    repository = FakeMediaRepository()
      ..requestUploadResultToReturn = RequestMediaUploadResponseDto(
        mediaFileId: 42,
        uploadUrl: 'https://minio.local/upload',
        expiresAt: DateTime(2026, 1, 1, 10, 5),
      );
    conversionService = FakeMediaConversionService();
    tempDir = await Directory.systemTemp.createTemp('media_upload_cubit_test');
  });

  tearDown(() async {
    if (tempDir.existsSync()) {
      await tempDir.delete(recursive: true);
    }
  });

  test('enqueueFiles uploads a jpg through to done', () async {
    final file = File('${tempDir.path}/photo.jpg')..writeAsBytesSync([1, 2, 3]);
    final cubit = MediaUploadCubit(repository, conversionService, 7);
    var confirmedCalls = 0;
    cubit.onUploadConfirmed = () => confirmedCalls++;

    await cubit.enqueueFiles([file.path], 'BEFORE');

    expect(cubit.state.tasks.single.status, UploadTaskStatus.done);
    expect(cubit.state.completedCount, 1);
    expect(repository.lastConfirmedMediaFileId, 42);
    expect(repository.lastUploadedUrl, 'https://minio.local/upload');
    expect(confirmedCalls, 1);
  });

  test('enqueueFiles marks unsupported extensions as error immediately', () async {
    final file = File('${tempDir.path}/document.pdf')..writeAsBytesSync([1]);
    final cubit = MediaUploadCubit(repository, conversionService, 7);

    await cubit.enqueueFiles([file.path], 'BEFORE');

    final task = cubit.state.tasks.single;
    expect(task.status, UploadTaskStatus.error);
    expect(task.errorMessage, contains('Desteklenmeyen dosya formatı'));
    expect(repository.lastUploadedUrl, isNull);
  });

  test('enqueueFiles rejects a photo exceeding the size limit', () async {
    final file = File('${tempDir.path}/big.jpg');
    final raf = file.openSync(mode: FileMode.write);
    raf.truncateSync(26 * 1024 * 1024);
    raf.closeSync();

    final cubit = MediaUploadCubit(repository, conversionService, 7);

    await cubit.enqueueFiles([file.path], 'BEFORE');

    final task = cubit.state.tasks.single;
    expect(task.status, UploadTaskStatus.error);
    expect(task.errorMessage, contains('çok büyük'));
    expect(repository.lastUploadedUrl, isNull);
  });

  test('converts heic before uploading and surfaces conversion failure message', () async {
    final file = File('${tempDir.path}/photo.heic')..writeAsBytesSync([1, 2]);
    conversionService.exceptionToThrow =
        MediaConversionException('ffmpeg dönüştürme sırasında hata verdi.');

    final cubit = MediaUploadCubit(repository, conversionService, 7);
    await cubit.enqueueFiles([file.path], 'BEFORE');

    final task = cubit.state.tasks.single;
    expect(task.status, UploadTaskStatus.error);
    expect(task.errorMessage, 'ffmpeg dönüştürme sırasında hata verdi.');
    expect(repository.lastUploadedUrl, isNull);
  });

  test('retry reprocesses a failed task after the underlying issue is fixed', () async {
    final file = File('${tempDir.path}/photo.heic')..writeAsBytesSync([1, 2]);
    final convertedFile = File('${tempDir.path}/photo.converted.jpg')
      ..writeAsBytesSync([9, 9]);
    conversionService.exceptionToThrow =
        MediaConversionException('ffmpeg dönüştürme sırasında hata verdi.');

    final cubit = MediaUploadCubit(repository, conversionService, 7);
    await cubit.enqueueFiles([file.path], 'BEFORE');
    expect(cubit.state.tasks.single.status, UploadTaskStatus.error);

    conversionService.exceptionToThrow = null;
    conversionService.fileToReturn = convertedFile;
    await cubit.retry(cubit.state.tasks.single.id);

    expect(cubit.state.tasks.single.status, UploadTaskStatus.done);
    expect(repository.lastConfirmedMediaFileId, 42);
  });

  test('retry on an unsupported-format task keeps it as error instead of crashing', () async {
    final file = File('${tempDir.path}/document.pdf')..writeAsBytesSync([1]);
    final cubit = MediaUploadCubit(repository, conversionService, 7);
    await cubit.enqueueFiles([file.path], 'BEFORE');

    await cubit.retry(cubit.state.tasks.single.id);

    expect(cubit.state.tasks.single.status, UploadTaskStatus.error);
  });

  test('surfaces the ApiException detail when requestUpload fails', () async {
    final file = File('${tempDir.path}/photo.jpg')..writeAsBytesSync([1, 2, 3]);
    repository.exceptionToThrow = ApiException(
      message: 'Bad Request',
      detail: 'Yükleme sınırına ulaşıldı.',
      statusCode: 400,
    );

    final cubit = MediaUploadCubit(repository, conversionService, 7);
    await cubit.enqueueFiles([file.path], 'BEFORE');

    final task = cubit.state.tasks.single;
    expect(task.status, UploadTaskStatus.error);
    expect(task.errorMessage, 'Yükleme sınırına ulaşıldı.');
  });
}
