import 'package:path/path.dart' as p;

enum MediaKind { photo, video }

class MediaFormatInfo {
  const MediaFormatInfo({
    required this.kind,
    required this.needsConversion,
    required this.targetMimeType,
  });

  final MediaKind kind;
  final bool needsConversion;
  final String targetMimeType;
}

class MediaFormatValidator {
  MediaFormatValidator._();

  static const int maxPhotoBytes = 25 * 1024 * 1024;
  static const int maxVideoBytes = 500 * 1024 * 1024;

  static MediaFormatInfo? classify(String filePath) {
    final ext = p.extension(filePath).toLowerCase();

    switch (ext) {
      case '.jpg':
      case '.jpeg':
        return const MediaFormatInfo(
          kind: MediaKind.photo,
          needsConversion: false,
          targetMimeType: 'image/jpeg',
        );
      case '.png':
        return const MediaFormatInfo(
          kind: MediaKind.photo,
          needsConversion: false,
          targetMimeType: 'image/png',
        );
      case '.heic':
        return const MediaFormatInfo(
          kind: MediaKind.photo,
          needsConversion: true,
          targetMimeType: 'image/jpeg',
        );
      case '.mp4':
        return const MediaFormatInfo(
          kind: MediaKind.video,
          needsConversion: false,
          targetMimeType: 'video/mp4',
        );
      case '.mov':
        return const MediaFormatInfo(
          kind: MediaKind.video,
          needsConversion: true,
          targetMimeType: 'video/mp4',
        );
      default:
        return null;
    }
  }

  static int maxBytesFor(MediaKind kind) =>
      kind == MediaKind.photo ? maxPhotoBytes : maxVideoBytes;
}
