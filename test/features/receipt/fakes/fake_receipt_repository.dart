import 'package:leather_care_admin/core/network/api_exception.dart';
import 'package:leather_care_admin/features/receipt/data/dto/create_receipt_request_dto.dart';
import 'package:leather_care_admin/features/receipt/data/dto/receipt_dto.dart';
import 'package:leather_care_admin/features/receipt/data/receipt_repository.dart';

class FakeReceiptRepository implements IReceiptRepository {
  ReceiptDto? receiptToReturn;
  ApiException? exceptionToThrow;

  CreateReceiptRequestDto? lastCreateRequest;
  String? lastFindQuery;
  List<int>? lastWorkOrderIds;
  String? lastNewStatus;
  double? lastCollectedAmount;

  ReceiptDto _result() {
    if (exceptionToThrow != null) throw exceptionToThrow!;
    return receiptToReturn!;
  }

  @override
  Future<ReceiptDto> create(CreateReceiptRequestDto request) async {
    lastCreateRequest = request;
    return _result();
  }

  @override
  Future<ReceiptDto> fetchDetail(int id) async => _result();

  @override
  Future<ReceiptDto?> findByNumber(String receiptNumber) async {
    lastFindQuery = receiptNumber;
    if (exceptionToThrow != null) throw exceptionToThrow!;
    return receiptToReturn;
  }

  @override
  Future<ReceiptDto> updateStatus(
    int id, {
    required List<int> workOrderIds,
    required String newStatus,
    String? note,
  }) async {
    lastWorkOrderIds = workOrderIds;
    lastNewStatus = newStatus;
    return _result();
  }

  @override
  Future<ReceiptDto> deliver(
    int id, {
    required List<int> workOrderIds,
    required double collectedAmount,
  }) async {
    lastWorkOrderIds = workOrderIds;
    lastCollectedAmount = collectedAmount;
    return _result();
  }
}
