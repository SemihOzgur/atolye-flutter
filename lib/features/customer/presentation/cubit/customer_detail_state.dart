import '../../data/dto/customer_detail_dto.dart';

enum CustomerDetailStatus { loading, loaded, error }

class CustomerDetailState {
  const CustomerDetailState({
    this.status = CustomerDetailStatus.loading,
    this.detail,
    this.errorMessage,
  });

  final CustomerDetailStatus status;
  final CustomerDetailDto? detail;
  final String? errorMessage;
}
