import 'package:freezed_annotation/freezed_annotation.dart';

part 'service_type_dto.freezed.dart';
part 'service_type_dto.g.dart';

@freezed
class ServiceTypeDto with _$ServiceTypeDto {
  const factory ServiceTypeDto({
    required int id,
    required String name,
    required int sortOrder,
    required bool isActive,
  }) = _ServiceTypeDto;

  factory ServiceTypeDto.fromJson(Map<String, dynamic> json) =>
      _$ServiceTypeDtoFromJson(json);
}
