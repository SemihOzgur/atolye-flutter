import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../core/di/injection.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_decorations.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../../../core/widgets/skeleton_box.dart';
import '../../data/work_order_repository.dart';
import '../cubit/work_order_detail_cubit.dart';
import '../cubit/work_order_detail_state.dart';
import '../../domain/status_transitions.dart';
import '../widgets/status_bottom_sheet.dart';
import '../widgets/status_timeline.dart';
import '../widgets/work_order_status_badge.dart';

/// Mobil kabuk ürün detayı — read-only, tek yazma aksiyonu status
/// değişimi. Mevcut [WorkOrderDetailCubit] yeniden kullanılır (409'da
/// zaten otomatik `load()` çağırıyor — bkz. cubit). Fiyat/medya/SMS/
/// Düzenle/Teslim Et bilinçli olarak yok (SDD F6 kapsamı).
class MobileWorkOrderDetailPage extends StatelessWidget {
  const MobileWorkOrderDetailPage({super.key, required this.workOrderId});

  final int workOrderId;

  @override
  Widget build(BuildContext context) {
    return BlocProvider<WorkOrderDetailCubit>(
      create: (_) => WorkOrderDetailCubit(
        getIt<IWorkOrderRepository>(),
        workOrderId,
      )..load(),
      child: const _MobileWorkOrderDetailView(),
    );
  }
}

class _MobileWorkOrderDetailView extends StatelessWidget {
  const _MobileWorkOrderDetailView();

  Future<void> _callCustomer(String phone) async {
    final uri = Uri(scheme: 'tel', path: phone);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }

  Future<void> _openStatusSheet(
    BuildContext context,
    String currentStatus,
  ) async {
    final cubit = context.read<WorkOrderDetailCubit>();
    await StatusBottomSheet.show(
      context,
      currentStatus: currentStatus,
      onConfirm: (target, {note}) async {
        final error = await cubit.updateStatus(target, note: note);
        if (!context.mounted) return;
        if (error != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(error)),
          );
        } else {
          unawaited(HapticFeedback.mediumImpact());
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('İş Emri Detayı')),
      body: BlocBuilder<WorkOrderDetailCubit, WorkOrderDetailState>(
        builder: (context, state) {
          if (state.status == WorkOrderDetailStatus.loading) {
            return const _DetailSkeleton();
          }

          if (state.status == WorkOrderDetailStatus.error) {
            return _ErrorView(
              message: state.errorMessage ?? 'İş emri yüklenemedi.',
              onRetry: () => context.read<WorkOrderDetailCubit>().load(),
            );
          }

          final workOrder = state.workOrder!;
          final transitions = allowedTransitions(workOrder.status);

          return Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(AppDimensions.spaceL),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              workOrder.orderNumber,
                              style: Theme.of(context).textTheme.headlineSmall,
                            ),
                          ),
                          const SizedBox(width: AppDimensions.spaceM),
                          WorkOrderStatusBadge(status: workOrder.status),
                        ],
                      ),
                      const SizedBox(height: AppDimensions.spaceL),
                      _InfoCard(
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  '${workOrder.customer.firstName} '
                                  '${workOrder.customer.lastName}',
                                  style: Theme.of(context).textTheme.titleMedium,
                                ),
                              ),
                              IconButton(
                                tooltip: 'Ara',
                                icon: const Icon(
                                  Icons.call_outlined,
                                  color: AppColors.primary,
                                ),
                                onPressed: () =>
                                    _callCustomer(workOrder.customer.phone),
                              ),
                            ],
                          ),
                          Text(
                            workOrder.customer.phone,
                            style: const TextStyle(color: AppColors.textMuted),
                          ),
                        ],
                      ),
                      const SizedBox(height: AppDimensions.spaceM),
                      _InfoCard(
                        children: [
                          Text(
                            workOrder.categoryPath,
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          if (workOrder.brand != null) ...[
                            const SizedBox(height: AppDimensions.spaceS),
                            Text('Marka: ${workOrder.brand}'),
                          ],
                          if (workOrder.color != null)
                            Text('Renk: ${workOrder.color}'),
                          if (workOrder.material != null)
                            Text('Malzeme: ${workOrder.material}'),
                        ],
                      ),
                      if (workOrder.description != null ||
                          workOrder.existingDamages != null) ...[
                        const SizedBox(height: AppDimensions.spaceM),
                        _InfoCard(
                          title: 'Arıza',
                          children: [
                            if (workOrder.description != null)
                              Text(workOrder.description!),
                            if (workOrder.existingDamages != null)
                              Text(workOrder.existingDamages!),
                          ],
                        ),
                      ],
                      const SizedBox(height: AppDimensions.spaceM),
                      _InfoCard(
                        children: [
                          Text(
                            'Kabul: '
                            '${DateFormat('dd.MM.yyyy').format(workOrder.createdAt.toLocal())}',
                          ),
                          if (workOrder.estimatedDeliveryDate != null)
                            Text(
                              'Tah. Teslim: '
                              '${DateFormat('dd.MM.yyyy').format(workOrder.estimatedDeliveryDate!)}',
                            ),
                        ],
                      ),
                      if (workOrder.services.isNotEmpty) ...[
                        const SizedBox(height: AppDimensions.spaceM),
                        _InfoCard(
                          title: 'Hizmetler',
                          children: workOrder.services
                              .map((s) => Text('• ${s.serviceName}'))
                              .toList(),
                        ),
                      ],
                      if (workOrder.statusHistory.isNotEmpty) ...[
                        const SizedBox(height: AppDimensions.spaceL),
                        Text(
                          'Durum Geçmişi',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        const SizedBox(height: AppDimensions.spaceS),
                        StatusTimeline(history: workOrder.statusHistory),
                      ],
                      const SizedBox(height: AppDimensions.spaceXl),
                    ],
                  ),
                ),
              ),
              if (transitions.isNotEmpty)
                SafeArea(
                  top: false,
                  child: Padding(
                    padding: const EdgeInsets.all(AppDimensions.spaceL),
                    child: SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: ElevatedButton(
                        onPressed: state.isMutating
                            ? null
                            : () => _openStatusSheet(context, workOrder.status),
                        child: state.isMutating
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: AppColors.onPrimary,
                                ),
                              )
                            : const Text('Durumu Değiştir'),
                      ),
                    ),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  const _InfoCard({required this.children, this.title});

  final String? title;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Container(
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
          if (title != null) ...[
            Text(
              title!,
              style: const TextStyle(
                color: AppColors.textMuted,
                fontWeight: FontWeight.w600,
                fontSize: 12,
              ),
            ),
            const SizedBox(height: AppDimensions.spaceXs),
          ],
          ...children,
        ],
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
          const SkeletonBox(width: 180, height: 28),
          const SizedBox(height: AppDimensions.spaceL),
          ...List.generate(
            4,
            (_) => const Padding(
              padding: EdgeInsets.only(bottom: AppDimensions.spaceM),
              child: SkeletonBox(width: double.infinity, height: 80),
            ),
          ),
        ],
      ),
    );
  }
}

class _ErrorView extends StatelessWidget {
  const _ErrorView({required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppDimensions.spaceXl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.error_outline_rounded,
              color: AppColors.error,
              size: 40,
            ),
            const SizedBox(height: AppDimensions.spaceM),
            Text(
              message,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: AppDimensions.spaceM),
            ElevatedButton(
              onPressed: onRetry,
              child: const Text('Tekrar Dene'),
            ),
          ],
        ),
      ),
    );
  }
}
