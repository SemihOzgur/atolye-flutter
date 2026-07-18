// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dashboard_summary_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$DashboardSummaryDtoImpl _$$DashboardSummaryDtoImplFromJson(
        Map<String, dynamic> json) =>
    _$DashboardSummaryDtoImpl(
      receivedCount: (json['receivedCount'] as num).toInt(),
      inProgressCount: (json['inProgressCount'] as num).toInt(),
      readyCount: (json['readyCount'] as num).toInt(),
      receivedTodayCount: (json['receivedTodayCount'] as num).toInt(),
      deliveredTodayCount: (json['deliveredTodayCount'] as num).toInt(),
      dailyRevenue: (json['dailyRevenue'] as num).toDouble(),
      monthlyRevenue: (json['monthlyRevenue'] as num).toDouble(),
      readyWaitingOverdueCount:
          (json['readyWaitingOverdueCount'] as num).toInt(),
      diskUsageBytes: (json['diskUsageBytes'] as num).toInt(),
    );

Map<String, dynamic> _$$DashboardSummaryDtoImplToJson(
        _$DashboardSummaryDtoImpl instance) =>
    <String, dynamic>{
      'receivedCount': instance.receivedCount,
      'inProgressCount': instance.inProgressCount,
      'readyCount': instance.readyCount,
      'receivedTodayCount': instance.receivedTodayCount,
      'deliveredTodayCount': instance.deliveredTodayCount,
      'dailyRevenue': instance.dailyRevenue,
      'monthlyRevenue': instance.monthlyRevenue,
      'readyWaitingOverdueCount': instance.readyWaitingOverdueCount,
      'diskUsageBytes': instance.diskUsageBytes,
    };
