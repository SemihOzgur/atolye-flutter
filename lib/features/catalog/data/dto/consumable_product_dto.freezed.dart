// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'consumable_product_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

ConsumableProductDto _$ConsumableProductDtoFromJson(Map<String, dynamic> json) {
  return _ConsumableProductDto.fromJson(json);
}

/// @nodoc
mixin _$ConsumableProductDto {
  int get id => throw _privateConstructorUsedError;
  int get groupId => throw _privateConstructorUsedError;
  String get groupName => throw _privateConstructorUsedError;
  String? get brand => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String get displayName => throw _privateConstructorUsedError;
  double get salePrice => throw _privateConstructorUsedError;
  bool get isActive => throw _privateConstructorUsedError;

  /// Serializes this ConsumableProductDto to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ConsumableProductDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ConsumableProductDtoCopyWith<ConsumableProductDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ConsumableProductDtoCopyWith<$Res> {
  factory $ConsumableProductDtoCopyWith(ConsumableProductDto value,
          $Res Function(ConsumableProductDto) then) =
      _$ConsumableProductDtoCopyWithImpl<$Res, ConsumableProductDto>;
  @useResult
  $Res call(
      {int id,
      int groupId,
      String groupName,
      String? brand,
      String name,
      String displayName,
      double salePrice,
      bool isActive});
}

/// @nodoc
class _$ConsumableProductDtoCopyWithImpl<$Res,
        $Val extends ConsumableProductDto>
    implements $ConsumableProductDtoCopyWith<$Res> {
  _$ConsumableProductDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ConsumableProductDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? groupId = null,
    Object? groupName = null,
    Object? brand = freezed,
    Object? name = null,
    Object? displayName = null,
    Object? salePrice = null,
    Object? isActive = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      groupId: null == groupId
          ? _value.groupId
          : groupId // ignore: cast_nullable_to_non_nullable
              as int,
      groupName: null == groupName
          ? _value.groupName
          : groupName // ignore: cast_nullable_to_non_nullable
              as String,
      brand: freezed == brand
          ? _value.brand
          : brand // ignore: cast_nullable_to_non_nullable
              as String?,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      displayName: null == displayName
          ? _value.displayName
          : displayName // ignore: cast_nullable_to_non_nullable
              as String,
      salePrice: null == salePrice
          ? _value.salePrice
          : salePrice // ignore: cast_nullable_to_non_nullable
              as double,
      isActive: null == isActive
          ? _value.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ConsumableProductDtoImplCopyWith<$Res>
    implements $ConsumableProductDtoCopyWith<$Res> {
  factory _$$ConsumableProductDtoImplCopyWith(_$ConsumableProductDtoImpl value,
          $Res Function(_$ConsumableProductDtoImpl) then) =
      __$$ConsumableProductDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int id,
      int groupId,
      String groupName,
      String? brand,
      String name,
      String displayName,
      double salePrice,
      bool isActive});
}

/// @nodoc
class __$$ConsumableProductDtoImplCopyWithImpl<$Res>
    extends _$ConsumableProductDtoCopyWithImpl<$Res, _$ConsumableProductDtoImpl>
    implements _$$ConsumableProductDtoImplCopyWith<$Res> {
  __$$ConsumableProductDtoImplCopyWithImpl(_$ConsumableProductDtoImpl _value,
      $Res Function(_$ConsumableProductDtoImpl) _then)
      : super(_value, _then);

  /// Create a copy of ConsumableProductDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? groupId = null,
    Object? groupName = null,
    Object? brand = freezed,
    Object? name = null,
    Object? displayName = null,
    Object? salePrice = null,
    Object? isActive = null,
  }) {
    return _then(_$ConsumableProductDtoImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      groupId: null == groupId
          ? _value.groupId
          : groupId // ignore: cast_nullable_to_non_nullable
              as int,
      groupName: null == groupName
          ? _value.groupName
          : groupName // ignore: cast_nullable_to_non_nullable
              as String,
      brand: freezed == brand
          ? _value.brand
          : brand // ignore: cast_nullable_to_non_nullable
              as String?,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      displayName: null == displayName
          ? _value.displayName
          : displayName // ignore: cast_nullable_to_non_nullable
              as String,
      salePrice: null == salePrice
          ? _value.salePrice
          : salePrice // ignore: cast_nullable_to_non_nullable
              as double,
      isActive: null == isActive
          ? _value.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ConsumableProductDtoImpl implements _ConsumableProductDto {
  const _$ConsumableProductDtoImpl(
      {required this.id,
      required this.groupId,
      required this.groupName,
      this.brand,
      required this.name,
      required this.displayName,
      required this.salePrice,
      required this.isActive});

  factory _$ConsumableProductDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$ConsumableProductDtoImplFromJson(json);

  @override
  final int id;
  @override
  final int groupId;
  @override
  final String groupName;
  @override
  final String? brand;
  @override
  final String name;
  @override
  final String displayName;
  @override
  final double salePrice;
  @override
  final bool isActive;

  @override
  String toString() {
    return 'ConsumableProductDto(id: $id, groupId: $groupId, groupName: $groupName, brand: $brand, name: $name, displayName: $displayName, salePrice: $salePrice, isActive: $isActive)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ConsumableProductDtoImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.groupId, groupId) || other.groupId == groupId) &&
            (identical(other.groupName, groupName) ||
                other.groupName == groupName) &&
            (identical(other.brand, brand) || other.brand == brand) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.displayName, displayName) ||
                other.displayName == displayName) &&
            (identical(other.salePrice, salePrice) ||
                other.salePrice == salePrice) &&
            (identical(other.isActive, isActive) ||
                other.isActive == isActive));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, groupId, groupName, brand,
      name, displayName, salePrice, isActive);

  /// Create a copy of ConsumableProductDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ConsumableProductDtoImplCopyWith<_$ConsumableProductDtoImpl>
      get copyWith =>
          __$$ConsumableProductDtoImplCopyWithImpl<_$ConsumableProductDtoImpl>(
              this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ConsumableProductDtoImplToJson(
      this,
    );
  }
}

abstract class _ConsumableProductDto implements ConsumableProductDto {
  const factory _ConsumableProductDto(
      {required final int id,
      required final int groupId,
      required final String groupName,
      final String? brand,
      required final String name,
      required final String displayName,
      required final double salePrice,
      required final bool isActive}) = _$ConsumableProductDtoImpl;

  factory _ConsumableProductDto.fromJson(Map<String, dynamic> json) =
      _$ConsumableProductDtoImpl.fromJson;

  @override
  int get id;
  @override
  int get groupId;
  @override
  String get groupName;
  @override
  String? get brand;
  @override
  String get name;
  @override
  String get displayName;
  @override
  double get salePrice;
  @override
  bool get isActive;

  /// Create a copy of ConsumableProductDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ConsumableProductDtoImplCopyWith<_$ConsumableProductDtoImpl>
      get copyWith => throw _privateConstructorUsedError;
}
