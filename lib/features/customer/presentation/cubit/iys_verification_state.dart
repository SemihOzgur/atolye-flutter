enum IysPanelStatus { active, confirming, resending, confirmed, skipped }

class IysVerificationState {
  const IysVerificationState({
    this.status = IysPanelStatus.active,
    required this.customerId,
    this.expiresAt,
    this.errorMessage,
    this.wrongAttemptCount = 0,
    this.resendCooldownUntil,
    this.iysConsentStatus,
    this.iysReferenceId,
  });

  final IysPanelStatus status;
  final int customerId;
  final DateTime? expiresAt;
  final String? errorMessage;
  final int wrongAttemptCount;
  final DateTime? resendCooldownUntil;
  final String? iysConsentStatus;
  final String? iysReferenceId;

  static const int maxAttempts = 3;

  int get remainingAttempts =>
      (maxAttempts - wrongAttemptCount).clamp(0, maxAttempts);

  bool get isExpired =>
      expiresAt != null && DateTime.now().isAfter(expiresAt!);

  bool get isInResendCooldown =>
      resendCooldownUntil != null &&
      DateTime.now().isBefore(resendCooldownUntil!);
}
