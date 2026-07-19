import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:leather_care_admin/core/network/api_exception.dart';
import 'package:leather_care_admin/features/social_media/data/social_media_repository.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late Dio dio;
  late SocialMediaRepository repository;

  setUp(() {
    dio = Dio(BaseOptions(baseUrl: 'https://dotikadbm.com'));
    repository = SocialMediaRepository(dio);
  });

  test('fetchItems parses a paged list of social media items', () async {
    dio.httpClientAdapter = _FakeAdapter(
      statusCode: 200,
      body: {
        'items': [
          {
            'workOrderId': 7,
            'orderNumber': 'WO-2026-000007',
            'status': 'READY',
            'categoryPath': 'Kadın > Ayakkabı > Sneakers',
            'brand': 'Nike',
            'socialMediaConsentAt': '2026-01-01T10:00:00Z',
            'beforeMedia': [
              {
                'id': 1,
                'mediaType': 'PHOTO',
                'stage': 'BEFORE',
                'viewUrl': 'https://minio.local/view/1',
                'createdAt': '2026-01-01T10:00:00Z',
              },
            ],
            'afterMedia': const <dynamic>[],
          },
        ],
        'page': 1,
        'pageSize': 20,
        'totalCount': 1,
      },
    );

    final result = await repository.fetchItems();

    expect(result.items, hasLength(1));
    expect(result.items.single.orderNumber, 'WO-2026-000007');
    expect(result.items.single.beforeMedia.single.stage, 'BEFORE');
    expect(result.items.single.afterMedia, isEmpty);
  });

  test('fetchItems throws ApiException on error response', () async {
    dio.httpClientAdapter = _FakeAdapter(
      statusCode: 401,
      body: {'title': 'Unauthorized'},
    );

    await expectLater(
      () => repository.fetchItems(),
      throwsA(isA<ApiException>()),
    );
  });

  group('downloadMedia', () {
    late Dio downloadClient;
    late Directory tempDir;

    setUp(() async {
      downloadClient = Dio();
      repository = SocialMediaRepository(dio, downloadClient: downloadClient);
      tempDir = await Directory.systemTemp.createTemp('social_media_test');
    });

    tearDown(() async {
      if (tempDir.existsSync()) {
        await tempDir.delete(recursive: true);
      }
    });

    test('writes the downloaded bytes to the destination path', () async {
      downloadClient.httpClientAdapter = _FakeAdapter(
        statusCode: 200,
        rawBody: [1, 2, 3, 4],
      );

      final destination = '${tempDir.path}/photo.jpg';
      await repository.downloadMedia(
        'https://minio.local/view/1',
        destination,
      );

      expect(File(destination).readAsBytesSync(), [1, 2, 3, 4]);
    });

    test('throws ApiException when the download request fails', () async {
      downloadClient.httpClientAdapter = _FakeAdapter(statusCode: 403);

      await expectLater(
        () => repository.downloadMedia(
          'https://minio.local/view/1',
          '${tempDir.path}/photo.jpg',
        ),
        throwsA(isA<ApiException>()),
      );
    });
  });
}

class _FakeAdapter implements HttpClientAdapter {
  _FakeAdapter({required this.statusCode, this.body, this.rawBody});

  final int statusCode;
  final dynamic body;
  final List<int>? rawBody;

  @override
  void close({bool force = false}) {}

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    final encoded = rawBody ?? utf8.encode(body == null ? '' : jsonEncode(body));
    return ResponseBody.fromBytes(
      encoded,
      statusCode,
      headers: {
        Headers.contentTypeHeader: [Headers.jsonContentType],
      },
    );
  }
}
