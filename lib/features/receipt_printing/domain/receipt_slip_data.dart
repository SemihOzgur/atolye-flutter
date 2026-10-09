import '../../receipt/data/dto/receipt_dto.dart';
import '../../work_order/presentation/widgets/work_order_status_badge.dart';
import 'receipt_data.dart';

/// Çok kalemli fiş çıktısı — `ReceiptDto` → basılacak alanlar. Saf eşleme.
/// Barkod içeriği fiş numarasıdır (`FS-…`); mobil tarayıcı bunu fişe çözer.
class ReceiptSlipData {
  const ReceiptSlipData({
    required this.receiptNumber,
    required this.customerName,
    required this.phone,
    required this.createdAt,
    this.estimatedDeliveryDate,
    required this.items,
    required this.totalPrice,
    required this.prepaymentAmount,
    required this.collectedAmount,
    required this.remainingAmount,
    required this.trackingUrl,
    required this.printedAt,
  });

  factory ReceiptSlipData.fromReceipt(
    ReceiptDto dto, {
    required bool maskPhone,
    required DateTime printedAt,
  }) {
    final active = dto.items.where((i) => i.status != 'CANCELLED').toList();
    DateTime? eta;
    for (final item in active) {
      final date = item.estimatedDeliveryDate;
      if (date != null && (eta == null || date.isAfter(eta))) eta = date;
    }
    return ReceiptSlipData(
      receiptNumber: dto.receiptNumber,
      customerName: '${dto.customer.firstName} ${dto.customer.lastName}',
      phone: maskPhone ? maskPhoneNumber(dto.customer.phone) : dto.customer.phone,
      createdAt: dto.createdAt,
      estimatedDeliveryDate: eta,
      items: active
          .map(
            (item) => ReceiptSlipItem(
              productType: item.categoryPath.split(' > ').last,
              details: [item.brand, item.color, item.material]
                  .whereType<String>()
                  .join(' · '),
              existingDamages: item.existingDamages,
              serviceNames: item.serviceNames,
              consumableNames: item.consumableNames,
              price: item.price,
              statusLabel: WorkOrderStatusBadge.presentationFor(item.status).label,
            ),
          )
          .toList(),
      totalPrice: dto.totalPrice,
      prepaymentAmount: dto.prepaymentAmount,
      collectedAmount: dto.collectedAmount,
      remainingAmount: dto.remainingAmount,
      trackingUrl: dto.trackingUrl,
      printedAt: printedAt,
    );
  }

  final String receiptNumber;
  final String customerName;
  final String phone;
  final DateTime createdAt;
  final DateTime? estimatedDeliveryDate;
  final List<ReceiptSlipItem> items;
  final double totalPrice;
  final double prepaymentAmount;
  final double collectedAmount;
  final double remainingAmount;
  final String trackingUrl;
  final DateTime printedAt;
}

class ReceiptSlipItem {
  const ReceiptSlipItem({
    required this.productType,
    required this.details,
    this.existingDamages,
    this.serviceNames = const [],
    this.consumableNames = const [],
    required this.price,
    required this.statusLabel,
  });

  final String productType;
  final String details;
  final String? existingDamages;
  final List<String> serviceNames;
  final List<String> consumableNames;
  final double price;
  final String statusLabel;
}
