import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/network/api_exception.dart';
import '../../../receipt/data/receipt_repository.dart';
import '../../../work_order/data/work_order_repository.dart';
import 'scan_resolve_state.dart';

/// Taranan barkod değerini iş emrine ya da fişe çözer. Barkod içeriği
/// sözleşmesi (F4): tek ürün fişinde `orderNumber` (`"WO-"`), çok kalemli
/// fişte `receiptNumber` (`"FS-"`) — takip QR'ı (URL) gibi alakasız
/// içerikler [ScanResolveStatus.rejected] ile elenir, hiç API çağrısı
/// yapılmaz.
class ScanResolveCubit extends Cubit<ScanResolveState> {
  ScanResolveCubit(this._repository, [this._receiptRepository])
      : super(const ScanResolveState());

  final IWorkOrderRepository _repository;
  final IReceiptRepository? _receiptRepository;

  static const String _orderNumberPrefix = 'WO-';
  static const String _receiptNumberPrefix = 'FS-';

  Future<void> resolve(String scannedValue) async {
    // Çözümleme sürerken gelen ek okumalar yok sayılır (çift okuma koruması).
    if (state.status == ScanResolveStatus.resolving) {
      return;
    }

    if (scannedValue.startsWith(_receiptNumberPrefix) &&
        _receiptRepository != null) {
      await _resolveReceipt(scannedValue, _receiptRepository);
      return;
    }

    if (!scannedValue.startsWith(_orderNumberPrefix)) {
      emit(
        ScanResolveState(
          status: ScanResolveStatus.rejected,
          scannedValue: scannedValue,
        ),
      );
      return;
    }

    emit(
      ScanResolveState(
        status: ScanResolveStatus.resolving,
        scannedValue: scannedValue,
      ),
    );

    try {
      final workOrder = await _repository.findByOrderNumber(scannedValue);
      if (workOrder == null) {
        emit(
          ScanResolveState(
            status: ScanResolveStatus.notFound,
            scannedValue: scannedValue,
          ),
        );
        return;
      }

      emit(
        ScanResolveState(
          status: ScanResolveStatus.resolved,
          scannedValue: scannedValue,
          resolvedWorkOrderId: workOrder.id,
        ),
      );
    } on ApiException catch (e) {
      emit(
        ScanResolveState(
          status: ScanResolveStatus.failure,
          scannedValue: scannedValue,
          errorMessage: e.detail ?? e.message,
        ),
      );
    }
  }

  Future<void> _resolveReceipt(
    String scannedValue,
    IReceiptRepository repository,
  ) async {
    emit(
      ScanResolveState(
        status: ScanResolveStatus.resolving,
        scannedValue: scannedValue,
      ),
    );
    try {
      final receipt = await repository.findByNumber(scannedValue);
      emit(
        ScanResolveState(
          status: receipt == null
              ? ScanResolveStatus.notFound
              : ScanResolveStatus.resolved,
          scannedValue: scannedValue,
          resolvedReceiptId: receipt?.id,
        ),
      );
    } on ApiException catch (e) {
      emit(
        ScanResolveState(
          status: ScanResolveStatus.failure,
          scannedValue: scannedValue,
          errorMessage: e.detail ?? e.message,
        ),
      );
    }
  }

  /// Yeniden tarama / tekrar dene aksiyonları öncesi çağrılır.
  void reset() => emit(const ScanResolveState());
}
