import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/app_routes.dart';
import '../../../../core/di/injection.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../../../core/utils/currency_formatter.dart';
import '../../../../core/utils/tr_decimal.dart';
import '../../../media/data/media_format_validator.dart';
import '../../../receipt_printing/presentation/print_receipt_action.dart';
import '../../../work_order/presentation/widgets/work_order_status_badge.dart';
import '../../data/dto/receipt_dto.dart';
import '../../data/receipt_repository.dart';
import '../cubit/receipt_detail_cubit.dart';

/// Fiş detayı: kalemler + durumları, çoklu seçimle toplu durum değişikliği ve
/// kısmi teslim. Kaleme dokununca o ürünün iş emri detayı (medya, hizmetler,
/// geçmiş) açılır. Masaüstü ve mobil ortak; [showAppBar] mobil rotada açılır.
class ReceiptDetailPage extends StatelessWidget {
  const ReceiptDetailPage({
    super.key,
    required this.receiptId,
    this.showAppBar = false,
  });

  final int receiptId;
  final bool showAppBar;

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ReceiptDetailCubit>(
      create: (_) =>
          ReceiptDetailCubit(getIt<IReceiptRepository>(), receiptId)..load(),
      child: _ReceiptDetailView(showAppBar: showAppBar),
    );
  }
}

class _ReceiptDetailView extends StatelessWidget {
  const _ReceiptDetailView({required this.showAppBar});

  final bool showAppBar;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ReceiptDetailCubit, ReceiptDetailState>(
      listenWhen: (previous, current) =>
          current.actionError != null &&
          current.actionError != previous.actionError,
      listener: (context, state) => ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(state.actionError!))),
      builder: (context, state) {
        final receipt = state.receipt;
        final Widget body;
        if (receipt == null) {
          body = Center(
            child: state.errorMessage != null
                ? Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(state.errorMessage!),
                      TextButton(
                        onPressed: () =>
                            context.read<ReceiptDetailCubit>().load(),
                        child: const Text('Tekrar Dene'),
                      ),
                    ],
                  )
                : const CircularProgressIndicator(),
          );
        } else {
          body = RefreshIndicator(
            onRefresh: () => context.read<ReceiptDetailCubit>().load(),
            child: ListView(
              padding: const EdgeInsets.all(AppDimensions.spaceL),
              children: [
                _Header(receipt: receipt, showTitle: !showAppBar),
                const SizedBox(height: AppDimensions.spaceM),
                _ItemList(receipt: receipt, state: state),
                const SizedBox(height: 96), // alttaki işlem çubuğu için
              ],
            ),
          );
        }

        return Scaffold(
          appBar: showAppBar
              ? AppBar(
                  title: Text(receipt?.receiptNumber ?? 'Fiş'),
                  actions: [
                    if (receipt != null) PrintReceiptSlipAction(receipt: receipt),
                  ],
                )
              : null,
          body: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 960),
              child: body,
            ),
          ),
          bottomNavigationBar:
              receipt == null || state.selectedIds.isEmpty
                  ? null
                  : _ActionBar(state: state),
        );
      },
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({required this.receipt, required this.showTitle});

  final ReceiptDto receipt;
  final bool showTitle;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final customer = receipt.customer;
    final readySms = receipt.smsHistory.where((s) => s.smsType == 'ORDER_READY');
    final receivedSms =
        receipt.smsHistory.where((s) => s.smsType == 'ORDER_RECEIVED');

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppDimensions.spaceM),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    showTitle ? 'Fiş ${receipt.receiptNumber}' : receipt.receiptNumber,
                    style: textTheme.headlineSmall,
                  ),
                ),
                if (showTitle) PrintReceiptSlipAction(receipt: receipt),
              ],
            ),
            const SizedBox(height: AppDimensions.spaceXs),
            InkWell(
              onTap: () => context.go('${AppRoutes.customers}/${customer.id}'),
              child: Text(
                '${customer.firstName} ${customer.lastName} · ${customer.phone}',
                style: textTheme.titleMedium,
              ),
            ),
            const SizedBox(height: AppDimensions.spaceS),
            Row(
              children: [
                Expanded(
                  child: Text(
                    receipt.trackingUrl,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(color: AppColors.textMuted),
                  ),
                ),
                TextButton.icon(
                  onPressed: () async {
                    await Clipboard.setData(ClipboardData(text: receipt.trackingUrl));
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Link kopyalandı.')),
                      );
                    }
                  },
                  icon: const Icon(Icons.copy_rounded, size: 18),
                  label: const Text('Kopyala'),
                ),
              ],
            ),
            const Divider(),
            Wrap(
              spacing: AppDimensions.spaceL,
              runSpacing: AppDimensions.spaceXs,
              children: [
                Text('Hazır: ${receipt.readyCount}/${receipt.activeCount}'),
                Text('Toplam: ${CurrencyFormatter.format(receipt.totalPrice)}'),
                if (receipt.prepaymentAmount > 0)
                  Text('Ön ödeme: ${CurrencyFormatter.format(receipt.prepaymentAmount)}'),
                if (receipt.collectedAmount > 0)
                  Text('Tahsil: ${CurrencyFormatter.format(receipt.collectedAmount)}'),
                Text(
                  'Kalan: ${CurrencyFormatter.format(receipt.remainingAmount)}',
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
              ],
            ),
            const SizedBox(height: AppDimensions.spaceXs),
            Text(
              'SMS: ${receivedSms.isEmpty ? '⏳ Teslim alındı (ilk "öncesi" medyası yüklenince)' : '✔ Teslim alındı (${_smsStatus(receivedSms.first.status)})'}'
              '   ${readySms.isEmpty ? '⏳ Hazır (tüm ürünler hazır olunca)' : '✔ Hazır (${_smsStatus(readySms.first.status)})'}',
              style: const TextStyle(color: AppColors.textMuted),
            ),
          ],
        ),
      ),
    );
  }

  static String _smsStatus(String status) => switch (status) {
        'SENT' => 'gönderildi',
        'FAILED' => 'gönderilemedi',
        _ => 'kuyrukta',
      };
}

