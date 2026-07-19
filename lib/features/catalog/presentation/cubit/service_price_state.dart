import 'service_price_row.dart';

enum ServicePriceStatus { idle, loading, loaded, error, saving }

class ServicePriceState {
  const ServicePriceState({
    this.status = ServicePriceStatus.idle,
    this.selectedCategoryId,
    this.selectedCategoryPath,
    this.rows = const <ServicePriceRow>[],
    this.errorMessage,
  });

  final ServicePriceStatus status;
  final int? selectedCategoryId;
  final String? selectedCategoryPath;
  final List<ServicePriceRow> rows;
  final String? errorMessage;
}
