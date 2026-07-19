import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/network/api_exception.dart';
import '../../data/catalog_repository.dart';
import '../../data/dto/upsert_service_price_request_dto.dart';
import 'service_price_row.dart';
import 'service_price_state.dart';
import 'service_type_cubit.dart';

class ServicePriceCubit extends Cubit<ServicePriceState> {
  ServicePriceCubit(this._repository, this._serviceTypeCubit)
      : super(const ServicePriceState());

  final ICatalogRepository _repository;
  final ServiceTypeCubit _serviceTypeCubit;

  Future<void> selectCategory(int categoryId, String categoryPath) async {
    emit(
      ServicePriceState(
        status: ServicePriceStatus.loading,
        selectedCategoryId: categoryId,
        selectedCategoryPath: categoryPath,
      ),
    );

    try {
      final existingPrices = await _repository.fetchServicePrices(
        categoryId: categoryId,
      );
      final pricesByServiceType = {
        for (final price in existingPrices) price.serviceTypeId: price,
      };

      final rows = _serviceTypeCubit.state.items
          .where((serviceType) => serviceType.isActive)
          .map((serviceType) {
        final existing = pricesByServiceType[serviceType.id];
        return ServicePriceRow(
          serviceTypeId: serviceType.id,
          serviceName: serviceType.name,
          price: existing?.price ?? 0,
          isActive: existing?.isActive ?? false,
          servicePriceId: existing?.id,
        );
      }).toList();

      emit(
        ServicePriceState(
          status: ServicePriceStatus.loaded,
          selectedCategoryId: categoryId,
          selectedCategoryPath: categoryPath,
          rows: rows,
        ),
      );
    } on ApiException catch (e) {
      emit(
        ServicePriceState(
          status: ServicePriceStatus.error,
          selectedCategoryId: categoryId,
          selectedCategoryPath: categoryPath,
          errorMessage: e.detail ?? e.message,
        ),
      );
    }
  }

  void updateRowPrice(int serviceTypeId, double price) {
    _replaceRow(
      serviceTypeId,
      (row) => row.copyWith(price: price),
    );
  }

  void updateRowActive(int serviceTypeId, bool isActive) {
    _replaceRow(
      serviceTypeId,
      (row) => row.copyWith(isActive: isActive),
    );
  }

  void _replaceRow(
    int serviceTypeId,
    ServicePriceRow Function(ServicePriceRow row) transform,
  ) {
    final rows = state.rows
        .map(
          (row) => row.serviceTypeId == serviceTypeId ? transform(row) : row,
        )
        .toList();
    emit(
      ServicePriceState(
        status: state.status,
        selectedCategoryId: state.selectedCategoryId,
        selectedCategoryPath: state.selectedCategoryPath,
        rows: rows,
      ),
    );
  }

  Future<void> saveAll() async {
    final categoryId = state.selectedCategoryId;
    if (categoryId == null) {
      return;
    }

    final rowsToSubmit =
        state.rows.where((row) => row.hasExistingPrice || row.isActive);

    emit(
      ServicePriceState(
        status: ServicePriceStatus.saving,
        selectedCategoryId: categoryId,
        selectedCategoryPath: state.selectedCategoryPath,
        rows: state.rows,
      ),
    );

    try {
      await _repository.bulkUpsertServicePrices(
        rowsToSubmit
            .map(
              (row) => UpsertServicePriceRequestDto(
                categoryId: categoryId,
                serviceTypeId: row.serviceTypeId,
                price: row.price,
                isActive: row.isActive,
              ),
            )
            .toList(),
      );

      await selectCategory(categoryId, state.selectedCategoryPath!);
    } on ApiException catch (e) {
      emit(
        ServicePriceState(
          status: ServicePriceStatus.error,
          selectedCategoryId: categoryId,
          selectedCategoryPath: state.selectedCategoryPath,
          rows: state.rows,
          errorMessage: e.detail ?? e.message,
        ),
      );
    }
  }
}
