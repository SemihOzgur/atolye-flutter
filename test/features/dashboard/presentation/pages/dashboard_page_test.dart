import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:leather_care_admin/app/app_routes.dart';
import 'package:leather_care_admin/core/di/injection.dart';
import 'package:leather_care_admin/core/theme/app_theme.dart';
import 'package:leather_care_admin/core/network/api_exception.dart';
import 'package:leather_care_admin/features/dashboard/data/dashboard_repository.dart';
import 'package:leather_care_admin/features/dashboard/data/dto/dashboard_summary_dto.dart';
import 'package:leather_care_admin/features/dashboard/presentation/pages/dashboard_page.dart';

void main() {
  late _FakeDashboardRepository fakeRepository;

  setUp(() {
    fakeRepository = _FakeDashboardRepository();
    if (getIt.isRegistered<IDashboardRepository>()) {
      getIt.unregister<IDashboardRepository>();
    }
    getIt.registerLazySingleton<IDashboardRepository>(() => fakeRepository);
  });

  tearDown(() async {
    await getIt.reset();
  });

  Widget buildSubject() {
    final router = GoRouter(
      initialLocation: AppRoutes.dashboard,
      routes: [
        GoRoute(
          path: AppRoutes.dashboard,
          builder: (context, state) =>
              const Scaffold(body: DashboardPage()),
        ),
        GoRoute(
          path: AppRoutes.workOrders,
          builder: (context, state) =>
              const Scaffold(body: Text('work-orders-page')),
        ),
        GoRoute(
          path: AppRoutes.archive,
          builder: (context, state) =>
              const Scaffold(body: Text('archive-page')),
        ),
      ],
    );
    return MaterialApp.router(routerConfig: router, theme: AppTheme.light());
  }

  const summaryWithWarnings = DashboardSummaryDto(
    receivedCount: 10,
    inProgressCount: 4,
    readyCount: 2,
    receivedTodayCount: 1,
    deliveredTodayCount: 1,
    dailyRevenue: 1250.5,
    monthlyRevenue: 34500,
    readyWaitingOverdueCount: 3,
    diskUsageBytes: 120 * 1024 * 1024 * 1024,
  );

  testWidgets('renders summary cards after successful load', (tester) async {
    fakeRepository.summaryToReturn = summaryWithWarnings;

    await tester.pumpWidget(buildSubject());
    await tester.pumpAndSettle();

    expect(find.text('10'), findsOneWidget);
    expect(find.textContaining('1.250,50'), findsOneWidget);
  });

  testWidgets('navigates to work orders on overdue alert tap', (
    tester,
  ) async {
    fakeRepository.summaryToReturn = summaryWithWarnings;

    await tester.pumpWidget(buildSubject());
    await tester.pumpAndSettle();

    expect(find.textContaining('7+ gündür teslim bekleyen: 3'), findsOneWidget);

    final alertFinder = find.textContaining('7+ gündür teslim bekleyen');
    await tester.ensureVisible(alertFinder);
    await tester.tap(alertFinder);
    await tester.pumpAndSettle();

    expect(find.text('work-orders-page'), findsOneWidget);
  });

  testWidgets('navigates to archive on disk warning tap', (tester) async {
    fakeRepository.summaryToReturn = summaryWithWarnings;

    await tester.pumpWidget(buildSubject());
    await tester.pumpAndSettle();

    final diskButtonFinder = find.text('Arşivleme önerilir');
    await tester.ensureVisible(diskButtonFinder);
    await tester.tap(diskButtonFinder);
    await tester.pumpAndSettle();

    expect(find.text('archive-page'), findsOneWidget);
  });

  testWidgets('shows error view with retry on failure', (tester) async {
    fakeRepository.exceptionToThrow = ApiException(
      message: 'Sunucu hatası',
      detail: 'Panel verileri alınamadı.',
      statusCode: 500,
    );

    await tester.pumpWidget(buildSubject());
    await tester.pumpAndSettle();

    expect(find.text('Panel verileri alınamadı.'), findsOneWidget);

    fakeRepository.exceptionToThrow = null;
    fakeRepository.summaryToReturn = summaryWithWarnings;

    await tester.tap(find.text('Tekrar Dene'));
    await tester.pumpAndSettle();

    expect(find.text('10'), findsOneWidget);
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
