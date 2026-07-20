import 'package:leather_care_admin/core/network/api_exception.dart';
import 'package:leather_care_admin/core/network/paged_response.dart';
import 'package:leather_care_admin/features/customer/data/customer_repository.dart';
import 'package:leather_care_admin/features/customer/data/dto/create_customer_request_dto.dart';
import 'package:leather_care_admin/features/customer/data/dto/customer_detail_dto.dart';
import 'package:leather_care_admin/features/customer/data/dto/customer_dto.dart';
import 'package:leather_care_admin/features/customer/data/dto/iys_confirm_response_dto.dart';
import 'package:leather_care_admin/features/customer/data/dto/iys_resend_code_response_dto.dart';
import 'package:leather_care_admin/features/customer/data/dto/update_customer_request_dto.dart';

class FakeCustomerRepository implements ICustomerRepository {
  PagedResponse<CustomerDto> pageToReturn = const PagedResponse(
    items: <CustomerDto>[],
    page: 1,
    pageSize: 20,
    totalCount: 0,
  );
  CustomerCreateResult? createResultToReturn;
  CustomerDetailDto? detailToReturn;
  CustomerDto? updateResultToReturn;
  IysResendCodeResponseDto? resendResultToReturn;
  IysConfirmResponseDto? confirmResultToReturn;
  ApiException? exceptionToThrow;

  int? lastPageRequested;
  String? lastSearchRequested;
  int? lastConfirmCustomerId;
  String? lastConfirmCode;
  int? lastResendCustomerId;

  @override
  Future<PagedResponse<CustomerDto>> search({
    String? search,
    int page = 1,
    int pageSize = 20,
  }) async {
    lastPageRequested = page;
    lastSearchRequested = search;
    if (exceptionToThrow != null) {
      throw exceptionToThrow!;
    }
    return pageToReturn;
  }

  @override
  Future<CustomerCreateResult> create(CreateCustomerRequestDto request) async {
    if (exceptionToThrow != null) {
      throw exceptionToThrow!;
    }
    return createResultToReturn!;
  }

  @override
  Future<CustomerDetailDto> fetchDetail(int id) async {
    if (exceptionToThrow != null) {
      throw exceptionToThrow!;
    }
    return detailToReturn!;
  }

  @override
  Future<CustomerDto> update(int id, UpdateCustomerRequestDto request) async {
    if (exceptionToThrow != null) {
      throw exceptionToThrow!;
    }
    return updateResultToReturn!;
  }

  @override
  Future<IysResendCodeResponseDto> resendIysCode(int id) async {
    lastResendCustomerId = id;
    if (exceptionToThrow != null) {
      throw exceptionToThrow!;
    }
    return resendResultToReturn!;
  }

  @override
  Future<IysConfirmResponseDto> confirmIysCode(int id, String code) async {
    lastConfirmCustomerId = id;
    lastConfirmCode = code;
    if (exceptionToThrow != null) {
      throw exceptionToThrow!;
    }
    return confirmResultToReturn!;
  }
}
