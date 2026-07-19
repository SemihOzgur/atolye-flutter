import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:leather_care_admin/features/media/data/media_conversion_service.dart';

void main() {
  late Directory tempDir;

  setUp(() async {
    tempDir = await Directory.systemTemp.createTemp('media_conversion_test');
  });

  tearDown(() async {
    if (tempDir.existsSync()) {
      await tempDir.delete(recursive: true);
    }
  });

  test('isFfmpegAvailable returns true when process exits 0', () async {
    final service = MediaConversionService(
      processRunner: (executable, arguments) async =>
          ProcessResult(0, 0, 'ffmpeg version 6.0', ''),
    );

    expect(await service.isFfmpegAvailable(), isTrue);
  });

  test('isFfmpegAvailable returns false when ffmpeg is not installed', () async {
    final service = MediaConversionService(
      processRunner: (executable, arguments) =>
          throw const ProcessException('ffmpeg', []),
    );

    expect(await service.isFfmpegAvailable(), isFalse);
  });

  test('convertHeicToJpeg returns the converted file on success', () async {
    final input = File('${tempDir.path}/photo.heic')..writeAsBytesSync([1, 2, 3]);
    List<String>? capturedArgs;

    final service = MediaConversionService(
      processRunner: (executable, arguments) async {
        capturedArgs = arguments;
        // Simulate ffmpeg writing the output file.
        File(arguments.last).writeAsBytesSync([4, 5, 6]);
        return ProcessResult(0, 0, '', '');
      },
    );

    final output = await service.convertHeicToJpeg(input);

    expect(capturedArgs, contains(input.path));
    expect(output.path, contains('.converted.'));
    expect(output.path, endsWith('.jpg'));
    expect(output.existsSync(), isTrue);
  });

  test('convertHeicToJpeg throws MediaConversionException on non-zero exit', () async {
    final input = File('${tempDir.path}/photo.heic')..writeAsBytesSync([1]);

    final service = MediaConversionService(
      processRunner: (executable, arguments) async =>
          ProcessResult(0, 1, '', 'unsupported codec'),
    );

    await expectLater(
      () => service.convertHeicToJpeg(input),
      throwsA(isA<MediaConversionException>()),
    );
  });

  test('convertHeicToJpeg throws a clear message when ffmpeg is missing', () async {
    final input = File('${tempDir.path}/photo.heic')..writeAsBytesSync([1]);

    final service = MediaConversionService(
      processRunner: (executable, arguments) =>
          throw const ProcessException('ffmpeg', []),
    );

    await expectLater(
      () => service.convertHeicToJpeg(input),
      throwsA(
        isA<MediaConversionException>().having(
          (e) => e.message,
          'message',
          contains('ffmpeg kurulu olmalıdır'),
        ),
      ),
    );
  });

  test('convertToMp4 returns the converted file on success', () async {
    final input = File('${tempDir.path}/video.mov')..writeAsBytesSync([1, 2]);

    final service = MediaConversionService(
      processRunner: (executable, arguments) async {
        File(arguments.last).writeAsBytesSync([9]);
        return ProcessResult(0, 0, '', '');
      },
    );

    final output = await service.convertToMp4(input);

    expect(output.path, contains('.converted.'));
    expect(output.path, endsWith('.mp4'));
    expect(output.existsSync(), isTrue);
  });

  test('convertToMp4 throws MediaConversionException on non-zero exit', () async {
    final input = File('${tempDir.path}/video.mov')..writeAsBytesSync([1]);

    final service = MediaConversionService(
      processRunner: (executable, arguments) async =>
          ProcessResult(0, 1, '', 'encoder error'),
    );

    await expectLater(
      () => service.convertToMp4(input),
      throwsA(isA<MediaConversionException>()),
    );
  });
}
