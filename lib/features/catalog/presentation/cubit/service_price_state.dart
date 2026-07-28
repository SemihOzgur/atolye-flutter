import 'service_price_row.dart';

enum ServicePriceStatus { idle, loading, loaded, error, saving }

class ServicePriceState {
  const ServicePriceState({
    this.status = ServicePriceStatus.idle,
    this.selectedCategoryId,
    this.selectedCategoryPath,
    this.rows = const <ServicePriceRow>[],
    this.errorMessage,
    this.invalidRowIds = const <int>{},
    this.reloadStamp = 0,
  });

  final ServicePriceStatus status;
  final int? selectedCategoryId;
  final String? selectedCategoryPath;
  final List<ServicePriceRow> rows;
  final String? errorMessage;

  /// `serviceTypeId`'leri parse edilemeyen (geçersiz) fiyat girdisine sahip
  /// satırların kümesi. Boş değilse Kaydet devre dışı bırakılır.
  final Set<int> invalidRowIds;

  /// Kategori değişiminde veya kaydet-sonrası yeniden yüklemede artan sayaç.
  /// `PriceRowField` yalnızca bu değer değiştiğinde controller'ını sunucu
  /// değeriyle tazeler; tuş vuruşu kaynaklı emit'ler alanı ezmez.
  final int reloadStamp;

  bool get canSave => invalidRowIds.isEmpty;
}
