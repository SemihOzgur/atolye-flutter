/// Mobil "Durumu Değiştir" akışı için saf geçiş matrisi — backend'deki
/// kuralla birebir aynıdır (`WorkOrdersController.UpdateStatus`,
/// `(order.Status, target)` switch ifadesi): RECEIVED→IN_PROGRESS,
/// IN_PROGRESS→READY, READY→IN_PROGRESS, açık durumlardan→CANCELLED.
/// DELIVERED yalnızca `/deliver` ucundan yapılır — mobilde hiç yok.
class StatusTransition {
  const StatusTransition({
    required this.target,
    required this.label,
    this.requiresSmsConfirm = false,
    this.allowsNote = false,
  });

  final String target;
  final String label;
  final bool requiresSmsConfirm;
  final bool allowsNote;
}

const _inProgress = StatusTransition(
  target: 'IN_PROGRESS',
  label: 'İşleme Al',
);

const _ready = StatusTransition(
  target: 'READY',
  label: 'Hazır',
  requiresSmsConfirm: true,
);

const _backToInProgress = StatusTransition(
  target: 'IN_PROGRESS',
  label: 'İşleme Geri Al',
);

const _cancelled = StatusTransition(
  target: 'CANCELLED',
  label: 'İptal Et',
  allowsNote: true,
);

List<StatusTransition> allowedTransitions(String currentStatus) {
  return switch (currentStatus) {
    'RECEIVED' => const [_inProgress, _cancelled],
    'IN_PROGRESS' => const [_ready, _cancelled],
    'READY' => const [_backToInProgress, _cancelled],
    _ => const [], // DELIVERED / CANCELLED: buton hiç gösterilmez
  };
}
