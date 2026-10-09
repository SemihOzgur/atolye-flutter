import 'package:flutter/material.dart';

import '../../../../core/theme/app_dimensions.dart';
import '../../../../core/utils/currency_formatter.dart';
import '../../../catalog/data/dto/consumable_group_dto.dart';
import '../../../catalog/data/dto/consumable_product_dto.dart';
import '../cubit/receipt_item_draft.dart';

/// Grup filtresi + ürün + adet seçimi; seçilen satırı döner (vazgeçilirse null).
class ConsumablePickerDialog extends StatefulWidget {
  const ConsumablePickerDialog({
    super.key,
    required this.groups,
    required this.loadProducts,
  });

  final List<ConsumableGroupDto> groups;
  final Future<List<ConsumableProductDto>> Function(int? groupId) loadProducts;

  static Future<DraftConsumable?> show(
    BuildContext context, {
    required List<ConsumableGroupDto> groups,
    required Future<List<ConsumableProductDto>> Function(int? groupId)
        loadProducts,
  }) {
    return showDialog<DraftConsumable>(
      context: context,
      builder: (_) =>
          ConsumablePickerDialog(groups: groups, loadProducts: loadProducts),
    );
  }

  @override
  State<ConsumablePickerDialog> createState() => _ConsumablePickerDialogState();
}

class _ConsumablePickerDialogState extends State<ConsumablePickerDialog> {
  int? _groupId;
  int? _productId;
  int _quantity = 1;
  List<ConsumableProductDto> _products = const [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() => _loading = true);
    final products = await widget.loadProducts(_groupId);
    if (!mounted) return;
    setState(() {
      _products = products;
      _productId = products.isEmpty ? null : products.first.id;
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Sarf Malzeme Ekle'),
      content: SizedBox(
        width: 420,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (widget.groups.isNotEmpty)
              DropdownButtonFormField<int?>(
                initialValue: _groupId,
                decoration: const InputDecoration(labelText: 'Grup'),
                items: [
                  const DropdownMenuItem(value: null, child: Text('Tüm gruplar')),
                  ...widget.groups.map(
                    (group) =>
                        DropdownMenuItem(value: group.id, child: Text(group.name)),
                  ),
                ],
                onChanged: (value) {
                  _groupId = value;
                  _load();
                },
              ),
            const SizedBox(height: AppDimensions.spaceS),
            if (_loading)
              const Padding(
                padding: EdgeInsets.all(AppDimensions.spaceM),
                child: CircularProgressIndicator(),
              )
            else if (_products.isEmpty)
              const Text('Bu grupta ürün bulunamadı.')
            else
              DropdownButtonFormField<int>(
                key: ValueKey(_groupId),
                initialValue: _productId,
                isExpanded: true,
                decoration: const InputDecoration(labelText: 'Ürün'),
                items: _products
                    .map(
                      (product) => DropdownMenuItem(
                        value: product.id,
                        child: Text(
                          '${product.displayName} — '
                          '${CurrencyFormatter.format(product.salePrice)}',
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    )
                    .toList(),
                onChanged: (value) => setState(() => _productId = value),
              ),
            const SizedBox(height: AppDimensions.spaceS),
            Row(
              children: [
                const Text('Adet:'),
                const SizedBox(width: AppDimensions.spaceM),
                IconButton(
                  onPressed:
                      _quantity > 1 ? () => setState(() => _quantity--) : null,
                  icon: const Icon(Icons.remove_circle_outline),
                ),
                Text('$_quantity'),
                IconButton(
                  onPressed: () => setState(() => _quantity++),
                  icon: const Icon(Icons.add_circle_outline),
                ),
              ],
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Vazgeç'),
        ),
        TextButton(
          onPressed: _productId == null
              ? null
              : () {
                  final product =
                      _products.firstWhere((item) => item.id == _productId);
                  Navigator.of(context).pop(
                    DraftConsumable(
                      consumableProductId: product.id,
                      productName: product.displayName,
                      unitPrice: product.salePrice,
                      quantity: _quantity,
                    ),
                  );
                },
          child: const Text('Ekle'),
        ),
      ],
    );
  }
}
