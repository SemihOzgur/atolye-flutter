import 'package:flutter_test/flutter_test.dart';
import 'package:leather_care_admin/features/media/data/media_format_validator.dart';

void main() {
  group('classify', () {
    test('recognizes jpeg/jpg as photo needing no conversion', () {
      final jpg = MediaFormatValidator.classify('/tmp/photo.jpg')!;
      expect(jpg.kind, MediaKind.photo);
      expect(jpg.needsConversion, isFalse);
      expect(jpg.targetMimeType, 'image/jpeg');

      final jpeg = MediaFormatValidator.classify('/tmp/photo.JPEG')!;
      expect(jpeg.kind, MediaKind.photo);
      expect(jpeg.needsConversion, isFalse);
    });

    test('recognizes png as photo needing no conversion', () {
      final info = MediaFormatValidator.classify('/tmp/photo.png')!;
      expect(info.kind, MediaKind.photo);
      expect(info.needsConversion, isFalse);
      expect(info.targetMimeType, 'image/png');
    });

    test('recognizes heic as photo needing conversion to jpeg', () {
      final info = MediaFormatValidator.classify('/tmp/photo.HEIC')!;
      expect(info.kind, MediaKind.photo);
      expect(info.needsConversion, isTrue);
      expect(info.targetMimeType, 'image/jpeg');
    });

    test('recognizes mp4 as video needing no conversion', () {
      final info = MediaFormatValidator.classify('/tmp/video.mp4')!;
      expect(info.kind, MediaKind.video);
      expect(info.needsConversion, isFalse);
      expect(info.targetMimeType, 'video/mp4');
    });

    test('recognizes mov as video needing conversion to mp4', () {
      final info = MediaFormatValidator.classify('/tmp/video.MOV')!;
      expect(info.kind, MediaKind.video);
      expect(info.needsConversion, isTrue);
      expect(info.targetMimeType, 'video/mp4');
    });

    test('returns null for unsupported extensions', () {
      expect(MediaFormatValidator.classify('/tmp/file.pdf'), isNull);
      expect(MediaFormatValidator.classify('/tmp/file.avi'), isNull);
      expect(MediaFormatValidator.classify('/tmp/file'), isNull);
    });
  });

  test('maxBytesFor returns the documented limits', () {
    expect(
      MediaFormatValidator.maxBytesFor(MediaKind.photo),
      25 * 1024 * 1024,
    );
    expect(
      MediaFormatValidator.maxBytesFor(MediaKind.video),
      500 * 1024 * 1024,
    );
  });
}
