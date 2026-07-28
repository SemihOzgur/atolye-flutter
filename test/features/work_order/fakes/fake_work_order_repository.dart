import 'package:leather_care_admin/core/network/api_exception.dart';
import 'package:leather_care_admin/core/network/paged_response.dart';
import 'package:leather_care_admin/features/customer/data/dto/work_order_list_item_dto.dart';
import 'package:leather_care_admin/features/work_order/data/dto/create_work_order_request_dto.dart';
import 'package:leather_care_admin/features/work_order/data/dto/deliver_work_order_request_dto.dart';
import 'package:leather_care_admin/features/work_order/data/dto/update_work_order_request_dto.dart';
import 'package:leather_care_admin/features/work_order/data/dto/update_work_order_status_request_dto.dart';
import 'package:leather_care_admin/features/work_order/data/dto/work_order_dto.dart';
import 'package:leather_care_admin/features/work_order/data/work_order_repository.dart';

class FakeWorkOrderRepository implements IWorkOrderRepository {
  PagedResponse<WorkOrderListItemDto>? pageToReturn;
  WorkOrderDto? workOrderToReturn;
  ApiException? exceptionToThrow;

  int? lastResendId;
  UpdateWorkOrderStatusRequestDto? lastStatusRequest;
  DeliverWorkOrderRequestDto? lastDeliverRequest;
  String? lastSearchStatus;

  @override
  Future<PagedResponse<WorkOrderListItemDto>> search({
    String? status,
    String? search,
    int page = 1,
    int pageSize = 20,
  }) async {
    lastSearchStatus = status;
    if (exceptionToThrow != null) throw exceptionToThrow!;
    return pageToReturn!;
  }

  @override
  Future<WorkOrderDto> create(CreateWorkOrderRequestDto request) async {
    if (exceptionToThrow != null) throw exceptionToThrow!;
    return workOrderToReturn!;
  }

  @override
  Future<WorkOrderDto> fetchDetail(int id) async {
    if (exceptionToThrow != null) throw exceptionToThrow!;
    return workOrderToReturn!;
  }

  @override
  Future<WorkOrderDto> update(
    int id,
    UpdateWorkOrderRequestDto request,
  ) async {
    if (exceptionToThrow != null) throw exceptionToThrow!;
    return workOrderToReturn!;
  }

  @override
  Future<WorkOrderDto> updateStatus(
    int id,
    UpdateWorkOrderStatusRequestDto request,
  ) async {
    lastStatusRequest = request;
    if (exceptionToThrow != null) throw exceptionToThrow!;
    return workOrderToReturn!;
  }

  @override
  Future<WorkOrderDto> deliver(
    int id,
    DeliverWorkOrderRequestDto request,
  ) async {
    lastDeliverRequest = request;
    if (exceptionToThrow != null) throw exceptionToThrow!;
    return workOrderToReturn!;
  }

  @override
  Future<void> resendSms(int id) async {
    lastResendId = id;
    if (exceptionToThrow != null) throw exceptionToThrow!;
  }

  String? lastFindByOrderNumberQuery;

  @override
  Future<WorkOrderDto?> findByOrderNumber(String orderNumber) async {
    lastFindByOrderNumberQuery = orderNumber;
    if (exceptionToThrow != null) throw exceptionToThrow!;
    return workOrderToReturn;
  }
}
