import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/network/api_exception.dart';
import '../../data/catalog_repository.dart';
import '../../data/dto/create_service_type_request_dto.dart';
import '../../data/dto/service_type_dto.dart';
import '../../data/dto/update_service_type_request_dto.dart';
import 'service_type_state.dart';

class ServiceTypeCubit extends Cubit<ServiceTypeState> {
  ServiceTypeCubit(this._repository) : super(const ServiceTypeState());

  final ICatalogRepository _repository;

  Future<void> load() async {
    emit(ServiceTypeState(status: ServiceTypeStatus.loading, items: state.items));

    try {
      final items = await _repository.fetchServiceTypes();
      emit(ServiceTypeState(status: ServiceTypeStatus.loaded, items: items));
    } on ApiException catch (e) {
      emit(
        ServiceTypeState(
          status: ServiceTypeStatus.error,
          items: state.items,
          errorMessage: e.detail ?? e.message,
        ),
      );
    }
  }

  Future<ServiceTypeDto> create(CreateServiceTypeRequestDto request) async {
    final created = await _repository.createServiceType(request);
    await load();
    return created;
  }

  Future<ServiceTypeDto> update(
    int id,
    UpdateServiceTypeRequestDto request,
  ) async {
    final updated = await _repository.updateServiceType(id, request);
    await load();
    return updated;
  }

  Future<void> delete(int id) async {
    await _repository.deleteServiceType(id);
    await load();
  }
}
