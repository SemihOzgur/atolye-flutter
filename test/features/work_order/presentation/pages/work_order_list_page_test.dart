import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:leather_care_admin/app/app_routes.dart';
import 'package:leather_care_admin/core/di/injection.dart';
import 'package:leather_care_admin/core/network/paged_response.dart';
import 'package:leather_care_admin/core/theme/app_theme.dart';
import 'package:leather_care_admin/features/customer/data/dto/work_order_list_item_dto.dart';
import 'package:leather_care_admin/features/work_order/data/work_order_repository.dart';
import 'package:leather_care_admin/features/work_order/presentation/pages/work_order_list_page.dart';

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

  Widget buildSubject() {
    final router = GoRouter(
      initialLocation: AppRoutes.workOrders,
      routes: [
        GoRoute(
          path: AppRoutes.workOrders,
          builder: (context, state) =>
              const Scaffold(body: WorkOrderListPage()),
          routes: [
            GoRoute(
              path: ':id',
              builder: (context, state) => Scaffold(
                body: Text('work-order-detail-${state.pathParameters['id']}'),
              ),
            ),
          ],
        ),
      ],
    );
    return MaterialApp.router(routerConfig: router, theme: AppTheme.light());
  }

  testWidgets('shows empty state when there are no results', (tester) async {
    fakeRepository.pageToReturn = const PagedResponse(
      items: <WorkOrderListItemDto>[],
      page: 1,
      pageSize: 20,
      totalCount: 0,
    );

    await tester.pumpWidget(buildSubject());
    await tester.pumpAndSettle();

    expect(find.text('İş emri bulunamadı.'), findsOneWidget);
  });

  testWidgets('renders work order rows and navigates to detail on tap', (
    tester,
  ) async {
    fakeRepository.pageToReturn = PagedResponse(
      items: [
        WorkOrderListItemDto(
          id: 7,
          orderNumber: 'WO-2026-000007',
          customerFullName: 'Ayşe Yılmaz',
          customerPhone: '+905321234567',
          categoryPath: 'Kadın > Ayakkabı > Sneakers',
          brand: 'Nike',
          status: 'RECEIVED',
          price: 1550,
          remainingAmount: 1550,
          createdAt: DateTime(2026, 1, 1),
        ),
      ],
      page: 1,
      pageSize: 20,
      totalCount: 1,
    );

    await tester.pumpWidget(buildSubject());
    await tester.pumpAndSettle();

    expect(find.textContaining('WO-2026-000007'), findsOneWidget);

    await tester.tap(find.textContaining('WO-2026-000007'));
    await tester.pumpAndSettle();

    expect(find.text('work-order-detail-7'), findsOneWidget);
  });

  testWidgets('applies the initialStatus query param as the status filter', (
    tester,
  ) async {
    fakeRepository.pageToReturn = const PagedResponse(
      items: <WorkOrderListItemDto>[],
      page: 1,
      pageSize: 20,
      totalCount: 0,
    );

    final router = GoRouter(
      initialLocation: '${AppRoutes.workOrders}?status=READY',
      routes: [
        GoRoute(
          path: AppRoutes.workOrders,
          builder: (context, state) => Scaffold(
            body: WorkOrderListPage(
              initialStatus: state.uri.queryParameters['status'],
            ),
          ),
        ),
      ],
    );
    await tester.pumpWidget(
      MaterialApp.router(routerConfig: router, theme: AppTheme.light()),
    );
    await tester.pumpAndSettle();

    expect(fakeRepository.lastSearchStatus, 'READY');
  });
}
