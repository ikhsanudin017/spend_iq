// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'autosave_plan.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

AutosavePlanModel _$AutosavePlanModelFromJson(Map<String, dynamic> json) {
  return _AutosavePlanModel.fromJson(json);
}

/// @nodoc
mixin _$AutosavePlanModel {
  @DateTimeIsoConverter()
  DateTime get date => throw _privateConstructorUsedError;
  double get amount => throw _privateConstructorUsedError;
  bool get confirmed => throw _privateConstructorUsedError;

  /// Serializes this AutosavePlanModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of AutosavePlanModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AutosavePlanModelCopyWith<AutosavePlanModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AutosavePlanModelCopyWith<$Res> {
  factory $AutosavePlanModelCopyWith(
          AutosavePlanModel value, $Res Function(AutosavePlanModel) then) =
      _$AutosavePlanModelCopyWithImpl<$Res, AutosavePlanModel>;
  @useResult
  $Res call(
      {@DateTimeIsoConverter() DateTime date, double amount, bool confirmed});
}

/// @nodoc
class _$AutosavePlanModelCopyWithImpl<$Res, $Val extends AutosavePlanModel>
    implements $AutosavePlanModelCopyWith<$Res> {
  _$AutosavePlanModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of AutosavePlanModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? date = null,
    Object? amount = null,
    Object? confirmed = null,
  }) {
    return _then(_value.copyWith(
      date: null == date
          ? _value.date
          : date // ignore: cast_nullable_to_non_nullable
              as DateTime,
      amount: null == amount
          ? _value.amount
          : amount // ignore: cast_nullable_to_non_nullable
              as double,
      confirmed: null == confirmed
          ? _value.confirmed
          : confirmed // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$AutosavePlanModelImplCopyWith<$Res>
    implements $AutosavePlanModelCopyWith<$Res> {
  factory _$$AutosavePlanModelImplCopyWith(_$AutosavePlanModelImpl value,
          $Res Function(_$AutosavePlanModelImpl) then) =
      __$$AutosavePlanModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@DateTimeIsoConverter() DateTime date, double amount, bool confirmed});
}

/// @nodoc
class __$$AutosavePlanModelImplCopyWithImpl<$Res>
    extends _$AutosavePlanModelCopyWithImpl<$Res, _$AutosavePlanModelImpl>
    implements _$$AutosavePlanModelImplCopyWith<$Res> {
  __$$AutosavePlanModelImplCopyWithImpl(_$AutosavePlanModelImpl _value,
      $Res Function(_$AutosavePlanModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of AutosavePlanModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? date = null,
    Object? amount = null,
    Object? confirmed = null,
  }) {
    return _then(_$AutosavePlanModelImpl(
      date: null == date
          ? _value.date
          : date // ignore: cast_nullable_to_non_nullable
              as DateTime,
      amount: null == amount
          ? _value.amount
          : amount // ignore: cast_nullable_to_non_nullable
              as double,
      confirmed: null == confirmed
          ? _value.confirmed
          : confirmed // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$AutosavePlanModelImpl extends _AutosavePlanModel {
  const _$AutosavePlanModelImpl(
      {@DateTimeIsoConverter() required this.date,
      required this.amount,
      this.confirmed = false})
      : super._();

  factory _$AutosavePlanModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$AutosavePlanModelImplFromJson(json);

  @override
  @DateTimeIsoConverter()
  final DateTime date;
  @override
  final double amount;
  @override
  @JsonKey()
  final bool confirmed;

  @override
  String toString() {
    return 'AutosavePlanModel(date: $date, amount: $amount, confirmed: $confirmed)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AutosavePlanModelImpl &&
            (identical(other.date, date) || other.date == date) &&
            (identical(other.amount, amount) || other.amount == amount) &&
            (identical(other.confirmed, confirmed) ||
                other.confirmed == confirmed));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, date, amount, confirmed);

  /// Create a copy of AutosavePlanModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AutosavePlanModelImplCopyWith<_$AutosavePlanModelImpl> get copyWith =>
      __$$AutosavePlanModelImplCopyWithImpl<_$AutosavePlanModelImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$AutosavePlanModelImplToJson(
      this,
    );
  }
}

abstract class _AutosavePlanModel extends AutosavePlanModel {
  const factory _AutosavePlanModel(
      {@DateTimeIsoConverter() required final DateTime date,
      required final double amount,
      final bool confirmed}) = _$AutosavePlanModelImpl;
  const _AutosavePlanModel._() : super._();

  factory _AutosavePlanModel.fromJson(Map<String, dynamic> json) =
      _$AutosavePlanModelImpl.fromJson;

  @override
  @DateTimeIsoConverter()
  DateTime get date;
  @override
  double get amount;
  @override
  bool get confirmed;

  /// Create a copy of AutosavePlanModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AutosavePlanModelImplCopyWith<_$AutosavePlanModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
