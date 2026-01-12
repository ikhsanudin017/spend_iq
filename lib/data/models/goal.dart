import 'package:freezed_annotation/freezed_annotation.dart';
import '../../core/utils/json_converters.dart';
import '../../domain/entities/goal.dart' as domain;

part 'goal.freezed.dart';
part 'goal.g.dart';

@freezed
class GoalModel with _$GoalModel {
  const factory GoalModel({
    required String id,
    required String name,
    required double targetAmount,
    required double currentAmount,
    required double monthlyPlan,
    @DateTimeIsoConverter() required DateTime dueDate,
  }) = _GoalModel;

  const GoalModel._();

  factory GoalModel.fromJson(Map<String, dynamic> json) =>
      _$GoalModelFromJson(json);

  domain.Goal toEntity() => domain.Goal(
        id: id,
        name: name,
        targetAmount: targetAmount,
        currentAmount: currentAmount,
        monthlyPlan: monthlyPlan,
        dueDate: dueDate,
      );

  static GoalModel fromEntity(domain.Goal entity) => GoalModel(
        id: entity.id,
        name: entity.name,
        targetAmount: entity.targetAmount,
        currentAmount: entity.currentAmount,
        monthlyPlan: entity.monthlyPlan,
        dueDate: entity.dueDate,
      );
}
