import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:leather_care_admin/core/network/api_exception.dart';
import 'package:leather_care_admin/features/catalog/data/catalog_repository.dart';
import 'package:leather_care_admin/features/catalog/data/dto/create_category_request_dto.dart';
import 'package:leather_care_admin/features/catalog/data/dto/create_consumable_group_request_dto.dart';
import 'package:leather_care_admin/features/catalog/data/dto/upsert_service_price_request_dto.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late Dio dio;
  late CatalogRepository repository;

  setUp(() {
    dio = Dio(BaseOptions(baseUrl: 'https://dotikadbm.com'));
    repository = CatalogRepository(dio);
  });

  test('fetchCategoryTree parses recursive tree', () async {
    dio.httpClientAdapter = _FakeAdapter(
      statusCode: 200,
      body: [
        {
          'id': 1,
          'name': 'Kadın',
          'level': 1,
          'isActive': true,
          'children': [
            {
              'id': 2,
              'name': 'Ayakkabı',
              'level': 2,
              'isActive': true,
              'children': [
                {
                  'id': 3,
                  'name': 'Sneakers',
                  'level': 3,
                  'isActive': true,
                  'children': <dynamic>[],
                },
              ],
            },
          ],
        },
      ],
    );

    final tree = await repository.fetchCategoryTree();

    expect(tree, hasLength(1));
    expect(tree.first.children.first.children.first.name, 'Sneakers');
    expect(tree.first.children.first.children.first.level, 3);
  });

  test('createCategory posts and parses CategoryDto', () async {
    dio.httpClientAdapter = _FakeAdapter(
      statusCode: 201,
      body: {
        'id': 10,
        'parentId': 1,
        'name': 'Terlik',
        'level': 2,
        'sortOrder': 0,
        'isActive': true,
      },
    );

    final category = await repository.createCategory(
      const CreateCategoryRequestDto(parentId: 1, name: 'Terlik', sortOrder: 0),
    );

    expect(category.id, 10);
    expect(category.level, 2);
  });

  test(
      'createCategory throws ApiException with INVALID_CATEGORY_LEVEL-like 400',
      () async {
    dio.httpClientAdapter = _FakeAdapter(
      statusCode: 400,
      body: {
        'title': 'Bad Request',
        'detail': 'Level 3 kategorinin altına kategori eklenemez.',
      },
    );

    await expectLater(
      () => repository.createCategory(
        const CreateCategoryRequestDto(parentId: 3, name: 'X', sortOrder: 0),
      ),
      throwsA(
          isA<ApiException>().having((e) => e.statusCode, 'statusCode', 400)),
    );
  });

  test('fetchCategoryServices parses options', () async {
    dio.httpClientAdapter = _FakeAdapter(
      statusCode: 200,
      body: {
        'categoryId': 3,
        'categoryPath': 'Kadın > Ayakkabı > Sneakers',
        'services': [
          {'servicePriceId': 100, 'serviceName': 'Bakım', 'price': 250.0},
        ],
      },
    );

    final result = await repository.fetchCategoryServices(3);

    expect(result.categoryPath, 'Kadın > Ayakkabı > Sneakers');
    expect(result.services.single.serviceName, 'Bakım');
  });

  test('fetchServicePrices parses list with categoryId filter', () async {
    dio.httpClientAdapter = _FakeAdapter(
      statusCode: 200,
      body: [
        {
          'id': 1,
          'categoryId': 3,
          'categoryPath': 'Kadın > Ayakkabı > Sneakers',
          'serviceTypeId': 1,
          'serviceName': 'Bakım',
          'price': 250.0,
          'isActive': true,
        },
      ],
    );

    final prices = await repository.fetchServicePrices(categoryId: 3);

    expect(prices, hasLength(1));
    expect(prices.first.price, 250.0);
  });

  test('bulkUpsertServicePrices sends items and parses response', () async {
    dio.httpClientAdapter = _FakeAdapter(
      statusCode: 200,
      body: [
        {
          'id': 1,
          'categoryId': 3,
          'categoryPath': 'Kadın > Ayakkabı > Sneakers',
          'serviceTypeId': 1,
          'serviceName': 'Bakım',
          'price': 300.0,
          'isActive': true,
        },
      ],
    );

    final result = await repository.bulkUpsertServicePrices([
      const UpsertServicePriceRequestDto(
        categoryId: 3,
        serviceTypeId: 1,
        price: 300,
        isActive: true,
      ),
    ]);

    expect(result.single.price, 300.0);
  });

  test('fetchConsumableProducts parses displayName field', () async {
    dio.httpClientAdapter = _FakeAdapter(
      statusCode: 200,
      body: [
        {
          'id': 1,
          'groupId': 1,
          'groupName': 'Bakım Ürünleri',
          'brand': 'Saphir',
          'name': 'Deri Bakım Kremi',
          'displayName': 'Saphir Deri Bakım Kremi',
          'salePrice': 400.0,
          'isActive': true,
        },
      ],
    );

    final products = await repository.fetchConsumableProducts(groupId: 1);

    expect(products.single.displayName, 'Saphir Deri Bakım Kremi');
  });

  test('createConsumableGroup throws ApiException on 409 unique conflict',
      () async {
    dio.httpClientAdapter = _FakeAdapter(
      statusCode: 409,
      body: {'title': 'Conflict', 'detail': 'Bu ad zaten mevcut.'},
    );

    await expectLater(
      () => repository.createConsumableGroup(
        const CreateConsumableGroupRequestDto(name: 'Bakım Ürünleri'),
      ),
      throwsA(
          isA<ApiException>().having((e) => e.statusCode, 'statusCode', 409)),
    );
  });
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
