import 'package:freezed_annotation/freezed_annotation.dart';

part 'goal.freezed.dart';

@freezed
class Goal with _$Goal {
  const factory Goal({
    required String id,
    required String name,
    required double targetAmount,
    required double currentAmount,
    required double monthlyPlan,
    required DateTime dueDate,
  }) = _Goal;
}
