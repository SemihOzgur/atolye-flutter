import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/network/api_error_codes.dart';
import '../../../../core/network/api_exception.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../../../core/utils/currency_formatter.dart';
import '../../../../core/widgets/skeleton_list_tile.dart';
import '../../data/dto/consumable_group_dto.dart';
import '../../data/dto/consumable_product_dto.dart';
import '../../data/dto/create_consumable_group_request_dto.dart';
import '../../data/dto/create_consumable_product_request_dto.dart';
import '../../data/dto/update_consumable_group_request_dto.dart';
import '../../data/dto/update_consumable_product_request_dto.dart';
import '../cubit/consumable_cubit.dart';
import '../cubit/consumable_state.dart';
import 'catalog_delete_support.dart';

class ConsumablesTab extends StatefulWidget {
  const ConsumablesTab({super.key});

  @override
  State<ConsumablesTab> createState() => _ConsumablesTabState();
}

class _ConsumablesTabState extends State<ConsumablesTab> {
  final Set<int> _deletingGroupIds = <int>{};
  final Set<int> _deletingProductIds = <int>{};

  Future<void> _openGroupDialog(
    BuildContext context, {
    ConsumableGroupDto? existing,
  }) async {
    final cubit = context.read<ConsumableCubit>();
    final nameController = TextEditingController(text: existing?.name);
    var isActive = existing?.isActive ?? true;

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => StatefulBuilder(
        builder: (dialogContext, setDialogState) => AlertDialog(
          title: Text(existing == null ? 'Yeni Grup' : 'Grubu Düzenle'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(labelText: 'Grup Adı'),
                autofocus: true,
              ),
              if (existing != null) ...[
                const SizedBox(height: AppDimensions.spaceM),
                SwitchListTile(
                  title: const Text('Aktif'),
                  value: isActive,
                  onChanged: (value) => setDialogState(() => isActive = value),
                ),
              ],
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(false),
              child: const Text('Vazgeç'),
            ),
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(true),
              child: const Text('Kaydet'),
            ),
          ],
        ),
      ),
    );

    if (confirmed != true || nameController.text.trim().isEmpty) {
      return;
    }

    try {
      if (existing == null) {
        await cubit.createGroup(
          CreateConsumableGroupRequestDto(name: nameController.text.trim()),
        );
      } else {
        await cubit.updateGroup(
          existing.id,
          UpdateConsumableGroupRequestDto(
            name: nameController.text.trim(),
            isActive: isActive,
          ),
        );
      }
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Grup kaydedildi.')),
        );
      }
    } on ApiException catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.detail ?? e.message)),
        );
      }
    }
  }

  Future<void> _openProductDialog(
    BuildContext context, {
    required List<ConsumableGroupDto> groups,
    ConsumableProductDto? existing,
  }) async {
    final cubit = context.read<ConsumableCubit>();
    final brandController = TextEditingController(text: existing?.brand);
    final nameController = TextEditingController(text: existing?.name);
    final priceController = TextEditingController(
      text: existing != null ? existing.salePrice.toStringAsFixed(2) : '',
    );
    var isActive = existing?.isActive ?? true;
    var selectedGroupId = existing?.groupId ?? groups.firstOrNull?.id;

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => StatefulBuilder(
        builder: (dialogContext, setDialogState) => AlertDialog(
          title: Text(existing == null ? 'Yeni Ürün' : 'Ürünü Düzenle'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              DropdownButtonFormField<int>(
                initialValue: selectedGroupId,
                decoration: const InputDecoration(labelText: 'Grup'),
                items: groups
                    .map(
                      (group) => DropdownMenuItem(
                        value: group.id,
                        child: Text(group.name),
                      ),
                    )
                    .toList(),
                onChanged: existing == null
                    ? (value) => setDialogState(() => selectedGroupId = value)
                    : null,
              ),
              const SizedBox(height: AppDimensions.spaceM),
              TextField(
                controller: brandController,
                decoration: const InputDecoration(
                  labelText: 'Marka (opsiyonel)',
                ),
              ),
              const SizedBox(height: AppDimensions.spaceM),
              TextField(
                controller: nameController,
                decoration: const InputDecoration(labelText: 'Ad'),
              ),
              const SizedBox(height: AppDimensions.spaceM),
              TextField(
                controller: priceController,
                decoration: const InputDecoration(labelText: 'Satış Fiyatı'),
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
              ),
              if (existing != null) ...[
                const SizedBox(height: AppDimensions.spaceM),
                SwitchListTile(
                  title: const Text('Aktif'),
                  value: isActive,
                  onChanged: (value) => setDialogState(() => isActive = value),
                ),
              ],
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(false),
              child: const Text('Vazgeç'),
            ),
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(true),
              child: const Text('Kaydet'),
            ),
          ],
        ),
      ),
    );

    if (confirmed != true ||
        nameController.text.trim().isEmpty ||
        selectedGroupId == null) {
      return;
    }

    final salePrice =
        double.tryParse(priceController.text.replaceAll(',', '.')) ?? 0;
    final brand =
        brandController.text.trim().isEmpty ? null : brandController.text.trim();

    try {
      if (existing == null) {
        await cubit.createProduct(
          CreateConsumableProductRequestDto(
            groupId: selectedGroupId!,
            brand: brand,
            name: nameController.text.trim(),
            salePrice: salePrice,
          ),
        );
      } else {
        await cubit.updateProduct(
          existing.id,
          UpdateConsumableProductRequestDto(
            brand: brand,
            name: nameController.text.trim(),
            salePrice: salePrice,
            isActive: isActive,
          ),
        );
      }
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Ürün kaydedildi.')),
        );
      }
    } on ApiException catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.detail ?? e.message)),
        );
      }
    }
  }

  Future<void> _confirmDeleteGroup(
    BuildContext context,
    ConsumableGroupDto group,
  ) async {
    final confirmed = await confirmCatalogDelete(
      context,
      title: 'Grubu Sil?',
      message:
          '"${group.name}" grubunu silmek istediğinize emin misiniz?\n\n'
          'Bu işlem geri alınamaz.',
    );
    if (!confirmed || !context.mounted) {
      return;
    }

    final cubit = context.read<ConsumableCubit>();
    setState(() => _deletingGroupIds.add(group.id));

    try {
      await cubit.deleteGroup(group.id);
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Grup başarıyla silindi.')),
        );
      }
    } on ApiException catch (e) {
      if (context.mounted) {
        await handleCatalogDeleteConflict(
          context: context,
          error: e,
          messages: {
            ApiErrorCodes.groupNotFound:
                'Sarf grubu bulunamadı. Liste güncel olmayabilir.',
            ApiErrorCodes.consumableGroupInUse:
                'Bu sarf grubu geçmiş iş emirlerinde kullanılmış ürünler '
                    'içerdiği için silinemez. Kullanılmayan ürünleri pasif '
                    'hale getirebilirsiniz.',
          },
          deactivate: e.errorCode == ApiErrorCodes.consumableGroupInUse
              ? () => cubit.updateGroup(
                    group.id,
                    UpdateConsumableGroupRequestDto(
                      name: group.name,
                      isActive: false,
                    ),
                  )
              : null,
        );
      }
      if (e.errorCode == ApiErrorCodes.groupNotFound) {
        await cubit.load();
      }
    } finally {
      if (mounted) {
        setState(() => _deletingGroupIds.remove(group.id));
      }
    }
  }

  Future<void> _confirmDeleteProduct(
    BuildContext context,
    ConsumableProductDto product,
  ) async {
    final confirmed = await confirmCatalogDelete(
      context,
      title: 'Ürünü Sil?',
      message:
          '"${product.displayName}" ürününü silmek istediğinize emin '
          'misiniz?\n\nBu işlem geri alınamaz.',
    );
    if (!confirmed || !context.mounted) {
      return;
    }

    final cubit = context.read<ConsumableCubit>();
    setState(() => _deletingProductIds.add(product.id));

    try {
      await cubit.deleteProduct(product.id);
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Ürün başarıyla silindi.')),
        );
      }
    } on ApiException catch (e) {
      if (context.mounted) {
        await handleCatalogDeleteConflict(
          context: context,
          error: e,
          messages: {
            ApiErrorCodes.productNotFound:
                'Sarf ürünü bulunamadı. Liste güncel olmayabilir.',
            ApiErrorCodes.consumableProductInUse:
                'Bu sarf ürünü geçmiş iş emirlerinde kullanıldığı için '
                    'silinemez.',
          },
          deactivate: e.errorCode == ApiErrorCodes.consumableProductInUse
              ? () => cubit.updateProduct(
                    product.id,
                    UpdateConsumableProductRequestDto(
                      brand: product.brand,
                      name: product.name,
                      salePrice: product.salePrice,
                      isActive: false,
                    ),
                  )
              : null,
        );
      }
      if (e.errorCode == ApiErrorCodes.productNotFound) {
        await cubit.load();
      }
    } finally {
      if (mounted) {
        setState(() => _deletingProductIds.remove(product.id));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ConsumableCubit, ConsumableState>(
      builder: (context, state) {
        if (state.status == ConsumableStatus.error) {
          return Text(
            state.errorMessage ?? 'Sarf malzemeler yüklenemedi.',
            style: const TextStyle(color: AppColors.error),
          );
        }

        if (state.status == ConsumableStatus.loading && state.groups.isEmpty) {
          return const SkeletonList();
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text('Gruplar', style: Theme.of(context).textTheme.titleLarge),
                const Spacer(),
                OutlinedButton.icon(
                  onPressed: () => _openGroupDialog(context),
                  icon: const Icon(Icons.add_rounded),
                  label: const Text('Yeni Grup'),
                ),
              ],
            ),
            const SizedBox(height: AppDimensions.spaceS),
            Wrap(
              spacing: AppDimensions.spaceS,
              children: [
                ChoiceChip(
                  label: const Text('Tümü'),
                  selected: state.selectedGroupId == null,
                  onSelected: (_) =>
                      context.read<ConsumableCubit>().filterByGroup(null),
                ),
                ...state.groups.map((group) {
                  final isDeleting = _deletingGroupIds.contains(group.id);
                  return InputChip(
                    label: isDeleting
                        ? const SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : Text(group.name),
                    selected: state.selectedGroupId == group.id,
                    onSelected: isDeleting
                        ? null
                        : (_) => context
                            .read<ConsumableCubit>()
                            .filterByGroup(group.id),
                    avatar: isDeleting
                        ? null
                        : GestureDetector(
                            onTap: () =>
                                _openGroupDialog(context, existing: group),
                            child: const Icon(Icons.edit_outlined, size: 16),
                          ),
                    deleteIcon: const Icon(Icons.close_rounded, size: 16),
                    onDeleted: isDeleting
                        ? null
                        : () => _confirmDeleteGroup(context, group),
                  );
                }),
              ],
            ),
            const SizedBox(height: AppDimensions.spaceM),
            Row(
              children: [
                Text('Ürünler', style: Theme.of(context).textTheme.titleLarge),
                const Spacer(),
                ElevatedButton.icon(
                  onPressed: state.groups.isEmpty
                      ? null
                      : () => _openProductDialog(context, groups: state.groups),
                  icon: const Icon(Icons.add_rounded),
                  label: const Text('Yeni Ürün'),
                ),
              ],
            ),
            const SizedBox(height: AppDimensions.spaceS),
            Expanded(
              child: ListView.separated(
                itemCount: state.products.length,
                separatorBuilder: (_, __) =>
                    const Divider(color: AppColors.border, height: 1),
                itemBuilder: (context, index) {
                  final product = state.products[index];
                  final hasPrice = product.salePrice > 0;
                  final isDeleting = _deletingProductIds.contains(product.id);
                  return ListTile(
                    title: Text(product.displayName),
                    subtitle: Text(
                      hasPrice
                          ? CurrencyFormatter.format(product.salePrice)
                          : 'fiyat girilmedi',
                      style: hasPrice
                          ? null
                          : const TextStyle(color: AppColors.warning),
                    ),
                    trailing: isDeleting
                        ? const Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: AppDimensions.spaceM,
                            ),
                            child: SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            ),
                          )
                        : Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              if (!product.isActive)
                                const Padding(
                                  padding: EdgeInsets.only(
                                    right: AppDimensions.spaceS,
                                  ),
                                  child: Text(
                                    'pasif',
                                    style: TextStyle(color: AppColors.textMuted),
                                  ),
                                ),
                              IconButton(
                                icon: const Icon(Icons.edit_outlined),
                                onPressed: () => _openProductDialog(
                                  context,
                                  groups: state.groups,
                                  existing: product,
                                ),
                              ),
                              IconButton(
                                icon: const Icon(
                                  Icons.delete_outline,
                                  color: AppColors.error,
                                ),
                                tooltip: 'Sil',
                                onPressed: () =>
                                    _confirmDeleteProduct(context, product),
                              ),
                            ],
                          ),
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }
}
