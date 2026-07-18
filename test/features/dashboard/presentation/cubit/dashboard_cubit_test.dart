import 'package:flutter_test/flutter_test.dart';
import 'package:leather_care_admin/core/network/api_exception.dart';
import 'package:leather_care_admin/features/dashboard/data/dashboard_repository.dart';
import 'package:leather_care_admin/features/dashboard/data/dto/dashboard_summary_dto.dart';
import 'package:leather_care_admin/features/dashboard/presentation/cubit/dashboard_cubit.dart';
import 'package:leather_care_admin/features/dashboard/presentation/cubit/dashboard_state.dart';

void main() {
  late _FakeDashboardRepository repository;
  late DashboardCubit cubit;

  setUp(() {
    repository = _FakeDashboardRepository();
    cubit = DashboardCubit(repository);
  });

  tearDown(() {
    cubit.close();
  });

  const summary = DashboardSummaryDto(
    receivedCount: 10,
    inProgressCount: 4,
    readyCount: 2,
    receivedTodayCount: 1,
    deliveredTodayCount: 1,
    dailyRevenue: 500,
    monthlyRevenue: 15000,
    readyWaitingOverdueCount: 3,
    diskUsageBytes: 120 * 1024 * 1024 * 1024,
  );

  test('loads summary successfully', () async {
    repository.summaryToReturn = summary;

    await cubit.load();

    expect(cubit.state.status, DashboardStatus.loaded);
    expect(cubit.state.summary, summary);
    expect(cubit.state.hasOverdueReadyItems, isTrue);
    expect(cubit.state.isDiskWarning, isTrue);
    expect(cubit.state.lastUpdatedAt, isNotNull);
  });

  test('keeps previous summary visible on refresh error', () async {
    repository.summaryToReturn = summary;
    await cubit.load();

    repository.summaryToReturn = null;
    repository.exceptionToThrow = ApiException(
      message: 'Sunucu hatası',
      statusCode: 500,
    );

    await cubit.load();

    expect(cubit.state.status, DashboardStatus.error);
    expect(cubit.state.summary, summary);
    expect(cubit.state.errorMessage, isNotNull);
  });

  test('has no overdue/disk warning under thresholds', () async {
    repository.summaryToReturn = const DashboardSummaryDto(
      receivedCount: 1,
      inProgressCount: 1,
      readyCount: 1,
      receivedTodayCount: 1,
      deliveredTodayCount: 1,
      dailyRevenue: 0,
      monthlyRevenue: 0,
      readyWaitingOverdueCount: 0,
      diskUsageBytes: 1024,
    );

    await cubit.load();

    expect(cubit.state.hasOverdueReadyItems, isFalse);
    expect(cubit.state.isDiskWarning, isFalse);
  });
}

class _FakeDashboardRepository implements IDashboardRepository {
  DashboardSummaryDto? summaryToReturn;
  ApiException? exceptionToThrow;

  @override
  Future<DashboardSummaryDto> fetchSummary() async {
    if (exceptionToThrow != null) {
      throw exceptionToThrow!;
    }
    return summaryToReturn!;
  }
}
