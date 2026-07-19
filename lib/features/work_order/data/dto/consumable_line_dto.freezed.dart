// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'consumable_line_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

ConsumableLineDto _$ConsumableLineDtoFromJson(Map<String, dynamic> json) {
  return _ConsumableLineDto.fromJson(json);
}

/// @nodoc
mixin _$ConsumableLineDto {
  int get consumableProductId => throw _privateConstructorUsedError;
  int get quantity => throw _privateConstructorUsedError;

  /// Serializes this ConsumableLineDto to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ConsumableLineDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ConsumableLineDtoCopyWith<ConsumableLineDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ConsumableLineDtoCopyWith<$Res> {
  factory $ConsumableLineDtoCopyWith(
          ConsumableLineDto value, $Res Function(ConsumableLineDto) then) =
      _$ConsumableLineDtoCopyWithImpl<$Res, ConsumableLineDto>;
  @useResult
  $Res call({int consumableProductId, int quantity});
}

/// @nodoc
class _$ConsumableLineDtoCopyWithImpl<$Res, $Val extends ConsumableLineDto>
    implements $ConsumableLineDtoCopyWith<$Res> {
  _$ConsumableLineDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ConsumableLineDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? consumableProductId = null,
    Object? quantity = null,
  }) {
    return _then(_value.copyWith(
      consumableProductId: null == consumableProductId
          ? _value.consumableProductId
          : consumableProductId // ignore: cast_nullable_to_non_nullable
              as int,
      quantity: null == quantity
          ? _value.quantity
          : quantity // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ConsumableLineDtoImplCopyWith<$Res>
    implements $ConsumableLineDtoCopyWith<$Res> {
  factory _$$ConsumableLineDtoImplCopyWith(_$ConsumableLineDtoImpl value,
          $Res Function(_$ConsumableLineDtoImpl) then) =
      __$$ConsumableLineDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({int consumableProductId, int quantity});
}

/// @nodoc
class __$$ConsumableLineDtoImplCopyWithImpl<$Res>
    extends _$ConsumableLineDtoCopyWithImpl<$Res, _$ConsumableLineDtoImpl>
    implements _$$ConsumableLineDtoImplCopyWith<$Res> {
  __$$ConsumableLineDtoImplCopyWithImpl(_$ConsumableLineDtoImpl _value,
      $Res Function(_$ConsumableLineDtoImpl) _then)
      : super(_value, _then);

  /// Create a copy of ConsumableLineDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? consumableProductId = null,
    Object? quantity = null,
  }) {
    return _then(_$ConsumableLineDtoImpl(
      consumableProductId: null == consumableProductId
          ? _value.consumableProductId
          : consumableProductId // ignore: cast_nullable_to_non_nullable
              as int,
      quantity: null == quantity
          ? _value.quantity
          : quantity // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ConsumableLineDtoImpl implements _ConsumableLineDto {
  const _$ConsumableLineDtoImpl(
      {required this.consumableProductId, required this.quantity});

  factory _$ConsumableLineDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$ConsumableLineDtoImplFromJson(json);

  @override
  final int consumableProductId;
  @override
  final int quantity;

  @override
  String toString() {
    return 'ConsumableLineDto(consumableProductId: $consumableProductId, quantity: $quantity)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ConsumableLineDtoImpl &&
            (identical(other.consumableProductId, consumableProductId) ||
                other.consumableProductId == consumableProductId) &&
            (identical(other.quantity, quantity) ||
                other.quantity == quantity));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, consumableProductId, quantity);

  /// Create a copy of ConsumableLineDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ConsumableLineDtoImplCopyWith<_$ConsumableLineDtoImpl> get copyWith =>
      __$$ConsumableLineDtoImplCopyWithImpl<_$ConsumableLineDtoImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ConsumableLineDtoImplToJson(
      this,
    );
  }
}

abstract class _ConsumableLineDto implements ConsumableLineDto {
  const factory _ConsumableLineDto(
      {required final int consumableProductId,
      required final int quantity}) = _$ConsumableLineDtoImpl;

  factory _ConsumableLineDto.fromJson(Map<String, dynamic> json) =
      _$ConsumableLineDtoImpl.fromJson;

  @override
  int get consumableProductId;
  @override
  int get quantity;

  /// Create a copy of ConsumableLineDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ConsumableLineDtoImplCopyWith<_$ConsumableLineDtoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
