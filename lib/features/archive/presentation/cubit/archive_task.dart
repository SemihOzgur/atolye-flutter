enum ArchiveTaskStatus {
  queued,
  exporting,
  downloading,
  confirming,
  done,
  error,
}

class ArchiveTask {
  const ArchiveTask({
    required this.workOrderId,
    required this.orderNumber,
    required this.totalMediaCount,
    this.status = ArchiveTaskStatus.queued,
    this.currentFileName,
    this.verifiedCount = 0,
    this.failedCount = 0,
    this.resultSummary,
    this.errorMessage,
  });

  final int workOrderId;
  final String orderNumber;
  final int totalMediaCount;
  final ArchiveTaskStatus status;
  final String? currentFileName;
  final int verifiedCount;
  final int failedCount;
  final String? resultSummary;
  final String? errorMessage;

  ArchiveTask copyWith({
    ArchiveTaskStatus? status,
    String? currentFileName,
    int? verifiedCount,
    int? failedCount,
    String? resultSummary,
    String? errorMessage,
  }) {
    return ArchiveTask(
      workOrderId: workOrderId,
      orderNumber: orderNumber,
      totalMediaCount: totalMediaCount,
      status: status ?? this.status,
      currentFileName: currentFileName ?? this.currentFileName,
      verifiedCount: verifiedCount ?? this.verifiedCount,
      failedCount: failedCount ?? this.failedCount,
      resultSummary: resultSummary ?? this.resultSummary,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
