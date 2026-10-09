import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:leather_care_admin/core/di/injection.dart';
import 'package:leather_care_admin/core/theme/app_theme.dart';
import 'package:leather_care_admin/features/catalog/data/catalog_repository.dart';
import 'package:leather_care_admin/features/catalog/data/dto/category_services_dto.dart';
import 'package:leather_care_admin/features/catalog/data/dto/category_tree_dto.dart';
import 'package:leather_care_admin/features/catalog/data/dto/service_price_option_dto.dart';
import 'package:leather_care_admin/features/customer/data/customer_repository.dart';
import 'package:leather_care_admin/features/customer/data/dto/customer_detail_dto.dart';
import 'package:leather_care_admin/features/receipt/data/dto/receipt_dto.dart';
import 'package:leather_care_admin/features/receipt/data/receipt_repository.dart';
import 'package:leather_care_admin/features/receipt/presentation/pages/receipt_detail_page.dart';
import 'package:leather_care_admin/features/receipt/presentation/pages/receipt_form_page.dart';

import '../../catalog/fakes/fake_catalog_repository.dart';
import '../../customer/fakes/fake_customer_repository.dart';
import '../fakes/fake_receipt_repository.dart';
import '../fakes/receipt_fixtures.dart';

void main() {
  late FakeReceiptRepository receipts;
  late FakeCatalogRepository catalog;
  late FakeCustomerRepository customers;

  setUp(() async {
    await getIt.reset();
    receipts = FakeReceiptRepository()
      ..receiptToReturn = ReceiptDto.fromJson(receiptJson());
    catalog = FakeCatalogRepository()
      ..treeToReturn = const [
        CategoryTreeDto(
          id: 1,
          name: 'Kadın',
          level: 1,
          isActive: true,
          children: [
            CategoryTreeDto(
              id: 2,
              name: 'Ayakkabı',
              level: 2,
              isActive: true,
              children: [
                CategoryTreeDto(
                  id: 3,
                  name: 'Sneakers',
                  level: 3,
                  isActive: true,
                ),
              ],
            ),
          ],
        ),
      ]
      ..categoryServicesToReturn = const CategoryServicesDto(
        categoryId: 3,
        categoryPath: 'Kadın > Ayakkabı > Sneakers',
        services: [
          ServicePriceOptionDto(
            servicePriceId: 9,
            serviceName: 'Bakım',
            price: 250,
          ),
        ],
      );
    customers = FakeCustomerRepository()
      ..detailToReturn = CustomerDetailDto(
        customer: ReceiptDto.fromJson(receiptJson()).customer,
      );
    getIt
      ..registerSingleton<IReceiptRepository>(receipts)
      ..registerSingleton<ICatalogRepository>(catalog)
      ..registerSingleton<ICustomerRepository>(customers);
  });

  tearDown(() => getIt.reset());

  // Ink sparkle shader'ı bu test motorunda yüklenemiyor — splash kapatılır
  final theme = AppTheme.light().copyWith(splashFactory: NoSplash.splashFactory);

  String? navigatedTo;

  Widget app(Widget child) => MaterialApp.router(
        theme: theme,
        routerConfig: GoRouter(
          routes: [
            GoRoute(path: '/', builder: (_, __) => child),
            GoRoute(
              path: '/receipts/:id',
              builder: (_, state) {
                navigatedTo = state.uri.path;
                return const Scaffold(body: Text('detail'));
              },
            ),
          ],
        ),
      );

  testWidgets('form: add and copy items, totals follow item prices', (tester) async {
    tester.view.physicalSize = const Size(1400, 2400);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetDevicePixelRatio);
    addTearDown(tester.view.resetPhysicalSize);

    await tester.pumpWidget(app(const ReceiptFormPage(customerId: 1)));
    await tester.pumpAndSettle();

    expect(find.text('Yeni Fiş'), findsOneWidget);
    expect(find.textContaining('Ayşe Yılmaz'), findsOneWidget);
    expect(find.text('Kaydet'), findsOneWidget);

    // Ürün türü seç → hizmet çipi gelir → seçince fiyat önerilenle dolar
    await tester.tap(find.text('Ürün türü seçin'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Kadın > Ayakkabı > Sneakers').last);
    await tester.pumpAndSettle();
    await tester.tap(find.textContaining('Bakım —'));
    await tester.pumpAndSettle();
    expect(find.text('1 ürün — Toplam'), findsOneWidget);

    await tester.tap(find.text('Son ürünü kopyala'));
    await tester.pumpAndSettle();
    expect(find.text('2 ürün — Toplam'), findsOneWidget);
    expect(find.text('2 Ürünü Kaydet'), findsOneWidget);
    expect(find.text('Sneakers'), findsNWidgets(2)); // iki kartın özeti

    await tester.tap(find.text('2 Ürünü Kaydet'));
    await tester.pumpAndSettle();
    final request = receipts.lastCreateRequest!;
    expect(request.items, hasLength(2));
    expect(request.items.every((i) => i.categoryId == 3 && i.price == 250), isTrue);
    expect(request.prepaymentAmount, isNull);
    expect(navigatedTo, '/receipts/7');
  });

  testWidgets('form: blocks submit when an item has no product type', (tester) async {
    tester.view.physicalSize = const Size(1400, 2400);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetDevicePixelRatio);
    addTearDown(tester.view.resetPhysicalSize);

    await tester.pumpWidget(app(const ReceiptFormPage(customerId: 1)));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Kaydet'));
    await tester.pumpAndSettle();

    expect(find.text('Ürün 1: ürün türü seçin.'), findsOneWidget);
    expect(receipts.lastCreateRequest, isNull);
  });

  testWidgets('detail: lists items, selection shows bulk actions', (tester) async {
    tester.view.physicalSize = const Size(1400, 2400);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetDevicePixelRatio);
    addTearDown(tester.view.resetPhysicalSize);

    await tester.pumpWidget(app(const ReceiptDetailPage(receiptId: 7)));
    await tester.pumpAndSettle();

    expect(find.text('Fiş FS-2026-000042'), findsOneWidget);
    expect(find.text('Hazır: 1/2'), findsOneWidget);
    expect(find.textContaining('#1'), findsOneWidget);
    expect(find.textContaining('#2'), findsOneWidget);
    expect(find.text('Teslim Et'), findsNothing);

    // #1 READY → Teslim Et görünür
    await tester.tap(find.byType(Checkbox).first);
    await tester.pumpAndSettle();
    expect(find.text('Seçili: 1'), findsOneWidget);
    expect(find.text('Teslim Et'), findsOneWidget);
    expect(find.text('İşleme Al'), findsOneWidget);

    // #2 IN_PROGRESS eklenince ortak hedef yalnızca iptal
    await tester.tap(find.byType(Checkbox).last);
    await tester.pumpAndSettle();
    expect(find.text('Teslim Et'), findsNothing);
    expect(find.text('İşleme Al'), findsNothing);
    expect(find.text('İptal Et'), findsOneWidget);
  });
}
