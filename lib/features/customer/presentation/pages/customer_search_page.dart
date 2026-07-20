import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/app_routes.dart';
import '../../../../core/di/injection.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../../../core/widgets/skeleton_list_tile.dart';
import '../../data/customer_repository.dart';
import '../cubit/customer_search_cubit.dart';
import '../cubit/customer_search_state.dart';
import '../widgets/iys_status_badge.dart';

class CustomerSearchPage extends StatelessWidget {
  const CustomerSearchPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<CustomerSearchCubit>(
      create: (_) =>
          CustomerSearchCubit(getIt<ICustomerRepository>())..search(''),
      child: const _CustomerSearchView(),
    );
  }
}

class _CustomerSearchView extends StatefulWidget {
  const _CustomerSearchView();

  @override
  State<_CustomerSearchView> createState() => _CustomerSearchViewState();
}

class _CustomerSearchViewState extends State<_CustomerSearchView> {
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
      context.read<CustomerSearchCubit>().search(value.trim());
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
                  labelText: 'Telefon veya isim ile ara',
                  prefixIcon: Icon(Icons.search_rounded),
                ),
              ),
            ),
            const SizedBox(width: AppDimensions.spaceM),
            ElevatedButton.icon(
              onPressed: () => context.go('${AppRoutes.customers}/new'),
              icon: const Icon(Icons.person_add_alt_rounded),
              label: const Text('Yeni Kayıt'),
            ),
          ],
        ),
        const SizedBox(height: AppDimensions.spaceL),
        Expanded(
          child: BlocBuilder<CustomerSearchCubit, CustomerSearchState>(
            builder: (context, state) {
              if (state.status == CustomerSearchStatus.error) {
                return Center(
                  child: Text(
                    state.errorMessage ?? 'Müşteriler yüklenemedi.',
                    style: const TextStyle(color: AppColors.error),
                  ),
                );
              }

              if (state.status == CustomerSearchStatus.loading &&
                  state.items.isEmpty) {
                return const SkeletonList();
              }

              if (state.items.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text('Müşteri bulunamadı'),
                      const SizedBox(height: AppDimensions.spaceM),
                      OutlinedButton(
                        onPressed: () => context.go('${AppRoutes.customers}/new'),
                        child: const Text('Yeni Kayıt'),
                      ),
                    ],
                  ),
                );
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
                        final customer = state.items[index];
                        return ListTile(
                          onTap: () => context
                              .go('${AppRoutes.customers}/${customer.id}'),
                          title: Text('${customer.firstName} ${customer.lastName}'),
                          subtitle: Text(customer.phone),
                          trailing: IysStatusBadge(
                            status: customer.iysConsentStatus,
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
                                  .read<CustomerSearchCubit>()
                                  .goToPage(state.page - 1)
                              : null,
                          icon: const Icon(Icons.chevron_left_rounded),
                        ),
                        Text('Sayfa ${state.page}'),
                        IconButton(
                          onPressed: state.hasNextPage
                              ? () => context
                                  .read<CustomerSearchCubit>()
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