class _ItemList extends StatelessWidget {
  const _ItemList({required this.receipt, required this.state});

  final ReceiptDto receipt;
  final ReceiptDetailState state;

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<ReceiptDetailCubit>();
    return Card(
      child: Column(
        children: [
          ListTile(
            title: Text(
              '${receipt.items.length} ürün',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            trailing: TextButton(
              onPressed: cubit.toggleAll,
              child: const Text('Açıkların hepsini seç'),
            ),
          ),
          const Divider(height: 1),
          for (var i = 0; i < receipt.items.length; i++)
            _ItemTile(
              index: i,
              item: receipt.items[i],
              selected: state.selectedIds.contains(receipt.items[i].id),
              onToggle: () => cubit.toggle(receipt.items[i].id),
              onOpen: () async {
                await context.push('${AppRoutes.workOrders}/${receipt.items[i].id}');
                // Ürün detayında durum/medya değişmiş olabilir
                if (context.mounted) cubit.load();
              },
            ),
        ],
      ),
    );
  }
}

class _ItemTile extends StatelessWidget {
  const _ItemTile({
    required this.index,
    required this.item,
    required this.selected,
    required this.onToggle,
    required this.onOpen,
  });

  final int index;
  final ReceiptItemDto item;
  final bool selected;
  final VoidCallback onToggle;
  final VoidCallback onOpen;

  @override
  Widget build(BuildContext context) {
    final isOpen = item.status != 'DELIVERED' && item.status != 'CANCELLED';
    final details = [
      item.categoryPath.split(' > ').last,
      if (item.brand != null) item.brand!,
      if (item.color != null) item.color!,
    ].join(' · ');

    return ListTile(
      onTap: onOpen,
      leading: Checkbox(
        value: selected,
        onChanged: isOpen ? (_) => onToggle() : null,
      ),
      title: Text('#${index + 1}  $details', overflow: TextOverflow.ellipsis),
      subtitle: Text(
        '${item.orderNumber} · ${CurrencyFormatter.format(item.price)} · '
        '📷 ${item.mediaCount}/${MediaFormatValidator.maxMediaPerOrder}',
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          WorkOrderStatusBadge(status: item.status),
          const Icon(Icons.chevron_right_rounded),
        ],
      ),
    );
  }
}

class _ActionBar extends StatelessWidget {
  const _ActionBar({required this.state});

