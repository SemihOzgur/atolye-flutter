import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/network/api_exception.dart';
import '../../data/customer_repository.dart';
import 'customer_search_state.dart';

class CustomerSearchCubit extends Cubit<CustomerSearchState> {
  CustomerSearchCubit(this._repository) : super(const CustomerSearchState());

  final ICustomerRepository _repository;

  Future<void> search(String query) async {
    await _load(query: query, page: 1);
  }

  Future<void> goToPage(int page) async {
    await _load(query: state.query, page: page);
  }

  Future<void> _load({required String query, required int page}) async {
    emit(
      CustomerSearchState(
        status: CustomerSearchStatus.loading,
        query: query,
        page: page,
        pageSize: state.pageSize,
        items: state.items,
        totalCount: state.totalCount,
      ),
    );

    try {
      final result = await _repository.search(
        search: query.isEmpty ? null : query,
        page: page,
        pageSize: state.pageSize,
      );

      emit(
        CustomerSearchState(
          status: CustomerSearchStatus.loaded,
          query: query,
          page: result.page,
          pageSize: result.pageSize,
          items: result.items,
          totalCount: result.totalCount,
        ),
      );
    } on ApiException catch (e) {
      emit(
        CustomerSearchState(
          status: CustomerSearchStatus.error,
          query: query,
          page: page,
          pageSize: state.pageSize,
          errorMessage: e.detail ?? e.message,
        ),
      );
    }
  }
}
