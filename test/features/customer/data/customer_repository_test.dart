import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:leather_care_admin/core/network/api_exception.dart';
import 'package:leather_care_admin/features/customer/data/customer_repository.dart';
import 'package:leather_care_admin/features/customer/data/dto/create_customer_request_dto.dart';
import 'package:leather_care_admin/features/customer/data/dto/update_customer_request_dto.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late Dio dio;
  late CustomerRepository repository;

  setUp(() {
    dio = Dio(BaseOptions(baseUrl: 'https://domain.com'));
    repository = CustomerRepository(dio);
  });

  test('search parses paged customer list', () async {
    dio.httpClientAdapter = _FakeAdapter(
      statusCode: 200,
      body: {
        'items': [
          {
            'id': 1,
            'firstName': 'Ayşe',
            'lastName': 'Yılmaz',
            'phone': '+905321234567',
            'email': null,
            'address': null,
            'iysConsentStatus': 'PENDING',
            'iysConsentAt': null,
            'createdAt': '2026-07-01T10:00:00Z',
          },
        ],
        'page': 1,
        'pageSize': 20,
        'totalCount': 1,
      },
    );

    final result = await repository.search(search: '0532');

    expect(result.items, hasLength(1));
    expect(result.items.first.firstName, 'Ayşe');
    expect(result.totalCount, 1);
  });

  test('create returns created result on 201', () async {
    dio.httpClientAdapter = _FakeAdapter(
      statusCode: 201,
      body: {
        'customer': {
          'id': 5,
          'firstName': 'Mehmet',
          'lastName': 'Demir',
          'phone': '+905321112233',
          'email': null,
          'address': null,
          'iysConsentStatus': 'PENDING',
          'iysConsentAt': null,
          'createdAt': '2026-07-01T10:00:00Z',
        },
        'iysCodeExpiresAt': '2026-07-01T10:05:00Z',
      },
    );

    final result = await repository.create(
      const CreateCustomerRequestDto(
        firstName: 'Mehmet',
        lastName: 'Demir',
        phone: '05321112233',
      ),
    );

    expect(result.isDuplicate, isFalse);
    expect(result.response.customer.id, 5);
    expect(result.response.iysCodeExpiresAt, DateTime.parse('2026-07-01T10:05:00Z'));
  });

  test('create returns duplicate result on 409 DUPLICATE_PHONE', () async {
    dio.httpClientAdapter = _FakeAdapter(
      statusCode: 409,
      body: {
        'title': 'Conflict',
        'detail': 'Bu telefon numarası zaten kayıtlı.',
        'errorCode': 'DUPLICATE_PHONE',
        'customer': {
          'id': 9,
          'firstName': 'Ayşe',
          'lastName': 'Yılmaz',
          'phone': '+905321234567',
          'email': null,
          'address': null,
          'iysConsentStatus': 'APPROVED',
          'iysConsentAt': '2026-06-01T10:00:00Z',
          'createdAt': '2026-05-01T10:00:00Z',
        },
      },
    );

    final result = await repository.create(
      const CreateCustomerRequestDto(
        firstName: 'Ayşe',
        lastName: 'Yılmaz',
        phone: '05321234567',
      ),
    );

    expect(result.isDuplicate, isTrue);
    expect(result.duplicateCustomer.id, 9);
    expect(result.duplicateCustomer.iysConsentStatus, 'APPROVED');
  });

  test('create rethrows ApiException for non-duplicate errors', () async {
    dio.httpClientAdapter = _FakeAdapter(
      statusCode: 400,
      body: {
        'title': 'Validation failed',
        'detail': 'Geçerli bir cep telefonu giriniz.',
        'errors': {
          'phone': ['Geçerli bir cep telefonu giriniz.'],
        },
      },
    );

    await expectLater(
      () => repository.create(
        const CreateCustomerRequestDto(
          firstName: 'Test',
          lastName: 'User',
          phone: '123',
        ),
      ),
      throwsA(isA<ApiException>()),
    );
  });

  test('fetchDetail parses customer with work order history', () async {
    dio.httpClientAdapter = _FakeAdapter(
      statusCode: 200,
      body: {
        'customer': {
          'id': 1,
          'firstName': 'Ayşe',
          'lastName': 'Yılmaz',
          'phone': '+905321234567',
          'email': null,
          'address': null,
          'iysConsentStatus': 'APPROVED',
          'iysConsentAt': '2026-06-01T10:00:00Z',
          'createdAt': '2026-05-01T10:00:00Z',
        },
        'workOrders': [
          {
            'id': 100,
            'orderNumber': 'WO-2026-100',
            'customerFullName': 'Ayşe Yılmaz',
            'customerPhone': '+905321234567',
            'categoryPath': 'Çanta > Deri Çanta',
            'brand': 'Louis Vuitton',
            'status': 'DELIVERED',
            'price': 750.0,
            'remainingAmount': 0.0,
            'estimatedDeliveryDate': null,
            'createdAt': '2026-06-01T10:00:00Z',
          },
        ],
      },
    );

    final detail = await repository.fetchDetail(1);

    expect(detail.customer.firstName, 'Ayşe');
    expect(detail.workOrders, hasLength(1));
    expect(detail.workOrders.first.orderNumber, 'WO-2026-100');
  });

  test('update sends PUT and parses CustomerResponse', () async {
    dio.httpClientAdapter = _FakeAdapter(
      statusCode: 200,
      body: {
        'id': 1,
        'firstName': 'Ayşe',
        'lastName': 'Yılmaz',
        'phone': '+905321234567',
        'email': 'ayse@example.com',
        'address': null,
        'iysConsentStatus': 'APPROVED',
        'iysConsentAt': '2026-06-01T10:00:00Z',
        'createdAt': '2026-05-01T10:00:00Z',
      },
    );

    final customer = await repository.update(
      1,
      const UpdateCustomerRequestDto(
        firstName: 'Ayşe',
        lastName: 'Yılmaz',
        phone: '05321234567',
        email: 'ayse@example.com',
      ),
    );

    expect(customer.email, 'ayse@example.com');
  });

  test('resendIysCode parses new expiry', () async {
    dio.httpClientAdapter = _FakeAdapter(
      statusCode: 200,
      body: {'customerId': 1, 'expiresAt': '2026-07-01T10:10:00Z'},
    );

    final result = await repository.resendIysCode(1);

    expect(result.customerId, 1);
    expect(result.expiresAt, DateTime.parse('2026-07-01T10:10:00Z'));
  });

  test('confirmIysCode parses SUBMITTED status', () async {
    dio.httpClientAdapter = _FakeAdapter(
      statusCode: 200,
      body: {'iysConsentStatus': 'SUBMITTED', 'iysReferenceId': 'cust-1-123'},
    );

    final result = await repository.confirmIysCode(1, '1234');

    expect(result.iysConsentStatus, 'SUBMITTED');
    expect(result.iysReferenceId, 'cust-1-123');
  });

  test('confirmIysCode throws ApiException with CODE_LOCKED', () async {
    dio.httpClientAdapter = _FakeAdapter(
      statusCode: 400,
      body: {
        'title': 'Bad Request',
        'detail': '3 kez yanlış girildi.',
        'errorCode': 'CODE_LOCKED',
      },
    );

    await expectLater(
      () => repository.confirmIysCode(1, '0000'),
      throwsA(
        isA<ApiException>()
            .having((e) => e.errorCode, 'errorCode', 'CODE_LOCKED'),
      ),
    );
  });
}

class _FakeAdapter implements HttpClientAdapter {
  _FakeAdapter({required this.statusCode, required this.body});

  final int statusCode;
  final Map<String, dynamic> body;

  @override
  void close({bool force = false}) {}

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    final encoded = utf8.encode(jsonEncode(body));
    return ResponseBody.fromBytes(
      encoded,
      statusCode,
      headers: {
        Headers.contentTypeHeader: [Headers.jsonContentType],
      },
    );
  }
}
