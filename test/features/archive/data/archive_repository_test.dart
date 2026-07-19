import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:leather_care_admin/core/network/api_exception.dart';
import 'package:leather_care_admin/features/archive/data/archive_repository.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late Dio dio;
  late ArchiveRepository repository;

  setUp(() {
    dio = Dio(BaseOptions(baseUrl: 'https://dotikadbm.com'));
    repository = ArchiveRepository(dio);
  });

  test('fetchCandidates parses the plain array response', () async {
    dio.httpClientAdapter = _FakeAdapter(
      statusCode: 200,
      body: [
        {
          'workOrderId': 7,
          'orderNumber': 'WO-2026-000007',
          'status': 'DELIVERED',
          'closedAt': '2026-01-01T10:00:00Z',
          'mediaCount': 4,
          'totalSizeBytes': 1048576,
          'hasSocialMediaConsent': true,
        },
      ],
    );

    final result = await repository.fetchCandidates(olderThanDays: 90);

    expect(result, hasLength(1));
    expect(result.single.orderNumber, 'WO-2026-000007');
    expect(result.single.hasSocialMediaConsent, isTrue);
  });

  test('fetchCandidates throws ApiException on error response', () async {
    dio.httpClientAdapter = _FakeAdapter(
      statusCode: 401,
      body: {'title': 'Unauthorized'},
    );

    await expectLater(
      () => repository.fetchCandidates(),
      throwsA(isA<ApiException>()),
    );
  });

  test('export parses the media item list', () async {
    dio.httpClientAdapter = _FakeAdapter(
      statusCode: 200,
      body: {
        'workOrderId': 7,
        'items': [
          {
            'mediaId': 1,
            'stage': 'BEFORE',
            'mediaType': 'PHOTO',
            'fileName': 'photo.jpg',
            'sizeBytes': 2048,
            'downloadUrl': 'https://minio.local/view/1',
          },
        ],
      },
    );

    final result = await repository.export(7);

    expect(result.workOrderId, 7);
    expect(result.items.single.fileName, 'photo.jpg');
  });

  test('export throws ApiException with 409 for an open work order', () async {
    dio.httpClientAdapter = _FakeAdapter(
      statusCode: 409,
      body: {'title': 'Conflict', 'detail': 'İş emri açık.'},
    );

    await expectLater(
      () => repository.export(7),
      throwsA(
        isA<ApiException>().having((e) => e.statusCode, 'statusCode', 409),
      ),
    );
  });

  test('confirm posts verifiedMediaIds', () async {
    dio.httpClientAdapter = _FakeAdapter(statusCode: 200, body: null);

    await repository.confirm(7, [1, 2, 3]);
  });

  test('confirm throws ApiException on 400 foreign mediaId', () async {
    dio.httpClientAdapter = _FakeAdapter(
      statusCode: 400,
      body: {'title': 'Bad Request', 'detail': 'Geçersiz medya kimliği.'},
    );

    await expectLater(
      () => repository.confirm(7, [999]),
      throwsA(isA<ApiException>()),
    );
  });

  group('downloadToFile', () {
    late Dio downloadClient;
    late Directory tempDir;

    setUp(() async {
      downloadClient = Dio();
      repository = ArchiveRepository(dio, downloadClient: downloadClient);
      tempDir = await Directory.systemTemp.createTemp('archive_download_test');
    });

    tearDown(() async {
      if (tempDir.existsSync()) {
        await tempDir.delete(recursive: true);
      }
    });

    test('writes bytes to disk and returns the ETag without quotes', () async {
      downloadClient.httpClientAdapter = _FakeAdapter(
        statusCode: 200,
        rawBody: [1, 2, 3],
        extraHeaders: {
          'etag': ['"5d41402abc4b2a76b9719d911017c592"'],
        },
      );

      final destination = '${tempDir.path}/photo.jpg';
      final etag = await repository.downloadToFile(
        'https://minio.local/view/1',
        destination,
      );

      expect(etag, '5d41402abc4b2a76b9719d911017c592');
      expect(File(destination).readAsBytesSync(), [1, 2, 3]);
    });

    test('returns null when no ETag header is present', () async {
      downloadClient.httpClientAdapter = _FakeAdapter(
        statusCode: 200,
        rawBody: [1, 2, 3],
      );

      final etag = await repository.downloadToFile(
        'https://minio.local/view/1',
        '${tempDir.path}/photo.jpg',
      );

      expect(etag, isNull);
    });

    test('throws ApiException when the download fails', () async {
      downloadClient.httpClientAdapter = _FakeAdapter(statusCode: 403);

      await expectLater(
        () => repository.downloadToFile(
          'https://minio.local/view/1',
          '${tempDir.path}/photo.jpg',
        ),
        throwsA(isA<ApiException>()),
      );
    });
  });
}

class _FakeAdapter implements HttpClientAdapter {
  _FakeAdapter({
    required this.statusCode,
    this.body,
    this.rawBody,
    this.extraHeaders = const {},
  });

  final int statusCode;
  final dynamic body;
  final List<int>? rawBody;
  final Map<String, List<String>> extraHeaders;

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
        ...extraHeaders,
      },
    );
  }
}
