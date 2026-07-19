// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'consumable_group_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

ConsumableGroupDto _$ConsumableGroupDtoFromJson(Map<String, dynamic> json) {
  return _ConsumableGroupDto.fromJson(json);
}

/// @nodoc
mixin _$ConsumableGroupDto {
  int get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  bool get isActive => throw _privateConstructorUsedError;

  /// Serializes this ConsumableGroupDto to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ConsumableGroupDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ConsumableGroupDtoCopyWith<ConsumableGroupDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ConsumableGroupDtoCopyWith<$Res> {
  factory $ConsumableGroupDtoCopyWith(
          ConsumableGroupDto value, $Res Function(ConsumableGroupDto) then) =
      _$ConsumableGroupDtoCopyWithImpl<$Res, ConsumableGroupDto>;
  @useResult
  $Res call({int id, String name, bool isActive});
}

/// @nodoc
class _$ConsumableGroupDtoCopyWithImpl<$Res, $Val extends ConsumableGroupDto>
    implements $ConsumableGroupDtoCopyWith<$Res> {
  _$ConsumableGroupDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ConsumableGroupDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? isActive = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      isActive: null == isActive
          ? _value.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ConsumableGroupDtoImplCopyWith<$Res>
    implements $ConsumableGroupDtoCopyWith<$Res> {
  factory _$$ConsumableGroupDtoImplCopyWith(_$ConsumableGroupDtoImpl value,
          $Res Function(_$ConsumableGroupDtoImpl) then) =
      __$$ConsumableGroupDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({int id, String name, bool isActive});
}

/// @nodoc
class __$$ConsumableGroupDtoImplCopyWithImpl<$Res>
    extends _$ConsumableGroupDtoCopyWithImpl<$Res, _$ConsumableGroupDtoImpl>
    implements _$$ConsumableGroupDtoImplCopyWith<$Res> {
  __$$ConsumableGroupDtoImplCopyWithImpl(_$ConsumableGroupDtoImpl _value,
      $Res Function(_$ConsumableGroupDtoImpl) _then)
      : super(_value, _then);

  /// Create a copy of ConsumableGroupDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? isActive = null,
  }) {
    return _then(_$ConsumableGroupDtoImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      isActive: null == isActive
          ? _value.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ConsumableGroupDtoImpl implements _ConsumableGroupDto {
  const _$ConsumableGroupDtoImpl(
      {required this.id, required this.name, required this.isActive});

  factory _$ConsumableGroupDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$ConsumableGroupDtoImplFromJson(json);

  @override
  final int id;
  @override
  final String name;
  @override
  final bool isActive;

  @override
  String toString() {
    return 'ConsumableGroupDto(id: $id, name: $name, isActive: $isActive)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ConsumableGroupDtoImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.isActive, isActive) ||
                other.isActive == isActive));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, name, isActive);

  /// Create a copy of ConsumableGroupDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ConsumableGroupDtoImplCopyWith<_$ConsumableGroupDtoImpl> get copyWith =>
      __$$ConsumableGroupDtoImplCopyWithImpl<_$ConsumableGroupDtoImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ConsumableGroupDtoImplToJson(
      this,
    );
  }
}

abstract class _ConsumableGroupDto implements ConsumableGroupDto {
  const factory _ConsumableGroupDto(
      {required final int id,
      required final String name,
      required final bool isActive}) = _$ConsumableGroupDtoImpl;

  factory _ConsumableGroupDto.fromJson(Map<String, dynamic> json) =
      _$ConsumableGroupDtoImpl.fromJson;

  @override
  int get id;
  @override
  String get name;
  @override
  bool get isActive;

  /// Create a copy of ConsumableGroupDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ConsumableGroupDtoImplCopyWith<_$ConsumableGroupDtoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
