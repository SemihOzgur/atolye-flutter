import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:leather_care_admin/core/network/api_exception.dart';
import 'package:leather_care_admin/features/work_order/data/dto/create_work_order_request_dto.dart';
import 'package:leather_care_admin/features/work_order/data/dto/deliver_work_order_request_dto.dart';
import 'package:leather_care_admin/features/work_order/data/dto/update_work_order_request_dto.dart';
import 'package:leather_care_admin/features/work_order/data/dto/update_work_order_status_request_dto.dart';
import 'package:leather_care_admin/features/work_order/data/work_order_repository.dart';

Map<String, dynamic> _sampleWorkOrderJson({String status = 'RECEIVED'}) {
  return {
    'id': 1,
    'orderNumber': 'WO-2026-000001',
    'customer': {
      'id': 1,
      'firstName': 'Ayşe',
      'lastName': 'Yılmaz',
      'phone': '+905321234567',
      'email': null,
      'address': null,
      'iysConsentStatus': 'APPROVED',
      'iysConsentAt': null,
      'createdAt': '2026-01-01T10:00:00Z',
    },
    'categoryId': 3,
    'categoryPath': 'Kadın > Ayakkabı > Sneakers',
    'brand': 'Nike',
    'color': null,
    'material': null,
    'description': null,
    'existingDamages': null,
    'estimatedDeliveryDate': null,
    'services': [
      {
        'servicePriceId': 1,
        'serviceName': 'Bakım ve Boya',
        'priceSnapshot': 1250.0
      },
    ],
    'consumables': [
      {
        'consumableProductId': 1,
        'productName': 'Deri Bakım Kremi',
        'quantity': 2,
        'unitPriceSnapshot': 150.0,
        'lineTotal': 300.0,
      },
    ],
    'suggestedPrice': 1550.0,
    'price': 1550.0,
    'hasPrepayment': false,
    'prepaymentAmount': null,
    'remainingAmount': 1550.0,
    'status': status,
    'socialMediaConsent': false,
    'trackingUrl': 'https://dotikadbm.com/t/abc123',
    'deliveredAt': null,
    'finalPaymentAmount': null,
    'media': const <dynamic>[],
    'statusHistory': [
      {
        'oldStatus': null,
        'newStatus': 'RECEIVED',
        'changedBy': 'admin@firma.com',
        'changedAt': '2026-01-01T10:00:00Z',
      },
    ],
    'createdAt': '2026-01-01T10:00:00Z',
    'updatedAt': '2026-01-01T10:00:00Z',
    'smsHistory': const <dynamic>[],
  };
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late Dio dio;
  late WorkOrderRepository repository;

  setUp(() {
    dio = Dio(BaseOptions(baseUrl: 'https://dotikadbm.com'));
    repository = WorkOrderRepository(dio);
  });

  test('search parses paged list', () async {
    dio.httpClientAdapter = _FakeAdapter(
      statusCode: 200,
      body: {
        'items': [
          {
            'id': 1,
            'orderNumber': 'WO-2026-000001',
            'customerFullName': 'Ayşe Yılmaz',
            'customerPhone': '+905321234567',
            'categoryPath': 'Kadın > Ayakkabı > Sneakers',
            'brand': 'Nike',
            'status': 'RECEIVED',
            'price': 1550.0,
            'remainingAmount': 1550.0,
            'estimatedDeliveryDate': null,
            'createdAt': '2026-01-01T10:00:00Z',
          },
        ],
        'page': 1,
        'pageSize': 20,
        'totalCount': 1,
      },
    );

    final result = await repository.search(status: 'RECEIVED');

    expect(result.items, hasLength(1));
    expect(result.items.first.orderNumber, 'WO-2026-000001');
  });

  test('create posts request and parses full WorkOrderDto', () async {
    dio.httpClientAdapter = _FakeAdapter(
      statusCode: 201,
      body: _sampleWorkOrderJson(),
    );

    final workOrder = await repository.create(
      const CreateWorkOrderRequestDto(
        customerId: 1,
        categoryId: 3,
        servicePriceIds: [1],
        price: 1550,
        hasPrepayment: false,
      ),
    );

    expect(workOrder.orderNumber, 'WO-2026-000001');
    expect(workOrder.services.single.serviceName, 'Bakım ve Boya');
    expect(workOrder.consumables.single.lineTotal, 300.0);
    expect(workOrder.customer.firstName, 'Ayşe');
  });

  test('create throws ApiException on 400 INVALID_CATEGORY_LEVEL', () async {
    dio.httpClientAdapter = _FakeAdapter(
      statusCode: 400,
      body: {
        'title': 'Bad Request',
        'detail': 'Kategori seviyesi geçersiz.',
        'errorCode': 'INVALID_CATEGORY_LEVEL',
      },
    );

    await expectLater(
      () => repository.create(
        const CreateWorkOrderRequestDto(
          customerId: 1,
          categoryId: 1,
          price: 0,
          hasPrepayment: false,
        ),
      ),
      throwsA(
        isA<ApiException>()
            .having((e) => e.errorCode, 'errorCode', 'INVALID_CATEGORY_LEVEL'),
      ),
    );
  });

  test('fetchDetail parses full detail', () async {
    dio.httpClientAdapter = _FakeAdapter(
      statusCode: 200,
      body: _sampleWorkOrderJson(status: 'READY'),
    );

    final workOrder = await repository.fetchDetail(1);

    expect(workOrder.status, 'READY');
    expect(workOrder.statusHistory.single.newStatus, 'RECEIVED');
  });

  test('update sends updatedAt concurrency token', () async {
    dio.httpClientAdapter = _FakeAdapter(
      statusCode: 200,
      body: _sampleWorkOrderJson(),
    );

    final workOrder = await repository.update(
      1,
      UpdateWorkOrderRequestDto(
        price: 1600,
        hasPrepayment: false,
        updatedAt: DateTime.parse('2026-01-01T10:00:00Z'),
      ),
    );

    expect(workOrder.id, 1);
  });

  test('update throws ApiException with 409 on stale concurrency token',
      () async {
    dio.httpClientAdapter = _FakeAdapter(
      statusCode: 409,
      body: {
        'title': 'Conflict',
        'detail': 'Kayıt başka yerden güncellendi.',
      },
    );

    await expectLater(
      () => repository.update(
        1,
        UpdateWorkOrderRequestDto(
          price: 1600,
          hasPrepayment: false,
          updatedAt: DateTime.parse('2026-01-01T10:00:00Z'),
        ),
      ),
      throwsA(
          isA<ApiException>().having((e) => e.statusCode, 'statusCode', 409)),
    );
  });

  test('updateStatus sends PATCH and parses response', () async {
    dio.httpClientAdapter = _FakeAdapter(
      statusCode: 200,
      body: _sampleWorkOrderJson(status: 'IN_PROGRESS'),
    );

    final workOrder = await repository.updateStatus(
      1,
      const UpdateWorkOrderStatusRequestDto(newStatus: 'IN_PROGRESS'),
    );

    expect(workOrder.status, 'IN_PROGRESS');
  });

  test('updateStatus throws ApiException with INVALID_STATUS_TRANSITION',
      () async {
    dio.httpClientAdapter = _FakeAdapter(
      statusCode: 409,
      body: {
        'title': 'Conflict',
        'detail': 'Geçersiz durum geçişi.',
        'errorCode': 'INVALID_STATUS_TRANSITION',
      },
    );

    await expectLater(
      () => repository.updateStatus(
        1,
        const UpdateWorkOrderStatusRequestDto(newStatus: 'DELIVERED'),
      ),
      throwsA(
        isA<ApiException>().having(
          (e) => e.errorCode,
          'errorCode',
          'INVALID_STATUS_TRANSITION',
        ),
      ),
    );
  });

  test('deliver posts final payment and parses DELIVERED response', () async {
    dio.httpClientAdapter = _FakeAdapter(
      statusCode: 200,
      body: _sampleWorkOrderJson(status: 'DELIVERED'),
    );

    final workOrder = await repository.deliver(
      1,
      const DeliverWorkOrderRequestDto(finalPaymentAmount: 1550),
    );

    expect(workOrder.status, 'DELIVERED');
  });

  test('resendSms posts with no body', () async {
    dio.httpClientAdapter = _FakeAdapter(statusCode: 200, body: null);

    await repository.resendSms(1);
  });

  test('resendSms throws ApiException on NETGSM duplicate block', () async {
    dio.httpClientAdapter = _FakeAdapter(
      statusCode: 400,
      body: {
        'title': 'Bad Request',
        'detail':
            'Aynı mesaj 1 saat içinde tekrar gönderilemez, NETGSM engelledi.',
      },
    );

    await expectLater(
      () => repository.resendSms(1),
      throwsA(isA<ApiException>()),
    );
  });

  group('findByOrderNumber (F5 barkod çözümleme)', () {
    Map<String, dynamic> listItemJson({
      required int id,
      required String orderNumber,
    }) {
      return {
        'id': id,
        'orderNumber': orderNumber,
        'customerFullName': 'Ayşe Yılmaz',
        'customerPhone': '+905321234567',
        'categoryPath': 'Kadın > Ayakkabı > Sneakers',
        'brand': 'Nike',
        'status': 'RECEIVED',
        'price': 1550.0,
        'remainingAmount': 1550.0,
        'estimatedDeliveryDate': null,
        'createdAt': '2026-01-01T10:00:00Z',
      };
    }

    test('resolves via search + detail when a matching order number exists',
        () async {
      final adapter = _SequencedFakeAdapter([
        (
          statusCode: 200,
          body: {
            'items': [listItemJson(id: 1, orderNumber: 'WO-2026-000001')],
            'page': 1,
            'pageSize': 20,
            'totalCount': 1,
          },
        ),
        (statusCode: 200, body: _sampleWorkOrderJson()),
      ]);
      dio.httpClientAdapter = adapter;

      final result = await repository.findByOrderNumber('WO-2026-000001');

      expect(result, isNotNull);
      expect(result!.orderNumber, 'WO-2026-000001');
      expect(adapter.callCount, 2);
    });

    test(
      'rejects a partial/ILIKE search result — only an exact match resolves',
      () async {
        final adapter = _SequencedFakeAdapter([
          (
            statusCode: 200,
            body: {
              // Backend ILIKE %term% kısmi eşleşme döndürebilir; tam
              // eşleşmeyen bu satır istemcide elenmeli.
              'items': [listItemJson(id: 5, orderNumber: 'WO-2026-0000123')],
              'page': 1,
              'pageSize': 20,
              'totalCount': 1,
            },
          ),
        ]);
        dio.httpClientAdapter = adapter;

        final result = await repository.findByOrderNumber('WO-2026-000012');

        expect(result, isNull);
        // Eşleşme bulunamadığı için detay ucu hiç çağrılmamalı.
        expect(adapter.callCount, 1);
      },
    );

    test('returns null when the search has no results', () async {
      final adapter = _SequencedFakeAdapter([
        (
          statusCode: 200,
          body: {'items': [], 'page': 1, 'pageSize': 20, 'totalCount': 0},
        ),
      ]);
      dio.httpClientAdapter = adapter;

      final result = await repository.findByOrderNumber('WO-2099-999999');

      expect(result, isNull);
    });

    test('the match is case-insensitive on the order number', () async {
      final adapter = _SequencedFakeAdapter([
        (
          statusCode: 200,
          body: {
            'items': [listItemJson(id: 1, orderNumber: 'WO-2026-000001')],
            'page': 1,
            'pageSize': 20,
            'totalCount': 1,
          },
        ),
        (statusCode: 200, body: _sampleWorkOrderJson()),
      ]);
      dio.httpClientAdapter = adapter;

      final result = await repository.findByOrderNumber('wo-2026-000001');

      expect(result, isNotNull);
    });
  });
}

/// Sırayla önceden tanımlanmış yanıtları döner — `findByOrderNumber` gibi
/// ardışık iki istek atan (search + detail) akışları test etmek için.
class _SequencedFakeAdapter implements HttpClientAdapter {
  _SequencedFakeAdapter(this._responses);

  final List<({int statusCode, dynamic body})> _responses;
  int callCount = 0;

  @override
  void close({bool force = false}) {}

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    final response = _responses[callCount];
    callCount++;
    final encoded =
        utf8.encode(response.body == null ? '' : jsonEncode(response.body));
    return ResponseBody.fromBytes(
      encoded,
      response.statusCode,
      headers: {
        Headers.contentTypeHeader: [Headers.jsonContentType],
      },
    );
  }
}

class _FakeAdapter implements HttpClientAdapter {
  _FakeAdapter({required this.statusCode, required this.body});

  final int statusCode;
  final dynamic body;

  @override
  void close({bool force = false}) {}

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    final encoded = utf8.encode(body == null ? '' : jsonEncode(body));
    return ResponseBody.fromBytes(
      encoded,
      statusCode,
      headers: {
        Headers.contentTypeHeader: [Headers.jsonContentType],
      },
    );
  }
}
