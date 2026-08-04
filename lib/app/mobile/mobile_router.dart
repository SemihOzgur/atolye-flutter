import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/presentation/pages/login_page.dart';
import '../../features/customer/presentation/pages/mobile_customer_detail_page.dart';
import '../../features/customer/presentation/pages/mobile_customer_form_page.dart';
import '../../features/customer/presentation/pages/mobile_customer_search_page.dart';
import '../../features/dashboard/presentation/pages/mobile_dashboard_page.dart';
import '../../features/scanner/presentation/pages/camera_permission_page.dart';
import '../../features/scanner/presentation/pages/scanner_page.dart';
import '../../features/work_order/presentation/pages/mobile_work_order_detail_page.dart';
import '../../features/work_order/presentation/pages/mobile_work_order_form_page.dart';
import '../../features/work_order/presentation/pages/mobile_work_order_list_page.dart';
import '../app_routes.dart';
import '../app_startup_controller.dart';
import '../splash_page.dart';
import 'mobile_shell.dart';

/// Mobil kabuk router'ı: Dashboard, tarayıcı→detay akışı ve Product
/// Create/Detail (ürünler listesi, müşteri seçimi, ürün oluşturma).
/// Masaüstü `buildAppRouter`'daki katalog/arşiv rotaları ve ürün
/// düzenleme/teslim bilinçli olarak yok (SDD F6 kapsamı korunuyor).
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
        path: AppRoutes.workOrders,
        builder: (context, state) => const MobileWorkOrderListPage(),
      ),
      GoRoute(
        path: AppRoutes.customers,
        builder: (context, state) => const MobileCustomerSearchPage(),
        routes: [
          GoRoute(
            path: 'new',
            builder: (context, state) => const MobileCustomerFormPage(),
          ),
          GoRoute(
            path: ':id',
            builder: (context, state) => MobileCustomerDetailPage(
              customerId: int.parse(state.pathParameters['id']!),
            ),
          ),
        ],
      ),
      GoRoute(
        path: '${AppRoutes.workOrders}/new',
        builder: (context, state) => MobileWorkOrderFormPage(
          customerId:
              int.parse(state.uri.queryParameters['customerId']!),
        ),
      ),
      GoRoute(
        path: '${AppRoutes.workOrders}/:id',
        builder: (context, state) => MobileWorkOrderDetailPage(
          workOrderId: int.parse(state.pathParameters['id']!),
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
