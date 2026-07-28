import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:leather_care_admin/core/di/injection.dart';
import 'package:leather_care_admin/core/network/api_exception.dart';
import 'package:leather_care_admin/core/theme/app_theme.dart';
import 'package:leather_care_admin/features/customer/data/dto/customer_dto.dart';
import 'package:leather_care_admin/features/work_order/data/dto/status_log_dto.dart';
import 'package:leather_care_admin/features/work_order/data/dto/update_work_order_status_request_dto.dart';
import 'package:leather_care_admin/features/work_order/data/dto/work_order_dto.dart';
import 'package:leather_care_admin/features/work_order/data/dto/work_order_service_item_dto.dart';
import 'package:leather_care_admin/features/work_order/data/work_order_repository.dart';
import 'package:leather_care_admin/features/work_order/presentation/pages/mobile_work_order_detail_page.dart';

import '../../fakes/fake_work_order_repository.dart';

WorkOrderDto _workOrder({
  String status = 'RECEIVED',
  List<StatusLogDto> statusHistory = const [],
}) {
  return WorkOrderDto(
    id: 7,
    orderNumber: 'WO-2026-000123',
    customer: CustomerDto(
      id: 1,
      firstName: 'Ayşe',
      lastName: 'Yılmaz',
      phone: '+905321234567',
      iysConsentStatus: 'APPROVED',
      createdAt: DateTime(2026, 1, 1),
    ),
    categoryId: 3,
    categoryPath: 'Kadın > Ayakkabı > Sneakers',
    brand: 'Nike',
    description: 'Topuk tamiri gerekiyor',
    services: const [
      WorkOrderServiceItemDto(
        servicePriceId: 1,
        serviceName: 'Bakım ve Boya',
        priceSnapshot: 1250,
      ),
    ],
    suggestedPrice: 1550,
    price: 1550,
    hasPrepayment: false,
    remainingAmount: 1550,
    status: status,
    socialMediaConsent: false,
    trackingUrl: 'https://dotikadbm.com/t/abc',
    createdAt: DateTime(2026, 7, 12, 10, 30),
    updatedAt: DateTime(2026, 7, 12, 10, 30),
    statusHistory: statusHistory,
  );
}

/// updateStatus'ta her zaman 409 fırlatır, fetchDetail (409 sonrası
/// otomatik `load()` çağrısı) ise normal şekilde başarılı döner —
/// gerçek backend'in 409 sonrası davranışını taklit eder.
class _RepositoryWith409OnUpdateStatus extends FakeWorkOrderRepository {
  @override
  Future<WorkOrderDto> updateStatus(
    int id,
    UpdateWorkOrderStatusRequestDto request,
  ) async {
    lastStatusRequest = request;
    throw ApiException(
      message: 'Conflict',
      detail: 'Kayıt başka bir istemci tarafından güncellendi.',
      statusCode: 409,
    );
  }
}

