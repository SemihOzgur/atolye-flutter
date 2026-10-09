import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/app_routes.dart';
import '../../../../core/di/injection.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_decorations.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../../../core/utils/currency_formatter.dart';
import '../../../../core/utils/tr_decimal.dart';
import '../../../catalog/data/catalog_repository.dart';
import '../../../catalog/data/dto/category_tree_dto.dart';
import '../../../customer/data/customer_repository.dart';
import '../../data/dto/create_receipt_request_dto.dart';
import '../../data/receipt_repository.dart';
import '../cubit/receipt_form_cubit.dart';
import '../cubit/receipt_item_draft.dart';
import '../widgets/consumable_picker_dialog.dart';

class _Level3Category {
  const _Level3Category({required this.id, required this.path});

  final int id;
  final String path;
}

List<_Level3Category> _flattenLevel3(
  List<CategoryTreeDto> nodes, [
  String prefix = '',
]) {
  final result = <_Level3Category>[];
  for (final node in nodes) {
    final path = prefix.isEmpty ? node.name : '$prefix > ${node.name}';
    if (node.level == 3) {
      result.add(_Level3Category(id: node.id, path: path));
    } else {
      result.addAll(_flattenLevel3(node.children, path));
    }
  }
  return result;
}

/// Yeni Fiş: müşteri bir kez seçilir, ürünler (çiftler) alt alta kart olarak
/// eklenir; kayıtta her ürün ayrı iş emri olur, SMS/fiş/takip linki tektir.
/// Tek ürünlük sipariş de bu formdan açılır. Masaüstü ve mobil ortak;
/// [showAppBar] mobil rotada (kabuk dışı) geri butonu için açılır.
class ReceiptFormPage extends StatelessWidget {
  const ReceiptFormPage({
    super.key,
    required this.customerId,
    this.showAppBar = false,
  });

  final int customerId;
  final bool showAppBar;

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ReceiptFormCubit>(
      create: (_) => ReceiptFormCubit(
        getIt<ICatalogRepository>(),
        getIt<IReceiptRepository>(),
        getIt<ICustomerRepository>(),
      )..load(customerId),
      child: _ReceiptFormView(customerId: customerId, showAppBar: showAppBar),
    );
  }
}

class _ReceiptFormView extends StatefulWidget {
  const _ReceiptFormView({required this.customerId, required this.showAppBar});

  final int customerId;
  final bool showAppBar;

  @override
  State<_ReceiptFormView> createState() => _ReceiptFormViewState();
}

class _ReceiptFormViewState extends State<_ReceiptFormView> {
  final List<ReceiptItemDraft> _items = [ReceiptItemDraft()];
  final TextEditingController _prepaymentController = TextEditingController();
  DateTime? _estimatedDeliveryDate;
  bool _hasPrepayment = false;

  @override
  void dispose() {
    for (final item in _items) {
      item.dispose();
    }
    _prepaymentController.dispose();
    super.dispose();
  }

  double get _total =>
      _items.fold<double>(0, (sum, item) => sum + (item.parsedPrice ?? 0));

  double get _prepayment =>
      _hasPrepayment ? (parseTrDecimal(_prepaymentController.text) ?? 0) : 0;

  void _addItem({bool copyLast = false}) {
    setState(() {
      for (final item in _items) {
        item.expanded = false;
      }
      _items.add(copyLast ? _items.last.copyForNext() : ReceiptItemDraft());
      _items.last.expanded = true;
    });
  }

  void _removeItem(ReceiptItemDraft item) {
    setState(() {
      _items.remove(item);
      item.dispose();
      if (_items.isEmpty) _items.add(ReceiptItemDraft());
    });
  }

  Future<void> _selectCategory(ReceiptItemDraft item, _Level3Category category) async {
    setState(() {
      item.categoryId = category.id;
      item.categoryPath = category.path;
      item.services.clear();
      item.availableServices = const [];
      item.syncPriceWithSuggested();
    });
    final services =
        await context.read<ReceiptFormCubit>().servicesFor(category.id);
    if (!mounted || item.categoryId != category.id) return;
    setState(() => item.availableServices = services);
  }

  Future<void> _addConsumable(ReceiptItemDraft item) async {
    final cubit = context.read<ReceiptFormCubit>();
    final line = await ConsumablePickerDialog.show(
      context,
      groups: cubit.state.consumableGroups,
      loadProducts: (groupId) => cubit.consumableProducts(groupId: groupId),
    );
    if (line == null || !mounted) return;
    setState(() {
      item.consumables.add(line);
      item.syncPriceWithSuggested();
    });
  }

