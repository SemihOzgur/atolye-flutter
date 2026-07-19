// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'deliver_work_order_request_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

DeliverWorkOrderRequestDto _$DeliverWorkOrderRequestDtoFromJson(
    Map<String, dynamic> json) {
  return _DeliverWorkOrderRequestDto.fromJson(json);
}

/// @nodoc
mixin _$DeliverWorkOrderRequestDto {
  double get finalPaymentAmount => throw _privateConstructorUsedError;

  /// Serializes this DeliverWorkOrderRequestDto to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of DeliverWorkOrderRequestDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $DeliverWorkOrderRequestDtoCopyWith<DeliverWorkOrderRequestDto>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DeliverWorkOrderRequestDtoCopyWith<$Res> {
  factory $DeliverWorkOrderRequestDtoCopyWith(DeliverWorkOrderRequestDto value,
          $Res Function(DeliverWorkOrderRequestDto) then) =
      _$DeliverWorkOrderRequestDtoCopyWithImpl<$Res,
          DeliverWorkOrderRequestDto>;
  @useResult
  $Res call({double finalPaymentAmount});
}

/// @nodoc
class _$DeliverWorkOrderRequestDtoCopyWithImpl<$Res,
        $Val extends DeliverWorkOrderRequestDto>
    implements $DeliverWorkOrderRequestDtoCopyWith<$Res> {
  _$DeliverWorkOrderRequestDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of DeliverWorkOrderRequestDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? finalPaymentAmount = null,
  }) {
    return _then(_value.copyWith(
      finalPaymentAmount: null == finalPaymentAmount
          ? _value.finalPaymentAmount
          : finalPaymentAmount // ignore: cast_nullable_to_non_nullable
              as double,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$DeliverWorkOrderRequestDtoImplCopyWith<$Res>
    implements $DeliverWorkOrderRequestDtoCopyWith<$Res> {
  factory _$$DeliverWorkOrderRequestDtoImplCopyWith(
          _$DeliverWorkOrderRequestDtoImpl value,
          $Res Function(_$DeliverWorkOrderRequestDtoImpl) then) =
      __$$DeliverWorkOrderRequestDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({double finalPaymentAmount});
}

/// @nodoc
class __$$DeliverWorkOrderRequestDtoImplCopyWithImpl<$Res>
    extends _$DeliverWorkOrderRequestDtoCopyWithImpl<$Res,
        _$DeliverWorkOrderRequestDtoImpl>
    implements _$$DeliverWorkOrderRequestDtoImplCopyWith<$Res> {
  __$$DeliverWorkOrderRequestDtoImplCopyWithImpl(
      _$DeliverWorkOrderRequestDtoImpl _value,
      $Res Function(_$DeliverWorkOrderRequestDtoImpl) _then)
      : super(_value, _then);

  /// Create a copy of DeliverWorkOrderRequestDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? finalPaymentAmount = null,
  }) {
    return _then(_$DeliverWorkOrderRequestDtoImpl(
      finalPaymentAmount: null == finalPaymentAmount
          ? _value.finalPaymentAmount
          : finalPaymentAmount // ignore: cast_nullable_to_non_nullable
              as double,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$DeliverWorkOrderRequestDtoImpl implements _DeliverWorkOrderRequestDto {
  const _$DeliverWorkOrderRequestDtoImpl({required this.finalPaymentAmount});

  factory _$DeliverWorkOrderRequestDtoImpl.fromJson(
          Map<String, dynamic> json) =>
      _$$DeliverWorkOrderRequestDtoImplFromJson(json);

  @override
  final double finalPaymentAmount;

  @override
  String toString() {
    return 'DeliverWorkOrderRequestDto(finalPaymentAmount: $finalPaymentAmount)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DeliverWorkOrderRequestDtoImpl &&
            (identical(other.finalPaymentAmount, finalPaymentAmount) ||
                other.finalPaymentAmount == finalPaymentAmount));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, finalPaymentAmount);

  /// Create a copy of DeliverWorkOrderRequestDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$DeliverWorkOrderRequestDtoImplCopyWith<_$DeliverWorkOrderRequestDtoImpl>
      get copyWith => __$$DeliverWorkOrderRequestDtoImplCopyWithImpl<
          _$DeliverWorkOrderRequestDtoImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$DeliverWorkOrderRequestDtoImplToJson(
      this,
    );
  }
}

abstract class _DeliverWorkOrderRequestDto
    implements DeliverWorkOrderRequestDto {
  const factory _DeliverWorkOrderRequestDto(
          {required final double finalPaymentAmount}) =
      _$DeliverWorkOrderRequestDtoImpl;

  factory _DeliverWorkOrderRequestDto.fromJson(Map<String, dynamic> json) =
      _$DeliverWorkOrderRequestDtoImpl.fromJson;

  @override
  double get finalPaymentAmount;

  /// Create a copy of DeliverWorkOrderRequestDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$DeliverWorkOrderRequestDtoImplCopyWith<_$DeliverWorkOrderRequestDtoImpl>
      get copyWith => throw _privateConstructorUsedError;
}
