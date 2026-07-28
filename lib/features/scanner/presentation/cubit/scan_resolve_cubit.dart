import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/network/api_exception.dart';
import '../../../work_order/data/work_order_repository.dart';
import 'scan_resolve_state.dart';

/// Taranan barkod değerini iş emrine çözer. Barkod içeriği sözleşmesi
/// (F4): `orderNumber`, `"WO-"` ön ekiyle başlar — takip QR'ı (URL) gibi
/// alakasız içerikler [ScanResolveStatus.rejected] ile elenir, hiç API
/// çağrısı yapılmaz.
class ScanResolveCubit extends Cubit<ScanResolveState> {
  ScanResolveCubit(this._repository) : super(const ScanResolveState());

  final IWorkOrderRepository _repository;

  static const String _orderNumberPrefix = 'WO-';

  Future<void> resolve(String scannedValue) async {
    // Çözümleme sürerken gelen ek okumalar yok sayılır (çift okuma koruması).
    if (state.status == ScanResolveStatus.resolving) {
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

  /// Yeniden tarama / tekrar dene aksiyonları öncesi çağrılır.
  void reset() => emit(const ScanResolveState());
}
