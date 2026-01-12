// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'alert_item.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

AlertItemModel _$AlertItemModelFromJson(Map<String, dynamic> json) {
  return _AlertItemModel.fromJson(json);
}

/// @nodoc
mixin _$AlertItemModel {
  String get id => throw _privateConstructorUsedError;
  AlertItemType get type => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  String get detail => throw _privateConstructorUsedError;
  @DateTimeIsoConverter()
  DateTime get date => throw _privateConstructorUsedError;
  bool get read => throw _privateConstructorUsedError;

  /// Serializes this AlertItemModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of AlertItemModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AlertItemModelCopyWith<AlertItemModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AlertItemModelCopyWith<$Res> {
  factory $AlertItemModelCopyWith(
          AlertItemModel value, $Res Function(AlertItemModel) then) =
      _$AlertItemModelCopyWithImpl<$Res, AlertItemModel>;
  @useResult
  $Res call(
      {String id,
      AlertItemType type,
      String title,
      String detail,
      @DateTimeIsoConverter() DateTime date,
      bool read});
}

/// @nodoc
class _$AlertItemModelCopyWithImpl<$Res, $Val extends AlertItemModel>
    implements $AlertItemModelCopyWith<$Res> {
  _$AlertItemModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of AlertItemModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? type = null,
    Object? title = null,
    Object? detail = null,
    Object? date = null,
    Object? read = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as AlertItemType,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      detail: null == detail
          ? _value.detail
          : detail // ignore: cast_nullable_to_non_nullable
              as String,
      date: null == date
          ? _value.date
          : date // ignore: cast_nullable_to_non_nullable
              as DateTime,
      read: null == read
          ? _value.read
          : read // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$AlertItemModelImplCopyWith<$Res>
    implements $AlertItemModelCopyWith<$Res> {
  factory _$$AlertItemModelImplCopyWith(_$AlertItemModelImpl value,
          $Res Function(_$AlertItemModelImpl) then) =
      __$$AlertItemModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      AlertItemType type,
      String title,
      String detail,
      @DateTimeIsoConverter() DateTime date,
      bool read});
}

/// @nodoc
class __$$AlertItemModelImplCopyWithImpl<$Res>
    extends _$AlertItemModelCopyWithImpl<$Res, _$AlertItemModelImpl>
    implements _$$AlertItemModelImplCopyWith<$Res> {
  __$$AlertItemModelImplCopyWithImpl(
      _$AlertItemModelImpl _value, $Res Function(_$AlertItemModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of AlertItemModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? type = null,
    Object? title = null,
    Object? detail = null,
    Object? date = null,
    Object? read = null,
  }) {
    return _then(_$AlertItemModelImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as AlertItemType,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      detail: null == detail
          ? _value.detail
          : detail // ignore: cast_nullable_to_non_nullable
              as String,
      date: null == date
          ? _value.date
          : date // ignore: cast_nullable_to_non_nullable
              as DateTime,
      read: null == read
          ? _value.read
          : read // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$AlertItemModelImpl extends _AlertItemModel {
  const _$AlertItemModelImpl(
      {required this.id,
      required this.type,
      required this.title,
      required this.detail,
      @DateTimeIsoConverter() required this.date,
      this.read = false})
      : super._();

  factory _$AlertItemModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$AlertItemModelImplFromJson(json);

  @override
  final String id;
  @override
  final AlertItemType type;
  @override
  final String title;
  @override
  final String detail;
  @override
  @DateTimeIsoConverter()
  final DateTime date;
  @override
  @JsonKey()
  final bool read;

  @override
  String toString() {
    return 'AlertItemModel(id: $id, type: $type, title: $title, detail: $detail, date: $date, read: $read)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AlertItemModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.detail, detail) || other.detail == detail) &&
            (identical(other.date, date) || other.date == date) &&
            (identical(other.read, read) || other.read == read));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, id, type, title, detail, date, read);

  /// Create a copy of AlertItemModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AlertItemModelImplCopyWith<_$AlertItemModelImpl> get copyWith =>
      __$$AlertItemModelImplCopyWithImpl<_$AlertItemModelImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$AlertItemModelImplToJson(
      this,
    );
  }
}

abstract class _AlertItemModel extends AlertItemModel {
  const factory _AlertItemModel(
      {required final String id,
      required final AlertItemType type,
      required final String title,
      required final String detail,
      @DateTimeIsoConverter() required final DateTime date,
      final bool read}) = _$AlertItemModelImpl;
  const _AlertItemModel._() : super._();

  factory _AlertItemModel.fromJson(Map<String, dynamic> json) =
      _$AlertItemModelImpl.fromJson;

  @override
  String get id;
  @override
  AlertItemType get type;
  @override
  String get title;
  @override
  String get detail;
  @override
  @DateTimeIsoConverter()
  DateTime get date;
  @override
  bool get read;

  /// Create a copy of AlertItemModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AlertItemModelImplCopyWith<_$AlertItemModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