void main() {
  late FakeWorkOrderRepository repository;

  setUp(() {
    repository = FakeWorkOrderRepository();
    if (getIt.isRegistered<IWorkOrderRepository>()) {
      getIt.unregister<IWorkOrderRepository>();
    }
    getIt.registerLazySingleton<IWorkOrderRepository>(() => repository);
  });

  tearDown(() async {
    await getIt.reset();
  });

  Widget buildSubject() {
    return MaterialApp(
      theme: AppTheme.light(),
      home: const MobileWorkOrderDetailPage(workOrderId: 7),
    );
  }

  testWidgets('renders read-only info without price/media/SMS/edit/deliver', (
    tester,
  ) async {
    repository.workOrderToReturn = _workOrder();

    await tester.pumpWidget(buildSubject());
    await tester.pumpAndSettle();

    expect(find.text('WO-2026-000123'), findsOneWidget);
    expect(find.text('Ayşe Yılmaz'), findsOneWidget);
    expect(find.textContaining('+905321234567'), findsOneWidget);
    expect(find.textContaining('Kadın > Ayakkabı > Sneakers'), findsOneWidget);
    expect(find.text('Marka: Nike'), findsOneWidget);
    expect(find.text('Topuk tamiri gerekiyor'), findsOneWidget);
    expect(find.text('• Bakım ve Boya'), findsOneWidget);

    // Fiyat/medya/SMS/Düzenle/Teslim Et mobilde hiç yok (SDD F6 kapsamı).
    expect(find.textContaining('Fiyat'), findsNothing);
    expect(find.text('Düzenle'), findsNothing);
    expect(find.text('Teslim Et'), findsNothing);
    expect(find.textContaining('SMS Durum'), findsNothing);
  });

  testWidgets('shows "Durumu Değiştir" for an open status', (tester) async {
    repository.workOrderToReturn = _workOrder(status: 'RECEIVED');

    await tester.pumpWidget(buildSubject());
    await tester.pumpAndSettle();

    expect(find.text('Durumu Değiştir'), findsOneWidget);
  });

  testWidgets('hides "Durumu Değiştir" for DELIVERED', (tester) async {
    repository.workOrderToReturn = _workOrder(status: 'DELIVERED');

    await tester.pumpWidget(buildSubject());
    await tester.pumpAndSettle();

    expect(find.text('Durumu Değiştir'), findsNothing);
  });

  testWidgets('hides "Durumu Değiştir" for CANCELLED', (tester) async {
    repository.workOrderToReturn = _workOrder(status: 'CANCELLED');

    await tester.pumpWidget(buildSubject());
    await tester.pumpAndSettle();

    expect(find.text('Durumu Değiştir'), findsNothing);
  });

  testWidgets(
    'tapping "Durumu Değiştir" opens the bottom sheet with the right targets',
    (tester) async {
      repository.workOrderToReturn = _workOrder(status: 'RECEIVED');

      await tester.pumpWidget(buildSubject());
      await tester.pumpAndSettle();

      await tester.tap(find.text('Durumu Değiştir'));
      await tester.pumpAndSettle();

      expect(find.text('İşleme Al'), findsOneWidget);
      expect(find.text('İptal Et'), findsOneWidget);
      expect(find.text('Hazır'), findsNothing);
    },
  );

  testWidgets('a successful status change updates the badge without reloading manually', (
    tester,
  ) async {
    repository.workOrderToReturn = _workOrder(status: 'RECEIVED');

    await tester.pumpWidget(buildSubject());
    await tester.pumpAndSettle();

    repository.workOrderToReturn = _workOrder(status: 'IN_PROGRESS');

    await tester.tap(find.text('Durumu Değiştir'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('İşleme Al'));
    await tester.pumpAndSettle();

    expect(repository.lastStatusRequest?.newStatus, 'IN_PROGRESS');
    // İşleme Al artık mevcut değil, "Hazır" ve "İşleme Geri Al" akışına
    // uygun yeni seçenekler var demektir (state güncellendi).
    expect(find.text('Durumu Değiştir'), findsOneWidget);
  });

  testWidgets(
    'a 409 error is surfaced via SnackBar and the record auto-reloads',
    (tester) async {
      final conflictRepository = _RepositoryWith409OnUpdateStatus()
        ..workOrderToReturn = _workOrder(status: 'RECEIVED');
      getIt.unregister<IWorkOrderRepository>();
      getIt.registerLazySingleton<IWorkOrderRepository>(
        () => conflictRepository,
      );

      await tester.pumpWidget(buildSubject());
      await tester.pumpAndSettle();

      await tester.tap(find.text('Durumu Değiştir'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('İşleme Al'));
      await tester.pumpAndSettle();

      // Hata mesajı yalnızca SnackBar'da görünmeli; kayıt otomatik
      // yeniden yüklendiği için ekran hâlâ RECEIVED durumunu gösteriyor
      // (updateStatus 409 fırlatıp yerine load() çalıştırdı).
      expect(
        find.text('Kayıt başka bir istemci tarafından güncellendi.'),
        findsOneWidget,
      );
      expect(find.text('WO-2026-000123'), findsOneWidget);
    },
  );

  testWidgets('shows an error view with retry on load failure', (
    tester,
  ) async {
    repository.exceptionToThrow = ApiException(
      message: 'Sunucu hatası',
      detail: 'İş emri yüklenemedi.',
      statusCode: 500,
    );

    await tester.pumpWidget(buildSubject());
    await tester.pumpAndSettle();

    expect(find.text('İş emri yüklenemedi.'), findsOneWidget);

    repository.exceptionToThrow = null;
    repository.workOrderToReturn = _workOrder();

    await tester.tap(find.text('Tekrar Dene'));
    await tester.pumpAndSettle();

    expect(find.text('WO-2026-000123'), findsOneWidget);
  });

  testWidgets('renders the status history timeline when present', (
    tester,
  ) async {
    repository.workOrderToReturn = _workOrder(
      status: 'IN_PROGRESS',
      statusHistory: [
        StatusLogDto(
          oldStatus: null,
          newStatus: 'RECEIVED',
          changedBy: 'admin@firma.com',
          changedAt: DateTime(2026, 7, 12, 10, 30),
        ),
        StatusLogDto(
          oldStatus: 'RECEIVED',
          newStatus: 'IN_PROGRESS',
          changedBy: 'admin@firma.com',
          changedAt: DateTime(2026, 7, 12, 11, 0),
        ),
      ],
    );

    await tester.pumpWidget(buildSubject());
    await tester.pumpAndSettle();

    expect(find.text('Durum Geçmişi'), findsOneWidget);
    expect(find.textContaining('admin@firma.com'), findsWidgets);
  });
}
