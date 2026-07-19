// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'work_order_sms_item_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

WorkOrderSmsItemDto _$WorkOrderSmsItemDtoFromJson(Map<String, dynamic> json) {
  return _WorkOrderSmsItemDto.fromJson(json);
}

/// @nodoc
mixin _$WorkOrderSmsItemDto {
  String get smsType => throw _privateConstructorUsedError;
  String get status => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;
  String? get errorMessage => throw _privateConstructorUsedError;

  /// Serializes this WorkOrderSmsItemDto to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of WorkOrderSmsItemDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $WorkOrderSmsItemDtoCopyWith<WorkOrderSmsItemDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $WorkOrderSmsItemDtoCopyWith<$Res> {
  factory $WorkOrderSmsItemDtoCopyWith(
          WorkOrderSmsItemDto value, $Res Function(WorkOrderSmsItemDto) then) =
      _$WorkOrderSmsItemDtoCopyWithImpl<$Res, WorkOrderSmsItemDto>;
  @useResult
  $Res call(
      {String smsType,
      String status,
      DateTime createdAt,
      String? errorMessage});
}

/// @nodoc
class _$WorkOrderSmsItemDtoCopyWithImpl<$Res, $Val extends WorkOrderSmsItemDto>
    implements $WorkOrderSmsItemDtoCopyWith<$Res> {
  _$WorkOrderSmsItemDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of WorkOrderSmsItemDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? smsType = null,
    Object? status = null,
    Object? createdAt = null,
    Object? errorMessage = freezed,
  }) {
    return _then(_value.copyWith(
      smsType: null == smsType
          ? _value.smsType
          : smsType // ignore: cast_nullable_to_non_nullable
              as String,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      errorMessage: freezed == errorMessage
          ? _value.errorMessage
          : errorMessage // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$WorkOrderSmsItemDtoImplCopyWith<$Res>
    implements $WorkOrderSmsItemDtoCopyWith<$Res> {
  factory _$$WorkOrderSmsItemDtoImplCopyWith(_$WorkOrderSmsItemDtoImpl value,
          $Res Function(_$WorkOrderSmsItemDtoImpl) then) =
      __$$WorkOrderSmsItemDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String smsType,
      String status,
      DateTime createdAt,
      String? errorMessage});
}

/// @nodoc
class __$$WorkOrderSmsItemDtoImplCopyWithImpl<$Res>
    extends _$WorkOrderSmsItemDtoCopyWithImpl<$Res, _$WorkOrderSmsItemDtoImpl>
    implements _$$WorkOrderSmsItemDtoImplCopyWith<$Res> {
  __$$WorkOrderSmsItemDtoImplCopyWithImpl(_$WorkOrderSmsItemDtoImpl _value,
      $Res Function(_$WorkOrderSmsItemDtoImpl) _then)
      : super(_value, _then);

  /// Create a copy of WorkOrderSmsItemDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? smsType = null,
    Object? status = null,
    Object? createdAt = null,
    Object? errorMessage = freezed,
  }) {
    return _then(_$WorkOrderSmsItemDtoImpl(
      smsType: null == smsType
          ? _value.smsType
          : smsType // ignore: cast_nullable_to_non_nullable
              as String,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      errorMessage: freezed == errorMessage
          ? _value.errorMessage
          : errorMessage // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$WorkOrderSmsItemDtoImpl implements _WorkOrderSmsItemDto {
  const _$WorkOrderSmsItemDtoImpl(
      {required this.smsType,
      required this.status,
      required this.createdAt,
      this.errorMessage});

  factory _$WorkOrderSmsItemDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$WorkOrderSmsItemDtoImplFromJson(json);

  @override
  final String smsType;
  @override
  final String status;
  @override
  final DateTime createdAt;
  @override
  final String? errorMessage;

  @override
  String toString() {
    return 'WorkOrderSmsItemDto(smsType: $smsType, status: $status, createdAt: $createdAt, errorMessage: $errorMessage)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$WorkOrderSmsItemDtoImpl &&
            (identical(other.smsType, smsType) || other.smsType == smsType) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.errorMessage, errorMessage) ||
                other.errorMessage == errorMessage));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, smsType, status, createdAt, errorMessage);

  /// Create a copy of WorkOrderSmsItemDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$WorkOrderSmsItemDtoImplCopyWith<_$WorkOrderSmsItemDtoImpl> get copyWith =>
      __$$WorkOrderSmsItemDtoImplCopyWithImpl<_$WorkOrderSmsItemDtoImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$WorkOrderSmsItemDtoImplToJson(
      this,
    );
  }
}

abstract class _WorkOrderSmsItemDto implements WorkOrderSmsItemDto {
  const factory _WorkOrderSmsItemDto(
      {required final String smsType,
      required final String status,
      required final DateTime createdAt,
      final String? errorMessage}) = _$WorkOrderSmsItemDtoImpl;

  factory _WorkOrderSmsItemDto.fromJson(Map<String, dynamic> json) =
      _$WorkOrderSmsItemDtoImpl.fromJson;

  @override
  String get smsType;
  @override
  String get status;
  @override
  DateTime get createdAt;
  @override
  String? get errorMessage;

  /// Create a copy of WorkOrderSmsItemDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$WorkOrderSmsItemDtoImplCopyWith<_$WorkOrderSmsItemDtoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
