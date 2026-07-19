import 'dart:io';

import 'package:leather_care_admin/core/network/api_exception.dart';
import 'package:leather_care_admin/features/media/data/dto/request_media_upload_request_dto.dart';
import 'package:leather_care_admin/features/media/data/dto/request_media_upload_response_dto.dart';
import 'package:leather_care_admin/features/media/data/media_repository.dart';
import 'package:leather_care_admin/features/work_order/data/dto/media_file_dto.dart';

class FakeMediaRepository implements IMediaRepository {
  RequestMediaUploadResponseDto? requestUploadResultToReturn;
  List<MediaFileDto> mediaToReturn = const [];
  ApiException? exceptionToThrow;

  int? lastConfirmedMediaFileId;
  int? lastDeletedMediaId;
  String? lastUploadedUrl;

  @override
  Future<RequestMediaUploadResponseDto> requestUpload(
    int workOrderId,
    RequestMediaUploadRequestDto request,
  ) async {
    if (exceptionToThrow != null) throw exceptionToThrow!;
    return requestUploadResultToReturn!;
  }

  @override
  Future<void> uploadFile(
    String uploadUrl,
    File file,
    String mimeType, {
    void Function(int sent, int total)? onProgress,
  }) async {
    lastUploadedUrl = uploadUrl;
    onProgress?.call(1, 1);
    if (exceptionToThrow != null) throw exceptionToThrow!;
  }

  @override
  Future<void> confirmUpload(int workOrderId, int mediaFileId) async {
    lastConfirmedMediaFileId = mediaFileId;
    if (exceptionToThrow != null) throw exceptionToThrow!;
  }

  @override
  Future<List<MediaFileDto>> fetchMedia(int workOrderId) async {
    if (exceptionToThrow != null) throw exceptionToThrow!;
    return mediaToReturn;
  }

  @override
  Future<void> deleteMedia(int mediaId) async {
    lastDeletedMediaId = mediaId;
    if (exceptionToThrow != null) throw exceptionToThrow!;
  }
}
