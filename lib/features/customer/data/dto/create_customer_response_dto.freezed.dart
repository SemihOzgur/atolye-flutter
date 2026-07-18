// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'create_customer_response_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

CreateCustomerResponseDto _$CreateCustomerResponseDtoFromJson(
    Map<String, dynamic> json) {
  return _CreateCustomerResponseDto.fromJson(json);
}

/// @nodoc
mixin _$CreateCustomerResponseDto {
  CustomerDto get customer => throw _privateConstructorUsedError;
  DateTime get iysCodeExpiresAt => throw _privateConstructorUsedError;

  /// Serializes this CreateCustomerResponseDto to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of CreateCustomerResponseDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CreateCustomerResponseDtoCopyWith<CreateCustomerResponseDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CreateCustomerResponseDtoCopyWith<$Res> {
  factory $CreateCustomerResponseDtoCopyWith(CreateCustomerResponseDto value,
          $Res Function(CreateCustomerResponseDto) then) =
      _$CreateCustomerResponseDtoCopyWithImpl<$Res, CreateCustomerResponseDto>;
  @useResult
  $Res call({CustomerDto customer, DateTime iysCodeExpiresAt});

  $CustomerDtoCopyWith<$Res> get customer;
}

/// @nodoc
class _$CreateCustomerResponseDtoCopyWithImpl<$Res,
        $Val extends CreateCustomerResponseDto>
    implements $CreateCustomerResponseDtoCopyWith<$Res> {
  _$CreateCustomerResponseDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CreateCustomerResponseDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? customer = null,
    Object? iysCodeExpiresAt = null,
  }) {
    return _then(_value.copyWith(
      customer: null == customer
          ? _value.customer
          : customer // ignore: cast_nullable_to_non_nullable
              as CustomerDto,
      iysCodeExpiresAt: null == iysCodeExpiresAt
          ? _value.iysCodeExpiresAt
          : iysCodeExpiresAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ) as $Val);
  }

  /// Create a copy of CreateCustomerResponseDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $CustomerDtoCopyWith<$Res> get customer {
    return $CustomerDtoCopyWith<$Res>(_value.customer, (value) {
      return _then(_value.copyWith(customer: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$CreateCustomerResponseDtoImplCopyWith<$Res>
    implements $CreateCustomerResponseDtoCopyWith<$Res> {
  factory _$$CreateCustomerResponseDtoImplCopyWith(
          _$CreateCustomerResponseDtoImpl value,
          $Res Function(_$CreateCustomerResponseDtoImpl) then) =
      __$$CreateCustomerResponseDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({CustomerDto customer, DateTime iysCodeExpiresAt});

  @override
  $CustomerDtoCopyWith<$Res> get customer;
}

/// @nodoc
class __$$CreateCustomerResponseDtoImplCopyWithImpl<$Res>
    extends _$CreateCustomerResponseDtoCopyWithImpl<$Res,
        _$CreateCustomerResponseDtoImpl>
    implements _$$CreateCustomerResponseDtoImplCopyWith<$Res> {
  __$$CreateCustomerResponseDtoImplCopyWithImpl(
      _$CreateCustomerResponseDtoImpl _value,
      $Res Function(_$CreateCustomerResponseDtoImpl) _then)
      : super(_value, _then);

  /// Create a copy of CreateCustomerResponseDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? customer = null,
    Object? iysCodeExpiresAt = null,
  }) {
    return _then(_$CreateCustomerResponseDtoImpl(
      customer: null == customer
          ? _value.customer
          : customer // ignore: cast_nullable_to_non_nullable
              as CustomerDto,
      iysCodeExpiresAt: null == iysCodeExpiresAt
          ? _value.iysCodeExpiresAt
          : iysCodeExpiresAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$CreateCustomerResponseDtoImpl implements _CreateCustomerResponseDto {
  const _$CreateCustomerResponseDtoImpl(
      {required this.customer, required this.iysCodeExpiresAt});

  factory _$CreateCustomerResponseDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$CreateCustomerResponseDtoImplFromJson(json);

  @override
  final CustomerDto customer;
  @override
  final DateTime iysCodeExpiresAt;

  @override
  String toString() {
    return 'CreateCustomerResponseDto(customer: $customer, iysCodeExpiresAt: $iysCodeExpiresAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CreateCustomerResponseDtoImpl &&
            (identical(other.customer, customer) ||
                other.customer == customer) &&
            (identical(other.iysCodeExpiresAt, iysCodeExpiresAt) ||
                other.iysCodeExpiresAt == iysCodeExpiresAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, customer, iysCodeExpiresAt);

  /// Create a copy of CreateCustomerResponseDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CreateCustomerResponseDtoImplCopyWith<_$CreateCustomerResponseDtoImpl>
      get copyWith => __$$CreateCustomerResponseDtoImplCopyWithImpl<
          _$CreateCustomerResponseDtoImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CreateCustomerResponseDtoImplToJson(
      this,
    );
  }
}

abstract class _CreateCustomerResponseDto implements CreateCustomerResponseDto {
  const factory _CreateCustomerResponseDto(
          {required final CustomerDto customer,
          required final DateTime iysCodeExpiresAt}) =
      _$CreateCustomerResponseDtoImpl;

  factory _CreateCustomerResponseDto.fromJson(Map<String, dynamic> json) =
      _$CreateCustomerResponseDtoImpl.fromJson;

  @override
  CustomerDto get customer;
  @override
  DateTime get iysCodeExpiresAt;

  /// Create a copy of CreateCustomerResponseDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CreateCustomerResponseDtoImplCopyWith<_$CreateCustomerResponseDtoImpl>
      get copyWith => throw _privateConstructorUsedError;
}
