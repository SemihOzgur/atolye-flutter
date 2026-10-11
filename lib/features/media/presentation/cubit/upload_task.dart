import '../../data/media_format_validator.dart';

enum UploadTaskStatus {
  queued,
  converting,
  uploading,
  confirming,
  done,
  error,
}

class UploadTask {
  const UploadTask({
    required this.id,
    required this.originalPath,
    required this.fileName,
    required this.stage,
    required this.kind,
    this.status = UploadTaskStatus.queued,
    this.progress = 0.0,
    this.errorMessage,
    this.mediaFileId,
  });

  final int id;
  final String originalPath;
  final String fileName;
  final String stage;
  final MediaKind kind;
  final UploadTaskStatus status;
  final double progress;
  final String? errorMessage;

  /// Sunucudaki medya kaydı — confirm sonrası dolar; galeri yenilenince aynı
  /// kayıt galeride de görünür, sayaç onu iki kez saymamak için buna bakar.
  final int? mediaFileId;

  UploadTask copyWith({
    UploadTaskStatus? status,
    double? progress,
    String? errorMessage,
    int? mediaFileId,
  }) {
    return UploadTask(
      id: id,
      originalPath: originalPath,
      fileName: fileName,
      stage: stage,
      kind: kind,
      status: status ?? this.status,
      progress: progress ?? this.progress,
      errorMessage: errorMessage,
      mediaFileId: mediaFileId ?? this.mediaFileId,
    );
  }
}
