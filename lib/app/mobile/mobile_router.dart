import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/widgets/feature_placeholder_page.dart';
import '../../features/auth/presentation/pages/login_page.dart';
import '../../features/dashboard/presentation/pages/mobile_dashboard_page.dart';
import '../../features/scanner/presentation/pages/camera_permission_page.dart';
import '../../features/scanner/presentation/pages/scanner_page.dart';
import '../app_routes.dart';
import '../app_startup_controller.dart';
import '../splash_page.dart';
import 'mobile_shell.dart';

/// Mobil kabuk router'ı: yalnızca Dashboard + tarayıcı→detay akışı.
/// Masaüstü `buildAppRouter`'daki katalog/müşteri/arşiv rotaları
/// bilinçli olarak yok (SDD F5 kapsamı — mobilde teslim/düzenleme yok).
GoRouter buildMobileRouter(
  AppStartupController startupController, {
  GlobalKey<NavigatorState>? navigatorKey,
}) {
  return GoRouter(
    navigatorKey: navigatorKey,
    initialLocation: AppRoutes.splash,
    refreshListenable: startupController,
    routes: [
      GoRoute(
        path: AppRoutes.splash,
        builder: (context, state) => const SplashPage(),
      ),
      GoRoute(
        path: AppRoutes.login,
        builder: (context, state) =>
            LoginPage(startupController: startupController),
      ),
      ShellRoute(
        builder: (context, state, child) => MobileShell(
          onLogout: startupController.logout,
          child: child,
        ),
        routes: [
          GoRoute(
            path: AppRoutes.dashboard,
            builder: (context, state) => const MobileDashboardPage(),
          ),
        ],
      ),
      GoRoute(
        path: AppRoutes.cameraPermission,
        builder: (context, state) => const CameraPermissionPage(),
      ),
      GoRoute(
        path: AppRoutes.scanner,
        builder: (context, state) => const ScannerPage(),
      ),
      GoRoute(
        // Mobil ürün detayı F6'da eklenecek; F5 kapsamında barkod
        // çözümlemesinin doğru kayda ulaştığını göstermek yeterli.
        path: '${AppRoutes.workOrders}/:id',
        builder: (context, state) => FeaturePlaceholderPage(
          title: 'İş Emri #${state.pathParameters['id']}',
          description: 'Mobil detay ekranı bir sonraki feature dalında '
              'eklenecektir.',
          icon: Icons.assignment_outlined,
        ),
      ),
    ],
    redirect: (context, state) {
      final location = state.matchedLocation;

      if (!startupController.isBootstrapped) {
        return location == AppRoutes.splash ? null : AppRoutes.splash;
      }

      final isAuthenticated =
          startupController.state == AppLaunchState.authenticated;
      final isProtectedLocation =
          location != AppRoutes.splash && location != AppRoutes.login;

      if (isAuthenticated) {
        if (location == AppRoutes.splash || location == AppRoutes.login) {
          return AppRoutes.dashboard;
        }
        return null;
      }

      if (isProtectedLocation) {
        return AppRoutes.login;
      }

      if (location == AppRoutes.splash) {
        return AppRoutes.login;
      }

      return null;
    },
  );
}
