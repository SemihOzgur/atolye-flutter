// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'media_file_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

MediaFileDto _$MediaFileDtoFromJson(Map<String, dynamic> json) {
  return _MediaFileDto.fromJson(json);
}

/// @nodoc
mixin _$MediaFileDto {
  int get id => throw _privateConstructorUsedError;
  String get mediaType => throw _privateConstructorUsedError;
  String get stage => throw _privateConstructorUsedError;
  String get viewUrl => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;

  /// Serializes this MediaFileDto to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of MediaFileDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $MediaFileDtoCopyWith<MediaFileDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MediaFileDtoCopyWith<$Res> {
  factory $MediaFileDtoCopyWith(
          MediaFileDto value, $Res Function(MediaFileDto) then) =
      _$MediaFileDtoCopyWithImpl<$Res, MediaFileDto>;
  @useResult
  $Res call(
      {int id,
      String mediaType,
      String stage,
      String viewUrl,
      DateTime createdAt});
}

/// @nodoc
class _$MediaFileDtoCopyWithImpl<$Res, $Val extends MediaFileDto>
    implements $MediaFileDtoCopyWith<$Res> {
  _$MediaFileDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of MediaFileDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? mediaType = null,
    Object? stage = null,
    Object? viewUrl = null,
    Object? createdAt = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      mediaType: null == mediaType
          ? _value.mediaType
          : mediaType // ignore: cast_nullable_to_non_nullable
              as String,
      stage: null == stage
          ? _value.stage
          : stage // ignore: cast_nullable_to_non_nullable
              as String,
      viewUrl: null == viewUrl
          ? _value.viewUrl
          : viewUrl // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$MediaFileDtoImplCopyWith<$Res>
    implements $MediaFileDtoCopyWith<$Res> {
  factory _$$MediaFileDtoImplCopyWith(
          _$MediaFileDtoImpl value, $Res Function(_$MediaFileDtoImpl) then) =
      __$$MediaFileDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int id,
      String mediaType,
      String stage,
      String viewUrl,
      DateTime createdAt});
}

/// @nodoc
class __$$MediaFileDtoImplCopyWithImpl<$Res>
    extends _$MediaFileDtoCopyWithImpl<$Res, _$MediaFileDtoImpl>
    implements _$$MediaFileDtoImplCopyWith<$Res> {
  __$$MediaFileDtoImplCopyWithImpl(
      _$MediaFileDtoImpl _value, $Res Function(_$MediaFileDtoImpl) _then)
      : super(_value, _then);

  /// Create a copy of MediaFileDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? mediaType = null,
    Object? stage = null,
    Object? viewUrl = null,
    Object? createdAt = null,
  }) {
    return _then(_$MediaFileDtoImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      mediaType: null == mediaType
          ? _value.mediaType
          : mediaType // ignore: cast_nullable_to_non_nullable
              as String,
      stage: null == stage
          ? _value.stage
          : stage // ignore: cast_nullable_to_non_nullable
              as String,
      viewUrl: null == viewUrl
          ? _value.viewUrl
          : viewUrl // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$MediaFileDtoImpl implements _MediaFileDto {
  const _$MediaFileDtoImpl(
      {required this.id,
      required this.mediaType,
      required this.stage,
      required this.viewUrl,
      required this.createdAt});

  factory _$MediaFileDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$MediaFileDtoImplFromJson(json);

  @override
  final int id;
  @override
  final String mediaType;
  @override
  final String stage;
  @override
  final String viewUrl;
  @override
  final DateTime createdAt;

  @override
  String toString() {
    return 'MediaFileDto(id: $id, mediaType: $mediaType, stage: $stage, viewUrl: $viewUrl, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MediaFileDtoImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.mediaType, mediaType) ||
                other.mediaType == mediaType) &&
            (identical(other.stage, stage) || other.stage == stage) &&
            (identical(other.viewUrl, viewUrl) || other.viewUrl == viewUrl) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, id, mediaType, stage, viewUrl, createdAt);

  /// Create a copy of MediaFileDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$MediaFileDtoImplCopyWith<_$MediaFileDtoImpl> get copyWith =>
      __$$MediaFileDtoImplCopyWithImpl<_$MediaFileDtoImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$MediaFileDtoImplToJson(
      this,
    );
  }
}

abstract class _MediaFileDto implements MediaFileDto {
  const factory _MediaFileDto(
      {required final int id,
      required final String mediaType,
      required final String stage,
      required final String viewUrl,
      required final DateTime createdAt}) = _$MediaFileDtoImpl;

  factory _MediaFileDto.fromJson(Map<String, dynamic> json) =
      _$MediaFileDtoImpl.fromJson;

  @override
  int get id;
  @override
  String get mediaType;
  @override
  String get stage;
  @override
  String get viewUrl;
  @override
  DateTime get createdAt;

  /// Create a copy of MediaFileDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$MediaFileDtoImplCopyWith<_$MediaFileDtoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
