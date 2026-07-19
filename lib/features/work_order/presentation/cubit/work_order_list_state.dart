import '../../../customer/data/dto/work_order_list_item_dto.dart';

enum WorkOrderListStatus { idle, loading, loaded, error }

class WorkOrderListState {
  const WorkOrderListState({
    this.status = WorkOrderListStatus.idle,
    this.statusFilter,
    this.query = '',
    this.page = 1,
    this.pageSize = 20,
    this.items = const <WorkOrderListItemDto>[],
    this.totalCount = 0,
    this.errorMessage,
  });

  final WorkOrderListStatus status;
  final String? statusFilter;
  final String query;
  final int page;
  final int pageSize;
  final List<WorkOrderListItemDto> items;
  final int totalCount;
  final String? errorMessage;

  bool get hasNextPage => page * pageSize < totalCount;

  bool get hasPreviousPage => page > 1;
}
