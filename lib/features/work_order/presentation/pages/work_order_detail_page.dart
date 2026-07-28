import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../app/app_routes.dart';
import '../../../../core/di/injection.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../../../core/utils/currency_formatter.dart';
import '../../../../core/widgets/skeleton_box.dart';
import '../../../media/presentation/widgets/media_section.dart';
import '../../../receipt_printing/presentation/print_receipt_action.dart';
import '../../data/work_order_repository.dart';
import '../cubit/work_order_detail_cubit.dart';
import '../cubit/work_order_detail_state.dart';
import '../widgets/work_order_status_badge.dart';
import 'work_order_form_page.dart';

class WorkOrderDetailPage extends StatelessWidget {
  const WorkOrderDetailPage({super.key, required this.workOrderId});

  final int workOrderId;

  @override
  Widget build(BuildContext context) {
    return BlocProvider<WorkOrderDetailCubit>(
      create: (_) => WorkOrderDetailCubit(
        getIt<IWorkOrderRepository>(),
        workOrderId,
      )..load(),
      child: const _WorkOrderDetailView(),
    );
  }
}

class _WorkOrderDetailView extends StatelessWidget {
  const _WorkOrderDetailView();

  Future<void> _confirmCancel(BuildContext context) async {
    final noteController = TextEditingController();
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('İş Emrini İptal Et'),
        content: TextField(
          controller: noteController,
          decoration: const InputDecoration(
            labelText: 'İptal nedeni',
            hintText: 'Örn: Müşteri vazgeçti',
          ),
          maxLines: 2,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: const Text('Vazgeç'),
          ),
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: const Text('İptal Et'),
          ),
        ],
      ),
    );

    if (confirmed == true && context.mounted) {
      final error = await context.read<WorkOrderDetailCubit>().updateStatus(
            'CANCELLED',
            note: noteController.text.trim().isEmpty
                ? null
                : noteController.text.trim(),
          );
      if (error != null && context.mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(error)));
      }
    }
  }

  Future<void> _confirmReadyTransition(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Hazır Olarak İşaretle'),
        content: const Text(
          'Müşteriye "ürününüz hazır" SMS\'i gidecek. Devam edilsin mi?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: const Text('Vazgeç'),
          ),
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: const Text('Devam Et'),
          ),
        ],
      ),
    );

    if (confirmed == true && context.mounted) {
      final error =
          await context.read<WorkOrderDetailCubit>().updateStatus('READY');
      if (error != null && context.mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(error)));
      }
    }
  }

  Future<void> _openDeliverDialog(BuildContext context, double remaining) async {
    final controller = TextEditingController(
      text: remaining.toStringAsFixed(2),
    );

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Teslim Et'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Kalan tutar: ${CurrencyFormatter.format(remaining)}'),
            const SizedBox(height: AppDimensions.spaceM),
            TextField(
              controller: controller,
              decoration: const InputDecoration(labelText: 'Teslim Ödemesi'),
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
            ),
            const SizedBox(height: AppDimensions.spaceS),
            const Text(
              'Girilen tutar kaydedilir, ödeme politikası firma '
              'sorumluluğundadır.',
              style: TextStyle(color: AppColors.textMuted, fontSize: 12),
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
            child: const Text('Teslim Et'),
          ),
        ],
      ),
    );

    if (confirmed != true || !context.mounted) {
      return;
    }

    final amount = double.tryParse(controller.text.replaceAll(',', '.'));
    if (amount == null || amount < 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Geçerli bir tutar girin.')),
      );
      return;
    }

    final error = await context.read<WorkOrderDetailCubit>().deliver(amount);
    if (error != null && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(error)));
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WorkOrderDetailCubit, WorkOrderDetailState>(
      builder: (context, state) {
        if (state.status == WorkOrderDetailStatus.loading) {
          return const _WorkOrderDetailSkeleton();
        }

        if (state.status == WorkOrderDetailStatus.error) {
          return Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  state.errorMessage ?? 'İş emri yüklenemedi.',
                  style: const TextStyle(color: AppColors.error),
                ),
                const SizedBox(height: AppDimensions.spaceM),
                ElevatedButton(
                  onPressed: () => context.read<WorkOrderDetailCubit>().load(),
                  child: const Text('Tekrar Dene'),
                ),
              ],
            ),
          );
        }

        final workOrder = state.workOrder!;
        final isOpen = workOrder.status == 'RECEIVED' ||
            workOrder.status == 'IN_PROGRESS' ||
            workOrder.status == 'READY';
        final isMutating = state.isMutating;

        return SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    workOrder.orderNumber,
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  const SizedBox(width: AppDimensions.spaceM),
                  WorkOrderStatusBadge(status: workOrder.status),
                  const Spacer(),
                  PrintReceiptAction(workOrder: workOrder),
                  IconButton(
                    tooltip: 'Linki kopyala',
                    icon: const Icon(Icons.link_rounded),
                    onPressed: () {
                      Clipboard.setData(
                        ClipboardData(text: workOrder.trackingUrl),
                      );
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Link kopyalandı.')),
                      );
                    },
                  ),
                ],
              ),
              Text(
                'Oluşturma: '
                '${DateFormat('dd.MM.yyyy HH:mm').format(workOrder.createdAt.toLocal())}',
                style: const TextStyle(color: AppColors.textMuted),
              ),
              const SizedBox(height: AppDimensions.spaceL),

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
                              '${workOrder.customer.firstName} '
                              '${workOrder.customer.lastName}',
                              style: Theme.of(context).textTheme.titleLarge,
                            ),
                          ),
                          TextButton(
                            onPressed: () => context.go(
                              '${AppRoutes.customers}/${workOrder.customer.id}',
                            ),
                            child: const Text('Müşteri Detayı'),
                          ),
                        ],
                      ),
                      Text(workOrder.customer.phone),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: AppDimensions.spaceM),

              Card(
                child: Padding(
                  padding: const EdgeInsets.all(AppDimensions.spaceL),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        workOrder.categoryPath,
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: AppDimensions.spaceS),
                      if (workOrder.brand != null) Text('Marka: ${workOrder.brand}'),
                      if (workOrder.color != null) Text('Renk: ${workOrder.color}'),
                      if (workOrder.material != null)
                        Text('Malzeme: ${workOrder.material}'),
                      if (workOrder.description != null)
                        Text('Açıklama: ${workOrder.description}'),
                      if (workOrder.existingDamages != null)
                        Text('Mevcut Hasarlar: ${workOrder.existingDamages}'),
                      if (workOrder.estimatedDeliveryDate != null)
                        Text(
                          'Tahmini Teslim: '
                          '${DateFormat('dd.MM.yyyy').format(workOrder.estimatedDeliveryDate!)}',
                        ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: AppDimensions.spaceM),

              if (workOrder.services.isNotEmpty) ...[
                Text('Hizmetler', style: Theme.of(context).textTheme.titleLarge),
                Card(
                  child: Column(
                    children: workOrder.services
                        .map(
                          (service) => ListTile(
                            title: Text(service.serviceName),
                            trailing: Text(
                              CurrencyFormatter.format(service.priceSnapshot),
                            ),
                          ),
                        )
                        .toList(),
                  ),
                ),
                const SizedBox(height: AppDimensions.spaceM),
              ],

              if (workOrder.consumables.isNotEmpty) ...[
                Text(
                  'Sarf Malzemeler',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                Card(
                  child: Column(
                    children: workOrder.consumables
                        .map(
                          (item) => ListTile(
                            title: Text(item.productName),
                            subtitle: Text(
                              '${item.quantity} × '
                              '${CurrencyFormatter.format(item.unitPriceSnapshot)}',
                            ),
                            trailing:
                                Text(CurrencyFormatter.format(item.lineTotal)),
                          ),
                        )
                        .toList(),
                  ),
                ),
                const SizedBox(height: AppDimensions.spaceM),
              ],

              Text('Fiyat', style: Theme.of(context).textTheme.titleLarge),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(AppDimensions.spaceL),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Önerilen: '
                        '${CurrencyFormatter.format(workOrder.suggestedPrice)}',
                      ),
                      Text(
                        'Nihai: ${CurrencyFormatter.format(workOrder.price)}',
                      ),
                      if (workOrder.hasPrepayment)
                        Text(
                          'Ön Ödeme: '
                          '${CurrencyFormatter.format(workOrder.prepaymentAmount ?? 0)}',
                        ),
                      Text(
                        'Kalan Tutar: '
                        '${CurrencyFormatter.format(workOrder.remainingAmount)}',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      if (workOrder.status == 'DELIVERED') ...[
                        Text(
                          'Teslim Ödemesi: '
                          '${CurrencyFormatter.format(workOrder.finalPaymentAmount ?? 0)}',
                        ),
                        if (workOrder.deliveredAt != null)
                          Text(
                            'Teslim Tarihi: '
                            '${DateFormat('dd.MM.yyyy HH:mm').format(workOrder.deliveredAt!.toLocal())}',
                          ),
                      ],
                    ],
                  ),
                ),
              ),
              const SizedBox(height: AppDimensions.spaceM),

              MediaSection(
                workOrderId: workOrder.id,
                isOrderOpen: isOpen,
              ),
              const SizedBox(height: AppDimensions.spaceM),

              if (workOrder.smsHistory.isNotEmpty) ...[
                Text('SMS Durumları', style: Theme.of(context).textTheme.titleLarge),
                Card(
                  child: Column(
                    children: workOrder.smsHistory
                        .map(
                          (sms) => ListTile(
                            title: Text(sms.smsType),
                            subtitle: Text(sms.errorMessage ?? sms.status),
                            trailing: sms.status == 'FAILED'
                                ? TextButton(
                                    onPressed: isMutating
                                        ? null
                                        : () async {
                                            final error = await context
                                                .read<WorkOrderDetailCubit>()
                                                .resendSms();
                                            if (error != null &&
                                                context.mounted) {
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(
                                                SnackBar(
                                                  content: Text(error),
                                                ),
                                              );
                                            }
                                          },
                                    child: const Text('Tekrar Gönder'),
                                  )
                                : Text(sms.status),
                          ),
                        )
                        .toList(),
                  ),
                ),
                const SizedBox(height: AppDimensions.spaceM),
              ],

              if (workOrder.statusHistory.isNotEmpty) ...[
                Text('Durum Geçmişi', style: Theme.of(context).textTheme.titleLarge),
                Card(
                  child: Column(
                    children: workOrder.statusHistory
                        .map(
                          (log) => ListTile(
                            title: Text(
                              '${log.oldStatus ?? '—'} → ${log.newStatus}',
                            ),
                            subtitle: Text(log.changedBy),
                            trailing: Text(
                              DateFormat('dd.MM.yyyy HH:mm')
                                  .format(log.changedAt.toLocal()),
                            ),
                          ),
                        )
                        .toList(),
                  ),
                ),
                const SizedBox(height: AppDimensions.spaceL),
              ],

              if (isOpen)
                Wrap(
                  spacing: AppDimensions.spaceM,
                  runSpacing: AppDimensions.spaceM,
                  children: [
                    if (workOrder.status == 'RECEIVED')
                      ElevatedButton(
                        onPressed: isMutating
                            ? null
                            : () => context
                                .read<WorkOrderDetailCubit>()
                                .updateStatus('IN_PROGRESS'),
                        child: const Text('İşleme Al'),
                      ),
                    if (workOrder.status == 'IN_PROGRESS')
                      ElevatedButton(
                        onPressed: isMutating
                            ? null
                            : () => _confirmReadyTransition(context),
                        child: const Text('Hazır Olarak İşaretle'),
                      ),
                    if (workOrder.status == 'READY') ...[
                      ElevatedButton(
                        onPressed: isMutating
                            ? null
                            : () => _openDeliverDialog(
                                  context,
                                  workOrder.remainingAmount,
                                ),
                        child: const Text('Teslim Et'),
                      ),
                      OutlinedButton(
                        onPressed: isMutating
                            ? null
                            : () => context
                                .read<WorkOrderDetailCubit>()
                                .updateStatus('IN_PROGRESS'),
                        child: const Text('İşleme Geri Al'),
                      ),
                    ],
                    OutlinedButton(
                      onPressed: () async {
                        await Navigator.of(context).push(
                          MaterialPageRoute<void>(
                            builder: (_) =>
                                WorkOrderFormPage(existingWorkOrder: workOrder),
                          ),
                        );
                        if (context.mounted) {
                          await context.read<WorkOrderDetailCubit>().load();
                        }
                      },
                      child: const Text('Düzenle'),
                    ),
                    TextButton(
                      onPressed:
                          isMutating ? null : () => _confirmCancel(context),
                      style: TextButton.styleFrom(
                        foregroundColor: AppColors.error,
                      ),
                      child: const Text('İptal Et'),
                    ),
                  ],
                ),
            ],
          ),
        );
      },
    );
  }
}

class _WorkOrderDetailSkeleton extends StatelessWidget {
  const _WorkOrderDetailSkeleton();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const SkeletonBox(width: 180, height: 28),
              const SizedBox(width: AppDimensions.spaceM),
              const SkeletonBox(width: 90, height: 24, borderRadius: 12),
            ],
          ),
          const SizedBox(height: AppDimensions.spaceS),
          const SkeletonBox(width: 220, height: 14),
          const SizedBox(height: AppDimensions.spaceL),
          const _SkeletonCardBlock(height: 90),
          const SizedBox(height: AppDimensions.spaceM),
          const _SkeletonCardBlock(height: 130),
          const SizedBox(height: AppDimensions.spaceM),
          const _SkeletonCardBlock(height: 150),
          const SizedBox(height: AppDimensions.spaceM),
          const _SkeletonCardBlock(height: 130),
        ],
      ),
    );
  }
}

class _SkeletonCardBlock extends StatelessWidget {
  const _SkeletonCardBlock({required this.height});

  final double height;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppDimensions.spaceL),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            const SkeletonBox(width: 160, height: 18),
            const SizedBox(height: AppDimensions.spaceM),
            SkeletonBox(height: height, borderRadius: 8),
          ],
        ),
      ),
    );
  }
}
