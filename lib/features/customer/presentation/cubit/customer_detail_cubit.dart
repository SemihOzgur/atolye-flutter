import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/network/api_exception.dart';
import '../../data/customer_repository.dart';
import 'customer_detail_state.dart';

class CustomerDetailCubit extends Cubit<CustomerDetailState> {
  CustomerDetailCubit(this._repository, this.customerId)
      : super(const CustomerDetailState());

  final ICustomerRepository _repository;
  final int customerId;

  Future<void> load() async {
    emit(const CustomerDetailState());

    try {
      final detail = await _repository.fetchDetail(customerId);
      emit(CustomerDetailState(status: CustomerDetailStatus.loaded, detail: detail));
    } on ApiException catch (e) {
      emit(
        CustomerDetailState(
          status: CustomerDetailStatus.error,
          errorMessage: e.detail ?? e.message,
        ),
      );
    }
  }
}
