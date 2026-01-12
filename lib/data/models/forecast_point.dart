import 'package:freezed_annotation/freezed_annotation.dart';
import '../../core/utils/json_converters.dart';
import '../../domain/entities/forecast_point.dart' as domain;

part 'forecast_point.freezed.dart';
part 'forecast_point.g.dart';

@freezed
class ForecastPointModel with _$ForecastPointModel {
  const factory ForecastPointModel({
    @DateTimeIsoConverter() required DateTime date,
    required double predictedSpend,
    required bool risky,
    String? riskReason,
  }) = _ForecastPointModel;

  const ForecastPointModel._();

  factory ForecastPointModel.fromJson(Map<String, dynamic> json) =>
      _$ForecastPointModelFromJson(json);

  domain.ForecastPoint toEntity() => domain.ForecastPoint(
        date: date,
        predictedSpend: predictedSpend,
        risky: risky,
        riskReason: riskReason,
      );

  static ForecastPointModel fromEntity(domain.ForecastPoint entity) =>
      ForecastPointModel(
        date: entity.date,
        predictedSpend: entity.predictedSpend,
        risky: entity.risky,
        riskReason: entity.riskReason,
      );
}
