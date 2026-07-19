import 'dart:io';

import 'package:leather_care_admin/features/media/data/media_conversion_service.dart';

class FakeMediaConversionService implements IMediaConversionService {
  bool ffmpegAvailable = true;
  File? fileToReturn;
  MediaConversionException? exceptionToThrow;

  @override
  Future<bool> isFfmpegAvailable() async => ffmpegAvailable;

  @override
  Future<File> convertHeicToJpeg(File input) async {
    if (exceptionToThrow != null) throw exceptionToThrow!;
    return fileToReturn ?? input;
  }

  @override
  Future<File> convertToMp4(File input) async {
    if (exceptionToThrow != null) throw exceptionToThrow!;
    return fileToReturn ?? input;
  }
}