  final ReceiptDetailState state;

  @override
  Widget build(BuildContext context) {
    final targets = state.commonTargets;
    final cubit = context.read<ReceiptDetailCubit>();
    final busy = state.isBusy;

    return SafeArea(
      child: Material(
        elevation: 8,
        child: Padding(
          padding: const EdgeInsets.all(AppDimensions.spaceS),
          child: Wrap(
            alignment: WrapAlignment.center,
            crossAxisAlignment: WrapCrossAlignment.center,
            spacing: AppDimensions.spaceS,
            runSpacing: AppDimensions.spaceXs,
            children: [
              Text('Seçili: ${state.selectedIds.length}'),
              if (targets.contains('IN_PROGRESS'))
                OutlinedButton(
                  onPressed: busy ? null : () => cubit.changeStatus('IN_PROGRESS'),
                  child: const Text('İşleme Al'),
                ),
              if (targets.contains('READY'))
                ElevatedButton(
                  onPressed: busy ? null : () => _confirmReady(context),
                  child: const Text('Hazır İşaretle'),
                ),
              if (state.canDeliver)
                ElevatedButton(
                  onPressed: busy ? null : () => _openDeliver(context),
                  child: const Text('Teslim Et'),
                ),
              if (targets.contains('CANCELLED'))
                TextButton(
                  onPressed: busy ? null : () => _confirmCancel(context),
                  child: const Text(
                    'İptal Et',
                    style: TextStyle(color: AppColors.error),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _confirmReady(BuildContext context) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Hazır Olarak İşaretle'),
        content: const Text(
          'Fişteki bütün ürünler hazır olduğunda müşteriye tek bir '
          '"ürünleriniz hazır" SMS\'i gider.',
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
    if (ok == true && context.mounted) {
      await context.read<ReceiptDetailCubit>().changeStatus('READY');
    }
  }

  Future<void> _confirmCancel(BuildContext context) async {
    final controller = TextEditingController();
    final note = await showDialog<String>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text('${state.selectedIds.length} ürünü iptal et'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(
            labelText: 'İptal nedeni',
            hintText: 'Örn: Müşteri vazgeçti',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text('Vazgeç'),
          ),
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(controller.text),
            child: const Text('İptal Et'),
          ),
        ],
      ),
    );
    controller.dispose();
    if (note != null && context.mounted) {
      await context.read<ReceiptDetailCubit>().changeStatus(
            'CANCELLED',
            note: note.trim().isEmpty ? null : note.trim(),
          );
    }
  }

  Future<void> _openDeliver(BuildContext context) async {
    final receipt = state.receipt!;
    final selected = state.selectedItems;
    final controller = TextEditingController();
    final amount = await showDialog<double>(
      context: context,
      builder: (dialogContext) => StatefulBuilder(
        builder: (dialogContext, setDialogState) {
          final entered = parseTrDecimal(controller.text);
          final after = (receipt.remainingAmount - (entered ?? 0))
              .clamp(0, double.infinity)
              .toDouble();
          return AlertDialog(
            title: const Text('Teslim Et'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Teslim edilecek: ${selected.map((i) => i.categoryPath.split(' > ').last).join(', ')}',
                ),
                const SizedBox(height: AppDimensions.spaceS),
                Text(
                  'Fiş kalanı (bu teslimden önce): '
                  '${CurrencyFormatter.format(receipt.remainingAmount)}',
                ),
                TextField(
                  controller: controller,
                  autofocus: true,
                  decoration: const InputDecoration(labelText: 'Tahsil edilen'),
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  inputFormatters: [trDecimalInputFormatter],
                  onChanged: (_) => setDialogState(() {}),
                ),
                const SizedBox(height: AppDimensions.spaceS),
                Text('Teslimden sonra fiş kalanı: ${CurrencyFormatter.format(after)}'),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(dialogContext).pop(),
                child: const Text('Vazgeç'),
              ),
              TextButton(
                onPressed: entered == null
                    ? null
                    : () => Navigator.of(dialogContext).pop(entered),
                child: const Text('Teslim Et'),
              ),
            ],
          );
        },
      ),
    );
    controller.dispose();
    if (amount != null && context.mounted) {
      await context.read<ReceiptDetailCubit>().deliver(amount);
    }
  }
}
