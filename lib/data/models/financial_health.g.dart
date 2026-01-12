// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'financial_health.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$FinancialHealthModelImpl _$$FinancialHealthModelImplFromJson(
        Map<String, dynamic> json) =>
    _$FinancialHealthModelImpl(
      score: (json['score'] as num).toInt(),
      label: $enumDecode(_$FinancialHealthLabelModelEnumMap, json['label']),
    );

Map<String, dynamic> _$$FinancialHealthModelImplToJson(
        _$FinancialHealthModelImpl instance) =>
    <String, dynamic>{
      'score': instance.score,
      'label': _$FinancialHealthLabelModelEnumMap[instance.label]!,
    };

const _$FinancialHealthLabelModelEnumMap = {
  FinancialHealthLabelModel.healthy: 'healthy',
  FinancialHealthLabelModel.stable: 'stable',
  FinancialHealthLabelModel.caution: 'caution',
  FinancialHealthLabelModel.risk: 'risk',
};
