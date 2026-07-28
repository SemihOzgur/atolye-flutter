import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

import '../../../../app/app_routes.dart';
import '../../../../core/di/injection.dart';
import '../../../work_order/data/work_order_repository.dart';
import '../cubit/scan_resolve_cubit.dart';
import '../cubit/scan_resolve_state.dart';

/// Tam ekran barkod tarayıcı. Code128 (F4 fiş sözleşmesi) + QR dinler;
/// bir okuma çözümlenirken kamera duraklatılır (çift okuma koruması).
class ScannerPage extends StatelessWidget {
  const ScannerPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ScanResolveCubit>(
      create: (_) => ScanResolveCubit(getIt<IWorkOrderRepository>()),
      child: const _ScannerView(),
    );
  }
}

class _ScannerView extends StatefulWidget {
  const _ScannerView();

  @override
  State<_ScannerView> createState() => _ScannerViewState();
}

class _ScannerViewState extends State<_ScannerView> {
  final MobileScannerController _controller = MobileScannerController(
    formats: const [BarcodeFormat.code128, BarcodeFormat.qrCode],
  );
  bool _torchOn = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleDetect(BarcodeCapture capture) {
    final cubit = context.read<ScanResolveCubit>();
    if (cubit.state.status != ScanResolveStatus.idle &&
        cubit.state.status != ScanResolveStatus.rejected) {
      return;
    }

    final barcodes = capture.barcodes;
    if (barcodes.isEmpty) return;
    final value = barcodes.first.rawValue;
    if (value == null || value.isEmpty) return;

    unawaited(_controller.stop());
    unawaited(HapticFeedback.mediumImpact());
    cubit.resolve(value);
  }

  Future<void> _toggleTorch() async {
    await _controller.toggleTorch();
    if (mounted) setState(() => _torchOn = !_torchOn);
  }

  void _retry() {
    context.read<ScanResolveCubit>().reset();
    unawaited(_controller.start());
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ScanResolveCubit, ScanResolveState>(
      listener: (context, state) {
        if (state.status == ScanResolveStatus.resolved &&
            state.resolvedWorkOrderId != null) {
          context.pushReplacement(
            '${AppRoutes.workOrders}/${state.resolvedWorkOrderId}',
          );
        }
      },
      child: Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          backgroundColor: Colors.black,
          foregroundColor: Colors.white,
          title: const Text('Barkod Okut'),
          actions: [
            IconButton(
              tooltip: 'El Feneri',
              icon: Icon(_torchOn ? Icons.flash_on : Icons.flash_off),
              onPressed: _toggleTorch,
            ),
          ],
        ),
        body: Stack(
          fit: StackFit.expand,
          children: [
            MobileScanner(controller: _controller, onDetect: _handleDetect),
            const _ViewfinderFrame(),
            BlocBuilder<ScanResolveCubit, ScanResolveState>(
              builder: (context, state) {
                switch (state.status) {
                  case ScanResolveStatus.resolving:
                    return const _CenterOverlay(
                      child: CircularProgressIndicator(color: Colors.white),
                    );
                  case ScanResolveStatus.rejected:
                    return _MessageOverlay(
                      message: 'İş emri barkodu okutun.',
                      actionLabel: 'Yeniden Tara',
                      onAction: _retry,
                    );
                  case ScanResolveStatus.notFound:
                    return _MessageOverlay(
                      message: 'Kayıt bulunamadı.',
                      actionLabel: 'Yeniden Tara',
                      onAction: _retry,
                    );
                  case ScanResolveStatus.failure:
                    return _MessageOverlay(
                      message: state.errorMessage ?? 'Bağlantı hatası.',
                      actionLabel: 'Tekrar Dene',
                      onAction: _retry,
                    );
                  case ScanResolveStatus.idle:
                  case ScanResolveStatus.resolved:
                    return const SizedBox.shrink();
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _ViewfinderFrame extends StatelessWidget {
  const _ViewfinderFrame();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 260,
        height: 260,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.white, width: 2),
          borderRadius: BorderRadius.circular(16),
        ),
      ),
    );
  }
}

class _CenterOverlay extends StatelessWidget {
  const _CenterOverlay({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: Colors.black54,
      child: Center(child: child),
    );
  }
}

class _MessageOverlay extends StatelessWidget {
  const _MessageOverlay({
    required this.message,
    required this.actionLabel,
    required this.onAction,
  });

  final String message;
  final String actionLabel;
  final VoidCallback onAction;

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: Colors.black87,
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                message,
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.white, fontSize: 16),
              ),
              const SizedBox(height: 16),
              ElevatedButton(onPressed: onAction, child: Text(actionLabel)),
            ],
          ),
        ),
      ),
    );
  }
}
