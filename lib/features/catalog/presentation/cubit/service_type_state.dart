import '../../data/dto/service_type_dto.dart';

enum ServiceTypeStatus { loading, loaded, error }

class ServiceTypeState {
  const ServiceTypeState({
    this.status = ServiceTypeStatus.loading,
    this.items = const <ServiceTypeDto>[],
    this.errorMessage,
  });

  final ServiceTypeStatus status;
  final List<ServiceTypeDto> items;
  final String? errorMessage;
}
