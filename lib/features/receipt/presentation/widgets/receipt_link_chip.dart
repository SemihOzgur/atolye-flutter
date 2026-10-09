import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/app_routes.dart';

/// İş emri detayında: kalem bir fişe aitse fişe dönüş bağlantısı. Fişsiz
/// (eski) iş emirlerinde hiçbir şey çizmez.
class ReceiptLinkChip extends StatelessWidget {
  const ReceiptLinkChip({super.key, this.receiptId, this.receiptNumber});

  final int? receiptId;
  final String? receiptNumber;

  @override
  Widget build(BuildContext context) {
    final id = receiptId;
    if (id == null) return const SizedBox.shrink();
    return ActionChip(
      avatar: const Icon(Icons.receipt_long_outlined, size: 18),
      label: Text('Fiş ${receiptNumber ?? ''} · tüm ürünler'),
      onPressed: () => context.go('${AppRoutes.receipts}/$id'),
    );
  }
}
