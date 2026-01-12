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

FinancialHealthModel _$FinancialHealthModelFromJson(Map<String, dynamic> json) {
  return _FinancialHealthModel.fromJson(json);
}

/// @nodoc
mixin _$FinancialHealthModel {
  int get score => throw _privateConstructorUsedError;
  FinancialHealthLabelModel get label => throw _privateConstructorUsedError;

  /// Serializes this FinancialHealthModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of FinancialHealthModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $FinancialHealthModelCopyWith<FinancialHealthModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $FinancialHealthModelCopyWith<$Res> {
  factory $FinancialHealthModelCopyWith(FinancialHealthModel value,
          $Res Function(FinancialHealthModel) then) =
      _$FinancialHealthModelCopyWithImpl<$Res, FinancialHealthModel>;
  @useResult
  $Res call({int score, FinancialHealthLabelModel label});
}

/// @nodoc
class _$FinancialHealthModelCopyWithImpl<$Res,
        $Val extends FinancialHealthModel>
    implements $FinancialHealthModelCopyWith<$Res> {
  _$FinancialHealthModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of FinancialHealthModel
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
              as FinancialHealthLabelModel,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$FinancialHealthModelImplCopyWith<$Res>
    implements $FinancialHealthModelCopyWith<$Res> {
  factory _$$FinancialHealthModelImplCopyWith(_$FinancialHealthModelImpl value,
          $Res Function(_$FinancialHealthModelImpl) then) =
      __$$FinancialHealthModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({int score, FinancialHealthLabelModel label});
}

/// @nodoc
class __$$FinancialHealthModelImplCopyWithImpl<$Res>
    extends _$FinancialHealthModelCopyWithImpl<$Res, _$FinancialHealthModelImpl>
    implements _$$FinancialHealthModelImplCopyWith<$Res> {
  __$$FinancialHealthModelImplCopyWithImpl(_$FinancialHealthModelImpl _value,
      $Res Function(_$FinancialHealthModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of FinancialHealthModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? score = null,
    Object? label = null,
  }) {
    return _then(_$FinancialHealthModelImpl(
      score: null == score
          ? _value.score
          : score // ignore: cast_nullable_to_non_nullable
              as int,
      label: null == label
          ? _value.label
          : label // ignore: cast_nullable_to_non_nullable
              as FinancialHealthLabelModel,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$FinancialHealthModelImpl extends _FinancialHealthModel {
  const _$FinancialHealthModelImpl({required this.score, required this.label})
      : super._();

  factory _$FinancialHealthModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$FinancialHealthModelImplFromJson(json);

  @override
  final int score;
  @override
  final FinancialHealthLabelModel label;

  @override
  String toString() {
    return 'FinancialHealthModel(score: $score, label: $label)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$FinancialHealthModelImpl &&
            (identical(other.score, score) || other.score == score) &&
            (identical(other.label, label) || other.label == label));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, score, label);

  /// Create a copy of FinancialHealthModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$FinancialHealthModelImplCopyWith<_$FinancialHealthModelImpl>
      get copyWith =>
          __$$FinancialHealthModelImplCopyWithImpl<_$FinancialHealthModelImpl>(
              this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$FinancialHealthModelImplToJson(
      this,
    );
  }
}

abstract class _FinancialHealthModel extends FinancialHealthModel {
  const factory _FinancialHealthModel(
          {required final int score,
          required final FinancialHealthLabelModel label}) =
      _$FinancialHealthModelImpl;
  const _FinancialHealthModel._() : super._();

  factory _FinancialHealthModel.fromJson(Map<String, dynamic> json) =
      _$FinancialHealthModelImpl.fromJson;

  @override
  int get score;
  @override
  FinancialHealthLabelModel get label;

  /// Create a copy of FinancialHealthModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$FinancialHealthModelImplCopyWith<_$FinancialHealthModelImpl>
      get copyWith => throw _privateConstructorUsedError;
}
