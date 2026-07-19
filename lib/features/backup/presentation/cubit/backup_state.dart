enum BackupDownloadStatus { idle, downloading, done, error }

class BackupState {
  const BackupState({
    this.status = BackupDownloadStatus.idle,
    this.progress = 0.0,
    this.fileName,
    this.savedPath,
    this.errorMessage,
  });

  final BackupDownloadStatus status;
  final double progress;
  final String? fileName;
  final String? savedPath;
  final String? errorMessage;

  BackupState copyWith({
    BackupDownloadStatus? status,
    double? progress,
    String? fileName,
    String? savedPath,
    String? errorMessage,
  }) {
    return BackupState(
      status: status ?? this.status,
      progress: progress ?? this.progress,
      fileName: fileName ?? this.fileName,
      savedPath: savedPath ?? this.savedPath,
      errorMessage: errorMessage,
    );
  }
}
