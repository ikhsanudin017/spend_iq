import 'package:freezed_annotation/freezed_annotation.dart';

part 'financial_health.freezed.dart';

enum FinancialHealthLabel { healthy, stable, caution, risk }

@freezed
class FinancialHealth with _$FinancialHealth {
  const factory FinancialHealth({
    required int score,
    required FinancialHealthLabel label,
  }) = _FinancialHealth;
}
