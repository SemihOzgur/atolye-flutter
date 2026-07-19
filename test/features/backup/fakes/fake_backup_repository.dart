import 'package:leather_care_admin/core/network/api_exception.dart';
import 'package:leather_care_admin/features/backup/data/backup_repository.dart';

class FakeBackupRepository implements IBackupRepository {
  String? fileNameToReturn;
  ApiException? exceptionToThrow;
  String? lastDestinationPath;

  @override
  Future<String?> downloadLatest(
    String destinationPath, {
    void Function(int sent, int total)? onProgress,
  }) async {
    lastDestinationPath = destinationPath;
    onProgress?.call(1, 1);
    if (exceptionToThrow != null) throw exceptionToThrow!;
    return fileNameToReturn;
  }
}
