import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/network/api_exception.dart';
import '../../data/work_order_repository.dart';
import 'work_order_list_state.dart';

const _unsetStatus = Object();

class WorkOrderListCubit extends Cubit<WorkOrderListState> {
  WorkOrderListCubit(this._repository) : super(const WorkOrderListState());

  final IWorkOrderRepository _repository;

  /// `status` verilmezse mevcut filtre korunur; `status: null` verilirse
  /// (ör. "Tümü" seçimi) filtre açıkça temizlenir. `??` ile bu iki durum
  /// ayırt edilemediği için sentinel kullanılır — aksi halde "Tümü"ye
  /// dönüş, önceki filtreyi geri getirip görmezden gelinirdi.
  Future<void> search({Object? status = _unsetStatus, String? query}) async {
    await _load(
      status: identical(status, _unsetStatus)
          ? state.statusFilter
          : status as String?,
      query: query ?? state.query,
      page: 1,
    );
  }

  Future<void> goToPage(int page) async {
    await _load(status: state.statusFilter, query: state.query, page: page);
  }

  Future<void> _load({
    required String? status,
    required String query,
    required int page,
  }) async {
    emit(
      WorkOrderListState(
        status: WorkOrderListStatus.loading,
        statusFilter: status,
        query: query,
        page: page,
        pageSize: state.pageSize,
        items: state.items,
        totalCount: state.totalCount,
      ),
    );

    try {
      final result = await _repository.search(
        status: status,
        search: query.isEmpty ? null : query,
        page: page,
        pageSize: state.pageSize,
      );

      emit(
        WorkOrderListState(
          status: WorkOrderListStatus.loaded,
          statusFilter: status,
          query: query,
          page: result.page,
          pageSize: result.pageSize,
          items: result.items,
          totalCount: result.totalCount,
        ),
      );
    } on ApiException catch (e) {
      emit(
        WorkOrderListState(
          status: WorkOrderListStatus.error,
          statusFilter: status,
          query: query,
          page: page,
          pageSize: state.pageSize,
          errorMessage: e.detail ?? e.message,
        ),
      );
    }
  }
}
