// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'goal.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

GoalModel _$GoalModelFromJson(Map<String, dynamic> json) {
  return _GoalModel.fromJson(json);
}

/// @nodoc
mixin _$GoalModel {
  String get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  double get targetAmount => throw _privateConstructorUsedError;
  double get currentAmount => throw _privateConstructorUsedError;
  double get monthlyPlan => throw _privateConstructorUsedError;
  @DateTimeIsoConverter()
  DateTime get dueDate => throw _privateConstructorUsedError;

  /// Serializes this GoalModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of GoalModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $GoalModelCopyWith<GoalModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $GoalModelCopyWith<$Res> {
  factory $GoalModelCopyWith(GoalModel value, $Res Function(GoalModel) then) =
      _$GoalModelCopyWithImpl<$Res, GoalModel>;
  @useResult
  $Res call(
      {String id,
      String name,
      double targetAmount,
      double currentAmount,
      double monthlyPlan,
      @DateTimeIsoConverter() DateTime dueDate});
}

/// @nodoc
class _$GoalModelCopyWithImpl<$Res, $Val extends GoalModel>
    implements $GoalModelCopyWith<$Res> {
  _$GoalModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of GoalModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? targetAmount = null,
    Object? currentAmount = null,
    Object? monthlyPlan = null,
    Object? dueDate = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      targetAmount: null == targetAmount
          ? _value.targetAmount
          : targetAmount // ignore: cast_nullable_to_non_nullable
              as double,
      currentAmount: null == currentAmount
          ? _value.currentAmount
          : currentAmount // ignore: cast_nullable_to_non_nullable
              as double,
      monthlyPlan: null == monthlyPlan
          ? _value.monthlyPlan
          : monthlyPlan // ignore: cast_nullable_to_non_nullable
              as double,
      dueDate: null == dueDate
          ? _value.dueDate
          : dueDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$GoalModelImplCopyWith<$Res>
    implements $GoalModelCopyWith<$Res> {
  factory _$$GoalModelImplCopyWith(
          _$GoalModelImpl value, $Res Function(_$GoalModelImpl) then) =
      __$$GoalModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String name,
      double targetAmount,
      double currentAmount,
      double monthlyPlan,
      @DateTimeIsoConverter() DateTime dueDate});
}

/// @nodoc
class __$$GoalModelImplCopyWithImpl<$Res>
    extends _$GoalModelCopyWithImpl<$Res, _$GoalModelImpl>
    implements _$$GoalModelImplCopyWith<$Res> {
  __$$GoalModelImplCopyWithImpl(
      _$GoalModelImpl _value, $Res Function(_$GoalModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of GoalModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? targetAmount = null,
    Object? currentAmount = null,
    Object? monthlyPlan = null,
    Object? dueDate = null,
  }) {
    return _then(_$GoalModelImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      targetAmount: null == targetAmount
          ? _value.targetAmount
          : targetAmount // ignore: cast_nullable_to_non_nullable
              as double,
      currentAmount: null == currentAmount
          ? _value.currentAmount
          : currentAmount // ignore: cast_nullable_to_non_nullable
              as double,
      monthlyPlan: null == monthlyPlan
          ? _value.monthlyPlan
          : monthlyPlan // ignore: cast_nullable_to_non_nullable
              as double,
      dueDate: null == dueDate
          ? _value.dueDate
          : dueDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$GoalModelImpl extends _GoalModel {
  const _$GoalModelImpl(
      {required this.id,
      required this.name,
      required this.targetAmount,
      required this.currentAmount,
      required this.monthlyPlan,
      @DateTimeIsoConverter() required this.dueDate})
      : super._();

  factory _$GoalModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$GoalModelImplFromJson(json);

  @override
  final String id;
  @override
  final String name;
  @override
  final double targetAmount;
  @override
  final double currentAmount;
  @override
  final double monthlyPlan;
  @override
  @DateTimeIsoConverter()
  final DateTime dueDate;

  @override
  String toString() {
    return 'GoalModel(id: $id, name: $name, targetAmount: $targetAmount, currentAmount: $currentAmount, monthlyPlan: $monthlyPlan, dueDate: $dueDate)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$GoalModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.targetAmount, targetAmount) ||
                other.targetAmount == targetAmount) &&
            (identical(other.currentAmount, currentAmount) ||
                other.currentAmount == currentAmount) &&
            (identical(other.monthlyPlan, monthlyPlan) ||
                other.monthlyPlan == monthlyPlan) &&
            (identical(other.dueDate, dueDate) || other.dueDate == dueDate));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, id, name, targetAmount, currentAmount, monthlyPlan, dueDate);

  /// Create a copy of GoalModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$GoalModelImplCopyWith<_$GoalModelImpl> get copyWith =>
      __$$GoalModelImplCopyWithImpl<_$GoalModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$GoalModelImplToJson(
      this,
    );
  }
}

abstract class _GoalModel extends GoalModel {
  const factory _GoalModel(
          {required final String id,
          required final String name,
          required final double targetAmount,
          required final double currentAmount,
          required final double monthlyPlan,
          @DateTimeIsoConverter() required final DateTime dueDate}) =
      _$GoalModelImpl;
  const _GoalModel._() : super._();

  factory _GoalModel.fromJson(Map<String, dynamic> json) =
      _$GoalModelImpl.fromJson;

  @override
  String get id;
  @override
  String get name;
  @override
  double get targetAmount;
  @override
  double get currentAmount;
  @override
  double get monthlyPlan;
  @override
  @DateTimeIsoConverter()
  DateTime get dueDate;

  /// Create a copy of GoalModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$GoalModelImplCopyWith<_$GoalModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
