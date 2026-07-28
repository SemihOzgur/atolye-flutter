import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_dimensions.dart';
import '../application/receipt_print_service.dart';

/// Yazıcı seçimi (Windows yazıcı kuyruğu ya da LAN IP adresi) + kalıcılık
/// + "Test Fişi Bas" tanılama aksiyonu.
class PrinterSettingsDialog extends StatefulWidget {
  const PrinterSettingsDialog({super.key, required this.service});

  final ReceiptPrintService service;

  static Future<bool> show(
    BuildContext context,
    ReceiptPrintService service,
  ) async {
    final saved = await showDialog<bool>(
      context: context,
      builder: (_) => PrinterSettingsDialog(service: service),
    );
    return saved ?? false;
  }

  @override
  State<PrinterSettingsDialog> createState() => _PrinterSettingsDialogState();
}

class _PrinterSettingsDialogState extends State<PrinterSettingsDialog> {
  PrinterConnectionMode _mode = PrinterConnectionMode.raw;
  List<String> _printers = const [];
  String? _selectedRawPrinter;
  final _networkController = TextEditingController();
  bool _loading = true;
  bool _testing = false;
  String? _testResultMessage;

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void dispose() {
    _networkController.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    final mode = await widget.service.connectionMode();
    final target = await widget.service.selectedTarget();
    final printers = await widget.service.listPrinters();
    if (!mounted) return;

    setState(() {
      _mode = mode;
      _printers = printers;
      if (mode == PrinterConnectionMode.raw) {
        _selectedRawPrinter = target;
      } else {
        _networkController.text = target ?? '';
      }
      _loading = false;
    });
  }

  Future<void> _save() async {
    final target = _mode == PrinterConnectionMode.raw
        ? _selectedRawPrinter
        : _networkController.text.trim();

    if (target == null || target.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Bir yazıcı seçin veya ağ adresi girin.'),
        ),
      );
      return;
    }

    await widget.service.savePrinterSelection(mode: _mode, target: target);
    if (mounted) Navigator.of(context).pop(true);
  }

  Future<void> _testPrint() async {
    setState(() {
      _testing = true;
      _testResultMessage = null;
    });

    final result = await widget.service.printTestReceipt();
    if (!mounted) return;

    setState(() {
      _testing = false;
      _testResultMessage =
          result.success ? 'Test fişi gönderildi.' : result.failureReason;
    });
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Yazıcı Ayarları'),
      content: SizedBox(
        width: 400,
        child: _loading
            ? const SizedBox(
                height: 80,
                child: Center(child: CircularProgressIndicator()),
              )
            : Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SegmentedButton<PrinterConnectionMode>(
                    segments: const [
                      ButtonSegment(
                        value: PrinterConnectionMode.raw,
                        label: Text('Windows Yazıcı'),
                      ),
                      ButtonSegment(
                        value: PrinterConnectionMode.network,
                        label: Text('Ağ (LAN)'),
                      ),
                    ],
                    selected: {_mode},
                    onSelectionChanged: (selection) =>
                        setState(() => _mode = selection.first),
                  ),
                  const SizedBox(height: AppDimensions.spaceM),
                  if (_mode == PrinterConnectionMode.raw)
                    _printers.isEmpty
                        ? const Text(
                            'Sistemde kayıtlı yazıcı bulunamadı.',
                            style: TextStyle(color: AppColors.textMuted),
                          )
                        : DropdownButton<String>(
                            isExpanded: true,
                            hint: const Text('Yazıcı seçin'),
                            value: _printers.contains(_selectedRawPrinter)
                                ? _selectedRawPrinter
                                : null,
                            items: _printers
                                .map(
                                  (name) => DropdownMenuItem(
                                    value: name,
                                    child: Text(name),
                                  ),
                                )
                                .toList(),
                            onChanged: (value) =>
                                setState(() => _selectedRawPrinter = value),
                          )
                  else
                    TextField(
                      controller: _networkController,
                      decoration: const InputDecoration(
                        labelText: 'Yazıcı IP adresi',
                        hintText: 'ör. 192.168.1.50 veya 192.168.1.50:9100',
                      ),
                    ),
                  const SizedBox(height: AppDimensions.spaceM),
                  OutlinedButton.icon(
                    onPressed: _testing ? null : _testPrint,
                    icon: _testing
                        ? const SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Icon(Icons.print_outlined),
                    label: const Text('Test Fişi Bas'),
                  ),
                  if (_testResultMessage != null) ...[
                    const SizedBox(height: AppDimensions.spaceS),
                    Text(
                      _testResultMessage!,
                      style: const TextStyle(
                        color: AppColors.textMuted,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ],
              ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: const Text('Vazgeç'),
        ),
        ElevatedButton(
          onPressed: _loading ? null : _save,
          child: const Text('Kaydet'),
        ),
      ],
    );
  }
}
