import 'package:dio/dio.dart';

import '../../../core/constants/api_endpoints.dart';
import '../../../core/network/api_exception.dart';
import 'dto/dashboard_summary_dto.dart';

abstract class IDashboardRepository {
  Future<DashboardSummaryDto> fetchSummary();
}

class DashboardRepository implements IDashboardRepository {
  DashboardRepository(this._dio);

  final Dio _dio;

  @override
  Future<DashboardSummaryDto> fetchSummary() async {
    try {
      final response = await _dio.get<Map<String, dynamic>>(
        ApiEndpoints.dashboardSummary.path,
      );

      return DashboardSummaryDto.fromJson(response.data!);
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    }
  }
}
