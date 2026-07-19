import 'package:dio/dio.dart';

import '../../../core/constants/api_endpoints.dart';
import '../../../core/network/api_exception.dart';
import '../../../core/network/paged_response.dart';
import '../../customer/data/dto/work_order_list_item_dto.dart';
import 'dto/create_work_order_request_dto.dart';
import 'dto/deliver_work_order_request_dto.dart';
import 'dto/update_work_order_request_dto.dart';
import 'dto/update_work_order_status_request_dto.dart';
import 'dto/work_order_dto.dart';

abstract class IWorkOrderRepository {
  Future<PagedResponse<WorkOrderListItemDto>> search({
    String? status,
    String? search,
    int page = 1,
    int pageSize = 20,
  });

  Future<WorkOrderDto> create(CreateWorkOrderRequestDto request);

  Future<WorkOrderDto> fetchDetail(int id);

  Future<WorkOrderDto> update(int id, UpdateWorkOrderRequestDto request);

  Future<WorkOrderDto> updateStatus(
    int id,
    UpdateWorkOrderStatusRequestDto request,
  );

  Future<WorkOrderDto> deliver(int id, DeliverWorkOrderRequestDto request);

  Future<void> resendSms(int id);
}

class WorkOrderRepository implements IWorkOrderRepository {
  WorkOrderRepository(this._dio);

  final Dio _dio;

  @override
  Future<PagedResponse<WorkOrderListItemDto>> search({
    String? status,
    String? search,
    int page = 1,
    int pageSize = 20,
  }) async {
    try {
      final response = await _dio.get<Map<String, dynamic>>(
        ApiEndpoints.searchWorkOrders.path,
        queryParameters: <String, dynamic>{
          if (status != null && status.isNotEmpty) 'status': status,
          if (search != null && search.isNotEmpty) 'search': search,
          'page': page,
          'pageSize': pageSize,
        },
      );

      return PagedResponse.fromJson(
        response.data!,
        WorkOrderListItemDto.fromJson,
      );
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    }
  }

  @override
  Future<WorkOrderDto> create(CreateWorkOrderRequestDto request) async {
    try {
      final response = await _dio.post<Map<String, dynamic>>(
        ApiEndpoints.createWorkOrder.path,
        data: request.toJson(),
      );

      return WorkOrderDto.fromJson(response.data!);
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    }
  }

  @override
  Future<WorkOrderDto> fetchDetail(int id) async {
    try {
      final response = await _dio.get<Map<String, dynamic>>(
        ApiEndpoints.workOrderDetail(id).path,
      );

      return WorkOrderDto.fromJson(response.data!);
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    }
  }

  @override
  Future<WorkOrderDto> update(
    int id,
    UpdateWorkOrderRequestDto request,
  ) async {
    try {
      final response = await _dio.put<Map<String, dynamic>>(
        ApiEndpoints.updateWorkOrder(id).path,
        data: request.toJson(),
      );

      return WorkOrderDto.fromJson(response.data!);
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    }
  }

  @override
  Future<WorkOrderDto> updateStatus(
    int id,
    UpdateWorkOrderStatusRequestDto request,
  ) async {
    try {
      final response = await _dio.patch<Map<String, dynamic>>(
        ApiEndpoints.updateWorkOrderStatus(id).path,
        data: request.toJson(),
      );

      return WorkOrderDto.fromJson(response.data!);
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    }
  }

  @override
  Future<WorkOrderDto> deliver(
    int id,
    DeliverWorkOrderRequestDto request,
  ) async {
    try {
      final response = await _dio.post<Map<String, dynamic>>(
        ApiEndpoints.deliverWorkOrder(id).path,
        data: request.toJson(),
      );

      return WorkOrderDto.fromJson(response.data!);
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    }
  }

  @override
  Future<void> resendSms(int id) async {
    try {
      await _dio.post<void>(ApiEndpoints.resendSms(id).path);
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    }
  }
}
