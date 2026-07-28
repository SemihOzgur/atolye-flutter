import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimensions.dart';

/// Kamera izni kalıcı olarak reddedildiğinde gösterilir — sistem izin
/// diyaloğu bir daha kendiliğinden çıkmaz, kullanıcı ayarlardan açmalıdır.
class CameraPermissionPage extends StatelessWidget {
  const CameraPermissionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Kamera İzni Gerekli')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(AppDimensions.spaceXl),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.camera_alt_outlined,
                size: 64,
                color: AppColors.textMuted,
              ),
              const SizedBox(height: AppDimensions.spaceL),
              const Text(
                'Ürün barkodunu okutabilmek için kamera izni gerekir. '
                'İzin daha önce reddedildiği için buradan tekrar '
                'açmanız gerekiyor.',
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppDimensions.spaceL),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => openAppSettings(),
                  child: const Text('Ayarları Aç'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
