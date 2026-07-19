import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/network/api_exception.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../data/dto/category_tree_dto.dart';
import '../../data/dto/create_category_request_dto.dart';
import '../../data/dto/update_category_request_dto.dart';
import '../cubit/category_cubit.dart';
import '../cubit/category_state.dart';

class CategoryTreeTab extends StatefulWidget {
  const CategoryTreeTab({super.key});

  @override
  State<CategoryTreeTab> createState() => _CategoryTreeTabState();
}

class _CategoryTreeTabState extends State<CategoryTreeTab> {
  CategoryTreeDto? _selectedNode;

  Future<void> _openCreateDialog(BuildContext context) async {
    final cubit = context.read<CategoryCubit>();
    final nameController = TextEditingController();
    final sortController = TextEditingController(text: '0');

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(
          _selectedNode == null
              ? 'Yeni Ana Kategori'
              : '"${_selectedNode!.name}" altına yeni kategori',
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: 'Ad'),
              autofocus: true,
            ),
            const SizedBox(height: AppDimensions.spaceM),
            TextField(
              controller: sortController,
              decoration: const InputDecoration(labelText: 'Sıra'),
              keyboardType: TextInputType.number,
            ),
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
    );

    if (confirmed != true || nameController.text.trim().isEmpty) {
      return;
    }

    try {
      await cubit.createCategory(
        CreateCategoryRequestDto(
          parentId: _selectedNode?.id,
          name: nameController.text.trim(),
          sortOrder: int.tryParse(sortController.text) ?? 0,
        ),
      );
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Kategori kaydedildi.')),
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

  Future<void> _openEditDialog(
    BuildContext context,
    CategoryTreeDto node,
  ) async {
    final cubit = context.read<CategoryCubit>();
    final nameController = TextEditingController(text: node.name);
    var isActive = node.isActive;

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => StatefulBuilder(
        builder: (dialogContext, setDialogState) => AlertDialog(
          title: const Text('Kategoriyi Düzenle'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(labelText: 'Ad'),
              ),
              const SizedBox(height: AppDimensions.spaceM),
              SwitchListTile(
                title: const Text('Aktif'),
                value: isActive,
                onChanged: (value) => setDialogState(() => isActive = value),
              ),
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

    if (confirmed != true || !context.mounted) {
      return;
    }

    if (!isActive && node.isActive) {
      final deactivateConfirmed = await showDialog<bool>(
        context: context,
        builder: (dialogContext) => AlertDialog(
          title: const Text('Kategoriyi pasifleştir'),
          content: const Text(
            'Bu kategori pasifleştirilirse altındaki tüm alt kategoriler de '
            'gizlenir ve bunlarla yeni iş emri açılamaz. Mevcut iş emirleri '
            'etkilenmez. Devam edilsin mi?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(false),
              child: const Text('Vazgeç'),
            ),
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(true),
              child: const Text('Pasifleştir'),
            ),
          ],
        ),
      );
      if (deactivateConfirmed != true) {
        return;
      }
    }

    try {
      await cubit.updateCategory(
        node.id,
        UpdateCategoryRequestDto(
          name: nameController.text.trim(),
          sortOrder: 0,
          isActive: isActive,
        ),
      );
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Kategori güncellendi.')),
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

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CategoryCubit, CategoryState>(
      builder: (context, state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Switch(
                  value: state.includeInactive,
                  onChanged: (value) =>
                      context.read<CategoryCubit>().setIncludeInactive(value),
                ),
                const Text('Pasifleri göster'),
                const Spacer(),
                ElevatedButton.icon(
                  onPressed: _selectedNode?.level == 3
                      ? null
                      : () => _openCreateDialog(context),
                  icon: const Icon(Icons.add_rounded),
                  label: const Text('Yeni Kategori'),
                ),
              ],
            ),
            const SizedBox(height: AppDimensions.spaceM),
            if (state.status == CategoryTreeStatus.error)
              Text(
                state.errorMessage ?? 'Kategori ağacı yüklenemedi.',
                style: const TextStyle(color: AppColors.error),
              )
            else if (state.status == CategoryTreeStatus.loading &&
                state.tree.isEmpty)
              const Center(child: CircularProgressIndicator())
            else
              Expanded(
                child: ListView(
                  children: state.tree
                      .map((node) => _CategoryNodeTile(
                            node: node,
                            selectedNode: _selectedNode,
                            onSelect: (node) =>
                                setState(() => _selectedNode = node),
                            onEdit: (node) => _openEditDialog(context, node),
                          ))
                      .toList(),
                ),
              ),
          ],
        );
      },
    );
  }
}

class _CategoryNodeTile extends StatelessWidget {
  const _CategoryNodeTile({
    required this.node,
    required this.selectedNode,
    required this.onSelect,
    required this.onEdit,
  });

  final CategoryTreeDto node;
  final CategoryTreeDto? selectedNode;
  final ValueChanged<CategoryTreeDto> onSelect;
  final ValueChanged<CategoryTreeDto> onEdit;

  @override
  Widget build(BuildContext context) {
    final isSelected = selectedNode?.id == node.id;

    final tile = ListTile(
      selected: isSelected,
      onTap: () => onSelect(node),
      title: Row(
        children: [
          Flexible(
            child: Text(
              node.name,
              style: TextStyle(
                color: node.isActive ? null : AppColors.textMuted,
              ),
            ),
          ),
          if (!node.isActive) ...[
            const SizedBox(width: AppDimensions.spaceS),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: AppColors.textMuted.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(6),
              ),
              child: const Text('pasif', style: TextStyle(fontSize: 12)),
            ),
          ],
        ],
      ),
      trailing: IconButton(
        icon: const Icon(Icons.edit_outlined),
        onPressed: () => onEdit(node),
      ),
    );

    if (node.children.isEmpty) {
      return Padding(
        padding: EdgeInsets.only(left: (node.level - 1) * AppDimensions.spaceL),
        child: tile,
      );
    }

    return Padding(
      padding: EdgeInsets.only(left: (node.level - 1) * AppDimensions.spaceL),
      child: ExpansionTile(
        title: tile,
        tilePadding: EdgeInsets.zero,
        childrenPadding: EdgeInsets.zero,
        children: node.children
            .map(
              (child) => _CategoryNodeTile(
                node: child,
                selectedNode: selectedNode,
                onSelect: onSelect,
                onEdit: onEdit,
              ),
            )
            .toList(),
      ),
    );
  }
}
