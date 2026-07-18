// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'update_customer_request_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

UpdateCustomerRequestDto _$UpdateCustomerRequestDtoFromJson(
    Map<String, dynamic> json) {
  return _UpdateCustomerRequestDto.fromJson(json);
}

/// @nodoc
mixin _$UpdateCustomerRequestDto {
  String get firstName => throw _privateConstructorUsedError;
  String get lastName => throw _privateConstructorUsedError;
  String get phone => throw _privateConstructorUsedError;
  String? get email => throw _privateConstructorUsedError;
  String? get address => throw _privateConstructorUsedError;

  /// Serializes this UpdateCustomerRequestDto to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of UpdateCustomerRequestDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $UpdateCustomerRequestDtoCopyWith<UpdateCustomerRequestDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UpdateCustomerRequestDtoCopyWith<$Res> {
  factory $UpdateCustomerRequestDtoCopyWith(UpdateCustomerRequestDto value,
          $Res Function(UpdateCustomerRequestDto) then) =
      _$UpdateCustomerRequestDtoCopyWithImpl<$Res, UpdateCustomerRequestDto>;
  @useResult
  $Res call(
      {String firstName,
      String lastName,
      String phone,
      String? email,
      String? address});
}

/// @nodoc
class _$UpdateCustomerRequestDtoCopyWithImpl<$Res,
        $Val extends UpdateCustomerRequestDto>
    implements $UpdateCustomerRequestDtoCopyWith<$Res> {
  _$UpdateCustomerRequestDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of UpdateCustomerRequestDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? firstName = null,
    Object? lastName = null,
    Object? phone = null,
    Object? email = freezed,
    Object? address = freezed,
  }) {
    return _then(_value.copyWith(
      firstName: null == firstName
          ? _value.firstName
          : firstName // ignore: cast_nullable_to_non_nullable
              as String,
      lastName: null == lastName
          ? _value.lastName
          : lastName // ignore: cast_nullable_to_non_nullable
              as String,
      phone: null == phone
          ? _value.phone
          : phone // ignore: cast_nullable_to_non_nullable
              as String,
      email: freezed == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String?,
      address: freezed == address
          ? _value.address
          : address // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$UpdateCustomerRequestDtoImplCopyWith<$Res>
    implements $UpdateCustomerRequestDtoCopyWith<$Res> {
  factory _$$UpdateCustomerRequestDtoImplCopyWith(
          _$UpdateCustomerRequestDtoImpl value,
          $Res Function(_$UpdateCustomerRequestDtoImpl) then) =
      __$$UpdateCustomerRequestDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String firstName,
      String lastName,
      String phone,
      String? email,
      String? address});
}

/// @nodoc
class __$$UpdateCustomerRequestDtoImplCopyWithImpl<$Res>
    extends _$UpdateCustomerRequestDtoCopyWithImpl<$Res,
        _$UpdateCustomerRequestDtoImpl>
    implements _$$UpdateCustomerRequestDtoImplCopyWith<$Res> {
  __$$UpdateCustomerRequestDtoImplCopyWithImpl(
      _$UpdateCustomerRequestDtoImpl _value,
      $Res Function(_$UpdateCustomerRequestDtoImpl) _then)
      : super(_value, _then);

  /// Create a copy of UpdateCustomerRequestDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? firstName = null,
    Object? lastName = null,
    Object? phone = null,
    Object? email = freezed,
    Object? address = freezed,
  }) {
    return _then(_$UpdateCustomerRequestDtoImpl(
      firstName: null == firstName
          ? _value.firstName
          : firstName // ignore: cast_nullable_to_non_nullable
              as String,
      lastName: null == lastName
          ? _value.lastName
          : lastName // ignore: cast_nullable_to_non_nullable
              as String,
      phone: null == phone
          ? _value.phone
          : phone // ignore: cast_nullable_to_non_nullable
              as String,
      email: freezed == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String?,
      address: freezed == address
          ? _value.address
          : address // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$UpdateCustomerRequestDtoImpl implements _UpdateCustomerRequestDto {
  const _$UpdateCustomerRequestDtoImpl(
      {required this.firstName,
      required this.lastName,
      required this.phone,
      this.email,
      this.address});

  factory _$UpdateCustomerRequestDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$UpdateCustomerRequestDtoImplFromJson(json);

  @override
  final String firstName;
  @override
  final String lastName;
  @override
  final String phone;
  @override
  final String? email;
  @override
  final String? address;

  @override
  String toString() {
    return 'UpdateCustomerRequestDto(firstName: $firstName, lastName: $lastName, phone: $phone, email: $email, address: $address)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UpdateCustomerRequestDtoImpl &&
            (identical(other.firstName, firstName) ||
                other.firstName == firstName) &&
            (identical(other.lastName, lastName) ||
                other.lastName == lastName) &&
            (identical(other.phone, phone) || other.phone == phone) &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.address, address) || other.address == address));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, firstName, lastName, phone, email, address);

  /// Create a copy of UpdateCustomerRequestDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$UpdateCustomerRequestDtoImplCopyWith<_$UpdateCustomerRequestDtoImpl>
      get copyWith => __$$UpdateCustomerRequestDtoImplCopyWithImpl<
          _$UpdateCustomerRequestDtoImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$UpdateCustomerRequestDtoImplToJson(
      this,
    );
  }
}

abstract class _UpdateCustomerRequestDto implements UpdateCustomerRequestDto {
  const factory _UpdateCustomerRequestDto(
      {required final String firstName,
      required final String lastName,
      required final String phone,
      final String? email,
      final String? address}) = _$UpdateCustomerRequestDtoImpl;

  factory _UpdateCustomerRequestDto.fromJson(Map<String, dynamic> json) =
      _$UpdateCustomerRequestDtoImpl.fromJson;

  @override
  String get firstName;
  @override
  String get lastName;
  @override
  String get phone;
  @override
  String? get email;
  @override
  String? get address;

  /// Create a copy of UpdateCustomerRequestDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$UpdateCustomerRequestDtoImplCopyWith<_$UpdateCustomerRequestDtoImpl>
      get copyWith => throw _privateConstructorUsedError;
}
