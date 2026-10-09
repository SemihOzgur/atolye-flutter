enum ScanResolveStatus { idle, resolving, rejected, notFound, failure, resolved }

class ScanResolveState {
  const ScanResolveState({
    this.status = ScanResolveStatus.idle,
    this.scannedValue,
    this.resolvedWorkOrderId,
    this.resolvedReceiptId,
    this.errorMessage,
  });

  final ScanResolveStatus status;
  final String? scannedValue;
  final int? resolvedWorkOrderId;

  /// `FS-` ile başlayan fiş barkodu çözüldüyse dolu (iş emri id'si boş kalır).
  final int? resolvedReceiptId;
  final String? errorMessage;
}
