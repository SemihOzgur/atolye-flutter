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

class WorkOrderListPage extends StatelessWidget {
  const WorkOrderListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<WorkOrderListCubit>(
      create: (_) => WorkOrderListCubit(getIt<IWorkOrderRepository>())
        ..search(),
      child: const _WorkOrderListView(),
    );
  }
}

class _WorkOrderListView extends StatefulWidget {
  const _WorkOrderListView();

  @override
  State<_WorkOrderListView> createState() => _WorkOrderListViewState();
}

class _WorkOrderListViewState extends State<_WorkOrderListView> {
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: _searchController,
                onChanged: (value) => _onQueryChanged(context, value),
                decoration: const InputDecoration(
                  labelText: 'İş emri no, müşteri, telefon veya marka ara',
                  prefixIcon: Icon(Icons.search_rounded),
                ),
              ),
            ),
            const SizedBox(width: AppDimensions.spaceM),
            BlocBuilder<WorkOrderListCubit, WorkOrderListState>(
              builder: (context, state) {
                return DropdownButton<String?>(
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
          ],
        ),
        const SizedBox(height: AppDimensions.spaceL),
        Expanded(
          child: BlocBuilder<WorkOrderListCubit, WorkOrderListState>(
            builder: (context, state) {
              if (state.status == WorkOrderListStatus.error) {
                return Center(
                  child: Text(
                    state.errorMessage ?? 'İş emirleri yüklenemedi.',
                    style: const TextStyle(color: AppColors.error),
                  ),
                );
              }

              if (state.status == WorkOrderListStatus.loading &&
                  state.items.isEmpty) {
                return const Center(child: CircularProgressIndicator());
              }

              if (state.items.isEmpty) {
                return const Center(child: Text('İş emri bulunamadı.'));
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
                          onTap: () => context
                              .go('${AppRoutes.workOrders}/${workOrder.id}'),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: AppDimensions.spaceM,
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
                                        '${workOrder.brand != null ? ' · ${workOrder.brand}' : ''}'
                                        ' · ${workOrder.customerPhone}',
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
                                      CurrencyFormatter.format(workOrder.price),
                                    ),
                                    if (workOrder.estimatedDeliveryDate != null)
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
    );
  }
}
