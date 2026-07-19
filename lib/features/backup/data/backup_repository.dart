import 'package:dio/dio.dart';

import '../../../core/constants/api_endpoints.dart';
import '../../../core/network/api_exception.dart';

abstract class IBackupRepository {
  /// Downloads the latest DB backup to [destinationPath]. Returns the
  /// filename reported by the server's `Content-Disposition` header, or
  /// null if the header is absent.
  Future<String?> downloadLatest(
    String destinationPath, {
    void Function(int sent, int total)? onProgress,
  });
}

class BackupRepository implements IBackupRepository {
  BackupRepository(this._dio);

  final Dio _dio;

  static final _fileNamePattern = RegExp('filename="?([^";]+)"?');

  @override
  Future<String?> downloadLatest(
    String destinationPath, {
    void Function(int sent, int total)? onProgress,
  }) async {
    try {
      final response = await _dio.download(
        ApiEndpoints.downloadLatestBackup.path,
        destinationPath,
        onReceiveProgress: onProgress,
      );

      final disposition = response.headers.value('content-disposition');
      if (disposition == null) return null;
      return _fileNamePattern.firstMatch(disposition)?.group(1);
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    }
  }
}
