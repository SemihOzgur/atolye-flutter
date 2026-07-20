import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../../../core/widgets/skeleton_list_tile.dart';
import '../../data/dto/category_tree_dto.dart';
import '../cubit/category_cubit.dart';
import '../cubit/category_state.dart';
import '../cubit/service_price_cubit.dart';
import '../cubit/service_price_state.dart';

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

class ServicePriceTab extends StatelessWidget {
  const ServicePriceTab({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CategoryCubit, CategoryState>(
      builder: (context, categoryState) {
        final level3Categories = _flattenLevel3(categoryState.tree);

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            BlocBuilder<ServicePriceCubit, ServicePriceState>(
              builder: (context, priceState) {
                return DropdownButton<int>(
                  hint: const Text('Ürün türü seçin'),
                  value: priceState.selectedCategoryId,
                  isExpanded: true,
                  items: level3Categories
                      .map(
                        (category) => DropdownMenuItem(
                          value: category.id,
                          child: Text(category.path),
                        ),
                      )
                      .toList(),
                  onChanged: (categoryId) {
                    if (categoryId == null) {
                      return;
                    }
                    final category = level3Categories
                        .firstWhere((item) => item.id == categoryId);
                    context
                        .read<ServicePriceCubit>()
                        .selectCategory(category.id, category.path);
                  },
                );
              },
            ),
            const SizedBox(height: AppDimensions.spaceM),
            Expanded(
              child: BlocConsumer<ServicePriceCubit, ServicePriceState>(
                listener: (context, state) {
                  if (state.status == ServicePriceStatus.error) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          state.errorMessage ?? 'Fiyatlar kaydedilemedi.',
                        ),
                      ),
                    );
                  }
                },
                builder: (context, priceState) {
                  if (priceState.selectedCategoryId == null) {
                    return const Center(
                      child: Text('Fiyatları düzenlemek için bir ürün türü seçin.'),
                    );
                  }

                  if (priceState.status == ServicePriceStatus.loading) {
                    return const SkeletonList();
                  }

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: ListView.separated(
                          itemCount: priceState.rows.length,
                          separatorBuilder: (_, __) =>
                              const Divider(color: AppColors.border, height: 1),
                          itemBuilder: (context, index) {
                            final row = priceState.rows[index];
                            return ListTile(
                              title: Text(row.serviceName),
                              leading: Checkbox(
                                value: row.isActive,
                                onChanged: (value) => context
                                    .read<ServicePriceCubit>()
                                    .updateRowActive(
                                      row.serviceTypeId,
                                      value ?? false,
                                    ),
                              ),
                              trailing: SizedBox(
                                width: 140,
                                child: TextFormField(
                                  key: ValueKey(
                                    'price-${row.serviceTypeId}-${row.price}',
                                  ),
                                  initialValue: row.price.toStringAsFixed(2),
                                  keyboardType:
                                      const TextInputType.numberWithOptions(
                                    decimal: true,
                                  ),
                                  decoration: const InputDecoration(
                                    suffixText: '₺',
                                  ),
                                  onChanged: (value) {
                                    final parsed = double.tryParse(
                                      value.replaceAll(',', '.'),
                                    );
                                    if (parsed != null) {
                                      context
                                          .read<ServicePriceCubit>()
                                          .updateRowPrice(
                                            row.serviceTypeId,
                                            parsed,
                                          );
                                    }
                                  },
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: AppDimensions.spaceM),
                      ElevatedButton(
                        onPressed: priceState.status == ServicePriceStatus.saving
                            ? null
                            : () => context.read<ServicePriceCubit>().saveAll(),
                        child: priceState.status == ServicePriceStatus.saving
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: AppColors.onPrimary,
                                ),
                              )
                            : const Text('Tümünü Kaydet'),
                      ),
                    ],
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
