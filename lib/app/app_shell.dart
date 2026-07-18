import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../core/constants/app_routes_labels.dart';
import '../core/theme/app_colors.dart';
import '../core/theme/app_decorations.dart';
import '../core/theme/app_dimensions.dart';
import '../core/widgets/app_logo_mark.dart';
import 'app_routes.dart';

class AppShell extends StatelessWidget {
  const AppShell({super.key, required this.child, required this.onLogout});

  final Widget child;
  final Future<void> Function() onLogout;

  int _selectedIndex(String location) {
    if (location.startsWith(AppRoutes.customers)) {
      return 1;
    }
    if (location.startsWith(AppRoutes.workOrders)) {
      return 2;
    }
    if (location.startsWith(AppRoutes.catalog)) {
      return 3;
    }
    if (location.startsWith(AppRoutes.socialMedia)) {
      return 4;
    }
    if (location.startsWith(AppRoutes.archive)) {
      return 5;
    }
    return 0;
  }

  String _titleForIndex(int index) {
    return switch (index) {
      1 => AppRoutesLabels.customers,
      2 => AppRoutesLabels.workOrders,
      3 => AppRoutesLabels.catalog,
      4 => AppRoutesLabels.socialMedia,
      5 => AppRoutesLabels.archive,
      _ => AppRoutesLabels.dashboard,
    };
  }

  String _routeForIndex(int index) {
    return switch (index) {
      1 => AppRoutes.customers,
      2 => AppRoutes.workOrders,
      3 => AppRoutes.catalog,
      4 => AppRoutes.socialMedia,
      5 => AppRoutes.archive,
      _ => AppRoutes.dashboard,
    };
  }

  @override
  Widget build(BuildContext context) {
    final location = GoRouterState.of(context).matchedLocation;
    final selectedIndex = _selectedIndex(location);

    return Scaffold(
      body: Row(
        children: [
          NavigationRail(
            selectedIndex: selectedIndex,
            onDestinationSelected: (index) => context.go(_routeForIndex(index)),
            labelType: NavigationRailLabelType.all,
            backgroundColor: AppColors.surfaceElevated,
            leading: Padding(
              padding: const EdgeInsets.only(
                top: AppDimensions.spaceL,
                bottom: AppDimensions.spaceM,
              ),
              child: Column(
                children: [
                  const AppLogoMark(size: 72),
                  const SizedBox(height: AppDimensions.spaceM),
                  Text(
                    'DoTiKa',
                    style: Theme.of(context).textTheme.titleLarge,
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            destinations: const [
              NavigationRailDestination(
                icon: Icon(Icons.dashboard_outlined),
                selectedIcon: Icon(Icons.dashboard_rounded),
                label: Text(AppRoutesLabels.dashboard),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.person_search_outlined),
                selectedIcon: Icon(Icons.person_search_rounded),
                label: Text(AppRoutesLabels.customers),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.work_outline),
                selectedIcon: Icon(Icons.work_rounded),
                label: Text(AppRoutesLabels.workOrders),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.category_outlined),
                selectedIcon: Icon(Icons.category_rounded),
                label: Text(AppRoutesLabels.catalog),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.campaign_outlined),
                selectedIcon: Icon(Icons.campaign_rounded),
                label: Text(AppRoutesLabels.socialMedia),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.archive_outlined),
                selectedIcon: Icon(Icons.archive_rounded),
                label: Text(AppRoutesLabels.archive),
              ),
            ],
          ),
          const VerticalDivider(width: 1, thickness: 1, color: AppColors.border),
          Expanded(
            child: Column(
              children: [
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppDimensions.spaceXl,
                    vertical: AppDimensions.spaceL,
                  ),
                  decoration: const BoxDecoration(
                    color: AppColors.surfaceElevated,
                    border: Border(
                      bottom: BorderSide(color: AppColors.border, width: 1),
                    ),
                  ),
                  child: Row(
                    children: [
                      Text(
                        _titleForIndex(selectedIndex),
                        style: Theme.of(context).textTheme.headlineMedium,
                      ),
                      const Spacer(),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppDimensions.spaceM,
                          vertical: AppDimensions.spaceXs,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withValues(alpha: 0.12),
                          borderRadius: AppDecorations.borderRadiusL,
                        ),
                        child: Text(
                          'Desktop Shell',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ),
                      const SizedBox(width: AppDimensions.spaceM),
                      IconButton(
                        onPressed: onLogout,
                        icon: const Icon(Icons.logout_rounded),
                        color: AppColors.textMuted,
                        tooltip: 'Çıkış Yap',
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Container(
                    color: AppColors.background,
                    padding: const EdgeInsets.all(AppDimensions.spaceXl),
                    child: child,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}