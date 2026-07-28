enum ScanResolveStatus { idle, resolving, rejected, notFound, failure, resolved }

class ScanResolveState {
  const ScanResolveState({
    this.status = ScanResolveStatus.idle,
    this.scannedValue,
    this.resolvedWorkOrderId,
    this.errorMessage,
  });

  final ScanResolveStatus status;
  final String? scannedValue;
  final int? resolvedWorkOrderId;
  final String? errorMessage;
}
