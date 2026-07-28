import 'dart:io';

import 'package:flutter/material.dart';

import '../../../core/di/injection.dart';
import '../../../core/theme/app_dimensions.dart';
import '../../work_order/data/dto/work_order_dto.dart';
import '../application/receipt_print_service.dart';
import 'printer_settings_dialog.dart';

/// İş Emri Detay başlık satırına eklenen "Fiş Bas" butonu. Yalnızca
/// Windows'ta görünür (SDD F4 AC-7) — masaüstü yazdırma yolu diğer
/// platformlarda anlamsız ve win32 çağrıları yalnızca Windows'ta çalışır.
class PrintReceiptAction extends StatelessWidget {
  const PrintReceiptAction({super.key, required this.workOrder});

  final WorkOrderDto workOrder;

  @override
  Widget build(BuildContext context) {
    if (!Platform.isWindows) {
      return const SizedBox.shrink();
    }

    return IconButton(
      tooltip: 'Fiş Bas',
      icon: const Icon(Icons.receipt_long_outlined),
      onPressed: () => _handleTap(context),
    );
  }

  Future<void> _handleTap(BuildContext context) async {
    final service = getIt<ReceiptPrintService>();

    var target = await service.selectedTarget();
    if (!context.mounted) return;

    if (target == null || target.isEmpty) {
      final saved = await PrinterSettingsDialog.show(context, service);
      if (!saved || !context.mounted) return;
      target = await service.selectedTarget();
      if (target == null || target.isEmpty || !context.mounted) return;
    }

    final options = await showDialog<PrintOptions>(
      context: context,
      builder: (_) => const _PrintPreviewDialog(),
    );
    if (options == null || !context.mounted) return;

    final result = await service.printWorkOrderReceipt(workOrder, options);
    if (!context.mounted) return;

    if (result.success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Fiş yazdırıldı.')),
      );
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Yazıcıya erişilemedi: ${result.failureReason}'),
        action: SnackBarAction(
          label: 'Yazıcı Ayarları',
          onPressed: () => PrinterSettingsDialog.show(context, service),
        ),
      ),
    );
  }
}

class _PrintPreviewDialog extends StatefulWidget {
  const _PrintPreviewDialog();

  @override
  State<_PrintPreviewDialog> createState() => _PrintPreviewDialogState();
}

class _PrintPreviewDialogState extends State<_PrintPreviewDialog> {
  static const _maxCopies = 5;

  int _copies = 1;
  bool _maskPhone = true;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Fiş Bas'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Text('Kopya sayısı:'),
              const Spacer(),
              IconButton(
                onPressed: _copies > 1
                    ? () => setState(() => _copies--)
                    : null,
                icon: const Icon(Icons.remove_circle_outline),
              ),
              Text('$_copies'),
              IconButton(
                onPressed: _copies < _maxCopies
                    ? () => setState(() => _copies++)
                    : null,
                icon: const Icon(Icons.add_circle_outline),
              ),
            ],
          ),
          const SizedBox(height: AppDimensions.spaceS),
          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            title: const Text('Telefonu maskele'),
            value: _maskPhone,
            onChanged: (value) => setState(() => _maskPhone = value),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Vazgeç'),
        ),
        ElevatedButton(
          onPressed: () => Navigator.of(context).pop(
            PrintOptions(copies: _copies, maskPhone: _maskPhone),
          ),
          child: const Text('Yazdır'),
        ),
      ],
    );
  }
}
