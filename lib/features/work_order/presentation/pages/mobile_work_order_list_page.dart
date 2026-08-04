import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../app/app_routes.dart';
import '../../../../core/di/injection.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../../../core/utils/currency_formatter.dart';
import '../../../../core/widgets/skeleton_list_tile.dart';
import '../../data/work_order_repository.dart';
import '../cubit/work_order_list_cubit.dart';
import '../cubit/work_order_list_state.dart';
import '../widgets/work_order_status_badge.dart';

const _statusOptions = <String?, String>{
  null: 'Tümü',
  'RECEIVED': 'Teslim Alındı',
  'IN_PROGRESS': 'İşlemde',
  'READY': 'Hazır',
  'DELIVERED': 'Teslim Edildi',
  'CANCELLED': 'İptal',
};

/// Mobil ürünler (iş emirleri) listesi — masaüstü [WorkOrderListPage] ile
/// aynı [WorkOrderListCubit]/[IWorkOrderRepository]'yi paylaşır (Analiz
/// §9.2/§6: cubit/repository aynen kullanılabilir). Satıra dokununca
/// mevcut [MobileWorkOrderDetailPage] rotasına (`/work-orders/:id`) gider.
/// Yeni ürün oluşturma girişi FAB üzerinden müşteri seçim akışına
/// (`/customers` → müşteri detay → "Yeni Ürün") yönlendirir.
class MobileWorkOrderListPage extends StatelessWidget {
  const MobileWorkOrderListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<WorkOrderListCubit>(
      create: (_) => WorkOrderListCubit(getIt<IWorkOrderRepository>())
        ..search(),
      child: const _MobileWorkOrderListView(),
    );
  }
}

class _MobileWorkOrderListView extends StatefulWidget {
  const _MobileWorkOrderListView();

  @override
  State<_MobileWorkOrderListView> createState() =>
      _MobileWorkOrderListViewState();
}

class _MobileWorkOrderListViewState extends State<_MobileWorkOrderListView> {
  final _searchController = TextEditingController();
  Timer? _debounce;

  @override
  void dispose() {
    _debounce?.cancel();
    _searchController.dispose();
    super.dispose();
  }

  void _onQueryChanged(BuildContext context, String value) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 400), () {
      context.read<WorkOrderListCubit>().search(query: value.trim());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Ürünler')),
      floatingActionButton: FloatingActionButton(
        tooltip: 'Yeni Ürün',
        onPressed: () => context.push(AppRoutes.customers),
        child: const Icon(Icons.add_rounded),
      ),
      body: Padding(
        padding: const EdgeInsets.all(AppDimensions.spaceL),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _searchController,
              onChanged: (value) => _onQueryChanged(context, value),
              decoration: const InputDecoration(
                labelText: 'İş emri no, müşteri, telefon veya marka ara',
                prefixIcon: Icon(Icons.search_rounded),
              ),
            ),
            const SizedBox(height: AppDimensions.spaceM),
            BlocBuilder<WorkOrderListCubit, WorkOrderListState>(
              builder: (context, state) {
                return DropdownButton<String?>(
                  isExpanded: true,
                  value: state.statusFilter,
                  items: _statusOptions.entries
                      .map(
                        (entry) => DropdownMenuItem(
                          value: entry.key,
                          child: Text(entry.value),
                        ),
                      )
                      .toList(),
                  onChanged: (value) =>
                      context.read<WorkOrderListCubit>().search(status: value),
                );
              },
            ),
            const SizedBox(height: AppDimensions.spaceM),
            Expanded(
              child: BlocBuilder<WorkOrderListCubit, WorkOrderListState>(
                builder: (context, state) {
                  if (state.status == WorkOrderListStatus.error) {
                    return Center(
                      child: Text(
                        state.errorMessage ?? 'Ürünler yüklenemedi.',
                        style: const TextStyle(color: AppColors.error),
                      ),
                    );
                  }

                  if (state.status == WorkOrderListStatus.loading &&
                      state.items.isEmpty) {
                    return const SkeletonList();
                  }

                  if (state.items.isEmpty) {
                    return const Center(child: Text('Ürün bulunamadı.'));
                  }

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: ListView.separated(
                          itemCount: state.items.length,
                          separatorBuilder: (_, __) =>
                              const Divider(color: AppColors.border, height: 1),
                          itemBuilder: (context, index) {
                            final workOrder = state.items[index];
                            return InkWell(
                              onTap: () => context.push(
                                '${AppRoutes.workOrders}/${workOrder.id}',
                              ),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  vertical: AppDimensions.spaceS,
                                ),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Text(
                                            '${workOrder.orderNumber} — '
                                            '${workOrder.customerFullName}',
                                          ),
                                          const SizedBox(
                                            height: AppDimensions.spaceXxs,
                                          ),
                                          Text(
                                            '${workOrder.categoryPath}'
                                            '${workOrder.brand != null ? ' · ${workOrder.brand}' : ''}',
                                            style: const TextStyle(
                                              color: AppColors.textMuted,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(width: AppDimensions.spaceM),
                                    Column(
                                      mainAxisSize: MainAxisSize.min,
                                      crossAxisAlignment: CrossAxisAlignment.end,
                                      children: [
                                        WorkOrderStatusBadge(
                                          status: workOrder.status,
                                        ),
                                        const SizedBox(
                                          height: AppDimensions.spaceXxs,
                                        ),
                                        Text(
                                          CurrencyFormatter.format(
                                            workOrder.price,
                                          ),
                                        ),
                                        if (workOrder.estimatedDeliveryDate !=
                                            null)
                                          Text(
                                            DateFormat('dd.MM.yyyy').format(
                                              workOrder.estimatedDeliveryDate!,
                                            ),
                                            style: const TextStyle(
                                              color: AppColors.textMuted,
                                              fontSize: 12,
                                            ),
                                          ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      if (state.totalCount > state.pageSize) ...[
                        const SizedBox(height: AppDimensions.spaceS),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            IconButton(
                              onPressed: state.hasPreviousPage
                                  ? () => context
                                      .read<WorkOrderListCubit>()
                                      .goToPage(state.page - 1)
                                  : null,
                              icon: const Icon(Icons.chevron_left_rounded),
                            ),
                            Text('Sayfa ${state.page}'),
                            IconButton(
                              onPressed: state.hasNextPage
                                  ? () => context
                                      .read<WorkOrderListCubit>()
                                      .goToPage(state.page + 1)
                                  : null,
                              icon: const Icon(Icons.chevron_right_rounded),
                            ),
                          ],
                        ),
                      ],
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
