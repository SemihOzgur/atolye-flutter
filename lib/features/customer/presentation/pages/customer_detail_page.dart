import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../app/app_routes.dart';
import '../../../../core/di/injection.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../../../core/utils/currency_formatter.dart';
import '../../data/customer_repository.dart';
import '../cubit/customer_detail_cubit.dart';
import '../cubit/customer_detail_state.dart';
import '../cubit/iys_verification_cubit.dart';
import '../widgets/iys_status_badge.dart';
import '../widgets/iys_verification_panel.dart';
import 'customer_form_page.dart';

class CustomerDetailPage extends StatelessWidget {
  const CustomerDetailPage({super.key, required this.customerId});

  final int customerId;

  @override
  Widget build(BuildContext context) {
    return BlocProvider<CustomerDetailCubit>(
      create: (_) =>
          CustomerDetailCubit(getIt<ICustomerRepository>(), customerId)..load(),
      child: const _CustomerDetailView(),
    );
  }
}

class _CustomerDetailView extends StatefulWidget {
  const _CustomerDetailView();

  @override
  State<_CustomerDetailView> createState() => _CustomerDetailViewState();
}

class _CustomerDetailViewState extends State<_CustomerDetailView> {
  bool _showIysPanel = false;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CustomerDetailCubit, CustomerDetailState>(
      builder: (context, state) {
        if (state.status == CustomerDetailStatus.loading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state.status == CustomerDetailStatus.error) {
          return Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  state.errorMessage ?? 'Müşteri yüklenemedi.',
                  style: const TextStyle(color: AppColors.error),
                ),
                const SizedBox(height: AppDimensions.spaceM),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => context.read<CustomerDetailCubit>().load(),
                    child: const Text('Tekrar Dene'),
                  ),
                ),
              ],
            ),
          );
        }

        final detail = state.detail!;
        final customer = detail.customer;
        final canResend = customer.iysConsentStatus == 'PENDING' ||
            customer.iysConsentStatus == 'REJECTED';

        return SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(AppDimensions.spaceL),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              '${customer.firstName} ${customer.lastName}',
                              style: Theme.of(context).textTheme.headlineMedium,
                            ),
                          ),
                          IysStatusBadge(status: customer.iysConsentStatus),
                          const SizedBox(width: AppDimensions.spaceM),
                          ElevatedButton(
                            onPressed: () => context.go(
                              '${AppRoutes.workOrders}/new'
                              '?customerId=${customer.id}',
                            ),
                            child: const Text('Yeni İş Emri'),
                          ),
                          const SizedBox(width: AppDimensions.spaceM),
                          OutlinedButton(
                            onPressed: () async {
                              await Navigator.of(context).push(
                                MaterialPageRoute<void>(
                                  builder: (_) => CustomerFormPage(
                                    existingCustomer: customer,
                                  ),
                                ),
                              );
                              if (context.mounted) {
                                await context.read<CustomerDetailCubit>().load();
                              }
                            },
                            child: const Text('Düzenle'),
                          ),
                        ],
                      ),
                      const SizedBox(height: AppDimensions.spaceM),
                      Text(customer.phone),
                      if (customer.email != null) Text(customer.email!),
                      if (customer.address != null) Text(customer.address!),
                      if (customer.iysConsentAt != null) ...[
                        const SizedBox(height: AppDimensions.spaceXs),
                        Text(
                          'İYS onay tarihi: '
                          '${DateFormat('dd.MM.yyyy HH:mm').format(customer.iysConsentAt!.toLocal())}',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ],
                      if (canResend && !_showIysPanel) ...[
                        const SizedBox(height: AppDimensions.spaceM),
                        OutlinedButton(
                          onPressed: () => setState(() => _showIysPanel = true),
                          child: const Text('Kodu yeniden gönder'),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
              if (_showIysPanel) ...[
                const SizedBox(height: AppDimensions.spaceM),
                BlocProvider<IysVerificationCubit>(
                  create: (_) => IysVerificationCubit(
                    getIt<ICustomerRepository>(),
                    customer.id,
                  ),
                  child: IysVerificationPanel(
                    onDone: () {
                      setState(() => _showIysPanel = false);
                      context.read<CustomerDetailCubit>().load();
                    },
                  ),
                ),
              ],
              const SizedBox(height: AppDimensions.spaceL),
              Text(
                'Geçmiş İş Emirleri',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: AppDimensions.spaceM),
              if (detail.workOrders.isEmpty)
                const Text('Bu müşteriye ait iş emri bulunmuyor.')
              else
                Card(
                  child: Column(
                    children: detail.workOrders
                        .map(
                          (workOrder) => ListTile(
                            onTap: () => context.go(AppRoutes.workOrders),
                            title: Text(
                              '${workOrder.orderNumber} — ${workOrder.categoryPath}',
                            ),
                            subtitle: Text(workOrder.status),
                            trailing: Text(
                              CurrencyFormatter.format(workOrder.price),
                            ),
                          ),
                        )
                        .toList(),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}