  Future<void> _pickDeliveryDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _estimatedDeliveryDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null) {
      setState(() => _estimatedDeliveryDate = picked);
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  Future<void> _submit() async {
    for (var i = 0; i < _items.length; i++) {
      final item = _items[i];
      if (item.categoryId == null) {
        setState(() => item.expanded = true);
        _showError('Ürün ${i + 1}: ürün türü seçin.');
        return;
      }
      if (item.parsedPrice == null) {
        setState(() => item.expanded = true);
        _showError('Ürün ${i + 1}: geçerli bir fiyat girin.');
        return;
      }
    }

    double? prepayment;
    if (_hasPrepayment) {
      prepayment = parseTrDecimal(_prepaymentController.text);
      if (prepayment == null || prepayment > _total) {
        _showError('Ön ödeme 0 ile fiş toplamı arasında olmalıdır.');
        return;
      }
    }

    final receipt = await context.read<ReceiptFormCubit>().submit(
          CreateReceiptRequestDto(
            customerId: widget.customerId,
            estimatedDeliveryDate: _estimatedDeliveryDate,
            items: _items.map((item) => item.toRequest()).toList(),
            prepaymentAmount: prepayment,
          ),
        );
    if (receipt != null && mounted) {
      context.go('${AppRoutes.receipts}/${receipt.id}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ReceiptFormCubit, ReceiptFormState>(
      builder: (context, state) {
        final categories = _flattenLevel3(state.categoryTree);
        final isSubmitting =
            state.submitStatus == ReceiptFormSubmitStatus.submitting;
        final customer = state.customer;

        final content = ListView(
          padding: const EdgeInsets.all(AppDimensions.spaceL),
          children: [
            if (!widget.showAppBar) ...[
              Text('Yeni Fiş', style: Theme.of(context).textTheme.headlineMedium),
              const SizedBox(height: AppDimensions.spaceM),
            ],
            Text(
              customer == null
                  ? 'Müşteri yükleniyor…'
                  : 'Müşteri: ${customer.firstName} ${customer.lastName} · '
                      '${customer.phone}',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: AppDimensions.spaceXs),
            Row(
              children: [
                Expanded(
                  child: Text(
                    _estimatedDeliveryDate == null
                        ? 'Tahmini teslim seçilmedi (tüm ürünler için)'
                        : 'Tahmini teslim: ${_formatDate(_estimatedDeliveryDate!)}'
                            ' (tüm ürünler için)',
                  ),
                ),
                TextButton(
                  onPressed: _pickDeliveryDate,
                  child: const Text('Tarih Seç'),
                ),
              ],
            ),
            const SizedBox(height: AppDimensions.spaceM),
            for (var i = 0; i < _items.length; i++)
              _ItemCard(
                key: ObjectKey(_items[i]),
                index: i,
                item: _items[i],
                categories: categories,
                canRemove: _items.length > 1,
                onToggle: () =>
                    setState(() => _items[i].expanded = !_items[i].expanded),
                onRemove: () => _removeItem(_items[i]),
                onCategory: (category) => _selectCategory(_items[i], category),
                onAddConsumable: () => _addConsumable(_items[i]),
                onChanged: () => setState(() {}),
              ),
            const SizedBox(height: AppDimensions.spaceS),
            Wrap(
              spacing: AppDimensions.spaceS,
              runSpacing: AppDimensions.spaceS,
              children: [
                OutlinedButton.icon(
                  onPressed: () => _addItem(),
                  icon: const Icon(Icons.add_rounded),
                  label: const Text('Ürün Ekle'),
                ),
                OutlinedButton.icon(
                  onPressed: () => _addItem(copyLast: true),
                  icon: const Icon(Icons.copy_rounded),
                  label: const Text('Son ürünü kopyala'),
                ),
              ],
            ),
            const SizedBox(height: AppDimensions.spaceL),
            _SummaryCard(
              itemCount: _items.length,
              total: _total,
              prepayment: _prepayment,
              hasPrepayment: _hasPrepayment,
              prepaymentController: _prepaymentController,
              onPrepaymentToggle: (value) =>
                  setState(() => _hasPrepayment = value),
              onPrepaymentChanged: () => setState(() {}),
            ),
            if (state.errorMessage != null) ...[
              const SizedBox(height: AppDimensions.spaceM),
              Container(
                padding: const EdgeInsets.all(AppDimensions.spaceM),
                decoration: BoxDecoration(
                  color: AppColors.error.withValues(alpha: 0.1),
                  borderRadius: AppDecorations.borderRadiusL,
                ),
                child: Text(
                  state.errorMessage!,
                  style: const TextStyle(color: AppColors.error),
                ),
              ),
            ],
            const SizedBox(height: AppDimensions.spaceM),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: isSubmitting ? null : _submit,
                child: isSubmitting
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: AppColors.onPrimary,
                        ),
                      )
                    : Text(
                        _items.length == 1
                            ? 'Kaydet'
                            : '${_items.length} Ürünü Kaydet',
                      ),
              ),
            ),
          ],
        );

        return Scaffold(
          appBar: widget.showAppBar
              ? AppBar(title: const Text('Yeni Fiş'))
              : null,
          body: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 820),
              child: content,
            ),
          ),
        );
      },
    );
  }
}

