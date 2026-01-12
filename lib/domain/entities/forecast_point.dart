import 'package:freezed_annotation/freezed_annotation.dart';

part 'forecast_point.freezed.dart';

@freezed
class ForecastPoint with _$ForecastPoint {
  const factory ForecastPoint({
    required DateTime date,
    required double predictedSpend,
    required bool risky,
    String? riskReason,
  }) = _ForecastPoint;
}
