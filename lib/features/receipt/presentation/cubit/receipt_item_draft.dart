import 'package:flutter/widgets.dart';

import '../../../../core/utils/tr_decimal.dart';
import '../../../catalog/data/dto/service_price_option_dto.dart';
import '../../../work_order/data/dto/consumable_line_dto.dart';
import '../../data/dto/create_receipt_request_dto.dart';

class DraftService {
  const DraftService({
    required this.servicePriceId,
    required this.serviceName,
    required this.price,
  });

  final int servicePriceId;
  final String serviceName;
  final double price;
}

class DraftConsumable {
  DraftConsumable({
    required this.consumableProductId,
    required this.productName,
    required this.unitPrice,
    required this.quantity,
  });

  final int consumableProductId;
  final String productName;
  final double unitPrice;
  int quantity;

  double get lineTotal => unitPrice * quantity;
}

/// Fiş formundaki tek bir ürünün (çiftin) düzenlenebilir hali. Controller'ları
/// sahibi olan sayfa [dispose] eder.
class ReceiptItemDraft {
  ReceiptItemDraft({
    this.categoryId,
    this.categoryPath,
    Map<int, DraftService>? services,
    List<DraftConsumable>? consumables,
    String? brand,
    String? color,
    String? material,
    String? price,
    this.priceManuallyEdited = false,
  })  : services = services ?? <int, DraftService>{},
        consumables = consumables ?? <DraftConsumable>[],
        brand = TextEditingController(text: brand),
        color = TextEditingController(text: color),
        material = TextEditingController(text: material),
        description = TextEditingController(),
        damages = TextEditingController(),
        price = TextEditingController(text: price ?? '0.00');

  int? categoryId;
  String? categoryPath;
  List<ServicePriceOptionDto> availableServices = const [];
  final Map<int, DraftService> services;
  final List<DraftConsumable> consumables;
  final TextEditingController brand;
  final TextEditingController color;
  final TextEditingController material;
  final TextEditingController description;
  final TextEditingController damages;
  final TextEditingController price;
  bool priceManuallyEdited;
  bool expanded = true;

  double get suggestedTotal =>
      services.values.fold<double>(0, (sum, s) => sum + s.price) +
      consumables.fold<double>(0, (sum, c) => sum + c.lineTotal);

  double? get parsedPrice => parseTrDecimal(price.text);

  /// Fiyat elle değiştirilmediyse önerilen toplamla eşitlenir.
  void syncPriceWithSuggested() {
    if (!priceManuallyEdited) {
      price.text = suggestedTotal.toStringAsFixed(2);
    }
  }

  /// "Son çifti kopyala": tür, hizmetler, sarf, marka/renk/malzeme ve fiyat
  /// taşınır; açıklama ve hasar her çifte özeldir, boş başlar.
  ReceiptItemDraft copyForNext() {
    final copy = ReceiptItemDraft(
      categoryId: categoryId,
      categoryPath: categoryPath,
      services: Map.of(services),
      consumables: consumables
          .map(
            (c) => DraftConsumable(
              consumableProductId: c.consumableProductId,
              productName: c.productName,
              unitPrice: c.unitPrice,
              quantity: c.quantity,
            ),
          )
          .toList(),
      brand: brand.text,
      color: color.text,
      material: material.text,
      price: price.text,
      priceManuallyEdited: priceManuallyEdited,
    );
    copy.availableServices = availableServices;
    return copy;
  }

  /// Tek satırlık kapalı kart özeti: "Sneakers Ayakkabı · Nike · Beyaz".
  String get summary {
    final parts = <String>[
      if (categoryPath != null) categoryPath!.split(' > ').last,
      if (brand.text.trim().isNotEmpty) brand.text.trim(),
      if (color.text.trim().isNotEmpty) color.text.trim(),
    ];
    return parts.isEmpty ? 'Ürün türü seçilmedi' : parts.join(' · ');
  }

  ReceiptItemRequestDto toRequest() => ReceiptItemRequestDto(
        categoryId: categoryId!,
        brand: _orNull(brand),
        color: _orNull(color),
        material: _orNull(material),
        description: _orNull(description),
        existingDamages: _orNull(damages),
        servicePriceIds: services.keys.toList(),
        consumables: consumables
            .map(
              (c) => ConsumableLineDto(
                consumableProductId: c.consumableProductId,
                quantity: c.quantity,
              ),
            )
            .toList(),
        price: parsedPrice!,
      );

  void dispose() {
    brand.dispose();
    color.dispose();
    material.dispose();
    description.dispose();
    damages.dispose();
    price.dispose();
  }

  static String? _orNull(TextEditingController c) {
    final value = c.text.trim();
    return value.isEmpty ? null : value;
  }
}
