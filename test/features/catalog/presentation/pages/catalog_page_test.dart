import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:leather_care_admin/core/di/injection.dart';
import 'package:leather_care_admin/core/theme/app_theme.dart';
import 'package:leather_care_admin/features/catalog/data/catalog_repository.dart';
import 'package:leather_care_admin/features/catalog/data/dto/category_tree_dto.dart';
import 'package:leather_care_admin/features/catalog/data/dto/consumable_group_dto.dart';
import 'package:leather_care_admin/features/catalog/data/dto/consumable_product_dto.dart';
import 'package:leather_care_admin/features/catalog/data/dto/service_type_dto.dart';
import 'package:leather_care_admin/features/catalog/presentation/pages/catalog_page.dart';

import '../../fakes/fake_catalog_repository.dart';

void main() {
  late FakeCatalogRepository fakeRepository;

  const tree = [
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
            CategoryTreeDto(id: 3, name: 'Sneakers', level: 3, isActive: true),
          ],
        ),
      ],
    ),
  ];

  const serviceTypes = [
    ServiceTypeDto(id: 1, name: 'Bakım', sortOrder: 0, isActive: true),
    ServiceTypeDto(id: 2, name: 'Boya', sortOrder: 1, isActive: true),
  ];

  const groups = [
    ConsumableGroupDto(id: 1, name: 'Bakım Ürünleri', isActive: true),
  ];
  const products = [
    ConsumableProductDto(
      id: 1,
      groupId: 1,
      groupName: 'Bakım Ürünleri',
      brand: 'Saphir',
      name: 'Deri Bakım Kremi',
      displayName: 'Saphir Deri Bakım Kremi',
      salePrice: 400,
      isActive: true,
    ),
  ];

  setUp(() {
    fakeRepository = FakeCatalogRepository()
      ..treeToReturn = tree
      ..serviceTypesToReturn = serviceTypes
      ..consumableGroupsToReturn = groups
      ..consumableProductsToReturn = products
      ..servicePricesToReturn = const [];

    if (getIt.isRegistered<ICatalogRepository>()) {
      getIt.unregister<ICatalogRepository>();
    }
    getIt.registerLazySingleton<ICatalogRepository>(() => fakeRepository);
  });

  tearDown(() async {
    await getIt.reset();
  });

  Widget buildSubject() {
    return MaterialApp(
      theme: AppTheme.light(),
      home: const Scaffold(body: CatalogPage()),
    );
  }

  testWidgets('shows category tree by default', (tester) async {
    await tester.pumpWidget(buildSubject());
    await tester.pumpAndSettle();

    expect(find.text('Kadın'), findsOneWidget);
    expect(find.text('Kategoriler'), findsWidgets);
  });

  testWidgets('switching to Hizmet Türleri tab shows service types', (
    tester,
  ) async {
    await tester.pumpWidget(buildSubject());
    await tester.pumpAndSettle();

    await tester.tap(find.text('Hizmet Türleri'));
    await tester.pumpAndSettle();

    expect(find.text('Bakım'), findsOneWidget);
    expect(find.text('Boya'), findsOneWidget);
  });

  testWidgets('switching to Fiyat Matrisi tab lists service types for a chosen category', (
    tester,
  ) async {
    await tester.pumpWidget(buildSubject());
    await tester.pumpAndSettle();

    await tester.tap(find.text('Fiyat Matrisi'));
    await tester.pumpAndSettle();

    await tester.tap(find.byType(DropdownButton<int>));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Kadın > Ayakkabı > Sneakers').last);
    await tester.pumpAndSettle();

    expect(find.text('Bakım'), findsOneWidget);
    expect(find.text('Boya'), findsOneWidget);
    expect(find.text('Tümünü Kaydet'), findsOneWidget);
  });

  testWidgets('switching to Sarf Malzemeler tab shows groups and products', (
    tester,
  ) async {
    await tester.pumpWidget(buildSubject());
    await tester.pumpAndSettle();

    final consumablesTabFinder = find.text('Sarf Malzemeler');
    await tester.ensureVisible(consumablesTabFinder);
    await tester.tap(consumablesTabFinder);
    await tester.pumpAndSettle();

    expect(find.text('Bakım Ürünleri'), findsWidgets);
    expect(find.text('Saphir Deri Bakım Kremi'), findsOneWidget);
  });

  testWidgets('deactivating an active category shows the cascading warning dialog', (
    tester,
  ) async {
    await tester.pumpWidget(buildSubject());
    await tester.pumpAndSettle();

    final editButtons = find.byIcon(Icons.edit_outlined);
    await tester.tap(editButtons.first);
    await tester.pumpAndSettle();

    await tester.tap(find.text('Aktif'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Kaydet'));
    await tester.pumpAndSettle();

    expect(
      find.textContaining('alt kategoriler de'),
      findsOneWidget,
    );
  });
}
