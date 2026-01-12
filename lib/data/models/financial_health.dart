import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/entities/financial_health.dart' as domain;

part 'financial_health.freezed.dart';
part 'financial_health.g.dart';

@freezed
class FinancialHealthModel with _$FinancialHealthModel {
  const factory FinancialHealthModel({
    required int score,
    required FinancialHealthLabelModel label,
  }) = _FinancialHealthModel;

  const FinancialHealthModel._();

  factory FinancialHealthModel.fromJson(Map<String, dynamic> json) =>
      _$FinancialHealthModelFromJson(json);

  domain.FinancialHealth toEntity() => domain.FinancialHealth(
        score: score,
        label: domain.FinancialHealthLabel.values[label.index],
      );

  static FinancialHealthModel fromEntity(domain.FinancialHealth entity) =>
      FinancialHealthModel(
        score: entity.score,
        label: FinancialHealthLabelModel.values[entity.label.index],
      );
}

enum FinancialHealthLabelModel { healthy, stable, caution, risk }
