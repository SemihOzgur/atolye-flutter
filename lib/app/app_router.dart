import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';

import '../features/archive/presentation/pages/archive_page.dart';
import '../features/auth/presentation/pages/login_page.dart';
import '../features/catalog/presentation/pages/catalog_page.dart';
import '../features/customer/presentation/pages/customer_detail_page.dart';
import '../features/customer/presentation/pages/customer_form_page.dart';
import '../features/customer/presentation/pages/customer_search_page.dart';
import '../features/dashboard/presentation/pages/dashboard_page.dart';
import '../features/social_media/presentation/pages/social_media_page.dart';
import '../features/work_order/presentation/pages/work_order_detail_page.dart';
import '../features/work_order/presentation/pages/work_order_form_page.dart';
import '../features/work_order/presentation/pages/work_order_list_page.dart';
import 'app_routes.dart';
import 'app_shell.dart';
import 'app_startup_controller.dart';
import 'splash_page.dart';

GoRouter buildAppRouter(
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
        builder: (context, state) => LoginPage(
          startupController: startupController,
        ),
      ),
      ShellRoute(
        builder: (context, state, child) => AppShell(
          onLogout: startupController.logout,
          child: child,
        ),
        routes: [
          GoRoute(
            path: AppRoutes.dashboard,
            builder: (context, state) => const DashboardPage(),
          ),
          GoRoute(
            path: AppRoutes.customers,
            builder: (context, state) => const CustomerSearchPage(),
            routes: [
              GoRoute(
                path: 'new',
                builder: (context, state) => const CustomerFormPage(),
              ),
              GoRoute(
                path: ':id',
                builder: (context, state) => CustomerDetailPage(
                  customerId: int.parse(state.pathParameters['id']!),
                ),
              ),
            ],
          ),
          GoRoute(
            path: AppRoutes.workOrders,
            builder: (context, state) => const WorkOrderListPage(),
            routes: [
              GoRoute(
                path: 'new',
                builder: (context, state) => WorkOrderFormPage(
                  customerId: int.tryParse(
                    state.uri.queryParameters['customerId'] ?? '',
                  ),
                ),
              ),
              GoRoute(
                path: ':id',
                builder: (context, state) => WorkOrderDetailPage(
                  workOrderId: int.parse(state.pathParameters['id']!),
                ),
              ),
            ],
          ),
          GoRoute(
            path: AppRoutes.catalog,
            builder: (context, state) => const CatalogPage(),
          ),
          GoRoute(
            path: AppRoutes.socialMedia,
            builder: (context, state) => const SocialMediaPage(),
          ),
          GoRoute(
            path: AppRoutes.archive,
            builder: (context, state) => const ArchivePage(),
          ),
        ],
      ),
    ],
    redirect: (context, state) {
      final location = state.matchedLocation;

      if (!startupController.isBootstrapped) {
        return location == AppRoutes.splash ? null : AppRoutes.splash;
      }

      final isAuthenticated =
          startupController.state == AppLaunchState.authenticated;
      final isShellLocation = location != AppRoutes.splash &&
          location != AppRoutes.login;

      if (isAuthenticated) {
        if (location == AppRoutes.splash || location == AppRoutes.login) {
          return AppRoutes.dashboard;
        }

        return null;
      }

      if (isShellLocation) {
        return AppRoutes.login;
      }

      if (location == AppRoutes.splash) {
        return AppRoutes.login;
      }

      return null;
    },
  );
}