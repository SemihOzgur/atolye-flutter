import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:leather_care_admin/app/app_routes.dart';
import 'package:leather_care_admin/core/di/injection.dart';
import 'package:leather_care_admin/core/theme/app_theme.dart';
import 'package:leather_care_admin/features/customer/data/customer_repository.dart';
import 'package:leather_care_admin/features/customer/data/dto/create_customer_response_dto.dart';
import 'package:leather_care_admin/features/customer/data/dto/customer_dto.dart';
import 'package:leather_care_admin/features/customer/presentation/pages/customer_form_page.dart';

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
      initialLocation: '${AppRoutes.customers}/new',
      routes: [
        GoRoute(
          path: '${AppRoutes.customers}/new',
          builder: (context, state) => const CustomerFormPage(),
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

  testWidgets('shows validation errors on empty submit', (tester) async {
    await tester.pumpWidget(buildSubject());
    await tester.pumpAndSettle();

    await tester.tap(find.text('Kaydet'));
    await tester.pump();

    expect(find.text('Ad zorunludur'), findsOneWidget);
    expect(find.text('Soyad zorunludur'), findsOneWidget);
    expect(find.text('Telefon zorunludur'), findsOneWidget);
  });

  testWidgets('shows IYS verification panel after successful create', (
    tester,
  ) async {
    fakeRepository.createResultToReturn = CustomerCreateResult.created(
      CreateCustomerResponseDto(
        customer: CustomerDto(
          id: 42,
          firstName: 'Mehmet',
          lastName: 'Demir',
          phone: '+905321112233',
          iysConsentStatus: 'PENDING',
          createdAt: DateTime(2026, 1, 1),
        ),
        iysCodeExpiresAt: DateTime.now().add(const Duration(minutes: 5)),
      ),
    );

    await tester.pumpWidget(buildSubject());
    await tester.enterText(find.widgetWithText(TextFormField, 'Ad'), 'Mehmet');
    await tester.enterText(find.widgetWithText(TextFormField, 'Soyad'), 'Demir');
    await tester.enterText(
      find.widgetWithText(TextFormField, 'Telefon'),
      '05321112233',
    );

    await tester.tap(find.text('Kaydet'));
    await tester.pumpAndSettle();

    expect(find.text('İYS Onay Kodu'), findsOneWidget);
  });

  testWidgets('shows duplicate phone banner and navigates to existing customer', (
    tester,
  ) async {
    fakeRepository.createResultToReturn = CustomerCreateResult.duplicate(
      CustomerDto(
        id: 9,
        firstName: 'Ayşe',
        lastName: 'Yılmaz',
        phone: '+905321234567',
        iysConsentStatus: 'APPROVED',
        createdAt: DateTime(2026, 1, 1),
      ),
    );

    await tester.pumpWidget(buildSubject());
    await tester.enterText(find.widgetWithText(TextFormField, 'Ad'), 'Ayşe');
    await tester.enterText(find.widgetWithText(TextFormField, 'Soyad'), 'Yılmaz');
    await tester.enterText(
      find.widgetWithText(TextFormField, 'Telefon'),
      '05321234567',
    );

    await tester.tap(find.text('Kaydet'));
    await tester.pumpAndSettle();

    expect(find.text('customer-detail-9'), findsOneWidget);
  });
}
