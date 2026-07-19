import 'package:flutter_test/flutter_test.dart';
import 'package:leather_care_admin/core/network/api_exception.dart';
import 'package:leather_care_admin/features/backup/presentation/cubit/backup_cubit.dart';
import 'package:leather_care_admin/features/backup/presentation/cubit/backup_state.dart';

import '../../fakes/fake_backup_repository.dart';

void main() {
  late FakeBackupRepository repository;

  setUp(() {
    repository = FakeBackupRepository();
  });

  test('download emits done with the server-reported filename on success', () async {
    repository.fileNameToReturn = 'db-2026-01-01.sql.gz';
    final cubit = BackupCubit(repository);

    await cubit.download('/tmp/backup.sql.gz');

    expect(cubit.state.status, BackupDownloadStatus.done);
    expect(cubit.state.fileName, 'db-2026-01-01.sql.gz');
    expect(cubit.state.savedPath, '/tmp/backup.sql.gz');
    expect(repository.lastDestinationPath, '/tmp/backup.sql.gz');
  });

  test('download falls back to the destination basename when no filename is reported', () async {
    repository.fileNameToReturn = null;
    final cubit = BackupCubit(repository);

    await cubit.download('/tmp/backup.sql.gz');

    expect(cubit.state.status, BackupDownloadStatus.done);
    expect(cubit.state.fileName, 'backup.sql.gz');
  });

  test('download emits a friendly message for a 404 (no backup yet)', () async {
    repository.exceptionToThrow = ApiException(
      message: 'Not Found',
      statusCode: 404,
    );
    final cubit = BackupCubit(repository);

    await cubit.download('/tmp/backup.sql.gz');

    expect(cubit.state.status, BackupDownloadStatus.error);
    expect(cubit.state.errorMessage, 'Henüz yedek alınmamış.');
  });

  test('download surfaces the ApiException detail for other errors', () async {
    repository.exceptionToThrow = ApiException(
      message: 'Unauthorized',
      detail: 'Bu işlem için admin yetkisi gerekiyor.',
      statusCode: 401,
    );
    final cubit = BackupCubit(repository);

    await cubit.download('/tmp/backup.sql.gz');

    expect(cubit.state.status, BackupDownloadStatus.error);
    expect(cubit.state.errorMessage, 'Bu işlem için admin yetkisi gerekiyor.');
  });
}
