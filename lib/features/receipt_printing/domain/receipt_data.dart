import '../../work_order/data/dto/work_order_dto.dart';
import '../../work_order/presentation/widgets/work_order_status_badge.dart';

/// `WorkOrderDto` → fiş alanları. Saf eşleme, IO yok — testlenebilir.
class ReceiptData {
  const ReceiptData({
    required this.orderNumber,
    required this.customerName,
    required this.phone,
    required this.categoryPath,
    this.brand,
    this.color,
    this.material,
    this.description,
    this.existingDamages,
    required this.createdAt,
    this.estimatedDeliveryDate,
    required this.statusLabel,
    this.trackingUrl,
    required this.printedAt,
    this.serviceNames = const [],
    this.consumableNames = const [],
    required this.totalPrice,
    this.prepaymentAmount,
    required this.remainingAmount,
  });

  factory ReceiptData.fromWorkOrder(
    WorkOrderDto dto, {
    required bool maskPhone,
    required DateTime printedAt,
  }) {
    return ReceiptData(
      orderNumber: dto.orderNumber,
      customerName: '${dto.customer.firstName} ${dto.customer.lastName}',
      phone: maskPhone
          ? maskPhoneNumber(dto.customer.phone)
          : dto.customer.phone,
      categoryPath: dto.categoryPath,
      brand: dto.brand,
      color: dto.color,
      material: dto.material,
      description: dto.description,
      existingDamages: dto.existingDamages,
      createdAt: dto.createdAt,
      estimatedDeliveryDate: dto.estimatedDeliveryDate,
      // WorkOrderStatusBadge ile aynı TR etiketleme — tek kaynak.
      statusLabel: WorkOrderStatusBadge.presentationFor(dto.status).label,
      trackingUrl: dto.trackingUrl,
      printedAt: printedAt,
      serviceNames: dto.services.map((s) => s.serviceName).toList(),
      consumableNames: dto.consumables.map((c) => c.productName).toList(),
      totalPrice: dto.price,
      prepaymentAmount: dto.hasPrepayment ? dto.prepaymentAmount : null,
      remainingAmount: dto.remainingAmount,
    );
  }

  /// Barkod içeriği DE bu — F5 mobil tarayıcı sözleşmesi.
  final String orderNumber;
  final String customerName;
  final String phone;
  final String categoryPath;
  final String? brand;
  final String? color;
  final String? material;
  final String? description;
  final String? existingDamages;
  final DateTime createdAt;
  final DateTime? estimatedDeliveryDate;
  final String statusLabel;
  final String? trackingUrl;
  final DateTime printedAt;
  final List<String> serviceNames;
  final List<String> consumableNames;
  final double totalPrice;
  final double? prepaymentAmount;
  final double remainingAmount;
}

/// "+905321234567" / "05321234567" → "0532 *** ** 67". Beklenmeyen
/// uzunlukta girdi gelirse (10 haneli TR mobil formatına indirgenemezse)
/// değeri olduğu gibi döner — fiş üretimini asla engellemez.
String maskPhoneNumber(String phone) {
  final digits = phone.replaceAll(RegExp(r'\D'), '');
  final String local;
  if (digits.length == 12 && digits.startsWith('90')) {
    local = '0${digits.substring(2)}';
  } else if (digits.length == 11 && digits.startsWith('0')) {
    local = digits;
  } else if (digits.length == 10) {
    local = '0$digits';
  } else {
    return phone;
  }

  final areaAndPrefix = local.substring(0, 4);
  final lastTwo = local.substring(9);
  return '$areaAndPrefix *** ** $lastTwo';
}
