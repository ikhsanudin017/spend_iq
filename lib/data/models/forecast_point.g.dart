// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'forecast_point.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ForecastPointModelImpl _$$ForecastPointModelImplFromJson(
        Map<String, dynamic> json) =>
    _$ForecastPointModelImpl(
      date: const DateTimeIsoConverter().fromJson(json['date'] as String),
      predictedSpend: (json['predictedSpend'] as num).toDouble(),
      risky: json['risky'] as bool,
      riskReason: json['riskReason'] as String?,
    );

Map<String, dynamic> _$$ForecastPointModelImplToJson(
        _$ForecastPointModelImpl instance) =>
    <String, dynamic>{
      'date': const DateTimeIsoConverter().toJson(instance.date),
      'predictedSpend': instance.predictedSpend,
      'risky': instance.risky,
      'riskReason': instance.riskReason,
    };
