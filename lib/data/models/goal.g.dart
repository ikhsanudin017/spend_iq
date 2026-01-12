// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'goal.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$GoalModelImpl _$$GoalModelImplFromJson(Map<String, dynamic> json) =>
    _$GoalModelImpl(
      id: json['id'] as String,
      name: json['name'] as String,
      targetAmount: (json['targetAmount'] as num).toDouble(),
      currentAmount: (json['currentAmount'] as num).toDouble(),
      monthlyPlan: (json['monthlyPlan'] as num).toDouble(),
      dueDate: const DateTimeIsoConverter().fromJson(json['dueDate'] as String),
    );

Map<String, dynamic> _$$GoalModelImplToJson(_$GoalModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'targetAmount': instance.targetAmount,
      'currentAmount': instance.currentAmount,
      'monthlyPlan': instance.monthlyPlan,
      'dueDate': const DateTimeIsoConverter().toJson(instance.dueDate),
    };
