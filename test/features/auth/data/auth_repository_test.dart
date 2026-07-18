import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:leather_care_admin/core/constants/storage_keys.dart';
import 'package:leather_care_admin/core/network/api_exception.dart';
import 'package:leather_care_admin/core/services/storage_service.dart';
import 'package:leather_care_admin/features/auth/data/auth_repository.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late Dio dio;
  late _FakeSecureStorageService storage;
  late AuthRepository repository;

  setUp(() {
    dio = Dio(BaseOptions(baseUrl: 'https://dotikadbm.com'));
    storage = _FakeSecureStorageService();
    repository = AuthRepository(dio, storage);
  });

  test('writes token to secure storage on 200', () async {
    dio.httpClientAdapter = _FakeAdapter(
      statusCode: 200,
      body: {'token': 'jwt-token-abc'},
    );

    await repository.login(email: 'admin@firma.com', password: 'secret');

    expect(await storage.read(StorageKeys.authToken), 'jwt-token-abc');
  });

  test('throws ApiException with 401 on wrong credentials', () async {
    dio.httpClientAdapter = _FakeAdapter(
      statusCode: 401,
      body: {
        'title': 'Unauthorized',
        'detail': 'E-posta veya şifre hatalı.',
        'errorCode': 'INVALID_CREDENTIALS',
      },
    );

    await expectLater(
      () => repository.login(email: 'admin@firma.com', password: 'wrong'),
      throwsA(
        isA<ApiException>().having((e) => e.statusCode, 'statusCode', 401),
      ),
    );
    expect(await storage.read(StorageKeys.authToken), isNull);
  });

  test('throws ApiException with 429 on rate limit', () async {
    dio.httpClientAdapter = _FakeAdapter(
      statusCode: 429,
      body: {
        'title': 'Too Many Requests',
        'detail': 'Çok fazla deneme yaptınız.',
      },
    );

    await expectLater(
      () => repository.login(email: 'admin@firma.com', password: 'secret'),
      throwsA(
        isA<ApiException>().having((e) => e.statusCode, 'statusCode', 429),
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

class _FakeSecureStorageService implements ISecureStorageService {
  final Map<String, String> _values = {};

  @override
  Future<void> clearAll() async {
    _values.clear();
  }

  @override
  Future<void> delete(String key) async {
    _values.remove(key);
  }

  @override
  Future<String?> read(String key) async => _values[key];

  @override
  Future<void> write(String key, String value) async {
    _values[key] = value;
  }
}
