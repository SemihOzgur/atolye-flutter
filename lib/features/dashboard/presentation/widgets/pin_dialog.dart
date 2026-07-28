import 'dart:async';

import 'package:flutter/material.dart';

import '../../../../core/security/finance_lock_controller.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimensions.dart';

enum PinDialogMode { setup, verify }

/// Finans kilidi için PIN belirleme/doğrulama diyaloğu. [mode]'a göre tek
/// alan (doğrulama) veya iki alan (belirleme + tekrar) gösterir; doğrulama
/// modunda "PIN'i unuttum" akışını ve kilitlenme geri sayımını da içerir.
class PinDialog extends StatefulWidget {
  const PinDialog({
    super.key,
    required this.mode,
    required this.controller,
    this.onForgotPin,
  });

  final PinDialogMode mode;
  final FinanceLockController controller;
  final VoidCallback? onForgotPin;

  /// Diyaloğu açar; kart(lar)ın kilidinin açılıp açılmadığını döner.
  static Future<bool> show(
    BuildContext context, {
    required PinDialogMode mode,
    required FinanceLockController controller,
    VoidCallback? onForgotPin,
  }) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (_) => PinDialog(
        mode: mode,
        controller: controller,
        onForgotPin: onForgotPin,
      ),
    );
    return result ?? false;
  }

  @override
  State<PinDialog> createState() => _PinDialogState();
}

class _PinDialogState extends State<PinDialog> {
  final _pinController = TextEditingController();
  final _confirmController = TextEditingController();
  String? _errorText;
  Timer? _tickTimer;
  int _lockoutSecondsRemaining = 0;

  @override
  void initState() {
    super.initState();
    _syncLockoutCountdown();
  }

  @override
  void dispose() {
    _tickTimer?.cancel();
    _pinController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  void _syncLockoutCountdown() {
    final lockoutUntil = widget.controller.lockoutUntil;
    _tickTimer?.cancel();
    if (lockoutUntil == null) {
      _lockoutSecondsRemaining = 0;
      return;
    }

    void tick() {
      final remaining = lockoutUntil.difference(DateTime.now()).inSeconds + 1;
      if (!mounted) return;
      setState(() => _lockoutSecondsRemaining = remaining.clamp(0, 999));
      if (remaining <= 0) {
        _tickTimer?.cancel();
      }
    }

    tick();
    _tickTimer = Timer.periodic(const Duration(seconds: 1), (_) => tick());
  }

  Future<void> _submit() async {
    final pin = _pinController.text.trim();
    if (pin.length < 4 || pin.length > 6 || int.tryParse(pin) == null) {
      setState(() => _errorText = 'PIN 4-6 haneli rakam olmalıdır.');
      return;
    }

    if (widget.mode == PinDialogMode.setup) {
      if (pin != _confirmController.text.trim()) {
        setState(() => _errorText = 'PIN tekrarı eşleşmiyor.');
        return;
      }
      await widget.controller.setPinAndUnlock(pin);
      if (mounted) Navigator.of(context).pop(true);
      return;
    }

    final result = await widget.controller.unlock(pin);
    if (!mounted) return;

    switch (result) {
      case PinVerifyResult.ok:
        Navigator.of(context).pop(true);
      case PinVerifyResult.wrong:
        _pinController.clear();
        setState(() {
          _errorText = 'Hatalı PIN '
              '(${widget.controller.failedAttempts}/${widget.controller.maxAttempts})';
        });
        _syncLockoutCountdown();
      case PinVerifyResult.lockedOut:
        setState(
          () => _errorText = 'Çok fazla hatalı deneme. Lütfen bekleyin.',
        );
        _syncLockoutCountdown();
    }
  }

  Future<void> _forgotPin() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('PIN\'i Unuttum'),
        content: const Text(
          'PIN silinecek ve oturumunuz kapatılacak. Tekrar giriş '
          'yaptıktan sonra yeni bir PIN belirleyebilirsiniz.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: const Text('Vazgeç'),
          ),
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: const Text('PIN\'i Sil'),
          ),
        ],
      ),
    );

    if (confirmed != true) {
      return;
    }

    await widget.controller.resetPin();
    if (!mounted) return;
    Navigator.of(context).pop(false);
    widget.onForgotPin?.call();
  }

  @override
  Widget build(BuildContext context) {
    final isLockedOut = _lockoutSecondsRemaining > 0;

    return AlertDialog(
      title: Text(
        widget.mode == PinDialogMode.setup ? 'PIN Belirle' : 'PIN Gir',
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextField(
            controller: _pinController,
            obscureText: true,
            autofocus: true,
            enabled: !isLockedOut,
            keyboardType: TextInputType.number,
            maxLength: 6,
            decoration: InputDecoration(
              labelText: 'PIN',
              errorText: _errorText,
              counterText: '',
            ),
            onSubmitted: (_) => isLockedOut ? null : _submit(),
          ),
          if (widget.mode == PinDialogMode.setup)
            TextField(
              controller: _confirmController,
              obscureText: true,
              keyboardType: TextInputType.number,
              maxLength: 6,
              decoration: const InputDecoration(
                labelText: 'PIN (Tekrar)',
                counterText: '',
              ),
              onSubmitted: (_) => _submit(),
            ),
          if (isLockedOut)
            Padding(
              padding: const EdgeInsets.only(top: AppDimensions.spaceS),
              child: Text(
                '$_lockoutSecondsRemaining sn sonra tekrar deneyin.',
                style: const TextStyle(color: AppColors.error, fontSize: 12),
              ),
            ),
          if (widget.mode == PinDialogMode.verify) ...[
            const SizedBox(height: AppDimensions.spaceS),
            Align(
              alignment: Alignment.centerLeft,
              child: TextButton(
                onPressed: _forgotPin,
                child: const Text('PIN\'i unuttum'),
              ),
            ),
          ],
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: const Text('Vazgeç'),
        ),
        ElevatedButton(
          onPressed: isLockedOut ? null : _submit,
          child: const Text('Onayla'),
        ),
      ],
    );
  }
}
