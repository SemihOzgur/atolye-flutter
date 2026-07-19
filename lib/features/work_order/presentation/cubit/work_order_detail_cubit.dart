import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/network/api_exception.dart';
import '../../data/dto/deliver_work_order_request_dto.dart';
import '../../data/dto/update_work_order_status_request_dto.dart';
import '../../data/work_order_repository.dart';
import 'work_order_detail_state.dart';

class WorkOrderDetailCubit extends Cubit<WorkOrderDetailState> {
  WorkOrderDetailCubit(this._repository, this.workOrderId)
      : super(const WorkOrderDetailState());

  final IWorkOrderRepository _repository;
  final int workOrderId;

  Future<void> load() async {
    emit(const WorkOrderDetailState());

    try {
      final workOrder = await _repository.fetchDetail(workOrderId);
      emit(
        WorkOrderDetailState(
          status: WorkOrderDetailStatus.loaded,
          workOrder: workOrder,
        ),
      );
    } on ApiException catch (e) {
      emit(
        WorkOrderDetailState(
          status: WorkOrderDetailStatus.error,
          errorMessage: e.detail ?? e.message,
        ),
      );
    }
  }

  Future<String?> updateStatus(String newStatus, {String? note}) async {
    emit(
      WorkOrderDetailState(
        status: state.status,
        workOrder: state.workOrder,
        isMutating: true,
      ),
    );

    try {
      final workOrder = await _repository.updateStatus(
        workOrderId,
        UpdateWorkOrderStatusRequestDto(newStatus: newStatus, note: note),
      );
      emit(
        WorkOrderDetailState(
          status: WorkOrderDetailStatus.loaded,
          workOrder: workOrder,
        ),
      );
      return null;
    } on ApiException catch (e) {
      final message = e.detail ?? e.message;
      emit(
        WorkOrderDetailState(
          status: WorkOrderDetailStatus.loaded,
          workOrder: state.workOrder,
        ),
      );
      if (e.statusCode == 409) {
        await load();
      }
      return message;
    }
  }

  Future<String?> deliver(double finalPaymentAmount) async {
    emit(
      WorkOrderDetailState(
        status: state.status,
        workOrder: state.workOrder,
        isMutating: true,
      ),
    );

    try {
      final workOrder = await _repository.deliver(
        workOrderId,
        DeliverWorkOrderRequestDto(finalPaymentAmount: finalPaymentAmount),
      );
      emit(
        WorkOrderDetailState(
          status: WorkOrderDetailStatus.loaded,
          workOrder: workOrder,
        ),
      );
      return null;
    } on ApiException catch (e) {
      final message = e.detail ?? e.message;
      emit(
        WorkOrderDetailState(
          status: WorkOrderDetailStatus.loaded,
          workOrder: state.workOrder,
        ),
      );
      if (e.statusCode == 409) {
        await load();
      }
      return message;
    }
  }

  Future<String?> resendSms() async {
    emit(
      WorkOrderDetailState(
        status: state.status,
        workOrder: state.workOrder,
        isMutating: true,
      ),
    );

    try {
      await _repository.resendSms(workOrderId);
      await load();
      return null;
    } on ApiException catch (e) {
      emit(
        WorkOrderDetailState(
          status: WorkOrderDetailStatus.loaded,
          workOrder: state.workOrder,
        ),
      );
      return e.detail ?? e.message;
    }
  }
}
