import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/network/api_exception.dart';
import '../../data/dashboard_repository.dart';
import 'dashboard_state.dart';

class DashboardCubit extends Cubit<DashboardState> {
  DashboardCubit(this._repository) : super(const DashboardState());

  final IDashboardRepository _repository;

  Future<void> load() async {
    emit(
      DashboardState(
        status: DashboardStatus.loading,
        summary: state.summary,
        lastUpdatedAt: state.lastUpdatedAt,
      ),
    );

    try {
      final summary = await _repository.fetchSummary();
      emit(
        DashboardState(
          status: DashboardStatus.loaded,
          summary: summary,
          lastUpdatedAt: DateTime.now(),
        ),
      );
    } on ApiException catch (e) {
      emit(
        DashboardState(
          status: DashboardStatus.error,
          summary: state.summary,
          errorMessage: e.detail ?? e.message,
          lastUpdatedAt: state.lastUpdatedAt,
        ),
      );
    }
  }
}
