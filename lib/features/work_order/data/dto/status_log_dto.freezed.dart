// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'status_log_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

StatusLogDto _$StatusLogDtoFromJson(Map<String, dynamic> json) {
  return _StatusLogDto.fromJson(json);
}

/// @nodoc
mixin _$StatusLogDto {
  String? get oldStatus => throw _privateConstructorUsedError;
  String get newStatus => throw _privateConstructorUsedError;
  String get changedBy => throw _privateConstructorUsedError;
  DateTime get changedAt => throw _privateConstructorUsedError;

  /// Serializes this StatusLogDto to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of StatusLogDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $StatusLogDtoCopyWith<StatusLogDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $StatusLogDtoCopyWith<$Res> {
  factory $StatusLogDtoCopyWith(
          StatusLogDto value, $Res Function(StatusLogDto) then) =
      _$StatusLogDtoCopyWithImpl<$Res, StatusLogDto>;
  @useResult
  $Res call(
      {String? oldStatus,
      String newStatus,
      String changedBy,
      DateTime changedAt});
}

/// @nodoc
class _$StatusLogDtoCopyWithImpl<$Res, $Val extends StatusLogDto>
    implements $StatusLogDtoCopyWith<$Res> {
  _$StatusLogDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of StatusLogDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? oldStatus = freezed,
    Object? newStatus = null,
    Object? changedBy = null,
    Object? changedAt = null,
  }) {
    return _then(_value.copyWith(
      oldStatus: freezed == oldStatus
          ? _value.oldStatus
          : oldStatus // ignore: cast_nullable_to_non_nullable
              as String?,
      newStatus: null == newStatus
          ? _value.newStatus
          : newStatus // ignore: cast_nullable_to_non_nullable
              as String,
      changedBy: null == changedBy
          ? _value.changedBy
          : changedBy // ignore: cast_nullable_to_non_nullable
              as String,
      changedAt: null == changedAt
          ? _value.changedAt
          : changedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$StatusLogDtoImplCopyWith<$Res>
    implements $StatusLogDtoCopyWith<$Res> {
  factory _$$StatusLogDtoImplCopyWith(
          _$StatusLogDtoImpl value, $Res Function(_$StatusLogDtoImpl) then) =
      __$$StatusLogDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String? oldStatus,
      String newStatus,
      String changedBy,
      DateTime changedAt});
}

/// @nodoc
class __$$StatusLogDtoImplCopyWithImpl<$Res>
    extends _$StatusLogDtoCopyWithImpl<$Res, _$StatusLogDtoImpl>
    implements _$$StatusLogDtoImplCopyWith<$Res> {
  __$$StatusLogDtoImplCopyWithImpl(
      _$StatusLogDtoImpl _value, $Res Function(_$StatusLogDtoImpl) _then)
      : super(_value, _then);

  /// Create a copy of StatusLogDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? oldStatus = freezed,
    Object? newStatus = null,
    Object? changedBy = null,
    Object? changedAt = null,
  }) {
    return _then(_$StatusLogDtoImpl(
      oldStatus: freezed == oldStatus
          ? _value.oldStatus
          : oldStatus // ignore: cast_nullable_to_non_nullable
              as String?,
      newStatus: null == newStatus
          ? _value.newStatus
          : newStatus // ignore: cast_nullable_to_non_nullable
              as String,
      changedBy: null == changedBy
          ? _value.changedBy
          : changedBy // ignore: cast_nullable_to_non_nullable
              as String,
      changedAt: null == changedAt
          ? _value.changedAt
          : changedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$StatusLogDtoImpl implements _StatusLogDto {
  const _$StatusLogDtoImpl(
      {this.oldStatus,
      required this.newStatus,
      required this.changedBy,
      required this.changedAt});

  factory _$StatusLogDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$StatusLogDtoImplFromJson(json);

  @override
  final String? oldStatus;
  @override
  final String newStatus;
  @override
  final String changedBy;
  @override
  final DateTime changedAt;

  @override
  String toString() {
    return 'StatusLogDto(oldStatus: $oldStatus, newStatus: $newStatus, changedBy: $changedBy, changedAt: $changedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$StatusLogDtoImpl &&
            (identical(other.oldStatus, oldStatus) ||
                other.oldStatus == oldStatus) &&
            (identical(other.newStatus, newStatus) ||
                other.newStatus == newStatus) &&
            (identical(other.changedBy, changedBy) ||
                other.changedBy == changedBy) &&
            (identical(other.changedAt, changedAt) ||
                other.changedAt == changedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, oldStatus, newStatus, changedBy, changedAt);

  /// Create a copy of StatusLogDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$StatusLogDtoImplCopyWith<_$StatusLogDtoImpl> get copyWith =>
      __$$StatusLogDtoImplCopyWithImpl<_$StatusLogDtoImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$StatusLogDtoImplToJson(
      this,
    );
  }
}

abstract class _StatusLogDto implements StatusLogDto {
  const factory _StatusLogDto(
      {final String? oldStatus,
      required final String newStatus,
      required final String changedBy,
      required final DateTime changedAt}) = _$StatusLogDtoImpl;

  factory _StatusLogDto.fromJson(Map<String, dynamic> json) =
      _$StatusLogDtoImpl.fromJson;

  @override
  String? get oldStatus;
  @override
  String get newStatus;
  @override
  String get changedBy;
  @override
  DateTime get changedAt;

  /// Create a copy of StatusLogDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$StatusLogDtoImplCopyWith<_$StatusLogDtoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
