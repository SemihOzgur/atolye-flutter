import 'package:flutter_test/flutter_test.dart';
import 'package:leather_care_admin/features/receipt/presentation/cubit/receipt_item_draft.dart';

void main() {
  ReceiptItemDraft filledDraft() {
    final draft = ReceiptItemDraft(
      categoryId: 9,
      categoryPath: 'Kadın > Ayakkabı > Sneakers Ayakkabı',
      brand: 'Nike',
      color: 'Beyaz',
    );
    draft.services[3] = const DraftService(
      servicePriceId: 3,
      serviceName: 'Bakım ve Boya',
      price: 1250,
    );
    draft.consumables.add(
      DraftConsumable(
        consumableProductId: 5,
        productName: 'Krem',
        unitPrice: 150,
        quantity: 2,
      ),
    );
    draft.description.text = 'Sol teki solmuş';
    draft.syncPriceWithSuggested();
    return draft;
  }

  test('price follows the suggested total until edited manually', () {
    final draft = filledDraft();
    expect(draft.suggestedTotal, 1550);
    expect(draft.price.text, '1550.00');

    draft.priceManuallyEdited = true;
    draft.price.text = '1400';
    draft.services.clear();
    draft.syncPriceWithSuggested();
    expect(draft.price.text, '1400');
  });

  test('copyForNext keeps type/services/brand but not per-pair notes', () {
    final draft = filledDraft();
    final copy = draft.copyForNext();

    expect(copy.categoryId, 9);
    expect(copy.services.keys, [3]);
    expect(copy.consumables.single.quantity, 2);
    expect(copy.brand.text, 'Nike');
    expect(copy.price.text, '1550.00');
    expect(copy.description.text, isEmpty);

    // Bağımsız: kopyadaki değişiklik aslını etkilemez
    copy.consumables.single.quantity = 5;
    copy.services.clear();
    expect(draft.consumables.single.quantity, 2);
    expect(draft.services, isNotEmpty);
  });

  test('summary and toRequest', () {
    final draft = filledDraft();
    expect(draft.summary, 'Sneakers Ayakkabı · Nike · Beyaz');

    final request = draft.toRequest();
    expect(request.categoryId, 9);
    expect(request.brand, 'Nike');
    expect(request.material, isNull);
    expect(request.description, 'Sol teki solmuş');
    expect(request.servicePriceIds, [3]);
    expect(request.price, 1550);

    expect(ReceiptItemDraft().summary, 'Ürün türü seçilmedi');
  });
}
