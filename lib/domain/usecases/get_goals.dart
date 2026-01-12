import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:smartspend_ai/data/repositories/finance_repository_impl.dart';

import '../entities/goal.dart';
import '../repositories/finance_repository.dart';

class GetGoalsUseCase {
  GetGoalsUseCase(this._repository);

  final FinanceRepository _repository;

  Future<List<Goal>> call() => _repository.getGoals();
}

class GoalsController extends AsyncNotifier<List<Goal>> {
  late final FinanceRepository _repository;

  @override
  Future<List<Goal>> build() async {
    _repository = ref.read(financeRepositoryProvider);
    await _repository.seedIfNeeded();
    final goals = await _repository.getGoals();
    goals.sort((a, b) => a.dueDate.compareTo(b.dueDate));
    return goals;
  }

  Future<void> upsertGoal(Goal goal) async {
    final current = List<Goal>.from(state.valueOrNull ?? await future);
    state = const AsyncLoading();
    await _repository.upsertGoal(goal);
    final updated = [
      ...current.where((g) => g.id != goal.id),
      goal,
    ]..sort((a, b) => a.dueDate.compareTo(b.dueDate));
    state = AsyncData(updated);
  }

  Future<void> deleteGoal(String id) async {
    final current = List<Goal>.from(state.valueOrNull ?? await future);
    state = const AsyncLoading();
    await _repository.deleteGoal(id);
    state = AsyncData(
      current.where((goal) => goal.id != id).toList()
        ..sort((a, b) => a.dueDate.compareTo(b.dueDate)),
    );
  }
}

final goalsControllerProvider =
    AsyncNotifierProvider<GoalsController, List<Goal>>(
  GoalsController.new,
);
