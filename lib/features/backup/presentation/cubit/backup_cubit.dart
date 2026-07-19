import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:path/path.dart' as p;

import '../../../../core/network/api_exception.dart';
import '../../data/backup_repository.dart';
import 'backup_state.dart';

class BackupCubit extends Cubit<BackupState> {
  BackupCubit(this._repository) : super(const BackupState());

  final IBackupRepository _repository;

  Future<void> download(String destinationPath) async {
    emit(const BackupState(status: BackupDownloadStatus.downloading));

    try {
      final fileName = await _repository.downloadLatest(
        destinationPath,
        onProgress: (sent, total) {
          if (total > 0) {
            emit(state.copyWith(progress: sent / total));
          }
        },
      );

      emit(
        BackupState(
          status: BackupDownloadStatus.done,
          progress: 1,
          fileName: fileName ?? p.basename(destinationPath),
          savedPath: destinationPath,
        ),
      );
    } on ApiException catch (e) {
      final message = e.statusCode == 404
          ? 'Henüz yedek alınmamış.'
          : e.detail ?? e.message;
      emit(
        BackupState(status: BackupDownloadStatus.error, errorMessage: message),
      );
    }
  }
}
