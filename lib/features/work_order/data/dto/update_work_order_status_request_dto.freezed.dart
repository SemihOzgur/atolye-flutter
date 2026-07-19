// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'update_work_order_status_request_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

UpdateWorkOrderStatusRequestDto _$UpdateWorkOrderStatusRequestDtoFromJson(
    Map<String, dynamic> json) {
  return _UpdateWorkOrderStatusRequestDto.fromJson(json);
}

/// @nodoc
mixin _$UpdateWorkOrderStatusRequestDto {
  String get newStatus => throw _privateConstructorUsedError;
  String? get note => throw _privateConstructorUsedError;

  /// Serializes this UpdateWorkOrderStatusRequestDto to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of UpdateWorkOrderStatusRequestDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $UpdateWorkOrderStatusRequestDtoCopyWith<UpdateWorkOrderStatusRequestDto>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UpdateWorkOrderStatusRequestDtoCopyWith<$Res> {
  factory $UpdateWorkOrderStatusRequestDtoCopyWith(
          UpdateWorkOrderStatusRequestDto value,
          $Res Function(UpdateWorkOrderStatusRequestDto) then) =
      _$UpdateWorkOrderStatusRequestDtoCopyWithImpl<$Res,
          UpdateWorkOrderStatusRequestDto>;
  @useResult
  $Res call({String newStatus, String? note});
}

/// @nodoc
class _$UpdateWorkOrderStatusRequestDtoCopyWithImpl<$Res,
        $Val extends UpdateWorkOrderStatusRequestDto>
    implements $UpdateWorkOrderStatusRequestDtoCopyWith<$Res> {
  _$UpdateWorkOrderStatusRequestDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of UpdateWorkOrderStatusRequestDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? newStatus = null,
    Object? note = freezed,
  }) {
    return _then(_value.copyWith(
      newStatus: null == newStatus
          ? _value.newStatus
          : newStatus // ignore: cast_nullable_to_non_nullable
              as String,
      note: freezed == note
          ? _value.note
          : note // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$UpdateWorkOrderStatusRequestDtoImplCopyWith<$Res>
    implements $UpdateWorkOrderStatusRequestDtoCopyWith<$Res> {
  factory _$$UpdateWorkOrderStatusRequestDtoImplCopyWith(
          _$UpdateWorkOrderStatusRequestDtoImpl value,
          $Res Function(_$UpdateWorkOrderStatusRequestDtoImpl) then) =
      __$$UpdateWorkOrderStatusRequestDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String newStatus, String? note});
}

/// @nodoc
class __$$UpdateWorkOrderStatusRequestDtoImplCopyWithImpl<$Res>
    extends _$UpdateWorkOrderStatusRequestDtoCopyWithImpl<$Res,
        _$UpdateWorkOrderStatusRequestDtoImpl>
    implements _$$UpdateWorkOrderStatusRequestDtoImplCopyWith<$Res> {
  __$$UpdateWorkOrderStatusRequestDtoImplCopyWithImpl(
      _$UpdateWorkOrderStatusRequestDtoImpl _value,
      $Res Function(_$UpdateWorkOrderStatusRequestDtoImpl) _then)
      : super(_value, _then);

  /// Create a copy of UpdateWorkOrderStatusRequestDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? newStatus = null,
    Object? note = freezed,
  }) {
    return _then(_$UpdateWorkOrderStatusRequestDtoImpl(
      newStatus: null == newStatus
          ? _value.newStatus
          : newStatus // ignore: cast_nullable_to_non_nullable
              as String,
      note: freezed == note
          ? _value.note
          : note // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$UpdateWorkOrderStatusRequestDtoImpl
    implements _UpdateWorkOrderStatusRequestDto {
  const _$UpdateWorkOrderStatusRequestDtoImpl(
      {required this.newStatus, this.note});

  factory _$UpdateWorkOrderStatusRequestDtoImpl.fromJson(
          Map<String, dynamic> json) =>
      _$$UpdateWorkOrderStatusRequestDtoImplFromJson(json);

  @override
  final String newStatus;
  @override
  final String? note;

  @override
  String toString() {
    return 'UpdateWorkOrderStatusRequestDto(newStatus: $newStatus, note: $note)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UpdateWorkOrderStatusRequestDtoImpl &&
            (identical(other.newStatus, newStatus) ||
                other.newStatus == newStatus) &&
            (identical(other.note, note) || other.note == note));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, newStatus, note);

  /// Create a copy of UpdateWorkOrderStatusRequestDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$UpdateWorkOrderStatusRequestDtoImplCopyWith<
          _$UpdateWorkOrderStatusRequestDtoImpl>
      get copyWith => __$$UpdateWorkOrderStatusRequestDtoImplCopyWithImpl<
          _$UpdateWorkOrderStatusRequestDtoImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$UpdateWorkOrderStatusRequestDtoImplToJson(
      this,
    );
  }
}

abstract class _UpdateWorkOrderStatusRequestDto
    implements UpdateWorkOrderStatusRequestDto {
  const factory _UpdateWorkOrderStatusRequestDto(
      {required final String newStatus,
      final String? note}) = _$UpdateWorkOrderStatusRequestDtoImpl;

  factory _UpdateWorkOrderStatusRequestDto.fromJson(Map<String, dynamic> json) =
      _$UpdateWorkOrderStatusRequestDtoImpl.fromJson;

  @override
  String get newStatus;
  @override
  String? get note;

  /// Create a copy of UpdateWorkOrderStatusRequestDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$UpdateWorkOrderStatusRequestDtoImplCopyWith<
          _$UpdateWorkOrderStatusRequestDtoImpl>
      get copyWith => throw _privateConstructorUsedError;
}
