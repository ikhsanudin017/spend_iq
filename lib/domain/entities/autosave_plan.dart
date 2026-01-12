import 'package:freezed_annotation/freezed_annotation.dart';

part 'autosave_plan.freezed.dart';

@freezed
class AutosavePlan with _$AutosavePlan {
  const factory AutosavePlan({
    required DateTime date,
    required double amount,
    @Default(false) bool confirmed,
  }) = _AutosavePlan;
}
