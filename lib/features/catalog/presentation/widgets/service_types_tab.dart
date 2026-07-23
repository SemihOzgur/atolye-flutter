import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/network/api_error_codes.dart';
import '../../../../core/network/api_exception.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../../../core/widgets/skeleton_list_tile.dart';
import '../../data/dto/create_service_type_request_dto.dart';
import '../../data/dto/service_type_dto.dart';
import '../../data/dto/update_service_type_request_dto.dart';
import '../cubit/service_type_cubit.dart';
import '../cubit/service_type_state.dart';
import 'catalog_delete_support.dart';

class ServiceTypesTab extends StatefulWidget {
  const ServiceTypesTab({super.key});

  @override
  State<ServiceTypesTab> createState() => _ServiceTypesTabState();
}

class _ServiceTypesTabState extends State<ServiceTypesTab> {
  final Set<int> _deletingIds = <int>{};

  Future<void> _openFormDialog(
    BuildContext context, {
    ServiceTypeDto? existing,
  }) async {
    final cubit = context.read<ServiceTypeCubit>();
    final nameController = TextEditingController(text: existing?.name);
    final sortController = TextEditingController(
      text: '${existing?.sortOrder ?? 0}',
    );
    var isActive = existing?.isActive ?? true;

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => StatefulBuilder(
        builder: (dialogContext, setDialogState) => AlertDialog(
          title: Text(existing == null ? 'Yeni Hizmet Türü' : 'Hizmet Türünü Düzenle'),
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
      final sortOrder = int.tryParse(sortController.text) ?? 0;
      if (existing == null) {
        await cubit.create(
          CreateServiceTypeRequestDto(
            name: nameController.text.trim(),
            sortOrder: sortOrder,
          ),
        );
      } else {
        await cubit.update(
          existing.id,
          UpdateServiceTypeRequestDto(
            name: nameController.text.trim(),
            sortOrder: sortOrder,
            isActive: isActive,
          ),
        );
      }
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Hizmet türü kaydedildi.')),
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

  Future<void> _confirmDelete(
    BuildContext context,
    ServiceTypeDto serviceType,
  ) async {
    final confirmed = await confirmCatalogDelete(
      context,
      title: 'Hizmet Türünü Sil?',
      message:
          '"${serviceType.name}" hizmet türünü silmek istediğinize emin '
          'misiniz?\n\nBu işlem geri alınamaz.',
    );
    if (!confirmed || !context.mounted) {
      return;
    }

    final cubit = context.read<ServiceTypeCubit>();
    setState(() => _deletingIds.add(serviceType.id));

    try {
      await cubit.delete(serviceType.id);
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Hizmet türü başarıyla silindi.')),
        );
      }
    } on ApiException catch (e) {
      if (context.mounted) {
        await handleCatalogDeleteConflict(
          context: context,
          error: e,
          messages: {
            ApiErrorCodes.serviceTypeNotFound:
                'Hizmet türü bulunamadı. Liste güncel olmayabilir.',
            ApiErrorCodes.serviceTypeInUse:
                'Bu hizmet türü geçmiş iş emirlerinde kullanıldığı için '
                    'silinemez.',
          },
          deactivate: e.errorCode == ApiErrorCodes.serviceTypeInUse
              ? () => cubit.update(
                    serviceType.id,
                    UpdateServiceTypeRequestDto(
                      name: serviceType.name,
                      sortOrder: serviceType.sortOrder,
                      isActive: false,
                    ),
                  )
              : null,
        );
      }
      if (e.errorCode == ApiErrorCodes.serviceTypeNotFound) {
        await cubit.load();
      }
    } finally {
      if (mounted) {
        setState(() => _deletingIds.remove(serviceType.id));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Expanded(
              child: Text(
                'Tamir/onarım hizmeti firma kararıyla sisteme eklenmez.',
              ),
            ),
            ElevatedButton.icon(
              onPressed: () => _openFormDialog(context),
              icon: const Icon(Icons.add_rounded),
              label: const Text('Yeni Hizmet Türü'),
            ),
          ],
        ),
        const SizedBox(height: AppDimensions.spaceM),
        Expanded(
          child: BlocBuilder<ServiceTypeCubit, ServiceTypeState>(
            builder: (context, state) {
              if (state.status == ServiceTypeStatus.error) {
                return Text(
                  state.errorMessage ?? 'Hizmet türleri yüklenemedi.',
                  style: const TextStyle(color: AppColors.error),
                );
              }
              if (state.status == ServiceTypeStatus.loading &&
                  state.items.isEmpty) {
                return const SkeletonList();
              }
              return ListView.separated(
                itemCount: state.items.length,
                separatorBuilder: (_, __) =>
                    const Divider(color: AppColors.border, height: 1),
                itemBuilder: (context, index) {
                  final serviceType = state.items[index];
                  final isDeleting = _deletingIds.contains(serviceType.id);
                  return ListTile(
                    title: Text(serviceType.name),
                    subtitle: Text('Sıra: ${serviceType.sortOrder}'),
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
                              if (!serviceType.isActive)
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
                                onPressed: () => _openFormDialog(
                                  context,
                                  existing: serviceType,
                                ),
                              ),
                              IconButton(
                                icon: const Icon(
                                  Icons.delete_outline,
                                  color: AppColors.error,
                                ),
                                tooltip: 'Sil',
                                onPressed: () =>
                                    _confirmDelete(context, serviceType),
                              ),
                            ],
                          ),
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }
}
