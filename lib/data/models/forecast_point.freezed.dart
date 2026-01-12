// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'forecast_point.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

ForecastPointModel _$ForecastPointModelFromJson(Map<String, dynamic> json) {
  return _ForecastPointModel.fromJson(json);
}

/// @nodoc
mixin _$ForecastPointModel {
  @DateTimeIsoConverter()
  DateTime get date => throw _privateConstructorUsedError;
  double get predictedSpend => throw _privateConstructorUsedError;
  bool get risky => throw _privateConstructorUsedError;
  String? get riskReason => throw _privateConstructorUsedError;

  /// Serializes this ForecastPointModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ForecastPointModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ForecastPointModelCopyWith<ForecastPointModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ForecastPointModelCopyWith<$Res> {
  factory $ForecastPointModelCopyWith(
          ForecastPointModel value, $Res Function(ForecastPointModel) then) =
      _$ForecastPointModelCopyWithImpl<$Res, ForecastPointModel>;
  @useResult
  $Res call(
      {@DateTimeIsoConverter() DateTime date,
      double predictedSpend,
      bool risky,
      String? riskReason});
}

/// @nodoc
class _$ForecastPointModelCopyWithImpl<$Res, $Val extends ForecastPointModel>
    implements $ForecastPointModelCopyWith<$Res> {
  _$ForecastPointModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ForecastPointModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? date = null,
    Object? predictedSpend = null,
    Object? risky = null,
    Object? riskReason = freezed,
  }) {
    return _then(_value.copyWith(
      date: null == date
          ? _value.date
          : date // ignore: cast_nullable_to_non_nullable
              as DateTime,
      predictedSpend: null == predictedSpend
          ? _value.predictedSpend
          : predictedSpend // ignore: cast_nullable_to_non_nullable
              as double,
      risky: null == risky
          ? _value.risky
          : risky // ignore: cast_nullable_to_non_nullable
              as bool,
      riskReason: freezed == riskReason
          ? _value.riskReason
          : riskReason // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ForecastPointModelImplCopyWith<$Res>
    implements $ForecastPointModelCopyWith<$Res> {
  factory _$$ForecastPointModelImplCopyWith(_$ForecastPointModelImpl value,
          $Res Function(_$ForecastPointModelImpl) then) =
      __$$ForecastPointModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@DateTimeIsoConverter() DateTime date,
      double predictedSpend,
      bool risky,
      String? riskReason});
}

/// @nodoc
class __$$ForecastPointModelImplCopyWithImpl<$Res>
    extends _$ForecastPointModelCopyWithImpl<$Res, _$ForecastPointModelImpl>
    implements _$$ForecastPointModelImplCopyWith<$Res> {
  __$$ForecastPointModelImplCopyWithImpl(_$ForecastPointModelImpl _value,
      $Res Function(_$ForecastPointModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of ForecastPointModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? date = null,
    Object? predictedSpend = null,
    Object? risky = null,
    Object? riskReason = freezed,
  }) {
    return _then(_$ForecastPointModelImpl(
      date: null == date
          ? _value.date
          : date // ignore: cast_nullable_to_non_nullable
              as DateTime,
      predictedSpend: null == predictedSpend
          ? _value.predictedSpend
          : predictedSpend // ignore: cast_nullable_to_non_nullable
              as double,
      risky: null == risky
          ? _value.risky
          : risky // ignore: cast_nullable_to_non_nullable
              as bool,
      riskReason: freezed == riskReason
          ? _value.riskReason
          : riskReason // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ForecastPointModelImpl extends _ForecastPointModel {
  const _$ForecastPointModelImpl(
      {@DateTimeIsoConverter() required this.date,
      required this.predictedSpend,
      required this.risky,
      this.riskReason})
      : super._();

  factory _$ForecastPointModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$ForecastPointModelImplFromJson(json);

  @override
  @DateTimeIsoConverter()
  final DateTime date;
  @override
  final double predictedSpend;
  @override
  final bool risky;
  @override
  final String? riskReason;

  @override
  String toString() {
    return 'ForecastPointModel(date: $date, predictedSpend: $predictedSpend, risky: $risky, riskReason: $riskReason)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ForecastPointModelImpl &&
            (identical(other.date, date) || other.date == date) &&
            (identical(other.predictedSpend, predictedSpend) ||
                other.predictedSpend == predictedSpend) &&
            (identical(other.risky, risky) || other.risky == risky) &&
            (identical(other.riskReason, riskReason) ||
                other.riskReason == riskReason));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, date, predictedSpend, risky, riskReason);

  /// Create a copy of ForecastPointModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ForecastPointModelImplCopyWith<_$ForecastPointModelImpl> get copyWith =>
      __$$ForecastPointModelImplCopyWithImpl<_$ForecastPointModelImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ForecastPointModelImplToJson(
      this,
    );
  }
}

abstract class _ForecastPointModel extends ForecastPointModel {
  const factory _ForecastPointModel(
      {@DateTimeIsoConverter() required final DateTime date,
      required final double predictedSpend,
      required final bool risky,
      final String? riskReason}) = _$ForecastPointModelImpl;
  const _ForecastPointModel._() : super._();

  factory _ForecastPointModel.fromJson(Map<String, dynamic> json) =
      _$ForecastPointModelImpl.fromJson;

  @override
  @DateTimeIsoConverter()
  DateTime get date;
  @override
  double get predictedSpend;
  @override
  bool get risky;
  @override
  String? get riskReason;

  /// Create a copy of ForecastPointModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ForecastPointModelImplCopyWith<_$ForecastPointModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
