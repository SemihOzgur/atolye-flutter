import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/app_routes.dart';
import '../../../../core/di/injection.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_decorations.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../../../core/widgets/skeleton_box.dart';
import '../../data/customer_repository.dart';
import '../cubit/customer_detail_cubit.dart';
import '../cubit/customer_detail_state.dart';
import '../widgets/iys_status_badge.dart';

/// Mobil müşteri detayı — Product Create'in önkoşulu. Yalnızca kimlik
/// bilgisi + "Yeni Ürün" girişini gösterir. Müşteri düzenleme, İYS onay
/// paneli ve geçmiş iş emri listesi bu sprint kapsamı dışıdır (yalnızca
/// Product Create/Detail — bkz. görev kapsamı).
class MobileCustomerDetailPage extends StatelessWidget {
  const MobileCustomerDetailPage({super.key, required this.customerId});

  final int customerId;

  @override
  Widget build(BuildContext context) {
    return BlocProvider<CustomerDetailCubit>(
      create: (_) =>
          CustomerDetailCubit(getIt<ICustomerRepository>(), customerId)
            ..load(),
      child: const _MobileCustomerDetailView(),
    );
  }
}

class _MobileCustomerDetailView extends StatelessWidget {
  const _MobileCustomerDetailView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Müşteri')),
      body: BlocBuilder<CustomerDetailCubit, CustomerDetailState>(
        builder: (context, state) {
          if (state.status == CustomerDetailStatus.loading) {
            return const _DetailSkeleton();
          }

          if (state.status == CustomerDetailStatus.error) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(AppDimensions.spaceXl),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      state.errorMessage ?? 'Müşteri yüklenemedi.',
                      style: const TextStyle(color: AppColors.error),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: AppDimensions.spaceM),
                    ElevatedButton(
                      onPressed: () =>
                          context.read<CustomerDetailCubit>().load(),
                      child: const Text('Tekrar Dene'),
                    ),
                  ],
                ),
              ),
            );
          }

          final customer = state.detail!.customer;

          return Padding(
            padding: const EdgeInsets.all(AppDimensions.spaceL),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(AppDimensions.spaceL),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: AppDecorations.borderRadiusXl,
                    border: Border.all(color: AppColors.border),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              '${customer.firstName} ${customer.lastName}',
                              style: Theme.of(context).textTheme.titleLarge,
                            ),
                          ),
                          IysStatusBadge(status: customer.iysConsentStatus),
                        ],
                      ),
                      const SizedBox(height: AppDimensions.spaceXs),
                      Text(
                        customer.phone,
                        style: const TextStyle(color: AppColors.textMuted),
                      ),
                      if (customer.email != null) Text(customer.email!),
                      if (customer.address != null) Text(customer.address!),
                    ],
                  ),
                ),
                const Spacer(),
                SizedBox(
                  width: double.infinity,
                  height: AppDimensions.buttonHeight,
                  child: ElevatedButton.icon(
                    onPressed: () => context.push(
                      '${AppRoutes.workOrders}/new?customerId=${customer.id}',
                    ),
                    icon: const Icon(Icons.add_rounded),
                    label: const Text('Yeni Ürün'),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _DetailSkeleton extends StatelessWidget {
  const _DetailSkeleton();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AppDimensions.spaceL),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SkeletonBox(width: 220, height: 24),
          const SizedBox(height: AppDimensions.spaceM),
          const SkeletonBox(width: 160, height: 14),
        ],
      ),
    );
  }
}
