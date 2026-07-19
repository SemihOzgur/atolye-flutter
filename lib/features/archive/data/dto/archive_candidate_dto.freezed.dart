// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'archive_candidate_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

ArchiveCandidateDto _$ArchiveCandidateDtoFromJson(Map<String, dynamic> json) {
  return _ArchiveCandidateDto.fromJson(json);
}

/// @nodoc
mixin _$ArchiveCandidateDto {
  int get workOrderId => throw _privateConstructorUsedError;
  String get orderNumber => throw _privateConstructorUsedError;
  String get status => throw _privateConstructorUsedError;
  DateTime get closedAt => throw _privateConstructorUsedError;
  int get mediaCount => throw _privateConstructorUsedError;
  int get totalSizeBytes => throw _privateConstructorUsedError;
  bool get hasSocialMediaConsent => throw _privateConstructorUsedError;

  /// Serializes this ArchiveCandidateDto to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ArchiveCandidateDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ArchiveCandidateDtoCopyWith<ArchiveCandidateDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ArchiveCandidateDtoCopyWith<$Res> {
  factory $ArchiveCandidateDtoCopyWith(
          ArchiveCandidateDto value, $Res Function(ArchiveCandidateDto) then) =
      _$ArchiveCandidateDtoCopyWithImpl<$Res, ArchiveCandidateDto>;
  @useResult
  $Res call(
      {int workOrderId,
      String orderNumber,
      String status,
      DateTime closedAt,
      int mediaCount,
      int totalSizeBytes,
      bool hasSocialMediaConsent});
}

