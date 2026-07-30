import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../core/theme/app_colors.dart';
import '../../core/widgets/app_logo_mark.dart';
import '../app_routes.dart';

/// Mobil kabuk: AppBar (logo + çıkış) + Dashboard içeriği + barkod
/// tarama FAB'ı. Kabuk seçimi platform bazlıdır (bkz. `app.dart`),
/// pencere boyutuna göre asla değişmez.
class MobileShell extends StatelessWidget {
  const MobileShell({
    super.key,
    required this.child,
    required this.onLogout,
  });

  final Widget child;
  final Future<void> Function() onLogout;

  Future<void> _handleScanTap(BuildContext context) async {
    final status = await Permission.camera.request();
    if (!context.mounted) return;

    if (status.isGranted) {
      context.push(AppRoutes.scanner);
      return;
    }

    if (status.isPermanentlyDenied) {
      context.push(AppRoutes.cameraPermission);
    }
    // Yalnızca reddedilmiş (kalıcı değil): sistem izin diyaloğu bir
    // sonraki FAB dokunuşunda yeniden gösterilebilir, ek işlem gerekmez.
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 12,
        title: Row(
          children: [
            const AppLogoMark(size: 32),
            const SizedBox(width: 12),
            const Text('DoTiKa'),
          ],
        ),
        actions: [
          IconButton(
            tooltip: 'Ürünler',
            icon: const Icon(Icons.inventory_2_outlined),
            onPressed: () => context.push(AppRoutes.workOrders),
            color: AppColors.textMuted,
          ),
          IconButton(
            tooltip: 'Çıkış Yap',
            icon: const Icon(Icons.logout_rounded),
            onPressed: onLogout,
            color: AppColors.textMuted,
          ),
        ],
      ),
      body: child,
      floatingActionButton: FloatingActionButton(
        tooltip: 'Barkod Okut',
        onPressed: () => _handleScanTap(context),
        child: const Icon(Icons.qr_code_scanner_rounded),
      ),
    );
  }
}
