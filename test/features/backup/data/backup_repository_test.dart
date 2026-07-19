import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:leather_care_admin/core/network/api_exception.dart';
import 'package:leather_care_admin/features/backup/data/backup_repository.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late Dio dio;
  late BackupRepository repository;
  late Directory tempDir;

  setUp(() async {
    dio = Dio(BaseOptions(baseUrl: 'https://dotikadbm.com'));
    repository = BackupRepository(dio);
    tempDir = await Directory.systemTemp.createTemp('backup_repository_test');
  });

  tearDown(() async {
    if (tempDir.existsSync()) {
      await tempDir.delete(recursive: true);
    }
  });

  test('downloads the backup and parses the filename from Content-Disposition', () async {
    dio.httpClientAdapter = _FakeAdapter(
      statusCode: 200,
      rawBody: [1, 2, 3, 4],
      extraHeaders: {
        'content-disposition': [
          'attachment; filename="db-2026-01-01.sql.gz"',
        ],
      },
    );

    final destination = '${tempDir.path}/backup.sql.gz';
    final fileName = await repository.downloadLatest(destination);

    expect(fileName, 'db-2026-01-01.sql.gz');
    expect(File(destination).readAsBytesSync(), [1, 2, 3, 4]);
  });

  test('returns null when Content-Disposition is absent', () async {
    dio.httpClientAdapter = _FakeAdapter(statusCode: 200, rawBody: [1, 2, 3]);

    final fileName = await repository.downloadLatest(
      '${tempDir.path}/backup.sql.gz',
    );

    expect(fileName, isNull);
  });

  test('throws ApiException with statusCode 404 when no backup exists', () async {
    dio.httpClientAdapter = _FakeAdapter(
      statusCode: 404,
      body: {'title': 'Not Found'},
    );

    await expectLater(
      () => repository.downloadLatest('${tempDir.path}/backup.sql.gz'),
      throwsA(
        isA<ApiException>().having((e) => e.statusCode, 'statusCode', 404),
      ),
    );
  });

  test('throws ApiException on 401', () async {
    dio.httpClientAdapter = _FakeAdapter(
      statusCode: 401,
      body: {'title': 'Unauthorized'},
    );

    await expectLater(
      () => repository.downloadLatest('${tempDir.path}/backup.sql.gz'),
      throwsA(isA<ApiException>()),
    );
  });

  test('reports download progress', () async {
    dio.httpClientAdapter = _FakeAdapter(
      statusCode: 200,
      rawBody: List.generate(10, (i) => i),
      extraHeaders: {
        Headers.contentLengthHeader: ['10'],
      },
    );

    final progressUpdates = <List<int>>[];
    await repository.downloadLatest(
      '${tempDir.path}/backup.sql.gz',
      onProgress: (sent, total) => progressUpdates.add([sent, total]),
    );

    expect(progressUpdates, isNotEmpty);
    expect(progressUpdates.last, [10, 10]);
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
