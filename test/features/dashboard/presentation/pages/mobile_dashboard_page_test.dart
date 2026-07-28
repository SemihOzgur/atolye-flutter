import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:leather_care_admin/core/di/injection.dart';
import 'package:leather_care_admin/core/network/api_exception.dart';
import 'package:leather_care_admin/core/theme/app_theme.dart';
import 'package:leather_care_admin/features/dashboard/data/dashboard_repository.dart';
import 'package:leather_care_admin/features/dashboard/data/dto/dashboard_summary_dto.dart';
import 'package:leather_care_admin/features/dashboard/presentation/pages/mobile_dashboard_page.dart';

class _FakeDashboardRepository implements IDashboardRepository {
  DashboardSummaryDto? summaryToReturn;
  ApiException? exceptionToThrow;
  int fetchCount = 0;

  @override
  Future<DashboardSummaryDto> fetchSummary() async {
    fetchCount++;
    if (exceptionToThrow != null) throw exceptionToThrow!;
    return summaryToReturn!;
  }
}

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
    return MaterialApp(
      theme: AppTheme.light(),
      home: const Scaffold(body: MobileDashboardPage()),
    );
  }

  const summary = DashboardSummaryDto(
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

  testWidgets(
    'renders paired KPI cards + charts, without disk/overdue cards',
    (tester) async {
      fakeRepository.summaryToReturn = summary;

      await tester.pumpWidget(buildSubject());
      await tester.pumpAndSettle();

      expect(find.text('Teslim Alınan'), findsOneWidget);
      // "İşlemde"/"Hazır" also appear as the donut chart's legend labels.
      expect(find.text('İşlemde'), findsNWidgets(2));
      expect(find.text('Hazır'), findsNWidgets(2));
      expect(find.text('Bugün Alınan'), findsOneWidget);
      expect(find.text('Bugün Teslim'), findsOneWidget);
      expect(find.text('Günlük Ciro'), findsOneWidget);
      expect(find.text('Aylık Ciro'), findsOneWidget);

      expect(find.text('İş Durumu Dağılımı'), findsOneWidget);
      expect(find.text('Bugünkü Operasyon'), findsOneWidget);
      expect(find.text('Finansal Özet'), findsOneWidget);

      // Mobilde disk/arşiv kartları hiç render edilmemeli (SDD F5.8 AC-3).
      expect(find.textContaining('Disk'), findsNothing);
      expect(find.textContaining('Arşiv'), findsNothing);
    },
  );

  testWidgets('finance cards are masked by default (no PIN on mobile)', (
    tester,
  ) async {
    fakeRepository.summaryToReturn = summary;

    await tester.pumpWidget(buildSubject());
    await tester.pumpAndSettle();

    expect(find.textContaining('1.250,50'), findsNothing);
    expect(find.text('Göstermek için dokunun'), findsWidgets);
  });

  testWidgets(
    'tapping a finance card reveals the value; tapping again re-masks it',
    (tester) async {
      fakeRepository.summaryToReturn = summary;

      await tester.pumpWidget(buildSubject());
      await tester.pumpAndSettle();

      final financeCardFinder = find.text('Günlük Ciro');
      await tester.ensureVisible(financeCardFinder);
      await tester.tap(financeCardFinder);
      await tester.pumpAndSettle();

      expect(find.textContaining('1.250,50'), findsWidgets);
      expect(find.text('Göstermek için dokunun'), findsNothing);

      // Aylık Ciro kartı da aynı toggle'a bağlı — birlikte açılır.
      expect(find.textContaining('34.500,00'), findsWidgets);

      await tester.tap(financeCardFinder);
      await tester.pumpAndSettle();

      expect(find.textContaining('1.250,50'), findsNothing);
      expect(find.text('Göstermek için dokunun'), findsWidgets);
    },
  );

  testWidgets('pull-to-refresh reloads the summary', (tester) async {
    fakeRepository.summaryToReturn = summary;

    await tester.pumpWidget(buildSubject());
    await tester.pumpAndSettle();
    expect(fakeRepository.fetchCount, 1);

    await tester.fling(
      find.byType(RefreshIndicator),
      const Offset(0, 300),
      1000,
    );
    await tester.pumpAndSettle();

    expect(fakeRepository.fetchCount, greaterThanOrEqualTo(2));
  });

  testWidgets('shows a retry button on load failure', (tester) async {
    fakeRepository.exceptionToThrow = ApiException(
      message: 'Sunucu hatası',
      detail: 'Dashboard verileri yüklenemedi.',
      statusCode: 500,
    );

    await tester.pumpWidget(buildSubject());
    await tester.pumpAndSettle();

    expect(find.text('Dashboard verileri yüklenemedi.'), findsOneWidget);
    expect(find.text('Tekrar Dene'), findsOneWidget);
  });
}
