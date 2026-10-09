import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/network/api_exception.dart';
import '../../../work_order/domain/status_transitions.dart';
import '../../data/dto/receipt_dto.dart';
import '../../data/receipt_repository.dart';

class ReceiptDetailState {
  const ReceiptDetailState({
    this.receipt,
    this.selectedIds = const <int>{},
    this.isLoading = false,
    this.isBusy = false,
    this.errorMessage,
    this.actionError,
  });

  final ReceiptDto? receipt;
  final Set<int> selectedIds;
  final bool isLoading;

  /// Toplu işlem sürüyor — butonlar kilitlenir.
  final bool isBusy;
  final String? errorMessage;
  final String? actionError;

  List<ReceiptItemDto> get selectedItems => (receipt?.items ?? const [])
      .where((item) => selectedIds.contains(item.id))
      .toList();

  /// Seçili TÜM kalemlerin geçebildiği hedefler (backend aynı kuralla toplu
  /// isteği ya hep ya hiç uygular — bkz. `allowedTransitions`).
  Set<String> get commonTargets {
    final items = selectedItems;
    if (items.isEmpty) return const {};
    var common = allowedTransitions(items.first.status)
        .map((t) => t.target)
        .toSet();
    for (final item in items.skip(1)) {
      common = common.intersection(
        allowedTransitions(item.status).map((t) => t.target).toSet(),
      );
    }
    return common;
  }

  bool get canDeliver =>
      selectedItems.isNotEmpty &&
      selectedItems.every((item) => item.status == 'READY');

  ReceiptDetailState copyWith({
    ReceiptDto? receipt,
    Set<int>? selectedIds,
    bool? isLoading,
    bool? isBusy,
    String? errorMessage,
    String? actionError,
  }) {
    return ReceiptDetailState(
      receipt: receipt ?? this.receipt,
      selectedIds: selectedIds ?? this.selectedIds,
      isLoading: isLoading ?? this.isLoading,
      isBusy: isBusy ?? this.isBusy,
      errorMessage: errorMessage,
      actionError: actionError,
    );
  }
}

class ReceiptDetailCubit extends Cubit<ReceiptDetailState> {
  ReceiptDetailCubit(this._repository, this.receiptId)
      : super(const ReceiptDetailState());

  final IReceiptRepository _repository;
  final int receiptId;

  Future<void> load() async {
    emit(state.copyWith(isLoading: true));
    try {
      final receipt = await _repository.fetchDetail(receiptId);
      if (isClosed) return;
      emit(_withReceipt(receipt).copyWith(isLoading: false));
    } on ApiException catch (e) {
      if (isClosed) return;
      emit(state.copyWith(isLoading: false, errorMessage: e.detail ?? e.message));
    }
  }

  void toggle(int workOrderId) {
    final ids = Set<int>.of(state.selectedIds);
    if (!ids.remove(workOrderId)) ids.add(workOrderId);
    emit(state.copyWith(selectedIds: ids));
  }

  /// Açık (teslim/iptal olmamış) kalemlerin hepsini seçer ya da seçimi temizler.
  void toggleAll() {
    final open = (state.receipt?.items ?? const <ReceiptItemDto>[])
        .where((item) => allowedTransitions(item.status).isNotEmpty)
        .map((item) => item.id)
        .toSet();
    final allSelected = open.isNotEmpty && state.selectedIds.containsAll(open);
    emit(state.copyWith(selectedIds: allSelected ? <int>{} : open));
  }

  Future<bool> changeStatus(String newStatus, {String? note}) => _run(
        () => _repository.updateStatus(
          receiptId,
          workOrderIds: state.selectedIds.toList(),
          newStatus: newStatus,
          note: note,
        ),
      );

  Future<bool> deliver(double collectedAmount) => _run(
        () => _repository.deliver(
          receiptId,
          workOrderIds: state.selectedIds.toList(),
          collectedAmount: collectedAmount,
        ),
      );

  Future<bool> _run(Future<ReceiptDto> Function() action) async {
    emit(state.copyWith(isBusy: true));
    try {
      final receipt = await action();
      if (isClosed) return true;
      emit(_withReceipt(receipt).copyWith(isBusy: false, selectedIds: <int>{}));
      return true;
    } on ApiException catch (e) {
      if (isClosed) return false;
      emit(state.copyWith(isBusy: false, actionError: e.detail ?? e.message));
      return false;
    }
  }

  /// Artık geçersiz (kapanmış) seçimleri düşürür.
  ReceiptDetailState _withReceipt(ReceiptDto receipt) {
    final openIds = receipt.items
        .where((item) => allowedTransitions(item.status).isNotEmpty)
        .map((item) => item.id)
        .toSet();
    return state.copyWith(
      receipt: receipt,
      selectedIds: state.selectedIds.intersection(openIds),
    );
  }
}
