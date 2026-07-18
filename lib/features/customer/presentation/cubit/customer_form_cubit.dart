import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/network/api_exception.dart';
import '../../data/customer_repository.dart';
import '../../data/dto/create_customer_request_dto.dart';
import '../../data/dto/update_customer_request_dto.dart';
import 'customer_form_state.dart';

const Duration _defaultIysCodeLifetime = Duration(minutes: 5);

class CustomerFormCubit extends Cubit<CustomerFormState> {
  CustomerFormCubit(this._repository) : super(const CustomerFormState());

  final ICustomerRepository _repository;

  Future<void> createCustomer(CreateCustomerRequestDto request) async {
    emit(const CustomerFormState(status: CustomerFormStatus.submitting));

    try {
      final result = await _repository.create(request);

      if (result.isDuplicate) {
        emit(
          CustomerFormState(
            success: CustomerFormSuccess(
              customer: result.duplicateCustomer,
              isDuplicate: true,
              requiresIysVerification: false,
            ),
          ),
        );
        return;
      }

      emit(
        CustomerFormState(
          success: CustomerFormSuccess(
            customer: result.response.customer,
            isDuplicate: false,
            requiresIysVerification: true,
            iysCodeExpiresAt: result.response.iysCodeExpiresAt,
          ),
        ),
      );
    } on ApiException catch (e) {
      emit(
        CustomerFormState(
          status: CustomerFormStatus.failure,
          errorMessage: e.detail ?? e.message,
          fieldErrors: e.fieldErrors,
        ),
      );
    }
  }

  Future<void> updateCustomer(
    int id,
    UpdateCustomerRequestDto request, {
    required bool phoneChanged,
  }) async {
    emit(const CustomerFormState(status: CustomerFormStatus.submitting));

    try {
      final customer = await _repository.update(id, request);

      emit(
        CustomerFormState(
          success: CustomerFormSuccess(
            customer: customer,
            isDuplicate: false,
            requiresIysVerification: phoneChanged,
            iysCodeExpiresAt:
                phoneChanged ? DateTime.now().add(_defaultIysCodeLifetime) : null,
          ),
        ),
      );
    } on ApiException catch (e) {
      emit(
        CustomerFormState(
          status: CustomerFormStatus.failure,
          errorMessage: e.detail ?? e.message,
          fieldErrors: e.fieldErrors,
        ),
      );
    }
  }
}
