import '../../data/dto/work_order_dto.dart';

enum WorkOrderDetailStatus { loading, loaded, error }

class WorkOrderDetailState {
  const WorkOrderDetailState({
    this.status = WorkOrderDetailStatus.loading,
    this.workOrder,
    this.errorMessage,
    this.isMutating = false,
  });

  final WorkOrderDetailStatus status;
  final WorkOrderDto? workOrder;
  final String? errorMessage;
  final bool isMutating;
}
