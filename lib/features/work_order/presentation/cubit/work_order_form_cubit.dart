import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/network/api_exception.dart';
import '../../../catalog/data/catalog_repository.dart';
import '../../data/dto/create_work_order_request_dto.dart';
import '../../data/dto/update_work_order_request_dto.dart';
import '../../data/dto/work_order_dto.dart';
import '../../data/work_order_repository.dart';
import 'work_order_form_state.dart';

class WorkOrderFormCubit extends Cubit<WorkOrderFormState> {
  WorkOrderFormCubit(this._catalogRepository, this._workOrderRepository)
      : super(const WorkOrderFormState());

  final ICatalogRepository _catalogRepository;
  final IWorkOrderRepository _workOrderRepository;

  Future<void> loadCategoryTree() async {
    final tree = await _catalogRepository.fetchCategoryTree();
    emit(state.copyWith(categoryTree: tree));
  }

  Future<void> selectCategory(int categoryId, String categoryPath) async {
    emit(
      state.copyWith(
        selectedCategoryId: categoryId,
        selectedCategoryPath: categoryPath,
        availableServices: const [],
      ),
    );

    final result = await _catalogRepository.fetchCategoryServices(categoryId);
    emit(state.copyWith(availableServices: result.services));
  }

  Future<void> loadConsumableGroups() async {
    final groups = await _catalogRepository.fetchConsumableGroups();
    emit(state.copyWith(consumableGroups: groups));
  }

  Future<void> loadConsumableProducts({int? groupId}) async {
    final products = await _catalogRepository.fetchConsumableProducts(
      groupId: groupId,
    );
    emit(state.copyWith(consumableProducts: products));
  }

  Future<WorkOrderDto?> submit(CreateWorkOrderRequestDto request) async {
    emit(
      state.copyWith(
        submitStatus: WorkOrderFormSubmitStatus.submitting,
        errorMessage: null,
        fieldErrors: const <String, List<String>>{},
      ),
    );

    try {
      final workOrder = await _workOrderRepository.create(request);
      emit(
        state.copyWith(
          submitStatus: WorkOrderFormSubmitStatus.idle,
          createdWorkOrder: workOrder,
        ),
      );
      return workOrder;
    } on ApiException catch (e) {
      emit(
        state.copyWith(
          submitStatus: WorkOrderFormSubmitStatus.failure,
          errorMessage: e.detail ?? e.message,
          fieldErrors: e.fieldErrors,
        ),
      );
      return null;
    }
  }

  Future<WorkOrderDto?> submitUpdate(
    int id,
    UpdateWorkOrderRequestDto request,
  ) async {
    emit(
      state.copyWith(
        submitStatus: WorkOrderFormSubmitStatus.submitting,
        errorMessage: null,
        fieldErrors: const <String, List<String>>{},
      ),
    );

    try {
      final workOrder = await _workOrderRepository.update(id, request);
      emit(
        state.copyWith(
          submitStatus: WorkOrderFormSubmitStatus.idle,
          createdWorkOrder: workOrder,
        ),
      );
      return workOrder;
    } on ApiException catch (e) {
      emit(
        state.copyWith(
          submitStatus: WorkOrderFormSubmitStatus.failure,
          errorMessage: e.detail ?? e.message,
          fieldErrors: e.fieldErrors,
        ),
      );
      return null;
    }
  }
}
