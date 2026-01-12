// ignore_for_file: prefer_expression_function_bodies
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:smartspend_ai/data/repositories/finance_repository_impl.dart';

import '../entities/autosave_plan.dart';
import '../repositories/finance_repository.dart';
import '../../services/predictive_engine.dart';

class AutosaveState {
  const AutosaveState({
    required this.enabled,
    required this.plans,
    required this.suggestedDays,
  });

  final bool enabled;
  final List<AutosavePlan> plans;
  final List<DateTime> suggestedDays;

  AutosaveState copyWith({
    bool? enabled,
    List<AutosavePlan>? plans,
    List<DateTime>? suggestedDays,
  }) {
    return AutosaveState(
      enabled: enabled ?? this.enabled,
      plans: plans ?? this.plans,
      suggestedDays: suggestedDays ?? this.suggestedDays,
    );
  }
}

class AutosaveController extends AsyncNotifier<AutosaveState> {
  late final FinanceRepository _repository;
  late final PredictiveEngine _engine;

  @override
  Future<AutosaveState> build() async {
    _repository = ref.read(financeRepositoryProvider);
    _engine = ref.read(predictiveEngineProvider);

    final enabled = await _repository.isAutoSaveEnabled();
    final plans = await _repository.getAutosavePlans();
    final suggestedDays = await _suggestSafeDays();
    return AutosaveState(
      enabled: enabled,
      plans: plans,
      suggestedDays: suggestedDays,
    );
  }

  Future<void> toggle() async {
    final current = state.valueOrNull ?? await future;
    final next = !current.enabled;
    state = const AsyncLoading();
    await _repository.setAutoSaveEnabled(next);
    state = AsyncData(current.copyWith(enabled: next));
  }

  Future<void> savePlans(List<AutosavePlan> plans) async {
    final current = state.valueOrNull ?? await future;
    state = const AsyncLoading();
    
    // Validate plans don't exceed balance
    final accounts = await _repository.getAccounts();
    final totalBalance = accounts.fold<double>(0, (sum, acc) => sum + acc.balance);
    final monthlyTotal = plans.fold<double>(0, (sum, plan) => sum + plan.amount);
    
    // Check if monthly total exceeds 50% of balance (safety threshold)
    if (totalBalance > 0 && monthlyTotal > totalBalance * 0.5) {
      state = AsyncError(
        'Total autosave (${monthlyTotal.toStringAsFixed(0)}) melebihi 50% dari saldo (${totalBalance.toStringAsFixed(0)}). Kurangi jumlah autosave.',
        StackTrace.current,
      );
      return;
    }
    
    await _repository.saveAutosavePlans(plans);
    state = AsyncData(
      current.copyWith(plans: plans),
    );
  }

  Future<void> refreshSuggestions({int horizon = 14}) async {
    final current = state.valueOrNull ?? await future;
    state = const AsyncLoading();
    final suggestions = await _suggestSafeDays(horizon: horizon);
    state = AsyncData(current.copyWith(suggestedDays: suggestions));
  }

  Future<List<DateTime>> _suggestSafeDays({int horizon = 14}) async {
    final transactions = await _repository.getRecentTransactions();
    final accounts = await _repository.getAccounts();
    final totalBalance = accounts.fold<double>(0, (sum, acc) => sum + acc.balance);
    return _engine.safeDays(
      transactions, 
      horizon,
      currentBalance: totalBalance > 0 ? totalBalance : null,
    );
  }
}

final autosaveControllerProvider =
    AsyncNotifierProvider<AutosaveController, AutosaveState>(
  AutosaveController.new,
);
