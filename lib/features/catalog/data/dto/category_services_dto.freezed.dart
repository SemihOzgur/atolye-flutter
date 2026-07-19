// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'category_services_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

CategoryServicesDto _$CategoryServicesDtoFromJson(Map<String, dynamic> json) {
  return _CategoryServicesDto.fromJson(json);
}

/// @nodoc
mixin _$CategoryServicesDto {
  int get categoryId => throw _privateConstructorUsedError;
  String get categoryPath => throw _privateConstructorUsedError;
  List<ServicePriceOptionDto> get services =>
      throw _privateConstructorUsedError;

  /// Serializes this CategoryServicesDto to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of CategoryServicesDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CategoryServicesDtoCopyWith<CategoryServicesDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CategoryServicesDtoCopyWith<$Res> {
  factory $CategoryServicesDtoCopyWith(
          CategoryServicesDto value, $Res Function(CategoryServicesDto) then) =
      _$CategoryServicesDtoCopyWithImpl<$Res, CategoryServicesDto>;
  @useResult
  $Res call(
      {int categoryId,
      String categoryPath,
      List<ServicePriceOptionDto> services});
}

/// @nodoc
class _$CategoryServicesDtoCopyWithImpl<$Res, $Val extends CategoryServicesDto>
    implements $CategoryServicesDtoCopyWith<$Res> {
  _$CategoryServicesDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CategoryServicesDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? categoryId = null,
    Object? categoryPath = null,
    Object? services = null,
  }) {
    return _then(_value.copyWith(
      categoryId: null == categoryId
          ? _value.categoryId
          : categoryId // ignore: cast_nullable_to_non_nullable
              as int,
      categoryPath: null == categoryPath
          ? _value.categoryPath
          : categoryPath // ignore: cast_nullable_to_non_nullable
              as String,
      services: null == services
          ? _value.services
          : services // ignore: cast_nullable_to_non_nullable
              as List<ServicePriceOptionDto>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$CategoryServicesDtoImplCopyWith<$Res>
    implements $CategoryServicesDtoCopyWith<$Res> {
  factory _$$CategoryServicesDtoImplCopyWith(_$CategoryServicesDtoImpl value,
          $Res Function(_$CategoryServicesDtoImpl) then) =
      __$$CategoryServicesDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int categoryId,
      String categoryPath,
      List<ServicePriceOptionDto> services});
}

/// @nodoc
class __$$CategoryServicesDtoImplCopyWithImpl<$Res>
    extends _$CategoryServicesDtoCopyWithImpl<$Res, _$CategoryServicesDtoImpl>
    implements _$$CategoryServicesDtoImplCopyWith<$Res> {
  __$$CategoryServicesDtoImplCopyWithImpl(_$CategoryServicesDtoImpl _value,
      $Res Function(_$CategoryServicesDtoImpl) _then)
      : super(_value, _then);

  /// Create a copy of CategoryServicesDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? categoryId = null,
    Object? categoryPath = null,
    Object? services = null,
  }) {
    return _then(_$CategoryServicesDtoImpl(
      categoryId: null == categoryId
          ? _value.categoryId
          : categoryId // ignore: cast_nullable_to_non_nullable
              as int,
      categoryPath: null == categoryPath
          ? _value.categoryPath
          : categoryPath // ignore: cast_nullable_to_non_nullable
              as String,
      services: null == services
          ? _value._services
          : services // ignore: cast_nullable_to_non_nullable
              as List<ServicePriceOptionDto>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$CategoryServicesDtoImpl implements _CategoryServicesDto {
  const _$CategoryServicesDtoImpl(
      {required this.categoryId,
      required this.categoryPath,
      final List<ServicePriceOptionDto> services =
          const <ServicePriceOptionDto>[]})
      : _services = services;

  factory _$CategoryServicesDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$CategoryServicesDtoImplFromJson(json);

  @override
  final int categoryId;
  @override
  final String categoryPath;
  final List<ServicePriceOptionDto> _services;
  @override
  @JsonKey()
  List<ServicePriceOptionDto> get services {
    if (_services is EqualUnmodifiableListView) return _services;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_services);
  }

  @override
  String toString() {
    return 'CategoryServicesDto(categoryId: $categoryId, categoryPath: $categoryPath, services: $services)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CategoryServicesDtoImpl &&
            (identical(other.categoryId, categoryId) ||
                other.categoryId == categoryId) &&
            (identical(other.categoryPath, categoryPath) ||
                other.categoryPath == categoryPath) &&
            const DeepCollectionEquality().equals(other._services, _services));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, categoryId, categoryPath,
      const DeepCollectionEquality().hash(_services));

  /// Create a copy of CategoryServicesDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CategoryServicesDtoImplCopyWith<_$CategoryServicesDtoImpl> get copyWith =>
      __$$CategoryServicesDtoImplCopyWithImpl<_$CategoryServicesDtoImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CategoryServicesDtoImplToJson(
      this,
    );
  }
}

abstract class _CategoryServicesDto implements CategoryServicesDto {
  const factory _CategoryServicesDto(
      {required final int categoryId,
      required final String categoryPath,
      final List<ServicePriceOptionDto> services}) = _$CategoryServicesDtoImpl;

  factory _CategoryServicesDto.fromJson(Map<String, dynamic> json) =
      _$CategoryServicesDtoImpl.fromJson;

  @override
  int get categoryId;
  @override
  String get categoryPath;
  @override
  List<ServicePriceOptionDto> get services;

  /// Create a copy of CategoryServicesDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CategoryServicesDtoImplCopyWith<_$CategoryServicesDtoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
