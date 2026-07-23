import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/network/api_exception.dart';
import '../../data/catalog_repository.dart';
import '../../data/dto/category_dto.dart';
import '../../data/dto/create_category_request_dto.dart';
import '../../data/dto/update_category_request_dto.dart';
import 'category_state.dart';

class CategoryCubit extends Cubit<CategoryState> {
  CategoryCubit(this._repository) : super(const CategoryState());

  final ICatalogRepository _repository;

  Future<void> load() async {
    emit(
      CategoryState(
        status: CategoryTreeStatus.loading,
        tree: state.tree,
        includeInactive: state.includeInactive,
      ),
    );

    try {
      final tree = await _repository.fetchCategoryTree(
        includeInactive: state.includeInactive,
      );
      emit(
        CategoryState(
          status: CategoryTreeStatus.loaded,
          tree: tree,
          includeInactive: state.includeInactive,
        ),
      );
    } on ApiException catch (e) {
      emit(
        CategoryState(
          status: CategoryTreeStatus.error,
          tree: state.tree,
          includeInactive: state.includeInactive,
          errorMessage: e.detail ?? e.message,
        ),
      );
    }
  }

  Future<void> setIncludeInactive(bool value) async {
    if (value == state.includeInactive) {
      return;
    }
    emit(
      CategoryState(
        status: state.status,
        tree: state.tree,
        includeInactive: value,
      ),
    );
    await load();
  }

  Future<CategoryDto> createCategory(CreateCategoryRequestDto request) async {
    final category = await _repository.createCategory(request);
    await load();
    return category;
  }

  Future<CategoryDto> updateCategory(
    int id,
    UpdateCategoryRequestDto request,
  ) async {
    final category = await _repository.updateCategory(id, request);
    await load();
    return category;
  }

  Future<void> deleteCategory(int id) async {
    await _repository.deleteCategory(id);
    await load();
  }
}
