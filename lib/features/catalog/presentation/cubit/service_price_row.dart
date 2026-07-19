class ServicePriceRow {
  const ServicePriceRow({
    required this.serviceTypeId,
    required this.serviceName,
    required this.price,
    required this.isActive,
    this.servicePriceId,
  });

  final int serviceTypeId;
  final String serviceName;
  final double price;
  final bool isActive;
  final int? servicePriceId;

  bool get hasExistingPrice => servicePriceId != null;

  ServicePriceRow copyWith({double? price, bool? isActive}) {
    return ServicePriceRow(
      serviceTypeId: serviceTypeId,
      serviceName: serviceName,
      price: price ?? this.price,
      isActive: isActive ?? this.isActive,
      servicePriceId: servicePriceId,
    );
  }
}
