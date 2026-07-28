import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../domain/status_transitions.dart';

/// "Durumu Değiştir" alt sabit bar bunu açar. Yalnızca [currentStatus]'tan
/// backend matrisinin izin verdiği hedefler listelenir (bkz.
/// `status_transitions.dart`) — DELIVERED asla denenmez. READY seçiminde
/// SMS onay diyaloğu, CANCELLED'da opsiyonel not istenir.
class StatusBottomSheet extends StatelessWidget {
  const StatusBottomSheet({
    super.key,
    required this.currentStatus,
    required this.onConfirm,
  });

  final String currentStatus;
  final void Function(String target, {String? note}) onConfirm;

  static Future<void> show(
    BuildContext context, {
    required String currentStatus,
    required void Function(String target, {String? note}) onConfirm,
  }) {
    return showModalBottomSheet<void>(
      context: context,
      builder: (_) => StatusBottomSheet(
        currentStatus: currentStatus,
        onConfirm: onConfirm,
      ),
    );
  }

  Future<void> _handleSelect(
    BuildContext context,
    StatusTransition transition,
  ) async {
    if (transition.requiresSmsConfirm) {
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
      if (confirmed != true) return;
      if (context.mounted) Navigator.of(context).pop();
      onConfirm(transition.target);
      return;
    }

    if (transition.allowsNote) {
      final noteController = TextEditingController();
      final confirmed = await showDialog<bool>(
        context: context,
        builder: (dialogContext) => AlertDialog(
          title: const Text('İş Emrini İptal Et'),
          content: TextField(
            controller: noteController,
            decoration: const InputDecoration(
              labelText: 'İptal nedeni (opsiyonel)',
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
      if (confirmed != true) return;
      final note = noteController.text.trim();
      if (context.mounted) Navigator.of(context).pop();
      onConfirm(transition.target, note: note.isEmpty ? null : note);
      return;
    }

    Navigator.of(context).pop();
    onConfirm(transition.target);
  }

  @override
  Widget build(BuildContext context) {
    final transitions = allowedTransitions(currentStatus);

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(AppDimensions.spaceL),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text('Yeni durum seçin', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: AppDimensions.spaceM),
            for (final transition in transitions) ...[
              _TransitionCard(
                transition: transition,
                onTap: () => _handleSelect(context, transition),
              ),
              const SizedBox(height: AppDimensions.spaceS),
            ],
          ],
        ),
      ),
    );
  }
}

class _TransitionCard extends StatelessWidget {
  const _TransitionCard({required this.transition, required this.onTap});

  final StatusTransition transition;
  final VoidCallback onTap;

  IconData get _icon => switch (transition.target) {
        'READY' => Icons.check_circle_outline_rounded,
        'CANCELLED' => Icons.cancel_outlined,
        'IN_PROGRESS' =>
          transition.label.contains('Geri') ? Icons.undo_rounded : Icons.play_arrow_rounded,
        _ => Icons.arrow_forward_rounded,
      };

  Color get _color => switch (transition.target) {
        'CANCELLED' => AppColors.error,
        'READY' => AppColors.warning,
        _ => AppColors.primary,
      };

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(AppDimensions.radiusL),
        onTap: onTap,
        child: Container(
          constraints: const BoxConstraints(minHeight: 64),
          padding: const EdgeInsets.symmetric(
            horizontal: AppDimensions.spaceL,
            vertical: AppDimensions.spaceM,
          ),
          decoration: BoxDecoration(
            color: AppColors.surface,
            border: Border.all(color: AppColors.border),
            borderRadius: BorderRadius.circular(AppDimensions.radiusL),
          ),
          child: Row(
            children: [
              Icon(_icon, color: _color),
              const SizedBox(width: AppDimensions.spaceM),
              Expanded(
                child: Text(
                  transition.label,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
