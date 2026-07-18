import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_decorations.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../cubit/iys_verification_cubit.dart';
import '../cubit/iys_verification_state.dart';

class IysVerificationPanel extends StatefulWidget {
  const IysVerificationPanel({super.key, required this.onDone});

  final VoidCallback onDone;

  @override
  State<IysVerificationPanel> createState() => _IysVerificationPanelState();
}

class _IysVerificationPanelState extends State<IysVerificationPanel> {
  final _codeController = TextEditingController();
  Timer? _ticker;

  @override
  void initState() {
    super.initState();
    _ticker = Timer.periodic(const Duration(seconds: 1), (_) {
      if (mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    _ticker?.cancel();
    _codeController.dispose();
    super.dispose();
  }

  String _formatRemaining(Duration duration) {
    final seconds = duration.inSeconds.clamp(0, 999);
    final minutes = seconds ~/ 60;
    final secs = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<IysVerificationCubit, IysVerificationState>(
      listener: (context, state) {
        if (state.status == IysPanelStatus.confirmed ||
            state.status == IysPanelStatus.skipped) {
          widget.onDone();
        }
      },
      builder: (context, state) {
        if (state.status == IysPanelStatus.confirmed) {
          return _buildSuccess(context);
        }

        final isBusy = state.status == IysPanelStatus.confirming ||
            state.status == IysPanelStatus.resending;
        final expired = state.isExpired;
        final remaining = state.expiresAt != null
            ? state.expiresAt!.difference(DateTime.now())
            : Duration.zero;
        final cooldownRemaining = state.resendCooldownUntil != null
            ? state.resendCooldownUntil!.difference(DateTime.now())
            : Duration.zero;
        final isInCooldown = state.isInResendCooldown;

        return Container(
          padding: const EdgeInsets.all(AppDimensions.spaceL),
          decoration: BoxDecoration(
            color: AppColors.surfaceMuted,
            borderRadius: AppDecorations.borderRadiusXl,
            border: Border.all(color: AppColors.border),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'İYS Onay Kodu',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: AppDimensions.spaceXs),
              Text(
                'Müşterinin telefonuna gelen 4 haneli kodu girin.',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: AppDimensions.spaceM),
              TextField(
                controller: _codeController,
                enabled: !isBusy,
                maxLength: 4,
                textAlign: TextAlign.center,
                keyboardType: TextInputType.number,
                style: const TextStyle(fontSize: 28, letterSpacing: 12),
                decoration: const InputDecoration(counterText: ''),
                onChanged: (_) => setState(() {}),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    expired
                        ? 'Kodun süresi doldu'
                        : 'Kalan süre: ${_formatRemaining(remaining)}',
                    style: TextStyle(
                      color: expired ? AppColors.error : AppColors.textMuted,
                    ),
                  ),
                  if (state.wrongAttemptCount > 0)
                    Text(
                      'Kalan deneme: ${state.remainingAttempts}',
                      style: const TextStyle(color: AppColors.textMuted),
                    ),
                ],
              ),
              if (state.errorMessage != null) ...[
                const SizedBox(height: AppDimensions.spaceS),
                Text(
                  state.errorMessage!,
                  style: const TextStyle(color: AppColors.error),
                ),
              ],
              const SizedBox(height: AppDimensions.spaceM),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed:
                      (isBusy || expired || _codeController.text.length != 4)
                          ? null
                          : () => context
                              .read<IysVerificationCubit>()
                              .confirm(_codeController.text),
                  child: state.status == IysPanelStatus.confirming
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: AppColors.onPrimary,
                          ),
                        )
                      : const Text('Doğrula'),
                ),
              ),
              const SizedBox(height: AppDimensions.spaceS),
              Row(
                children: [
                  TextButton(
                    onPressed: (isBusy || isInCooldown)
                        ? null
                        : () => context.read<IysVerificationCubit>().resend(),
                    child: Text(
                      isInCooldown
                          ? 'Yeniden gönder (${_formatRemaining(cooldownRemaining)})'
                          : 'Kodu yeniden gönder',
                    ),
                  ),
                  const Spacer(),
                  TextButton(
                    onPressed: isBusy
                        ? null
                        : () => context.read<IysVerificationCubit>().skip(),
                    child: const Text('Atla'),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSuccess(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppDimensions.spaceL),
      decoration: BoxDecoration(
        color: AppColors.success.withValues(alpha: 0.12),
        borderRadius: AppDecorations.borderRadiusXl,
        border: Border.all(color: AppColors.success),
      ),
      child: Row(
        children: [
          const Icon(Icons.check_circle_rounded, color: AppColors.success),
          const SizedBox(width: AppDimensions.spaceM),
          const Expanded(
            child: Text('Kod doğrulandı, İYS\'ye iletildi (teyit bekleniyor).'),
          ),
        ],
      ),
    );
  }
}
