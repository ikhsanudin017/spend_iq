// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'autosave_plan.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$AutosavePlanModelImpl _$$AutosavePlanModelImplFromJson(
        Map<String, dynamic> json) =>
    _$AutosavePlanModelImpl(
      date: const DateTimeIsoConverter().fromJson(json['date'] as String),
      amount: (json['amount'] as num).toDouble(),
      confirmed: json['confirmed'] as bool? ?? false,
    );

Map<String, dynamic> _$$AutosavePlanModelImplToJson(
        _$AutosavePlanModelImpl instance) =>
    <String, dynamic>{
      'date': const DateTimeIsoConverter().toJson(instance.date),
      'amount': instance.amount,
      'confirmed': instance.confirmed,
    };