String _formatDate(DateTime date) =>
    '${date.day.toString().padLeft(2, '0')}.'
    '${date.month.toString().padLeft(2, '0')}.${date.year}';

class _ItemCard extends StatelessWidget {
  const _ItemCard({
    super.key,
    required this.index,
    required this.item,
    required this.categories,
    required this.canRemove,
    required this.onToggle,
    required this.onRemove,
    required this.onCategory,
    required this.onAddConsumable,
    required this.onChanged,
  });

  final int index;
  final ReceiptItemDraft item;
  final List<_Level3Category> categories;
  final bool canRemove;
  final VoidCallback onToggle;
  final VoidCallback onRemove;
  final ValueChanged<_Level3Category> onCategory;
  final VoidCallback onAddConsumable;
  final VoidCallback onChanged;

  @override
  Widget build(BuildContext context) {
    final price = item.parsedPrice;
    return Card(
      margin: const EdgeInsets.only(bottom: AppDimensions.spaceS),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            onTap: onToggle,
            leading: CircleAvatar(radius: 14, child: Text('${index + 1}')),
            title: Text(item.summary, overflow: TextOverflow.ellipsis),
            subtitle: price == null ? null : Text(CurrencyFormatter.format(price)),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (canRemove)
                  IconButton(
                    tooltip: 'Ürünü kaldır',
                    icon: const Icon(Icons.delete_outline),
                    onPressed: onRemove,
                  ),
                Icon(item.expanded ? Icons.expand_less : Icons.expand_more),
              ],
            ),
          ),
          if (item.expanded)
            Padding(
              padding: const EdgeInsets.fromLTRB(
                AppDimensions.spaceM,
                0,
                AppDimensions.spaceM,
                AppDimensions.spaceM,
              ),
              child: _ItemFields(
                item: item,
                categories: categories,
                onCategory: onCategory,
                onAddConsumable: onAddConsumable,
                onChanged: onChanged,
              ),
            ),
        ],
      ),
    );
  }
}

class _ItemFields extends StatelessWidget {
  const _ItemFields({
    required this.item,
    required this.categories,
    required this.onCategory,
    required this.onAddConsumable,
    required this.onChanged,
  });

  final ReceiptItemDraft item;
  final List<_Level3Category> categories;
  final ValueChanged<_Level3Category> onCategory;
  final VoidCallback onAddConsumable;
  final VoidCallback onChanged;

