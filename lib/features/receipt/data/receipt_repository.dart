import 'package:dio/dio.dart';

import '../../../core/constants/api_endpoints.dart';
import '../../../core/network/api_exception.dart';
import 'dto/create_receipt_request_dto.dart';
import 'dto/receipt_dto.dart';

abstract class IReceiptRepository {
  Future<ReceiptDto> create(CreateReceiptRequestDto request);

  Future<ReceiptDto> fetchDetail(int id);

  /// Barkod çözümleme: tam eşleşme; bulunamazsa null.
  Future<ReceiptDto?> findByNumber(String receiptNumber);

  /// Seçili kalemlerde toplu durum değişikliği (hepsi ya da hiçbiri).
  Future<ReceiptDto> updateStatus(
    int id, {
    required List<int> workOrderIds,
    required String newStatus,
    String? note,
  });

  /// Kısmi teslim: tahsilat fiş üzerinden tek tutar.
  Future<ReceiptDto> deliver(
    int id, {
    required List<int> workOrderIds,
    required double collectedAmount,
  });
}

class ReceiptRepository implements IReceiptRepository {
  ReceiptRepository(this._dio);

  final Dio _dio;

  @override
  Future<ReceiptDto> create(CreateReceiptRequestDto request) =>
      _send(() => _dio.post<Map<String, dynamic>>(
            ApiEndpoints.createReceipt.path,
            data: request.toJson(),
          ));

  @override
  Future<ReceiptDto> fetchDetail(int id) => _send(
        () => _dio.get<Map<String, dynamic>>(ApiEndpoints.receiptDetail(id).path),
      );

  @override
  Future<ReceiptDto?> findByNumber(String receiptNumber) async {
    try {
      return await _send(() => _dio.get<Map<String, dynamic>>(
            ApiEndpoints.receiptByNumber(receiptNumber.trim().toUpperCase()).path,
          ));
    } on ApiException catch (e) {
      if (e.statusCode == 404) return null;
      rethrow;
    }
  }

  @override
  Future<ReceiptDto> updateStatus(
    int id, {
    required List<int> workOrderIds,
    required String newStatus,
    String? note,
  }) =>
      _send(() => _dio.post<Map<String, dynamic>>(
            ApiEndpoints.receiptStatus(id).path,
            data: <String, dynamic>{
              'workOrderIds': workOrderIds,
              'newStatus': newStatus,
              'note': note,
            },
          ));

  @override
  Future<ReceiptDto> deliver(
    int id, {
    required List<int> workOrderIds,
    required double collectedAmount,
  }) =>
      _send(() => _dio.post<Map<String, dynamic>>(
            ApiEndpoints.receiptDeliver(id).path,
            data: <String, dynamic>{
              'workOrderIds': workOrderIds,
              'collectedAmount': collectedAmount,
            },
          ));

  Future<ReceiptDto> _send(
    Future<Response<Map<String, dynamic>>> Function() call,
  ) async {
    try {
      final response = await call();
      return ReceiptDto.fromJson(response.data!);
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    }
  }
}