/// @nodoc
class _$ArchiveCandidateDtoCopyWithImpl<$Res, $Val extends ArchiveCandidateDto>
    implements $ArchiveCandidateDtoCopyWith<$Res> {
  _$ArchiveCandidateDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ArchiveCandidateDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? workOrderId = null,
    Object? orderNumber = null,
    Object? status = null,
    Object? closedAt = null,
    Object? mediaCount = null,
    Object? totalSizeBytes = null,
    Object? hasSocialMediaConsent = null,
  }) {
    return _then(_value.copyWith(
      workOrderId: null == workOrderId
          ? _value.workOrderId
          : workOrderId // ignore: cast_nullable_to_non_nullable
              as int,
      orderNumber: null == orderNumber
          ? _value.orderNumber
          : orderNumber // ignore: cast_nullable_to_non_nullable
              as String,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      closedAt: null == closedAt
          ? _value.closedAt
          : closedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      mediaCount: null == mediaCount
          ? _value.mediaCount
          : mediaCount // ignore: cast_nullable_to_non_nullable
              as int,
      totalSizeBytes: null == totalSizeBytes
          ? _value.totalSizeBytes
          : totalSizeBytes // ignore: cast_nullable_to_non_nullable
              as int,
      hasSocialMediaConsent: null == hasSocialMediaConsent
          ? _value.hasSocialMediaConsent
          : hasSocialMediaConsent // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ArchiveCandidateDtoImplCopyWith<$Res>
    implements $ArchiveCandidateDtoCopyWith<$Res> {
  factory _$$ArchiveCandidateDtoImplCopyWith(_$ArchiveCandidateDtoImpl value,
          $Res Function(_$ArchiveCandidateDtoImpl) then) =
      __$$ArchiveCandidateDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int workOrderId,
      String orderNumber,
      String status,
      DateTime closedAt,
      int mediaCount,
      int totalSizeBytes,
      bool hasSocialMediaConsent});
}

/// @nodoc
class __$$ArchiveCandidateDtoImplCopyWithImpl<$Res>
    extends _$ArchiveCandidateDtoCopyWithImpl<$Res, _$ArchiveCandidateDtoImpl>
    implements _$$ArchiveCandidateDtoImplCopyWith<$Res> {
  __$$ArchiveCandidateDtoImplCopyWithImpl(_$ArchiveCandidateDtoImpl _value,
      $Res Function(_$ArchiveCandidateDtoImpl) _then)
      : super(_value, _then);

  /// Create a copy of ArchiveCandidateDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? workOrderId = null,
    Object? orderNumber = null,
    Object? status = null,
    Object? closedAt = null,
    Object? mediaCount = null,
    Object? totalSizeBytes = null,
    Object? hasSocialMediaConsent = null,
  }) {
    return _then(_$ArchiveCandidateDtoImpl(
      workOrderId: null == workOrderId
          ? _value.workOrderId
          : workOrderId // ignore: cast_nullable_to_non_nullable
              as int,
      orderNumber: null == orderNumber
          ? _value.orderNumber
          : orderNumber // ignore: cast_nullable_to_non_nullable
              as String,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      closedAt: null == closedAt
          ? _value.closedAt
          : closedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      mediaCount: null == mediaCount
          ? _value.mediaCount
          : mediaCount // ignore: cast_nullable_to_non_nullable
              as int,
      totalSizeBytes: null == totalSizeBytes
          ? _value.totalSizeBytes
          : totalSizeBytes // ignore: cast_nullable_to_non_nullable
              as int,
      hasSocialMediaConsent: null == hasSocialMediaConsent
          ? _value.hasSocialMediaConsent
          : hasSocialMediaConsent // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ArchiveCandidateDtoImpl implements _ArchiveCandidateDto {
  const _$ArchiveCandidateDtoImpl(
      {required this.workOrderId,
      required this.orderNumber,
      required this.status,
      required this.closedAt,
      required this.mediaCount,
      required this.totalSizeBytes,
      required this.hasSocialMediaConsent});

  factory _$ArchiveCandidateDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$ArchiveCandidateDtoImplFromJson(json);

  @override
  final int workOrderId;
  @override
  final String orderNumber;
  @override
  final String status;
  @override
  final DateTime closedAt;
  @override
  final int mediaCount;
  @override
  final int totalSizeBytes;
  @override
  final bool hasSocialMediaConsent;

  @override
  String toString() {
    return 'ArchiveCandidateDto(workOrderId: $workOrderId, orderNumber: $orderNumber, status: $status, closedAt: $closedAt, mediaCount: $mediaCount, totalSizeBytes: $totalSizeBytes, hasSocialMediaConsent: $hasSocialMediaConsent)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ArchiveCandidateDtoImpl &&
            (identical(other.workOrderId, workOrderId) ||
                other.workOrderId == workOrderId) &&
            (identical(other.orderNumber, orderNumber) ||
                other.orderNumber == orderNumber) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.closedAt, closedAt) ||
                other.closedAt == closedAt) &&
            (identical(other.mediaCount, mediaCount) ||
                other.mediaCount == mediaCount) &&
            (identical(other.totalSizeBytes, totalSizeBytes) ||
                other.totalSizeBytes == totalSizeBytes) &&
            (identical(other.hasSocialMediaConsent, hasSocialMediaConsent) ||
                other.hasSocialMediaConsent == hasSocialMediaConsent));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, workOrderId, orderNumber, status,
      closedAt, mediaCount, totalSizeBytes, hasSocialMediaConsent);

  /// Create a copy of ArchiveCandidateDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ArchiveCandidateDtoImplCopyWith<_$ArchiveCandidateDtoImpl> get copyWith =>
      __$$ArchiveCandidateDtoImplCopyWithImpl<_$ArchiveCandidateDtoImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ArchiveCandidateDtoImplToJson(
      this,
    );
  }
}

abstract class _ArchiveCandidateDto implements ArchiveCandidateDto {
  const factory _ArchiveCandidateDto(
      {required final int workOrderId,
      required final String orderNumber,
      required final String status,
      required final DateTime closedAt,
      required final int mediaCount,
      required final int totalSizeBytes,
      required final bool hasSocialMediaConsent}) = _$ArchiveCandidateDtoImpl;

  factory _ArchiveCandidateDto.fromJson(Map<String, dynamic> json) =
      _$ArchiveCandidateDtoImpl.fromJson;

  @override
  int get workOrderId;
  @override
  String get orderNumber;
  @override
  String get status;
  @override
  DateTime get closedAt;
  @override
  int get mediaCount;
  @override
  int get totalSizeBytes;
  @override
  bool get hasSocialMediaConsent;

  /// Create a copy of ArchiveCandidateDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ArchiveCandidateDtoImplCopyWith<_$ArchiveCandidateDtoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
