import 'package:flutter_test/flutter_test.dart';
import 'package:leather_care_admin/core/network/api_exception.dart';
import 'package:leather_care_admin/features/catalog/data/dto/category_dto.dart';
import 'package:leather_care_admin/features/catalog/data/dto/category_tree_dto.dart';
import 'package:leather_care_admin/features/catalog/data/dto/create_category_request_dto.dart';
import 'package:leather_care_admin/features/catalog/presentation/cubit/category_cubit.dart';
import 'package:leather_care_admin/features/catalog/presentation/cubit/category_state.dart';

import '../../fakes/fake_catalog_repository.dart';

void main() {
  late FakeCatalogRepository repository;
  late CategoryCubit cubit;

  setUp(() {
    repository = FakeCatalogRepository();
    cubit = CategoryCubit(repository);
  });

  tearDown(() {
    cubit.close();
  });

  const tree = [
    CategoryTreeDto(id: 1, name: 'Kadın', level: 1, isActive: true),
  ];

  test('load populates tree on success', () async {
    repository.treeToReturn = tree;

    await cubit.load();

    expect(cubit.state.status, CategoryTreeStatus.loaded);
    expect(cubit.state.tree, tree);
  });

  test('load emits error state on failure', () async {
    repository.exceptionToThrow = ApiException(
      message: 'Sunucu hatası',
      detail: 'Kategori ağacı yüklenemedi.',
      statusCode: 500,
    );

    await cubit.load();

    expect(cubit.state.status, CategoryTreeStatus.error);
    expect(cubit.state.errorMessage, 'Kategori ağacı yüklenemedi.');
  });

  test('setIncludeInactive toggles flag and reloads', () async {
    repository.treeToReturn = tree;

    await cubit.setIncludeInactive(true);

    expect(cubit.state.includeInactive, isTrue);
    expect(cubit.state.status, CategoryTreeStatus.loaded);
  });

  test('createCategory creates then reloads tree', () async {
    repository.treeToReturn = tree;
    repository.categoryResultToReturn = const CategoryDto(
      id: 2,
      parentId: 1,
      name: 'Ayakkabı',
      level: 2,
      sortOrder: 0,
      isActive: true,
    );

    final result = await cubit.createCategory(
      const CreateCategoryRequestDto(parentId: 1, name: 'Ayakkabı', sortOrder: 0),
    );

    expect(result.name, 'Ayakkabı');
    expect(cubit.state.tree, tree);
  });
}
