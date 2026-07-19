import 'dart:io';

import 'package:dio/dio.dart';

import '../../../core/constants/api_endpoints.dart';
import '../../../core/network/api_exception.dart';
import '../../work_order/data/dto/media_file_dto.dart';
import 'dto/confirm_media_upload_request_dto.dart';
import 'dto/request_media_upload_request_dto.dart';
import 'dto/request_media_upload_response_dto.dart';

abstract class IMediaRepository {
  Future<RequestMediaUploadResponseDto> requestUpload(
    int workOrderId,
    RequestMediaUploadRequestDto request,
  );

  Future<void> uploadFile(
    String uploadUrl,
    File file,
    String mimeType, {
    void Function(int sent, int total)? onProgress,
  });

  Future<void> confirmUpload(int workOrderId, int mediaFileId);

  Future<List<MediaFileDto>> fetchMedia(int workOrderId);

  Future<void> deleteMedia(int mediaId);
}

class MediaRepository implements IMediaRepository {
  MediaRepository(this._dio, {Dio? uploadClient})
      : _uploadClient = uploadClient ?? Dio();

  final Dio _dio;
  final Dio _uploadClient;

  @override
  Future<RequestMediaUploadResponseDto> requestUpload(
    int workOrderId,
    RequestMediaUploadRequestDto request,
  ) async {
    try {
      final response = await _dio.post<Map<String, dynamic>>(
        ApiEndpoints.requestMediaUpload(workOrderId).path,
        data: request.toJson(),
      );

      return RequestMediaUploadResponseDto.fromJson(response.data!);
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    }
  }

  @override
  Future<void> uploadFile(
    String uploadUrl,
    File file,
    String mimeType, {
    void Function(int sent, int total)? onProgress,
  }) async {
    try {
      final length = await file.length();
      await _uploadClient.put<void>(
        uploadUrl,
        data: file.openRead(),
        options: Options(
          headers: {
            Headers.contentTypeHeader: mimeType,
            Headers.contentLengthHeader: length,
          },
        ),
        onSendProgress: onProgress,
      );
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    }
  }

  @override
  Future<void> confirmUpload(int workOrderId, int mediaFileId) async {
    try {
      await _dio.post<void>(
        ApiEndpoints.confirmMediaUpload(workOrderId).path,
        data: ConfirmMediaUploadRequestDto(mediaFileId: mediaFileId).toJson(),
      );
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    }
  }

  @override
  Future<List<MediaFileDto>> fetchMedia(int workOrderId) async {
    try {
      final response = await _dio.get<List<dynamic>>(
        ApiEndpoints.getMediaList(workOrderId).path,
      );

      return response.data!
          .map((item) => MediaFileDto.fromJson(item as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    }
  }

  @override
  Future<void> deleteMedia(int mediaId) async {
    try {
      await _dio.delete<void>(ApiEndpoints.deleteMedia(mediaId).path);
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    }
  }
}
