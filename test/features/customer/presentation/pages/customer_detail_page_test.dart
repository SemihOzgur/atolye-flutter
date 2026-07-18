import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:leather_care_admin/app/app_routes.dart';
import 'package:leather_care_admin/core/di/injection.dart';
import 'package:leather_care_admin/core/theme/app_theme.dart';
import 'package:leather_care_admin/core/network/api_exception.dart';
import 'package:leather_care_admin/features/customer/data/customer_repository.dart';
import 'package:leather_care_admin/features/customer/data/dto/customer_detail_dto.dart';
import 'package:leather_care_admin/features/customer/data/dto/customer_dto.dart';
import 'package:leather_care_admin/features/customer/data/dto/work_order_list_item_dto.dart';
import 'package:leather_care_admin/features/customer/presentation/pages/customer_detail_page.dart';

import '../../fakes/fake_customer_repository.dart';

void main() {
  late FakeCustomerRepository fakeRepository;

  setUp(() {
    fakeRepository = FakeCustomerRepository();
    if (getIt.isRegistered<ICustomerRepository>()) {
      getIt.unregister<ICustomerRepository>();
    }
    getIt.registerLazySingleton<ICustomerRepository>(() => fakeRepository);
  });

  tearDown(() async {
    await getIt.reset();
  });

  Widget buildSubject() {
    final router = GoRouter(
      initialLocation: '${AppRoutes.customers}/7',
      routes: [
        GoRoute(
          path: '${AppRoutes.customers}/:id',
          builder: (context, state) => Scaffold(
            body: CustomerDetailPage(
              customerId: int.parse(state.pathParameters['id']!),
            ),
          ),
        ),
      ],
    );
    return MaterialApp.router(routerConfig: router, theme: AppTheme.light());
  }

  testWidgets('shows customer info and work order history', (tester) async {
    fakeRepository.detailToReturn = CustomerDetailDto(
      customer: CustomerDto(
        id: 7,
        firstName: 'Ayşe',
        lastName: 'Yılmaz',
        phone: '+905321234567',
        iysConsentStatus: 'APPROVED',
        createdAt: DateTime(2026, 1, 1),
      ),
      workOrders: [
        WorkOrderListItemDto(
          id: 100,
          orderNumber: 'WO-2026-100',
          customerFullName: 'Ayşe Yılmaz',
          customerPhone: '+905321234567',
          categoryPath: 'Çanta > Deri Çanta',
          status: 'DELIVERED',
          price: 750,
          remainingAmount: 0,
          createdAt: DateTime(2026, 1, 1),
        ),
      ],
    );

    await tester.pumpWidget(buildSubject());
    await tester.pumpAndSettle();

    expect(find.text('Ayşe Yılmaz'), findsOneWidget);
    expect(find.textContaining('WO-2026-100'), findsOneWidget);
  });

  testWidgets('shows error view with retry', (tester) async {
    fakeRepository.exceptionToThrow = ApiException(
      message: 'Not found',
      detail: 'Müşteri bulunamadı.',
      statusCode: 404,
    );

    await tester.pumpWidget(buildSubject());
    await tester.pumpAndSettle();

    expect(find.text('Müşteri bulunamadı.'), findsOneWidget);

    fakeRepository.exceptionToThrow = null;
    fakeRepository.detailToReturn = CustomerDetailDto(
      customer: CustomerDto(
        id: 7,
        firstName: 'Ayşe',
        lastName: 'Yılmaz',
        phone: '+905321234567',
        iysConsentStatus: 'APPROVED',
        createdAt: DateTime(2026, 1, 1),
      ),
      workOrders: const [],
    );

    await tester.tap(find.text('Tekrar Dene'));
    await tester.pumpAndSettle();

    expect(find.text('Ayşe Yılmaz'), findsOneWidget);
  });

  testWidgets('shows resend button and opens IYS panel for PENDING customer', (
    tester,
  ) async {
    fakeRepository.detailToReturn = CustomerDetailDto(
      customer: CustomerDto(
        id: 7,
        firstName: 'Ayşe',
        lastName: 'Yılmaz',
        phone: '+905321234567',
        iysConsentStatus: 'PENDING',
        createdAt: DateTime(2026, 1, 1),
      ),
      workOrders: const [],
    );

    await tester.pumpWidget(buildSubject());
    await tester.pumpAndSettle();

    expect(find.text('Kodu yeniden gönder'), findsOneWidget);

    await tester.tap(find.text('Kodu yeniden gönder'));
    await tester.pumpAndSettle();

    expect(find.text('İYS Onay Kodu'), findsOneWidget);
  });
}