  @override
  Widget build(BuildContext context) {
    final titleStyle = Theme.of(context).textTheme.titleSmall;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Ürün Türü', style: titleStyle),
        DropdownButton<int>(
          isExpanded: true,
          hint: const Text('Ürün türü seçin'),
          value: categories.any((c) => c.id == item.categoryId)
              ? item.categoryId
              : null,
          items: categories
              .map(
                (category) => DropdownMenuItem(
                  value: category.id,
                  child: Text(category.path, overflow: TextOverflow.ellipsis),
                ),
              )
              .toList(),
          onChanged: (id) {
            if (id == null) return;
            onCategory(categories.firstWhere((c) => c.id == id));
          },
        ),
        const SizedBox(height: AppDimensions.spaceS),
        Text('Hizmetler', style: titleStyle),
        const SizedBox(height: AppDimensions.spaceXs),
        if (item.categoryId == null)
          const Text(
            'Önce ürün türü seçin.',
            style: TextStyle(color: AppColors.textMuted),
          )
        else if (item.availableServices.isEmpty)
          const Text(
            'Bu ürün türü için fiyatlandırılmış hizmet yok — '
            'tarifesiz iş olarak devam edilebilir.',
            style: TextStyle(color: AppColors.textMuted),
          )
        else
          Wrap(
            spacing: AppDimensions.spaceXs,
            runSpacing: AppDimensions.spaceXs,
            children: item.availableServices.map((service) {
              final selected = item.services.containsKey(service.servicePriceId);
              return FilterChip(
                label: Text(
                  '${service.serviceName} — '
                  '${CurrencyFormatter.format(service.price)}',
                ),
                selected: selected,
                onSelected: (isSelected) {
                  if (isSelected) {
                    item.services[service.servicePriceId] = DraftService(
                      servicePriceId: service.servicePriceId,
                      serviceName: service.serviceName,
                      price: service.price,
                    );
                  } else {
                    item.services.remove(service.servicePriceId);
                  }
                  item.syncPriceWithSuggested();
                  onChanged();
                },
              );
            }).toList(),
          ),
        const SizedBox(height: AppDimensions.spaceS),
        Row(
          children: [
            Expanded(child: Text('Sarf Malzemeler', style: titleStyle)),
            TextButton.icon(
              onPressed: onAddConsumable,
              icon: const Icon(Icons.add_rounded),
              label: const Text('Ekle'),
            ),
          ],
        ),
        ...item.consumables.map(
          (line) => ListTile(
            dense: true,
            contentPadding: EdgeInsets.zero,
            title: Text(line.productName),
            subtitle: Text(
              '${line.quantity} × ${CurrencyFormatter.format(line.unitPrice)} = '
              '${CurrencyFormatter.format(line.lineTotal)}',
            ),
            trailing: IconButton(
              icon: const Icon(Icons.delete_outline),
              onPressed: () {
                item.consumables.remove(line);
                item.syncPriceWithSuggested();
                onChanged();
              },
            ),
          ),
        ),
        const SizedBox(height: AppDimensions.spaceS),
        Wrap(
          spacing: AppDimensions.spaceS,
          runSpacing: AppDimensions.spaceS,
          children: [
            _field(item.brand, 'Marka', onChanged),
            _field(item.color, 'Renk', onChanged),
            _field(item.material, 'Malzeme', onChanged),
          ],
        ),
        const SizedBox(height: AppDimensions.spaceS),
        TextField(
          controller: item.description,
          decoration: const InputDecoration(labelText: 'Açıklama'),
          maxLines: 2,
        ),
        const SizedBox(height: AppDimensions.spaceS),
        TextField(
          controller: item.damages,
          decoration: const InputDecoration(labelText: 'Mevcut Hasarlar'),
          maxLines: 2,
        ),
        const SizedBox(height: AppDimensions.spaceS),
        Text(
          'Önerilen: ${CurrencyFormatter.format(item.suggestedTotal)}',
          style: const TextStyle(color: AppColors.textMuted),
        ),
        const SizedBox(height: AppDimensions.spaceXs),
        SizedBox(
          width: 220,
          child: TextField(
            controller: item.price,
            decoration: InputDecoration(
              labelText: 'Nihai Fiyat',
              errorText: item.parsedPrice == null ? 'Geçerli bir tutar girin' : null,
              helperText: item.parsedPrice == 0
                  ? 'Fiyat 0 — garanti/jest işi olarak kaydedilir'
                  : null,
            ),
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            inputFormatters: [trDecimalInputFormatter],
            onChanged: (_) {
              item.priceManuallyEdited = true;
              onChanged();
            },
          ),
        ),
      ],
    );
  }

  static Widget _field(
    TextEditingController controller,
    String label,
    VoidCallback onChanged,
  ) {
    return SizedBox(
      width: 220,
      child: TextField(
        controller: controller,
        decoration: InputDecoration(labelText: label),
        onChanged: (_) => onChanged(),
      ),
    );
  }
}

class _SummaryCard extends StatelessWidget {
  const _SummaryCard({
    required this.itemCount,
    required this.total,
    required this.prepayment,
    required this.hasPrepayment,
    required this.prepaymentController,
    required this.onPrepaymentToggle,
    required this.onPrepaymentChanged,
  });

  final int itemCount;
  final double total;
  final double prepayment;
  final bool hasPrepayment;
  final TextEditingController prepaymentController;
  final ValueChanged<bool> onPrepaymentToggle;
  final VoidCallback onPrepaymentChanged;

  @override
  Widget build(BuildContext context) {
    final remaining = (total - prepayment).clamp(0, double.infinity).toDouble();
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppDimensions.spaceM),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _row(context, '$itemCount ürün — Toplam', CurrencyFormatter.format(total),
                bold: true),
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('Ön ödeme alındı (fiş toplamı üzerinden)'),
              value: hasPrepayment,
              onChanged: onPrepaymentToggle,
            ),
            if (hasPrepayment)
              SizedBox(
                width: 220,
                child: TextField(
                  controller: prepaymentController,
                  decoration: InputDecoration(
                    labelText: 'Ön Ödeme Tutarı',
                    errorText: prepayment > total ? 'Toplamı aşamaz' : null,
                  ),
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  inputFormatters: [trDecimalInputFormatter],
                  onChanged: (_) => onPrepaymentChanged(),
                ),
              ),
            const SizedBox(height: AppDimensions.spaceS),
            _row(context, 'Kalan', CurrencyFormatter.format(remaining), bold: true),
          ],
        ),
      ),
    );
  }

  Widget _row(BuildContext context, String label, String value, {bool bold = false}) {
    final style = bold
        ? Theme.of(context).textTheme.titleMedium
        : Theme.of(context).textTheme.bodyMedium;
    return Row(
      children: [
        Expanded(child: Text(label, style: style)),
        Text(value, style: style),
      ],
    );
  }
}
