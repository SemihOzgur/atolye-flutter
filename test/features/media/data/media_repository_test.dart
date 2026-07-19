import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:leather_care_admin/core/network/api_exception.dart';
import 'package:leather_care_admin/features/media/data/dto/request_media_upload_request_dto.dart';
import 'package:leather_care_admin/features/media/data/media_repository.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late Dio dio;
  late MediaRepository repository;

  setUp(() {
    dio = Dio(BaseOptions(baseUrl: 'https://dotikadbm.com'));
    repository = MediaRepository(dio);
  });

  test('requestUpload posts request and parses response', () async {
    dio.httpClientAdapter = _FakeAdapter(
      statusCode: 200,
      body: {
        'mediaFileId': 42,
        'uploadUrl': 'https://minio.local/bucket/key?signature=abc',
        'expiresAt': '2026-01-01T10:05:00Z',
      },
    );

    final result = await repository.requestUpload(
      7,
      const RequestMediaUploadRequestDto(
        mediaType: 'PHOTO',
        stage: 'BEFORE',
        fileName: 'photo.jpg',
        mimeType: 'image/jpeg',
        sizeBytes: 1024,
      ),
    );

    expect(result.mediaFileId, 42);
    expect(result.uploadUrl, 'https://minio.local/bucket/key?signature=abc');
  });

  test('requestUpload throws ApiException on error response', () async {
    dio.httpClientAdapter = _FakeAdapter(
      statusCode: 400,
      body: {
        'title': 'Bad Request',
        'detail': 'Desteklenmeyen dosya formatı.',
        'errorCode': 'UNSUPPORTED_MEDIA_FORMAT',
      },
    );

    await expectLater(
      () => repository.requestUpload(
        7,
        const RequestMediaUploadRequestDto(
          mediaType: 'PHOTO',
          stage: 'BEFORE',
          fileName: 'photo.bmp',
          mimeType: 'image/bmp',
          sizeBytes: 1024,
        ),
      ),
      throwsA(
        isA<ApiException>().having(
          (e) => e.errorCode,
          'errorCode',
          'UNSUPPORTED_MEDIA_FORMAT',
        ),
      ),
    );
  });

  test('confirmUpload posts mediaFileId', () async {
    dio.httpClientAdapter = _FakeAdapter(statusCode: 200, body: null);

    await repository.confirmUpload(7, 42);
  });

  test('confirmUpload throws ApiException on error', () async {
    dio.httpClientAdapter = _FakeAdapter(
      statusCode: 404,
      body: {'title': 'Not Found', 'detail': 'Medya bulunamadı.'},
    );

    await expectLater(
      () => repository.confirmUpload(7, 999),
      throwsA(isA<ApiException>()),
    );
  });

  test('fetchMedia parses a list of MediaFileDto', () async {
    dio.httpClientAdapter = _FakeAdapter(
      statusCode: 200,
      body: [
        {
          'id': 1,
          'mediaType': 'PHOTO',
          'stage': 'BEFORE',
          'viewUrl': 'https://minio.local/view/1',
          'createdAt': '2026-01-01T10:00:00Z',
        },
      ],
    );

    final result = await repository.fetchMedia(7);

    expect(result, hasLength(1));
    expect(result.single.stage, 'BEFORE');
  });

  test('fetchMedia throws ApiException on error', () async {
    dio.httpClientAdapter = _FakeAdapter(
      statusCode: 500,
      body: {'title': 'Internal Server Error'},
    );

    await expectLater(
        () => repository.fetchMedia(7), throwsA(isA<ApiException>()));
  });

  test('deleteMedia sends DELETE', () async {
    dio.httpClientAdapter = _FakeAdapter(statusCode: 204, body: null);

    await repository.deleteMedia(1);
  });

  test('deleteMedia throws ApiException on error', () async {
    dio.httpClientAdapter = _FakeAdapter(
      statusCode: 404,
      body: {'title': 'Not Found', 'detail': 'Medya bulunamadı.'},
    );

    await expectLater(
        () => repository.deleteMedia(999), throwsA(isA<ApiException>()));
  });

  group('uploadFile', () {
    late Dio uploadClient;
    late Directory tempDir;

    setUp(() async {
      uploadClient = Dio();
      repository = MediaRepository(dio, uploadClient: uploadClient);
      tempDir = await Directory.systemTemp.createTemp('media_upload_test');
    });

    tearDown(() async {
      if (tempDir.existsSync()) {
        await tempDir.delete(recursive: true);
      }
    });

    test('PUTs file bytes to the presigned URL and reports progress', () async {
      late RequestOptions capturedOptions;
      uploadClient.httpClientAdapter = _CapturingAdapter((options) {
        capturedOptions = options;
        return 200;
      });

      final file = File('${tempDir.path}/photo.jpg')
        ..writeAsBytesSync(List.generate(10, (i) => i));

      final progressUpdates = <List<int>>[];
      await repository.uploadFile(
        'https://minio.local/bucket/key?signature=abc',
        file,
        'image/jpeg',
        onProgress: (sent, total) => progressUpdates.add([sent, total]),
      );

      expect(
          capturedOptions.path, 'https://minio.local/bucket/key?signature=abc');
      expect(capturedOptions.headers[Headers.contentTypeHeader], 'image/jpeg');
      expect(capturedOptions.headers[Headers.contentLengthHeader], 10);
      expect(progressUpdates, isNotEmpty);
      expect(progressUpdates.last, [10, 10]);
    });

    test('throws ApiException when the presigned PUT fails', () async {
      uploadClient.httpClientAdapter = _CapturingAdapter((options) => 403);

      final file = File('${tempDir.path}/photo.jpg')
        ..writeAsBytesSync([1, 2, 3]);

      await expectLater(
        () => repository.uploadFile(
          'https://minio.local/bucket/key?signature=abc',
          file,
          'image/jpeg',
        ),
        throwsA(isA<ApiException>()),
      );
    });
  });
}

class _CapturingAdapter implements HttpClientAdapter {
  _CapturingAdapter(this._onRequest);

  final int Function(RequestOptions options) _onRequest;

  @override
  void close({bool force = false}) {}

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    if (requestStream != null) {
      await requestStream.drain<void>();
    }
    final statusCode = _onRequest(options);
    return ResponseBody.fromBytes(const <int>[], statusCode);
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
