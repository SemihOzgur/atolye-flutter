import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:leather_care_admin/app/app_routes.dart';
import 'package:leather_care_admin/core/di/injection.dart';
import 'package:leather_care_admin/core/network/api_exception.dart';
import 'package:leather_care_admin/core/security/finance_lock_controller.dart';
import 'package:leather_care_admin/core/security/pin_store.dart';
import 'package:leather_care_admin/core/services/storage_service.dart';
import 'package:leather_care_admin/core/theme/app_theme.dart';
import 'package:leather_care_admin/core/widgets/skeleton_box.dart';
import 'package:leather_care_admin/features/dashboard/data/dashboard_repository.dart';
import 'package:leather_care_admin/features/dashboard/data/dto/dashboard_summary_dto.dart';
import 'package:leather_care_admin/features/dashboard/presentation/pages/dashboard_page.dart';

class _FakeSecureStorageService implements ISecureStorageService {
  final Map<String, String> _values = {};

  @override
  Future<void> clearAll() async => _values.clear();

  @override
  Future<void> delete(String key) async => _values.remove(key);

  @override
  Future<String?> read(String key) async => _values[key];

  @override
  Future<void> write(String key, String value) async => _values[key] = value;
}

void main() {
  late _FakeDashboardRepository fakeRepository;
  late FinanceLockController financeLock;

  setUp(() {
    fakeRepository = _FakeDashboardRepository();
    if (getIt.isRegistered<IDashboardRepository>()) {
      getIt.unregister<IDashboardRepository>();
    }
    getIt.registerLazySingleton<IDashboardRepository>(() => fakeRepository);

    financeLock = FinanceLockController(
      PinStore(_FakeSecureStorageService()),
    );
    if (getIt.isRegistered<FinanceLockController>()) {
      getIt.unregister<FinanceLockController>();
    }
    getIt.registerSingleton<FinanceLockController>(financeLock);
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
          builder: (context, state) => Scaffold(
            body: Text('work-orders-page-${state.uri.query}'),
          ),
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

  const summaryAllZero = DashboardSummaryDto(
    receivedCount: 0,
    inProgressCount: 0,
    readyCount: 0,
    receivedTodayCount: 0,
    deliveredTodayCount: 0,
    dailyRevenue: 0,
    monthlyRevenue: 0,
    readyWaitingOverdueCount: 0,
    diskUsageBytes: 0,
  );

  testWidgets('shows a skeleton loader before the first load resolves', (
    tester,
  ) async {
    fakeRepository.summaryToReturn = summaryWithWarnings;

    await tester.pumpWidget(buildSubject());

    expect(find.text('Genel Bakış'), findsNothing);
    expect(find.byType(SkeletonBox), findsWidgets);
  });

  testWidgets('renders KPI cards, donut legend, and financial summary', (
    tester,
  ) async {
    fakeRepository.summaryToReturn = summaryWithWarnings;

    await tester.pumpWidget(buildSubject());
    await tester.pumpAndSettle();

    expect(find.text('Genel Bakış'), findsOneWidget);
    expect(find.text('Teslim Alınan'), findsOneWidget);
    // "İşlemde"/"Hazır" also appear as the donut legend's status labels.
    expect(find.text('İşlemde'), findsNWidgets(2));
    expect(find.text('Hazır'), findsNWidgets(2));
    expect(find.text('Bugün Alınan'), findsOneWidget);
    expect(find.text('Bugün Teslim'), findsOneWidget);
    expect(find.text('Günlük Ciro'), findsOneWidget);
    expect(find.text('Aylık Ciro'), findsOneWidget);
    // Appears both in the "Teslim Alınan" KPI card and the donut legend.
    expect(find.text('10'), findsNWidgets(2));
    // Finance is locked by default — the raw amount must not be shown.
    expect(find.textContaining('1.250,50'), findsNothing);

    expect(find.text('İş Durumu Dağılımı'), findsOneWidget);
    expect(find.text('Bugünkü Operasyon'), findsOneWidget);
    expect(find.text('Finansal Özet'), findsOneWidget);
  });

  group('finance lock (F3)', () {
    testWidgets('finance cards start masked on every app open', (
      tester,
    ) async {
      fakeRepository.summaryToReturn = summaryWithWarnings;

      await tester.pumpWidget(buildSubject());
      await tester.pumpAndSettle();

      expect(find.textContaining('1.250,50'), findsNothing);
      expect(find.textContaining('34.500,00'), findsNothing);
      expect(find.text('Göstermek için dokunun'), findsWidgets);
    });

    testWidgets(
      'tapping a masked card without an existing PIN opens the setup dialog '
      'and unlocks after a matching PIN + confirmation',
      (tester) async {
        fakeRepository.summaryToReturn = summaryWithWarnings;
        await tester.pumpWidget(buildSubject());
        await tester.pumpAndSettle();

        await tester.tap(find.text('Günlük Ciro'));
        await tester.pumpAndSettle();

        expect(find.text('PIN Belirle'), findsOneWidget);

        await tester.enterText(find.widgetWithText(TextField, 'PIN'), '1234');
        await tester.enterText(
          find.widgetWithText(TextField, 'PIN (Tekrar)'),
          '1234',
        );
        await tester.tap(find.text('Onayla'));
        await tester.pumpAndSettle();

        expect(find.textContaining('1.250,50'), findsWidgets);
        expect(await financeLock.hasPin(), isTrue);

        // Cancel the pending 5-minute auto-lock timer so it doesn't leak
        // past this fake-async test.
        financeLock.lock();
      },
    );

    testWidgets(
      'an existing PIN opens the verify dialog; the correct PIN unlocks',
      (tester) async {
        await financeLock.setPinAndUnlock('1234');
        financeLock.lock();
        fakeRepository.summaryToReturn = summaryWithWarnings;

        await tester.pumpWidget(buildSubject());
        await tester.pumpAndSettle();

        await tester.tap(find.text('Günlük Ciro'));
        await tester.pumpAndSettle();

        expect(find.text('PIN Gir'), findsOneWidget);

        await tester.enterText(find.widgetWithText(TextField, 'PIN'), '1234');
        await tester.tap(find.text('Onayla'));
        await tester.pumpAndSettle();

        expect(find.textContaining('1.250,50'), findsWidgets);

        // Cancel the pending 5-minute auto-lock timer so it doesn't leak
        // past this fake-async test.
        financeLock.lock();
      },
    );

    testWidgets('a wrong PIN shows an inline error and stays masked', (
      tester,
    ) async {
      await financeLock.setPinAndUnlock('1234');
      financeLock.lock();
      fakeRepository.summaryToReturn = summaryWithWarnings;

      await tester.pumpWidget(buildSubject());
      await tester.pumpAndSettle();

      await tester.tap(find.text('Günlük Ciro'));
      await tester.pumpAndSettle();

      await tester.enterText(find.widgetWithText(TextField, 'PIN'), '0000');
      await tester.tap(find.text('Onayla'));
      await tester.pumpAndSettle();

      expect(find.textContaining('Hatalı PIN (1/5)'), findsOneWidget);
      expect(find.textContaining('1.250,50'), findsNothing);
    });

    testWidgets('unlocked cards re-mask automatically after 5 minutes', (
      tester,
    ) async {
      await financeLock.setPinAndUnlock('1234');
      fakeRepository.summaryToReturn = summaryWithWarnings;

      await tester.pumpWidget(buildSubject());
      await tester.pumpAndSettle();

      expect(find.textContaining('1.250,50'), findsWidgets);

      await tester.pump(const Duration(minutes: 5));
      await tester.pumpAndSettle();

      expect(find.textContaining('1.250,50'), findsNothing);
      expect(find.text('Göstermek için dokunun'), findsWidgets);
    });
  });

  testWidgets('shows the empty-state hint when every value is zero', (
    tester,
  ) async {
    fakeRepository.summaryToReturn = summaryAllZero;

    await tester.pumpWidget(buildSubject());
    await tester.pumpAndSettle();

    expect(
      find.textContaining('Henüz dashboard verisi bulunmuyor'),
      findsOneWidget,
    );
  });

  testWidgets(
    'navigates to work orders with the READY filter on overdue alert tap',
    (tester) async {
      fakeRepository.summaryToReturn = summaryWithWarnings;

      await tester.pumpWidget(buildSubject());
      await tester.pumpAndSettle();

      expect(find.textContaining('3 iş emri uzun süredir'), findsOneWidget);

      final alertFinder = find.text('READY işlerini görüntüle');
      await tester.ensureVisible(alertFinder);
      await tester.tap(alertFinder);
      await tester.pumpAndSettle();

      expect(find.text('work-orders-page-status=READY'), findsOneWidget);
    },
  );

  testWidgets('navigates to archive on disk warning tap', (tester) async {
    fakeRepository.summaryToReturn = summaryWithWarnings;

    await tester.pumpWidget(buildSubject());
    await tester.pumpAndSettle();

    final diskButtonFinder = find.text('Arşivlemeyi Aç');
    await tester.ensureVisible(diskButtonFinder);
    await tester.tap(diskButtonFinder);
    await tester.pumpAndSettle();

    expect(find.text('archive-page'), findsOneWidget);
  });

  testWidgets('shows error view with retry on failure', (tester) async {
    fakeRepository.exceptionToThrow = ApiException(
      message: 'Sunucu hatası',
      detail: 'Dashboard verileri yüklenemedi.',
      statusCode: 500,
    );

    await tester.pumpWidget(buildSubject());
    await tester.pumpAndSettle();

    expect(find.text('Dashboard verileri yüklenemedi.'), findsOneWidget);

    fakeRepository.exceptionToThrow = null;
    fakeRepository.summaryToReturn = summaryWithWarnings;

    await tester.tap(find.text('Tekrar Dene'));
    await tester.pumpAndSettle();

    expect(find.text('Genel Bakış'), findsOneWidget);
  });

  testWidgets('Yenile button reloads and updates last-updated time', (
    tester,
  ) async {
    fakeRepository.summaryToReturn = summaryWithWarnings;

    await tester.pumpWidget(buildSubject());
    await tester.pumpAndSettle();

    expect(find.textContaining('Son güncelleme:'), findsOneWidget);

    await tester.tap(find.text('Yenile'));
    await tester.pumpAndSettle();

    expect(find.text('Genel Bakış'), findsOneWidget);
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
