import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:leather_care_admin/core/network/api_exception.dart';
import 'package:leather_care_admin/features/dashboard/data/dashboard_repository.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late Dio dio;
  late DashboardRepository repository;

  setUp(() {
    dio = Dio(BaseOptions(baseUrl: 'https://dotikadbm.com'));
    repository = DashboardRepository(dio);
  });

  test('parses summary response into DashboardSummaryDto', () async {
    dio.httpClientAdapter = _FakeAdapter(
      statusCode: 200,
      body: {
        'receivedCount': 12,
        'inProgressCount': 5,
        'readyCount': 3,
        'receivedTodayCount': 2,
        'deliveredTodayCount': 1,
        'dailyRevenue': 1250.5,
        'monthlyRevenue': 34500.0,
        'readyWaitingOverdueCount': 4,
        'diskUsageBytes': 107374182400,
      },
    );

    final summary = await repository.fetchSummary();

    expect(summary.receivedCount, 12);
    expect(summary.readyWaitingOverdueCount, 4);
    expect(summary.diskUsageBytes, 107374182400);
    expect(summary.dailyRevenue, 1250.5);
  });

  test('throws ApiException on 401', () async {
    dio.httpClientAdapter = _FakeAdapter(
      statusCode: 401,
      body: {'title': 'Unauthorized', 'detail': 'Oturum geçersiz.'},
    );

    await expectLater(
      repository.fetchSummary,
      throwsA(
        isA<ApiException>().having((e) => e.statusCode, 'statusCode', 401),
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
