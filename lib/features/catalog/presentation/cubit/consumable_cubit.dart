import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/network/api_exception.dart';
import '../../data/catalog_repository.dart';
import '../../data/dto/consumable_group_dto.dart';
import '../../data/dto/consumable_product_dto.dart';
import '../../data/dto/create_consumable_group_request_dto.dart';
import '../../data/dto/create_consumable_product_request_dto.dart';
import '../../data/dto/update_consumable_group_request_dto.dart';
import '../../data/dto/update_consumable_product_request_dto.dart';
import 'consumable_state.dart';

class ConsumableCubit extends Cubit<ConsumableState> {
  ConsumableCubit(this._repository) : super(const ConsumableState());

  final ICatalogRepository _repository;

  Future<void> load() async {
    emit(
      ConsumableState(
        status: ConsumableStatus.loading,
        groups: state.groups,
        products: state.products,
        selectedGroupId: state.selectedGroupId,
        brandFilter: state.brandFilter,
      ),
    );

    try {
      final groups = await _repository.fetchConsumableGroups();
      final products = await _repository.fetchConsumableProducts(
        groupId: state.selectedGroupId,
        brand: state.brandFilter,
      );

      emit(
        ConsumableState(
          status: ConsumableStatus.loaded,
          groups: groups,
          products: products,
          selectedGroupId: state.selectedGroupId,
          brandFilter: state.brandFilter,
        ),
      );
    } on ApiException catch (e) {
      emit(
        ConsumableState(
          status: ConsumableStatus.error,
          groups: state.groups,
          products: state.products,
          selectedGroupId: state.selectedGroupId,
          brandFilter: state.brandFilter,
          errorMessage: e.detail ?? e.message,
        ),
      );
    }
  }

  Future<void> filterByGroup(int? groupId) async {
    emit(
      ConsumableState(
        status: state.status,
        groups: state.groups,
        products: state.products,
        selectedGroupId: groupId,
        brandFilter: state.brandFilter,
      ),
    );
    await _reloadProducts();
  }

  Future<void> filterByBrand(String? brand) async {
    emit(
      ConsumableState(
        status: state.status,
        groups: state.groups,
        products: state.products,
        selectedGroupId: state.selectedGroupId,
        brandFilter: brand,
      ),
    );
    await _reloadProducts();
  }

  Future<void> _reloadProducts() async {
    try {
      final products = await _repository.fetchConsumableProducts(
        groupId: state.selectedGroupId,
        brand: state.brandFilter,
      );
      emit(
        ConsumableState(
          status: ConsumableStatus.loaded,
          groups: state.groups,
          products: products,
          selectedGroupId: state.selectedGroupId,
          brandFilter: state.brandFilter,
        ),
      );
    } on ApiException catch (e) {
      emit(
        ConsumableState(
          status: ConsumableStatus.error,
          groups: state.groups,
          products: state.products,
          selectedGroupId: state.selectedGroupId,
          brandFilter: state.brandFilter,
          errorMessage: e.detail ?? e.message,
        ),
      );
    }
  }

  Future<ConsumableGroupDto> createGroup(
    CreateConsumableGroupRequestDto request,
  ) async {
    final group = await _repository.createConsumableGroup(request);
    await load();
    return group;
  }

  Future<ConsumableGroupDto> updateGroup(
    int id,
    UpdateConsumableGroupRequestDto request,
  ) async {
    final group = await _repository.updateConsumableGroup(id, request);
    await load();
    return group;
  }

  Future<ConsumableProductDto> createProduct(
    CreateConsumableProductRequestDto request,
  ) async {
    final product = await _repository.createConsumableProduct(request);
    await _reloadProducts();
    return product;
  }

  Future<ConsumableProductDto> updateProduct(
    int id,
    UpdateConsumableProductRequestDto request,
  ) async {
    final product = await _repository.updateConsumableProduct(id, request);
    await _reloadProducts();
    return product;
  }
}
