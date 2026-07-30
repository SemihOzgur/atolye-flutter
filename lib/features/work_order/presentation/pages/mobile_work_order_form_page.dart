import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/app_routes.dart';
import '../../../../core/di/injection.dart';
import '../../../../core/network/field_error_resolver.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_decorations.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../../../core/utils/currency_formatter.dart';
import '../../../catalog/data/catalog_repository.dart';
import '../../../catalog/data/dto/category_tree_dto.dart';
import '../../data/dto/consumable_line_dto.dart';
import '../../data/dto/create_work_order_request_dto.dart';
import '../../data/work_order_repository.dart';
import '../cubit/work_order_form_cubit.dart';
import '../cubit/work_order_form_state.dart';

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

class _SelectedService {
  const _SelectedService({
    required this.servicePriceId,
    required this.serviceName,
    required this.price,
  });

  final int servicePriceId;
  final String serviceName;
  final double price;
}

class _ConsumableLineDraft {
  _ConsumableLineDraft({
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

/// Mobil ürün ekleme formu — masaüstü [WorkOrderFormPage] ile aynı
/// [WorkOrderFormCubit]/[IWorkOrderRepository]/[ICatalogRepository]'yi
/// paylaşır (Analiz §9.2: repository/cubit/DTO aynen kullanılabilir).
/// Widget ağacı tek kolon mobil düzen için yeniden yazılmıştır (Analiz
/// §9.3). Düzenleme (PUT) bu sprint kapsamı dışıdır — yalnızca oluşturma.
class MobileWorkOrderFormPage extends StatelessWidget {
  const MobileWorkOrderFormPage({super.key, required this.customerId});

  final int customerId;

  @override
  Widget build(BuildContext context) {
    return BlocProvider<WorkOrderFormCubit>(
      create: (_) => WorkOrderFormCubit(
        getIt<ICatalogRepository>(),
        getIt<IWorkOrderRepository>(),
      )
        ..loadCategoryTree()
        ..loadConsumableGroups(),
      child: _MobileWorkOrderFormView(customerId: customerId),
    );
  }
}

class _MobileWorkOrderFormView extends StatefulWidget {
  const _MobileWorkOrderFormView({required this.customerId});

  final int customerId;

  @override
  State<_MobileWorkOrderFormView> createState() =>
      _MobileWorkOrderFormViewState();
}

class _MobileWorkOrderFormViewState extends State<_MobileWorkOrderFormView> {
  int? _selectedCategoryId;
  final Map<int, _SelectedService> _selectedServices = {};
  final List<_ConsumableLineDraft> _consumableLines = [];

  final _brandController = TextEditingController();
  final _colorController = TextEditingController();
  final _materialController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _damagesController = TextEditingController();
  final _priceController = TextEditingController(text: '0.00');
  final _prepaymentController = TextEditingController();

  DateTime? _estimatedDeliveryDate;
  bool _hasPrepayment = false;
  bool _priceManuallyEdited = false;
  int? _consumableGroupFilter;

  @override
  void dispose() {
    _brandController.dispose();
    _colorController.dispose();
    _materialController.dispose();
    _descriptionController.dispose();
    _damagesController.dispose();
    _priceController.dispose();
    _prepaymentController.dispose();
    super.dispose();
  }

  double get _suggestedTotal {
    final servicesTotal =
        _selectedServices.values.fold<double>(0, (sum, s) => sum + s.price);
    final consumablesTotal =
        _consumableLines.fold<double>(0, (sum, c) => sum + c.lineTotal);
    return servicesTotal + consumablesTotal;
  }

  void _syncPriceWithSuggested() {
    if (!_priceManuallyEdited) {
      setState(() {
        _priceController.text = _suggestedTotal.toStringAsFixed(2);
      });
    }
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

  Future<void> _addConsumableLine(BuildContext context) async {
    final cubit = context.read<WorkOrderFormCubit>();
    await cubit.loadConsumableProducts(groupId: _consumableGroupFilter);

    if (!context.mounted) {
      return;
    }

    final products = cubit.state.consumableProducts;
    if (products.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Bu grupta ürün bulunamadı.')),
      );
      return;
    }

    final selected = await showDialog<_ConsumableLineDraft>(
      context: context,
      builder: (dialogContext) {
        var quantity = 1;
        int? productId = products.first.id;
        return StatefulBuilder(
          builder: (dialogContext, setDialogState) => AlertDialog(
            title: const Text('Sarf Malzeme Ekle'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                DropdownButtonFormField<int>(
                  initialValue: productId,
                  decoration: const InputDecoration(labelText: 'Ürün'),
                  items: products
                      .map(
                        (product) => DropdownMenuItem(
                          value: product.id,
                          child: Text(
                            '${product.displayName} — '
                            '${CurrencyFormatter.format(product.salePrice)}',
                          ),
                        ),
                      )
                      .toList(),
                  onChanged: (value) =>
                      setDialogState(() => productId = value),
                ),
                const SizedBox(height: AppDimensions.spaceM),
                Row(
                  children: [
                    const Text('Adet:'),
                    const SizedBox(width: AppDimensions.spaceM),
                    IconButton(
                      onPressed: quantity > 1
                          ? () => setDialogState(() => quantity--)
                          : null,
                      icon: const Icon(Icons.remove_circle_outline),
                    ),
                    Text('$quantity'),
                    IconButton(
                      onPressed: () => setDialogState(() => quantity++),
                      icon: const Icon(Icons.add_circle_outline),
                    ),
                  ],
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(dialogContext).pop(),
                child: const Text('Vazgeç'),
              ),
              TextButton(
                onPressed: productId == null
                    ? null
                    : () {
                        final product = products
                            .firstWhere((item) => item.id == productId);
                        Navigator.of(dialogContext).pop(
                          _ConsumableLineDraft(
                            consumableProductId: product.id,
                            productName: product.displayName,
                            unitPrice: product.salePrice,
                            quantity: quantity,
                          ),
                        );
                      },
                child: const Text('Ekle'),
              ),
            ],
          ),
        );
      },
    );

    if (selected != null) {
      setState(() => _consumableLines.add(selected));
      _syncPriceWithSuggested();
    }
  }

  Future<void> _submit(BuildContext context) async {
    if (_selectedCategoryId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Lütfen bir ürün türü seçin.')),
      );
      return;
    }

    final price = double.tryParse(_priceController.text.replaceAll(',', '.'));
    if (price == null || price < 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Geçerli bir fiyat girin.')),
      );
      return;
    }

    double? prepaymentAmount;
    if (_hasPrepayment) {
      prepaymentAmount =
          double.tryParse(_prepaymentController.text.replaceAll(',', '.'));
      if (prepaymentAmount == null ||
          prepaymentAmount < 0 ||
          prepaymentAmount > price) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Ön ödeme tutarı 0 ile nihai fiyat arasında olmalıdır.',
            ),
          ),
        );
        return;
      }
    }

    final cubit = context.read<WorkOrderFormCubit>();
    final consumables = _consumableLines
        .map(
          (line) => ConsumableLineDto(
            consumableProductId: line.consumableProductId,
            quantity: line.quantity,
          ),
        )
        .toList();

    final result = await cubit.submit(
      CreateWorkOrderRequestDto(
        customerId: widget.customerId,
        categoryId: _selectedCategoryId!,
        brand: _brandController.text.trim().isEmpty
            ? null
            : _brandController.text.trim(),
        color: _colorController.text.trim().isEmpty
            ? null
            : _colorController.text.trim(),
        material: _materialController.text.trim().isEmpty
            ? null
            : _materialController.text.trim(),
        description: _descriptionController.text.trim().isEmpty
            ? null
            : _descriptionController.text.trim(),
        existingDamages: _damagesController.text.trim().isEmpty
            ? null
            : _damagesController.text.trim(),
        estimatedDeliveryDate: _estimatedDeliveryDate,
        servicePriceIds: _selectedServices.keys.toList(),
        consumables: consumables,
        price: price,
        hasPrepayment: _hasPrepayment,
        prepaymentAmount: _hasPrepayment ? prepaymentAmount : null,
      ),
    );

    if (result != null && context.mounted) {
      context.go('${AppRoutes.workOrders}/${result.id}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Yeni Ürün')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppDimensions.spaceL),
        child: BlocBuilder<WorkOrderFormCubit, WorkOrderFormState>(
          builder: (context, state) {
            final level3Categories = _flattenLevel3(state.categoryTree);
            final isSubmitting =
                state.submitStatus == WorkOrderFormSubmitStatus.submitting;
            final fieldErrors = FieldErrorResolver(state.fieldErrors);

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Ürün Türü', style: Theme.of(context).textTheme.titleLarge),
                const SizedBox(height: AppDimensions.spaceS),
                DropdownButton<int>(
                  isExpanded: true,
                  hint: const Text('Ürün türü seçin'),
                  value: _selectedCategoryId,
                  items: level3Categories
                      .map(
                        (category) => DropdownMenuItem(
                          value: category.id,
                          child: Text(category.path),
                        ),
                      )
                      .toList(),
                  onChanged: (categoryId) {
                    if (categoryId == null) return;
                    final category = level3Categories
                        .firstWhere((item) => item.id == categoryId);
                    setState(() {
                      _selectedCategoryId = category.id;
                      _selectedServices.clear();
                    });
                    context
                        .read<WorkOrderFormCubit>()
                        .selectCategory(category.id, category.path);
                  },
                ),

                const SizedBox(height: AppDimensions.spaceL),

                Text('Hizmetler', style: Theme.of(context).textTheme.titleLarge),
                const SizedBox(height: AppDimensions.spaceS),
                if (state.availableServices.isEmpty)
                  const Text(
                    'Bu ürün türü için fiyatlandırılmış hizmet yok — '
                    'tarifesiz iş olarak devam edilebilir.',
                    style: TextStyle(color: AppColors.textMuted),
                  )
                else
                  Wrap(
                    spacing: AppDimensions.spaceS,
                    children: state.availableServices.map((service) {
                      final selected =
                          _selectedServices.containsKey(service.servicePriceId);
                      return FilterChip(
                        label: Text(
                          '${service.serviceName} — '
                          '${CurrencyFormatter.format(service.price)}',
                        ),
                        selected: selected,
                        onSelected: (isSelected) {
                          setState(() {
                            if (isSelected) {
                              _selectedServices[service.servicePriceId] =
                                  _SelectedService(
                                servicePriceId: service.servicePriceId,
                                serviceName: service.serviceName,
                                price: service.price,
                              );
                            } else {
                              _selectedServices.remove(service.servicePriceId);
                            }
                          });
                          _syncPriceWithSuggested();
                        },
                      );
                    }).toList(),
                  ),

                const SizedBox(height: AppDimensions.spaceL),

                Row(
                  children: [
                    Text(
                      'Sarf Malzemeler',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const Spacer(),
                    if (state.consumableGroups.isNotEmpty)
                      DropdownButton<int?>(
                        value: _consumableGroupFilter,
                        hint: const Text('Grup'),
                        items: [
                          const DropdownMenuItem(
                            value: null,
                            child: Text('Tüm gruplar'),
                          ),
                          ...state.consumableGroups.map(
                            (group) => DropdownMenuItem(
                              value: group.id,
                              child: Text(group.name),
                            ),
                          ),
                        ],
                        onChanged: (value) =>
                            setState(() => _consumableGroupFilter = value),
                      ),
                  ],
                ),
                const SizedBox(height: AppDimensions.spaceS),
                if (_consumableLines.isEmpty)
                  const Text(
                    'Sarf malzeme eklenmedi.',
                    style: TextStyle(color: AppColors.textMuted),
                  )
                else
                  ..._consumableLines.map(
                    (line) => ListTile(
                      contentPadding: EdgeInsets.zero,
                      title: Text(line.productName),
                      subtitle: Text(
                        '${line.quantity} × '
                        '${CurrencyFormatter.format(line.unitPrice)} = '
                        '${CurrencyFormatter.format(line.lineTotal)}',
                      ),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete_outline),
                        onPressed: () {
                          setState(() => _consumableLines.remove(line));
                          _syncPriceWithSuggested();
                        },
                      ),
                    ),
                  ),
                const SizedBox(height: AppDimensions.spaceS),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: () => _addConsumableLine(context),
                    icon: const Icon(Icons.add_rounded),
                    label: const Text('Sarf Malzeme Ekle'),
                  ),
                ),

                const SizedBox(height: AppDimensions.spaceL),

                Text('Detaylar', style: Theme.of(context).textTheme.titleLarge),
                const SizedBox(height: AppDimensions.spaceS),
                TextField(
                  controller: _brandController,
                  decoration: InputDecoration(
                    labelText: 'Marka',
                    errorText: fieldErrors.errorFor('brand'),
                  ),
                ),
                const SizedBox(height: AppDimensions.spaceM),
                TextField(
                  controller: _colorController,
                  decoration: InputDecoration(
                    labelText: 'Renk',
                    errorText: fieldErrors.errorFor('color'),
                  ),
                ),
                const SizedBox(height: AppDimensions.spaceM),
                TextField(
                  controller: _materialController,
                  decoration: InputDecoration(
                    labelText: 'Malzeme',
                    errorText: fieldErrors.errorFor('material'),
                  ),
                ),
                const SizedBox(height: AppDimensions.spaceM),
                TextField(
                  controller: _descriptionController,
                  decoration: InputDecoration(
                    labelText: 'Açıklama',
                    errorText: fieldErrors.errorFor('description'),
                  ),
                  maxLines: 2,
                ),
                const SizedBox(height: AppDimensions.spaceM),
                TextField(
                  controller: _damagesController,
                  decoration: InputDecoration(
                    labelText: 'Mevcut Hasarlar',
                    errorText: fieldErrors.errorFor('existingDamages'),
                  ),
                  maxLines: 2,
                ),
                const SizedBox(height: AppDimensions.spaceM),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        _estimatedDeliveryDate == null
                            ? 'Tahmini teslim tarihi seçilmedi'
                            : 'Tahmini teslim: '
                                '${_estimatedDeliveryDate!.day}.'
                                '${_estimatedDeliveryDate!.month}.'
                                '${_estimatedDeliveryDate!.year}',
                      ),
                    ),
                    TextButton(
                      onPressed: _pickDeliveryDate,
                      child: const Text('Tarih Seç'),
                    ),
                  ],
                ),
                if (fieldErrors.errorFor('estimatedDeliveryDate') != null) ...[
                  const SizedBox(height: AppDimensions.spaceXs),
                  Text(
                    fieldErrors.errorFor('estimatedDeliveryDate')!,
                    style: const TextStyle(color: AppColors.error, fontSize: 12),
                  ),
                ],

                const SizedBox(height: AppDimensions.spaceL),

                Text(
                  'Fiyat ve Ödeme',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: AppDimensions.spaceS),
                Text(
                  'Önerilen Fiyat: ${CurrencyFormatter.format(_suggestedTotal)}',
                  style: const TextStyle(color: AppColors.textMuted),
                ),
                const SizedBox(height: AppDimensions.spaceM),
                TextField(
                  controller: _priceController,
                  decoration: InputDecoration(
                    labelText: 'Nihai Fiyat',
                    errorText: fieldErrors.errorFor('price'),
                  ),
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  onChanged: (_) => setState(() => _priceManuallyEdited = true),
                ),
                if ((double.tryParse(
                          _priceController.text.replaceAll(',', '.'),
                        ) ??
                        -1) ==
                    0) ...[
                  const SizedBox(height: AppDimensions.spaceXs),
                  const Text(
                    'Fiyat 0 girildi — garanti/jest işi olarak kaydedilecek.',
                    style: TextStyle(color: AppColors.warning),
                  ),
                ],
                const SizedBox(height: AppDimensions.spaceM),
                SwitchListTile(
                  contentPadding: EdgeInsets.zero,
                  title: const Text('Ön ödeme alındı'),
                  value: _hasPrepayment,
                  onChanged: (value) => setState(() => _hasPrepayment = value),
                ),
                if (_hasPrepayment) ...[
                  TextField(
                    controller: _prepaymentController,
                    decoration: InputDecoration(
                      labelText: 'Ön Ödeme Tutarı',
                      errorText: fieldErrors.errorFor('prepaymentAmount'),
                    ),
                    keyboardType:
                        const TextInputType.numberWithOptions(decimal: true),
                  ),
                ],
                if (state.errorMessage != null) ...[
                  const SizedBox(height: AppDimensions.spaceM),
                  Container(
                    width: double.infinity,
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
                const SizedBox(height: AppDimensions.spaceL),
                SizedBox(
                  width: double.infinity,
                  height: AppDimensions.buttonHeight,
                  child: ElevatedButton(
                    onPressed: isSubmitting ? null : () => _submit(context),
                    child: isSubmitting
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: AppColors.onPrimary,
                            ),
                          )
                        : const Text('Kaydet'),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
