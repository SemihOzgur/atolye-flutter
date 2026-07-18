import 'package:dio/dio.dart';

import '../../../core/constants/api_endpoints.dart';
import '../../../core/network/api_error_codes.dart';
import '../../../core/network/api_exception.dart';
import '../../../core/network/paged_response.dart';
import 'dto/create_customer_request_dto.dart';
import 'dto/create_customer_response_dto.dart';
import 'dto/customer_detail_dto.dart';
import 'dto/customer_dto.dart';
import 'dto/iys_confirm_response_dto.dart';
import 'dto/iys_resend_code_response_dto.dart';
import 'dto/update_customer_request_dto.dart';

class CustomerCreateResult {
  const CustomerCreateResult.created(CreateCustomerResponseDto response)
      : _response = response,
        _duplicateCustomer = null;

  const CustomerCreateResult.duplicate(CustomerDto existingCustomer)
      : _response = null,
        _duplicateCustomer = existingCustomer;

  final CreateCustomerResponseDto? _response;
  final CustomerDto? _duplicateCustomer;

  bool get isDuplicate => _duplicateCustomer != null;

  CreateCustomerResponseDto get response => _response!;

  CustomerDto get duplicateCustomer => _duplicateCustomer!;
}

abstract class ICustomerRepository {
  Future<PagedResponse<CustomerDto>> search({
    String? search,
    int page = 1,
    int pageSize = 20,
  });

  Future<CustomerCreateResult> create(CreateCustomerRequestDto request);

  Future<CustomerDetailDto> fetchDetail(int id);

  Future<CustomerDto> update(int id, UpdateCustomerRequestDto request);

  Future<IysResendCodeResponseDto> resendIysCode(int id);

  Future<IysConfirmResponseDto> confirmIysCode(int id, String code);
}

class CustomerRepository implements ICustomerRepository {
  CustomerRepository(this._dio);

  final Dio _dio;

  @override
  Future<PagedResponse<CustomerDto>> search({
    String? search,
    int page = 1,
    int pageSize = 20,
  }) async {
    try {
      final response = await _dio.get<Map<String, dynamic>>(
        ApiEndpoints.searchCustomers.path,
        queryParameters: <String, dynamic>{
          if (search != null && search.isNotEmpty) 'search': search,
          'page': page,
          'pageSize': pageSize,
        },
      );

      return PagedResponse.fromJson(response.data!, CustomerDto.fromJson);
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    }
  }

  @override
  Future<CustomerCreateResult> create(CreateCustomerRequestDto request) async {
    try {
      final response = await _dio.post<Map<String, dynamic>>(
        ApiEndpoints.createCustomer.path,
        data: request.toJson(),
      );

      return CustomerCreateResult.created(
        CreateCustomerResponseDto.fromJson(response.data!),
      );
    } on DioException catch (e) {
      final exception = ApiException.fromDioException(e);

      if (exception.errorCode == ApiErrorCodes.duplicatePhone) {
        final existingCustomerJson =
            exception.rawBody?['customer'] as Map<String, dynamic>?;

        if (existingCustomerJson != null) {
          return CustomerCreateResult.duplicate(
            CustomerDto.fromJson(existingCustomerJson),
          );
        }
      }

      throw exception;
    }
  }

  @override
  Future<CustomerDetailDto> fetchDetail(int id) async {
    try {
      final response = await _dio.get<Map<String, dynamic>>(
        ApiEndpoints.customerDetail(id).path,
      );

      return CustomerDetailDto.fromJson(response.data!);
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    }
  }

  @override
  Future<CustomerDto> update(int id, UpdateCustomerRequestDto request) async {
    try {
      final response = await _dio.put<Map<String, dynamic>>(
        ApiEndpoints.updateCustomer(id).path,
        data: request.toJson(),
      );

      return CustomerDto.fromJson(response.data!);
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    }
  }

  @override
  Future<IysResendCodeResponseDto> resendIysCode(int id) async {
    try {
      final response = await _dio.post<Map<String, dynamic>>(
        ApiEndpoints.resendIysCode(id).path,
      );

      return IysResendCodeResponseDto.fromJson(response.data!);
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    }
  }

  @override
  Future<IysConfirmResponseDto> confirmIysCode(int id, String code) async {
    try {
      final response = await _dio.post<Map<String, dynamic>>(
        ApiEndpoints.confirmIysCode(id).path,
        data: <String, dynamic>{'code': code},
      );

      return IysConfirmResponseDto.fromJson(response.data!);
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    }
  }
}
