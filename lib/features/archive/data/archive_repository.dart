import 'package:dio/dio.dart';

import '../../../core/constants/api_endpoints.dart';
import '../../../core/network/api_exception.dart';
import 'dto/archive_candidate_dto.dart';
import 'dto/archive_confirm_request_dto.dart';
import 'dto/archive_export_response_dto.dart';

abstract class IArchiveRepository {
  Future<List<ArchiveCandidateDto>> fetchCandidates({int olderThanDays = 90});

  Future<ArchiveExportResponseDto> export(int workOrderId);

  Future<void> confirm(int workOrderId, List<int> verifiedMediaIds);

  /// Downloads [url] directly to [destinationPath] and returns the response's
  /// `ETag` header (quotes stripped), or null if the header is absent.
  Future<String?> downloadToFile(String url, String destinationPath);
}

class ArchiveRepository implements IArchiveRepository {
  ArchiveRepository(this._dio, {Dio? downloadClient})
      : _downloadClient = downloadClient ?? Dio();

  final Dio _dio;
  final Dio _downloadClient;

  @override
  Future<List<ArchiveCandidateDto>> fetchCandidates({
    int olderThanDays = 90,
  }) async {
    try {
      final response = await _dio.get<List<dynamic>>(
        ApiEndpoints.archiveCandidates.path,
        queryParameters: {'olderThanDays': olderThanDays},
      );

      return response.data!
          .map(
            (item) =>
                ArchiveCandidateDto.fromJson(item as Map<String, dynamic>),
          )
          .toList();
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    }
  }

  @override
  Future<ArchiveExportResponseDto> export(int workOrderId) async {
    try {
      final response = await _dio.post<Map<String, dynamic>>(
        ApiEndpoints.archiveExport(workOrderId).path,
      );

      return ArchiveExportResponseDto.fromJson(response.data!);
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    }
  }

  @override
  Future<void> confirm(int workOrderId, List<int> verifiedMediaIds) async {
    try {
      await _dio.post<void>(
        ApiEndpoints.archiveConfirm(workOrderId).path,
        data: ArchiveConfirmRequestDto(
          verifiedMediaIds: verifiedMediaIds,
        ).toJson(),
      );
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    }
  }

  @override
  Future<String?> downloadToFile(String url, String destinationPath) async {
    try {
      final response = await _downloadClient.download(url, destinationPath);
      final etagHeader = response.headers.value('etag');
      return etagHeader?.replaceAll('"', '');
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    }
  }
}
