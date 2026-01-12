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

/// @nodoc
mixin _$AutosavePlan {
  DateTime get date => throw _privateConstructorUsedError;
  double get amount => throw _privateConstructorUsedError;
  bool get confirmed => throw _privateConstructorUsedError;

  /// Create a copy of AutosavePlan
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AutosavePlanCopyWith<AutosavePlan> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AutosavePlanCopyWith<$Res> {
  factory $AutosavePlanCopyWith(
          AutosavePlan value, $Res Function(AutosavePlan) then) =
      _$AutosavePlanCopyWithImpl<$Res, AutosavePlan>;
  @useResult
  $Res call({DateTime date, double amount, bool confirmed});
}

/// @nodoc
class _$AutosavePlanCopyWithImpl<$Res, $Val extends AutosavePlan>
    implements $AutosavePlanCopyWith<$Res> {
  _$AutosavePlanCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of AutosavePlan
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
abstract class _$$AutosavePlanImplCopyWith<$Res>
    implements $AutosavePlanCopyWith<$Res> {
  factory _$$AutosavePlanImplCopyWith(
          _$AutosavePlanImpl value, $Res Function(_$AutosavePlanImpl) then) =
      __$$AutosavePlanImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({DateTime date, double amount, bool confirmed});
}

/// @nodoc
class __$$AutosavePlanImplCopyWithImpl<$Res>
    extends _$AutosavePlanCopyWithImpl<$Res, _$AutosavePlanImpl>
    implements _$$AutosavePlanImplCopyWith<$Res> {
  __$$AutosavePlanImplCopyWithImpl(
      _$AutosavePlanImpl _value, $Res Function(_$AutosavePlanImpl) _then)
      : super(_value, _then);

  /// Create a copy of AutosavePlan
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? date = null,
    Object? amount = null,
    Object? confirmed = null,
  }) {
    return _then(_$AutosavePlanImpl(
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

class _$AutosavePlanImpl implements _AutosavePlan {
  const _$AutosavePlanImpl(
      {required this.date, required this.amount, this.confirmed = false});

  @override
  final DateTime date;
  @override
  final double amount;
  @override
  @JsonKey()
  final bool confirmed;

  @override
  String toString() {
    return 'AutosavePlan(date: $date, amount: $amount, confirmed: $confirmed)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AutosavePlanImpl &&
            (identical(other.date, date) || other.date == date) &&
            (identical(other.amount, amount) || other.amount == amount) &&
            (identical(other.confirmed, confirmed) ||
                other.confirmed == confirmed));
  }

  @override
  int get hashCode => Object.hash(runtimeType, date, amount, confirmed);

  /// Create a copy of AutosavePlan
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AutosavePlanImplCopyWith<_$AutosavePlanImpl> get copyWith =>
      __$$AutosavePlanImplCopyWithImpl<_$AutosavePlanImpl>(this, _$identity);
}

abstract class _AutosavePlan implements AutosavePlan {
  const factory _AutosavePlan(
      {required final DateTime date,
      required final double amount,
      final bool confirmed}) = _$AutosavePlanImpl;

  @override
  DateTime get date;
  @override
  double get amount;
  @override
  bool get confirmed;

  /// Create a copy of AutosavePlan
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AutosavePlanImplCopyWith<_$AutosavePlanImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
