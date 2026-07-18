// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'customer_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

CustomerDto _$CustomerDtoFromJson(Map<String, dynamic> json) {
  return _CustomerDto.fromJson(json);
}

/// @nodoc
mixin _$CustomerDto {
  int get id => throw _privateConstructorUsedError;
  String get firstName => throw _privateConstructorUsedError;
  String get lastName => throw _privateConstructorUsedError;
  String get phone => throw _privateConstructorUsedError;
  String? get email => throw _privateConstructorUsedError;
  String? get address => throw _privateConstructorUsedError;
  String get iysConsentStatus => throw _privateConstructorUsedError;
  DateTime? get iysConsentAt => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;

  /// Serializes this CustomerDto to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of CustomerDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CustomerDtoCopyWith<CustomerDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CustomerDtoCopyWith<$Res> {
  factory $CustomerDtoCopyWith(
          CustomerDto value, $Res Function(CustomerDto) then) =
      _$CustomerDtoCopyWithImpl<$Res, CustomerDto>;
  @useResult
  $Res call(
      {int id,
      String firstName,
      String lastName,
      String phone,
      String? email,
      String? address,
      String iysConsentStatus,
      DateTime? iysConsentAt,
      DateTime createdAt});
}

/// @nodoc
class _$CustomerDtoCopyWithImpl<$Res, $Val extends CustomerDto>
    implements $CustomerDtoCopyWith<$Res> {
  _$CustomerDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CustomerDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? firstName = null,
    Object? lastName = null,
    Object? phone = null,
    Object? email = freezed,
    Object? address = freezed,
    Object? iysConsentStatus = null,
    Object? iysConsentAt = freezed,
    Object? createdAt = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
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
      iysConsentStatus: null == iysConsentStatus
          ? _value.iysConsentStatus
          : iysConsentStatus // ignore: cast_nullable_to_non_nullable
              as String,
      iysConsentAt: freezed == iysConsentAt
          ? _value.iysConsentAt
          : iysConsentAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$CustomerDtoImplCopyWith<$Res>
    implements $CustomerDtoCopyWith<$Res> {
  factory _$$CustomerDtoImplCopyWith(
          _$CustomerDtoImpl value, $Res Function(_$CustomerDtoImpl) then) =
      __$$CustomerDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int id,
      String firstName,
      String lastName,
      String phone,
      String? email,
      String? address,
      String iysConsentStatus,
      DateTime? iysConsentAt,
      DateTime createdAt});
}

/// @nodoc
class __$$CustomerDtoImplCopyWithImpl<$Res>
    extends _$CustomerDtoCopyWithImpl<$Res, _$CustomerDtoImpl>
    implements _$$CustomerDtoImplCopyWith<$Res> {
  __$$CustomerDtoImplCopyWithImpl(
      _$CustomerDtoImpl _value, $Res Function(_$CustomerDtoImpl) _then)
      : super(_value, _then);

  /// Create a copy of CustomerDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? firstName = null,
    Object? lastName = null,
    Object? phone = null,
    Object? email = freezed,
    Object? address = freezed,
    Object? iysConsentStatus = null,
    Object? iysConsentAt = freezed,
    Object? createdAt = null,
  }) {
    return _then(_$CustomerDtoImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
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
      iysConsentStatus: null == iysConsentStatus
          ? _value.iysConsentStatus
          : iysConsentStatus // ignore: cast_nullable_to_non_nullable
              as String,
      iysConsentAt: freezed == iysConsentAt
          ? _value.iysConsentAt
          : iysConsentAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$CustomerDtoImpl implements _CustomerDto {
  const _$CustomerDtoImpl(
      {required this.id,
      required this.firstName,
      required this.lastName,
      required this.phone,
      this.email,
      this.address,
      required this.iysConsentStatus,
      this.iysConsentAt,
      required this.createdAt});

  factory _$CustomerDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$CustomerDtoImplFromJson(json);

  @override
  final int id;
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
  final String iysConsentStatus;
  @override
  final DateTime? iysConsentAt;
  @override
  final DateTime createdAt;

  @override
  String toString() {
    return 'CustomerDto(id: $id, firstName: $firstName, lastName: $lastName, phone: $phone, email: $email, address: $address, iysConsentStatus: $iysConsentStatus, iysConsentAt: $iysConsentAt, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CustomerDtoImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.firstName, firstName) ||
                other.firstName == firstName) &&
            (identical(other.lastName, lastName) ||
                other.lastName == lastName) &&
            (identical(other.phone, phone) || other.phone == phone) &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.address, address) || other.address == address) &&
            (identical(other.iysConsentStatus, iysConsentStatus) ||
                other.iysConsentStatus == iysConsentStatus) &&
            (identical(other.iysConsentAt, iysConsentAt) ||
                other.iysConsentAt == iysConsentAt) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, firstName, lastName, phone,
      email, address, iysConsentStatus, iysConsentAt, createdAt);

  /// Create a copy of CustomerDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CustomerDtoImplCopyWith<_$CustomerDtoImpl> get copyWith =>
      __$$CustomerDtoImplCopyWithImpl<_$CustomerDtoImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CustomerDtoImplToJson(
      this,
    );
  }
}

abstract class _CustomerDto implements CustomerDto {
  const factory _CustomerDto(
      {required final int id,
      required final String firstName,
      required final String lastName,
      required final String phone,
      final String? email,
      final String? address,
      required final String iysConsentStatus,
      final DateTime? iysConsentAt,
      required final DateTime createdAt}) = _$CustomerDtoImpl;

  factory _CustomerDto.fromJson(Map<String, dynamic> json) =
      _$CustomerDtoImpl.fromJson;

  @override
  int get id;
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
  @override
  String get iysConsentStatus;
  @override
  DateTime? get iysConsentAt;
  @override
  DateTime get createdAt;

  /// Create a copy of CustomerDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CustomerDtoImplCopyWith<_$CustomerDtoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
