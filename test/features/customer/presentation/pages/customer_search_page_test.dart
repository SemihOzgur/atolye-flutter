import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:leather_care_admin/app/app_routes.dart';
import 'package:leather_care_admin/core/di/injection.dart';
import 'package:leather_care_admin/core/theme/app_theme.dart';
import 'package:leather_care_admin/core/network/paged_response.dart';
import 'package:leather_care_admin/features/customer/data/customer_repository.dart';
import 'package:leather_care_admin/features/customer/data/dto/customer_dto.dart';
import 'package:leather_care_admin/features/customer/presentation/pages/customer_search_page.dart';

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
      initialLocation: AppRoutes.customers,
      routes: [
        GoRoute(
          path: AppRoutes.customers,
          builder: (context, state) =>
              const Scaffold(body: CustomerSearchPage()),
          routes: [
            GoRoute(
              path: 'new',
              builder: (context, state) =>
                  const Scaffold(body: Text('new-customer-page')),
            ),
            GoRoute(
              path: ':id',
              builder: (context, state) => Scaffold(
                body: Text('customer-detail-${state.pathParameters['id']}'),
              ),
            ),
          ],
        ),
      ],
    );
    return MaterialApp.router(routerConfig: router, theme: AppTheme.light());
  }

  testWidgets('shows prompt before any search', (tester) async {
    await tester.pumpWidget(buildSubject());
    await tester.pumpAndSettle();

    expect(find.text('Aramak için telefon veya isim yazın.'), findsOneWidget);
  });

  testWidgets('navigates to new customer page on Yeni Kayıt tap', (
    tester,
  ) async {
    await tester.pumpWidget(buildSubject());
    await tester.pumpAndSettle();

    await tester.tap(find.text('Yeni Kayıt'));
    await tester.pumpAndSettle();

    expect(find.text('new-customer-page'), findsOneWidget);
  });

  testWidgets('shows results after debounced search and navigates on tap', (
    tester,
  ) async {
    fakeRepository.pageToReturn = PagedResponse(
      items: [
        CustomerDto(
          id: 7,
          firstName: 'Ayşe',
          lastName: 'Yılmaz',
          phone: '+905321234567',
          iysConsentStatus: 'APPROVED',
          createdAt: DateTime(2026, 1, 1),
        ),
      ],
      page: 1,
      pageSize: 20,
      totalCount: 1,
    );

    await tester.pumpWidget(buildSubject());
    await tester.enterText(find.byType(TextField), '0532');
    await tester.pump(const Duration(milliseconds: 500));
    await tester.pumpAndSettle();

    expect(find.text('Ayşe Yılmaz'), findsOneWidget);

    await tester.tap(find.text('Ayşe Yılmaz'));
    await tester.pumpAndSettle();

    expect(find.text('customer-detail-7'), findsOneWidget);
  });

  testWidgets('shows empty state with Yeni Kayıt shortcut when no match', (
    tester,
  ) async {
    fakeRepository.pageToReturn = const PagedResponse(
      items: <CustomerDto>[],
      page: 1,
      pageSize: 20,
      totalCount: 0,
    );

    await tester.pumpWidget(buildSubject());
    await tester.enterText(find.byType(TextField), 'olmayan müşteri');
    await tester.pump(const Duration(milliseconds: 500));
    await tester.pumpAndSettle();

    expect(find.text('Müşteri bulunamadı'), findsOneWidget);
  });
}
