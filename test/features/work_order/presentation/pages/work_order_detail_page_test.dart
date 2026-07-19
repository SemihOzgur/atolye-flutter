import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:leather_care_admin/app/app_routes.dart';
import 'package:leather_care_admin/core/di/injection.dart';
import 'package:leather_care_admin/core/network/api_exception.dart';
import 'package:leather_care_admin/core/theme/app_theme.dart';
import 'package:leather_care_admin/features/customer/data/dto/customer_dto.dart';
import 'package:leather_care_admin/features/work_order/data/dto/work_order_dto.dart';
import 'package:leather_care_admin/features/work_order/data/work_order_repository.dart';
import 'package:leather_care_admin/features/work_order/presentation/pages/work_order_detail_page.dart';

import '../../fakes/fake_work_order_repository.dart';

void main() {
  late FakeWorkOrderRepository fakeRepository;

  setUp(() {
    fakeRepository = FakeWorkOrderRepository();
    if (getIt.isRegistered<IWorkOrderRepository>()) {
      getIt.unregister<IWorkOrderRepository>();
    }
    getIt.registerLazySingleton<IWorkOrderRepository>(() => fakeRepository);
  });

  tearDown(() async {
    await getIt.reset();
  });

  WorkOrderDto buildWorkOrder({required String status}) {
    return WorkOrderDto(
      id: 7,
      orderNumber: 'WO-2026-000007',
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
      services: const [],
      suggestedPrice: 1550,
      price: 1550,
      hasPrepayment: false,
      remainingAmount: 1550,
      status: status,
      socialMediaConsent: false,
      trackingUrl: 'https://domain.com/t/abc',
      createdAt: DateTime(2026, 1, 1),
      updatedAt: DateTime(2026, 1, 1),
    );
  }

  Widget buildSubject() {
    final router = GoRouter(
      initialLocation: '${AppRoutes.workOrders}/7',
      routes: [
        GoRoute(
          path: '${AppRoutes.workOrders}/:id',
          builder: (context, state) => Scaffold(
            body: WorkOrderDetailPage(
              workOrderId: int.parse(state.pathParameters['id']!),
            ),
          ),
        ),
        GoRoute(
          path: '${AppRoutes.customers}/:id',
          builder: (context, state) => Scaffold(
            body: Text('customer-detail-${state.pathParameters['id']}'),
          ),
        ),
      ],
    );
    return MaterialApp.router(routerConfig: router, theme: AppTheme.light());
  }

  testWidgets('shows RECEIVED work order with İşleme Al action', (
    tester,
  ) async {
    fakeRepository.workOrderToReturn = buildWorkOrder(status: 'RECEIVED');

    await tester.pumpWidget(buildSubject());
    await tester.pumpAndSettle();

    expect(find.text('WO-2026-000007'), findsOneWidget);
    expect(find.text('İşleme Al'), findsOneWidget);
    expect(find.text('Teslim Et'), findsNothing);
  });

  testWidgets('İşleme Al transitions to IN_PROGRESS', (tester) async {
    fakeRepository.workOrderToReturn = buildWorkOrder(status: 'RECEIVED');

    await tester.pumpWidget(buildSubject());
    await tester.pumpAndSettle();

    fakeRepository.workOrderToReturn = buildWorkOrder(status: 'IN_PROGRESS');
    await tester.tap(find.text('İşleme Al'));
    await tester.pumpAndSettle();

    expect(fakeRepository.lastStatusRequest!.newStatus, 'IN_PROGRESS');
    expect(find.text('Hazır Olarak İşaretle'), findsOneWidget);
  });

  testWidgets('READY status shows Teslim Et and opens deliver dialog', (
    tester,
  ) async {
    fakeRepository.workOrderToReturn = buildWorkOrder(status: 'READY');

    await tester.pumpWidget(buildSubject());
    await tester.pumpAndSettle();

    await tester.tap(find.text('Teslim Et'));
    await tester.pumpAndSettle();

    expect(find.text('Kalan tutar: 1.550,00 ₺'), findsOneWidget);

    fakeRepository.workOrderToReturn = buildWorkOrder(status: 'DELIVERED');
    await tester.tap(find.widgetWithText(TextButton, 'Teslim Et'));
    await tester.pumpAndSettle();

    expect(fakeRepository.lastDeliverRequest!.finalPaymentAmount, 1550);
  });

  testWidgets('DELIVERED status hides all action buttons', (tester) async {
    fakeRepository.workOrderToReturn = buildWorkOrder(status: 'DELIVERED');

    await tester.pumpWidget(buildSubject());
    await tester.pumpAndSettle();

    expect(find.text('İptal Et'), findsNothing);
    expect(find.text('Düzenle'), findsNothing);
  });

  testWidgets('cancel dialog sends CANCELLED status with note', (
    tester,
  ) async {
    fakeRepository.workOrderToReturn = buildWorkOrder(status: 'RECEIVED');

    await tester.pumpWidget(buildSubject());
    await tester.pumpAndSettle();

    await tester.tap(find.text('İptal Et'));
    await tester.pumpAndSettle();

    await tester.enterText(
      find.widgetWithText(TextField, 'İptal nedeni'),
      'Müşteri vazgeçti',
    );

    fakeRepository.workOrderToReturn = buildWorkOrder(status: 'CANCELLED');
    await tester.tap(find.widgetWithText(TextButton, 'İptal Et').last);
    await tester.pumpAndSettle();

    expect(fakeRepository.lastStatusRequest!.newStatus, 'CANCELLED');
    expect(fakeRepository.lastStatusRequest!.note, 'Müşteri vazgeçti');
  });

  testWidgets('shows error message when a status transition is rejected', (
    tester,
  ) async {
    fakeRepository.workOrderToReturn = buildWorkOrder(status: 'RECEIVED');

    await tester.pumpWidget(buildSubject());
    await tester.pumpAndSettle();

    fakeRepository.exceptionToThrow = ApiException(
      message: 'Conflict',
      detail: 'Kayıt başka yerden güncellendi, liste yenileniyor.',
      errorCode: 'INVALID_STATUS_TRANSITION',
      statusCode: 409,
    );

    await tester.tap(find.text('İşleme Al'));
    await tester.pumpAndSettle();

    expect(
      find.text('Kayıt başka yerden güncellendi, liste yenileniyor.'),
      findsOneWidget,
    );
  });
}
