/// Backend `ReceiptResponse` JSON'unun birebir örneği (ReceiptsController).
Map<String, dynamic> receiptJson({
  List<Map<String, dynamic>>? items,
  double remainingAmount = 1200,
}) {
  return <String, dynamic>{
    'id': 7,
    'receiptNumber': 'FS-2026-000042',
    'customer': <String, dynamic>{
      'id': 1,
      'firstName': 'Ayşe',
      'lastName': 'Yılmaz',
      'phone': '+905321234567',
      'email': null,
      'address': null,
      'iysConsentStatus': 'APPROVED',
      'iysConsentAt': null,
      'createdAt': '2026-10-01T10:00:00Z',
    },
    'trackingUrl': 'https://dotikadbm.com/t/receipt-token',
    'createdAt': '2026-10-09T09:30:00Z',
    'totalPrice': 1500.0,
    'prepaymentAmount': 300.0,
    'collectedAmount': 0.0,
    'remainingAmount': remainingAmount,
    'readyCount': 1,
    'activeCount': 2,
    'items': items ??
        <Map<String, dynamic>>[
          itemJson(id: 11, status: 'READY', price: 1000),
          itemJson(id: 12, status: 'IN_PROGRESS', price: 500, brand: 'Puma'),
        ],
    'smsHistory': <Map<String, dynamic>>[
      <String, dynamic>{
        'smsType': 'ORDER_RECEIVED',
        'status': 'SENT',
        'createdAt': '2026-10-09T09:35:00Z',
        'errorMessage': null,
      },
    ],
  };
}

Map<String, dynamic> itemJson({
  required int id,
  required String status,
  double price = 100,
  String? brand = 'Nike',
}) {
  return <String, dynamic>{
    'id': id,
    'orderNumber': 'WO-2026-0000$id',
    'categoryPath': 'Kadın > Ayakkabı > Sneakers Ayakkabı',
    'brand': brand,
    'color': 'Beyaz',
    'material': 'Deri',
    'description': 'Dikiş-Yapıştırma-Boya',
    'existingDamages': 'Burunda çizik',
    'estimatedDeliveryDate': '2026-10-15',
    'serviceNames': <String>['Bakım ve Boya'],
    'consumableNames': <String>['Deri Bakım Kremi x2'],
    'price': price,
    'prepaymentAmount': 150.0,
    'finalPaymentAmount': null,
    'status': status,
    'mediaCount': 3,
    'updatedAt': '2026-10-09T09:30:00Z',
  };
}
