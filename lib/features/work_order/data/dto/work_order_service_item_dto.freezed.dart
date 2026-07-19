// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'work_order_service_item_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

WorkOrderServiceItemDto _$WorkOrderServiceItemDtoFromJson(
    Map<String, dynamic> json) {
  return _WorkOrderServiceItemDto.fromJson(json);
}

/// @nodoc
mixin _$WorkOrderServiceItemDto {
  int? get servicePriceId => throw _privateConstructorUsedError;
  String get serviceName => throw _privateConstructorUsedError;
  double get priceSnapshot => throw _privateConstructorUsedError;

  /// Serializes this WorkOrderServiceItemDto to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of WorkOrderServiceItemDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $WorkOrderServiceItemDtoCopyWith<WorkOrderServiceItemDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $WorkOrderServiceItemDtoCopyWith<$Res> {
  factory $WorkOrderServiceItemDtoCopyWith(WorkOrderServiceItemDto value,
          $Res Function(WorkOrderServiceItemDto) then) =
      _$WorkOrderServiceItemDtoCopyWithImpl<$Res, WorkOrderServiceItemDto>;
  @useResult
  $Res call({int? servicePriceId, String serviceName, double priceSnapshot});
}

/// @nodoc
class _$WorkOrderServiceItemDtoCopyWithImpl<$Res,
        $Val extends WorkOrderServiceItemDto>
    implements $WorkOrderServiceItemDtoCopyWith<$Res> {
  _$WorkOrderServiceItemDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of WorkOrderServiceItemDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? servicePriceId = freezed,
    Object? serviceName = null,
    Object? priceSnapshot = null,
  }) {
    return _then(_value.copyWith(
      servicePriceId: freezed == servicePriceId
          ? _value.servicePriceId
          : servicePriceId // ignore: cast_nullable_to_non_nullable
              as int?,
      serviceName: null == serviceName
          ? _value.serviceName
          : serviceName // ignore: cast_nullable_to_non_nullable
              as String,
      priceSnapshot: null == priceSnapshot
          ? _value.priceSnapshot
          : priceSnapshot // ignore: cast_nullable_to_non_nullable
              as double,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$WorkOrderServiceItemDtoImplCopyWith<$Res>
    implements $WorkOrderServiceItemDtoCopyWith<$Res> {
  factory _$$WorkOrderServiceItemDtoImplCopyWith(
          _$WorkOrderServiceItemDtoImpl value,
          $Res Function(_$WorkOrderServiceItemDtoImpl) then) =
      __$$WorkOrderServiceItemDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({int? servicePriceId, String serviceName, double priceSnapshot});
}

/// @nodoc
class __$$WorkOrderServiceItemDtoImplCopyWithImpl<$Res>
    extends _$WorkOrderServiceItemDtoCopyWithImpl<$Res,
        _$WorkOrderServiceItemDtoImpl>
    implements _$$WorkOrderServiceItemDtoImplCopyWith<$Res> {
  __$$WorkOrderServiceItemDtoImplCopyWithImpl(
      _$WorkOrderServiceItemDtoImpl _value,
      $Res Function(_$WorkOrderServiceItemDtoImpl) _then)
      : super(_value, _then);

  /// Create a copy of WorkOrderServiceItemDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? servicePriceId = freezed,
    Object? serviceName = null,
    Object? priceSnapshot = null,
  }) {
    return _then(_$WorkOrderServiceItemDtoImpl(
      servicePriceId: freezed == servicePriceId
          ? _value.servicePriceId
          : servicePriceId // ignore: cast_nullable_to_non_nullable
              as int?,
      serviceName: null == serviceName
          ? _value.serviceName
          : serviceName // ignore: cast_nullable_to_non_nullable
              as String,
      priceSnapshot: null == priceSnapshot
          ? _value.priceSnapshot
          : priceSnapshot // ignore: cast_nullable_to_non_nullable
              as double,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$WorkOrderServiceItemDtoImpl implements _WorkOrderServiceItemDto {
  const _$WorkOrderServiceItemDtoImpl(
      {this.servicePriceId,
      required this.serviceName,
      required this.priceSnapshot});

  factory _$WorkOrderServiceItemDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$WorkOrderServiceItemDtoImplFromJson(json);

  @override
  final int? servicePriceId;
  @override
  final String serviceName;
  @override
  final double priceSnapshot;

  @override
  String toString() {
    return 'WorkOrderServiceItemDto(servicePriceId: $servicePriceId, serviceName: $serviceName, priceSnapshot: $priceSnapshot)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$WorkOrderServiceItemDtoImpl &&
            (identical(other.servicePriceId, servicePriceId) ||
                other.servicePriceId == servicePriceId) &&
            (identical(other.serviceName, serviceName) ||
                other.serviceName == serviceName) &&
            (identical(other.priceSnapshot, priceSnapshot) ||
                other.priceSnapshot == priceSnapshot));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, servicePriceId, serviceName, priceSnapshot);

  /// Create a copy of WorkOrderServiceItemDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$WorkOrderServiceItemDtoImplCopyWith<_$WorkOrderServiceItemDtoImpl>
      get copyWith => __$$WorkOrderServiceItemDtoImplCopyWithImpl<
          _$WorkOrderServiceItemDtoImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$WorkOrderServiceItemDtoImplToJson(
      this,
    );
  }
}

abstract class _WorkOrderServiceItemDto implements WorkOrderServiceItemDto {
  const factory _WorkOrderServiceItemDto(
      {final int? servicePriceId,
      required final String serviceName,
      required final double priceSnapshot}) = _$WorkOrderServiceItemDtoImpl;

  factory _WorkOrderServiceItemDto.fromJson(Map<String, dynamic> json) =
      _$WorkOrderServiceItemDtoImpl.fromJson;

  @override
  int? get servicePriceId;
  @override
  String get serviceName;
  @override
  double get priceSnapshot;

  /// Create a copy of WorkOrderServiceItemDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$WorkOrderServiceItemDtoImplCopyWith<_$WorkOrderServiceItemDtoImpl>
      get copyWith => throw _privateConstructorUsedError;
}
