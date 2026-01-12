// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'financial_health.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$FinancialHealth {
  int get score => throw _privateConstructorUsedError;
  FinancialHealthLabel get label => throw _privateConstructorUsedError;

  /// Create a copy of FinancialHealth
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $FinancialHealthCopyWith<FinancialHealth> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $FinancialHealthCopyWith<$Res> {
  factory $FinancialHealthCopyWith(
          FinancialHealth value, $Res Function(FinancialHealth) then) =
      _$FinancialHealthCopyWithImpl<$Res, FinancialHealth>;
  @useResult
  $Res call({int score, FinancialHealthLabel label});
}

/// @nodoc
class _$FinancialHealthCopyWithImpl<$Res, $Val extends FinancialHealth>
    implements $FinancialHealthCopyWith<$Res> {
  _$FinancialHealthCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of FinancialHealth
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? score = null,
    Object? label = null,
  }) {
    return _then(_value.copyWith(
      score: null == score
          ? _value.score
          : score // ignore: cast_nullable_to_non_nullable
              as int,
      label: null == label
          ? _value.label
          : label // ignore: cast_nullable_to_non_nullable
              as FinancialHealthLabel,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$FinancialHealthImplCopyWith<$Res>
    implements $FinancialHealthCopyWith<$Res> {
  factory _$$FinancialHealthImplCopyWith(_$FinancialHealthImpl value,
          $Res Function(_$FinancialHealthImpl) then) =
      __$$FinancialHealthImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({int score, FinancialHealthLabel label});
}

/// @nodoc
class __$$FinancialHealthImplCopyWithImpl<$Res>
    extends _$FinancialHealthCopyWithImpl<$Res, _$FinancialHealthImpl>
    implements _$$FinancialHealthImplCopyWith<$Res> {
  __$$FinancialHealthImplCopyWithImpl(
      _$FinancialHealthImpl _value, $Res Function(_$FinancialHealthImpl) _then)
      : super(_value, _then);

  /// Create a copy of FinancialHealth
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? score = null,
    Object? label = null,
  }) {
    return _then(_$FinancialHealthImpl(
      score: null == score
          ? _value.score
          : score // ignore: cast_nullable_to_non_nullable
              as int,
      label: null == label
          ? _value.label
          : label // ignore: cast_nullable_to_non_nullable
              as FinancialHealthLabel,
    ));
  }
}

/// @nodoc

class _$FinancialHealthImpl implements _FinancialHealth {
  const _$FinancialHealthImpl({required this.score, required this.label});

  @override
  final int score;
  @override
  final FinancialHealthLabel label;

  @override
  String toString() {
    return 'FinancialHealth(score: $score, label: $label)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$FinancialHealthImpl &&
            (identical(other.score, score) || other.score == score) &&
            (identical(other.label, label) || other.label == label));
  }

  @override
  int get hashCode => Object.hash(runtimeType, score, label);

  /// Create a copy of FinancialHealth
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$FinancialHealthImplCopyWith<_$FinancialHealthImpl> get copyWith =>
      __$$FinancialHealthImplCopyWithImpl<_$FinancialHealthImpl>(
          this, _$identity);
}

abstract class _FinancialHealth implements FinancialHealth {
  const factory _FinancialHealth(
      {required final int score,
      required final FinancialHealthLabel label}) = _$FinancialHealthImpl;

  @override
  int get score;
  @override
  FinancialHealthLabel get label;

  /// Create a copy of FinancialHealth
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$FinancialHealthImplCopyWith<_$FinancialHealthImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
