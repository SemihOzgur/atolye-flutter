import '../../data/dto/customer_dto.dart';

enum CustomerSearchStatus { idle, loading, loaded, error }

class CustomerSearchState {
  const CustomerSearchState({
    this.status = CustomerSearchStatus.idle,
    this.query = '',
    this.page = 1,
    this.pageSize = 20,
    this.items = const <CustomerDto>[],
    this.totalCount = 0,
    this.errorMessage,
  });

  final CustomerSearchStatus status;
  final String query;
  final int page;
  final int pageSize;
  final List<CustomerDto> items;
  final int totalCount;
  final String? errorMessage;

  bool get hasNextPage => page * pageSize < totalCount;

  bool get hasPreviousPage => page > 1;
}
