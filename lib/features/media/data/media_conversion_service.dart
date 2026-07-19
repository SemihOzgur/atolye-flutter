import 'dart:io';

import 'package:path/path.dart' as p;

class MediaConversionException implements Exception {
  MediaConversionException(this.message);

  final String message;

  @override
  String toString() => message;
}

typedef ProcessRunFunction = Future<ProcessResult> Function(
  String executable,
  List<String> arguments,
);

abstract class IMediaConversionService {
  Future<bool> isFfmpegAvailable();

  Future<File> convertHeicToJpeg(File input);

  Future<File> convertToMp4(File input);
}

class MediaConversionService implements IMediaConversionService {
  MediaConversionService({ProcessRunFunction? processRunner})
      : _processRunner = processRunner ?? Process.run;

  final ProcessRunFunction _processRunner;

  static const String _missingFfmpegMessage =
      'Dönüştürme için sisteminizde ffmpeg kurulu olmalıdır. '
      'Lütfen ffmpeg\'i kurup tekrar deneyin.';

  @override
  Future<bool> isFfmpegAvailable() async {
    try {
      final result = await _processRunner('ffmpeg', ['-version']);
      return result.exitCode == 0;
    } on ProcessException {
      return false;
    }
  }

  @override
  Future<File> convertHeicToJpeg(File input) async {
    final outputPath = _derivedOutputPath(input.path, 'jpg');

    final ProcessResult result;
    try {
      result = await _processRunner(
        'ffmpeg',
        ['-y', '-i', input.path, outputPath],
      );
    } on ProcessException {
      throw MediaConversionException(_missingFfmpegMessage);
    }

    if (result.exitCode != 0) {
      throw MediaConversionException(
        'HEIC dosyası JPEG\'e çevrilemedi.\n${result.stderr}',
      );
    }

    return File(outputPath);
  }

  @override
  Future<File> convertToMp4(File input) async {
    final outputPath = _derivedOutputPath(input.path, 'mp4');

    final ProcessResult result;
    try {
      result = await _processRunner(
        'ffmpeg',
        [
          '-y',
          '-i',
          input.path,
          '-c:v',
          'libx264',
          '-c:a',
          'aac',
          outputPath,
        ],
      );
    } on ProcessException {
      throw MediaConversionException(_missingFfmpegMessage);
    }

    if (result.exitCode != 0) {
      throw MediaConversionException(
        'Video MP4\'e çevrilemedi.\n${result.stderr}',
      );
    }

    return File(outputPath);
  }

  String _derivedOutputPath(String inputPath, String newExtension) {
    // Writes into the app's own sandbox container instead of next to the
    // source file: under App Sandbox, the user-selected-file entitlement
    // only grants access to that exact file, not to new sibling files in
    // its (likely unrelated, e.g. Desktop/Downloads) directory.
    final directory = Directory.systemTemp.path;
    final baseName = p.basenameWithoutExtension(inputPath);
    final uniqueSuffix = DateTime.now().microsecondsSinceEpoch;
    return p.join(directory, '$baseName.converted.$uniqueSuffix.$newExtension');
  }
}
