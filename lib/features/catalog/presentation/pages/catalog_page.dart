import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/di/injection.dart';
import '../../data/catalog_repository.dart';
import '../cubit/category_cubit.dart';
import '../cubit/consumable_cubit.dart';
import '../cubit/service_price_cubit.dart';
import '../cubit/service_type_cubit.dart';
import '../widgets/category_tree_tab.dart';
import '../widgets/consumables_tab.dart';
import '../widgets/service_price_tab.dart';
import '../widgets/service_types_tab.dart';

class CatalogPage extends StatelessWidget {
  const CatalogPage({super.key});

  @override
  Widget build(BuildContext context) {
    final repository = getIt<ICatalogRepository>();

    return MultiBlocProvider(
      providers: [
        BlocProvider<CategoryCubit>(
          create: (_) => CategoryCubit(repository)..load(),
        ),
        BlocProvider<ServiceTypeCubit>(
          create: (_) => ServiceTypeCubit(repository)..load(),
        ),
        BlocProvider<ConsumableCubit>(
          create: (_) => ConsumableCubit(repository)..load(),
        ),
      ],
      child: Builder(
        builder: (context) {
          return BlocProvider<ServicePriceCubit>(
            create: (_) => ServicePriceCubit(
              repository,
              context.read<ServiceTypeCubit>(),
            ),
            child: const _CatalogTabs(),
          );
        },
      ),
    );
  }
}

class _CatalogTabs extends StatelessWidget {
  const _CatalogTabs();

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const TabBar(
            isScrollable: true,
            tabs: [
              Tab(text: 'Kategoriler'),
              Tab(text: 'Hizmet Türleri'),
              Tab(text: 'Fiyat Matrisi'),
              Tab(text: 'Sarf Malzemeler'),
            ],
          ),
          Expanded(
            child: TabBarView(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 16),
                  child: const CategoryTreeTab(),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 16),
                  child: const ServiceTypesTab(),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 16),
                  child: const ServicePriceTab(),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 16),
                  child: const ConsumablesTab(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
