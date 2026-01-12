import 'package:freezed_annotation/freezed_annotation.dart';
import '../../core/utils/json_converters.dart';
import '../../domain/entities/autosave_plan.dart' as domain;

part 'autosave_plan.freezed.dart';
part 'autosave_plan.g.dart';

@freezed
class AutosavePlanModel with _$AutosavePlanModel {
  const factory AutosavePlanModel({
    @DateTimeIsoConverter() required DateTime date,
    required double amount,
    @Default(false) bool confirmed,
  }) = _AutosavePlanModel;

  const AutosavePlanModel._();

  factory AutosavePlanModel.fromJson(Map<String, dynamic> json) =>
      _$AutosavePlanModelFromJson(json);

  domain.AutosavePlan toEntity() => domain.AutosavePlan(
        date: date,
        amount: amount,
        confirmed: confirmed,
      );

  static AutosavePlanModel fromEntity(domain.AutosavePlan entity) =>
      AutosavePlanModel(
        date: entity.date,
        amount: entity.amount,
        confirmed: entity.confirmed,
      );
}
