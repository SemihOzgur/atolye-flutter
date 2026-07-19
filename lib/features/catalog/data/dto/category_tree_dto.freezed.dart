// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'category_tree_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

CategoryTreeDto _$CategoryTreeDtoFromJson(Map<String, dynamic> json) {
  return _CategoryTreeDto.fromJson(json);
}

/// @nodoc
mixin _$CategoryTreeDto {
  int get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  int get level => throw _privateConstructorUsedError;
  bool get isActive => throw _privateConstructorUsedError;
  List<CategoryTreeDto> get children => throw _privateConstructorUsedError;

  /// Serializes this CategoryTreeDto to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of CategoryTreeDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CategoryTreeDtoCopyWith<CategoryTreeDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CategoryTreeDtoCopyWith<$Res> {
  factory $CategoryTreeDtoCopyWith(
          CategoryTreeDto value, $Res Function(CategoryTreeDto) then) =
      _$CategoryTreeDtoCopyWithImpl<$Res, CategoryTreeDto>;
  @useResult
  $Res call(
      {int id,
      String name,
      int level,
      bool isActive,
      List<CategoryTreeDto> children});
}

/// @nodoc
class _$CategoryTreeDtoCopyWithImpl<$Res, $Val extends CategoryTreeDto>
    implements $CategoryTreeDtoCopyWith<$Res> {
  _$CategoryTreeDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CategoryTreeDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? level = null,
    Object? isActive = null,
    Object? children = null,
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
      level: null == level
          ? _value.level
          : level // ignore: cast_nullable_to_non_nullable
              as int,
      isActive: null == isActive
          ? _value.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
              as bool,
      children: null == children
          ? _value.children
          : children // ignore: cast_nullable_to_non_nullable
              as List<CategoryTreeDto>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$CategoryTreeDtoImplCopyWith<$Res>
    implements $CategoryTreeDtoCopyWith<$Res> {
  factory _$$CategoryTreeDtoImplCopyWith(_$CategoryTreeDtoImpl value,
          $Res Function(_$CategoryTreeDtoImpl) then) =
      __$$CategoryTreeDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int id,
      String name,
      int level,
      bool isActive,
      List<CategoryTreeDto> children});
}

/// @nodoc
class __$$CategoryTreeDtoImplCopyWithImpl<$Res>
    extends _$CategoryTreeDtoCopyWithImpl<$Res, _$CategoryTreeDtoImpl>
    implements _$$CategoryTreeDtoImplCopyWith<$Res> {
  __$$CategoryTreeDtoImplCopyWithImpl(
      _$CategoryTreeDtoImpl _value, $Res Function(_$CategoryTreeDtoImpl) _then)
      : super(_value, _then);

  /// Create a copy of CategoryTreeDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? level = null,
    Object? isActive = null,
    Object? children = null,
  }) {
    return _then(_$CategoryTreeDtoImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      level: null == level
          ? _value.level
          : level // ignore: cast_nullable_to_non_nullable
              as int,
      isActive: null == isActive
          ? _value.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
              as bool,
      children: null == children
          ? _value._children
          : children // ignore: cast_nullable_to_non_nullable
              as List<CategoryTreeDto>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$CategoryTreeDtoImpl implements _CategoryTreeDto {
  const _$CategoryTreeDtoImpl(
      {required this.id,
      required this.name,
      required this.level,
      required this.isActive,
      final List<CategoryTreeDto> children = const <CategoryTreeDto>[]})
      : _children = children;

  factory _$CategoryTreeDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$CategoryTreeDtoImplFromJson(json);

  @override
  final int id;
  @override
  final String name;
  @override
  final int level;
  @override
  final bool isActive;
  final List<CategoryTreeDto> _children;
  @override
  @JsonKey()
  List<CategoryTreeDto> get children {
    if (_children is EqualUnmodifiableListView) return _children;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_children);
  }

  @override
  String toString() {
    return 'CategoryTreeDto(id: $id, name: $name, level: $level, isActive: $isActive, children: $children)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CategoryTreeDtoImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.level, level) || other.level == level) &&
            (identical(other.isActive, isActive) ||
                other.isActive == isActive) &&
            const DeepCollectionEquality().equals(other._children, _children));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, name, level, isActive,
      const DeepCollectionEquality().hash(_children));

  /// Create a copy of CategoryTreeDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CategoryTreeDtoImplCopyWith<_$CategoryTreeDtoImpl> get copyWith =>
      __$$CategoryTreeDtoImplCopyWithImpl<_$CategoryTreeDtoImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CategoryTreeDtoImplToJson(
      this,
    );
  }
}

abstract class _CategoryTreeDto implements CategoryTreeDto {
  const factory _CategoryTreeDto(
      {required final int id,
      required final String name,
      required final int level,
      required final bool isActive,
      final List<CategoryTreeDto> children}) = _$CategoryTreeDtoImpl;

  factory _CategoryTreeDto.fromJson(Map<String, dynamic> json) =
      _$CategoryTreeDtoImpl.fromJson;

  @override
  int get id;
  @override
  String get name;
  @override
  int get level;
  @override
  bool get isActive;
  @override
  List<CategoryTreeDto> get children;

  /// Create a copy of CategoryTreeDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CategoryTreeDtoImplCopyWith<_$CategoryTreeDtoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
