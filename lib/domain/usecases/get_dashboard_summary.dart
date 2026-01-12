import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:smartspend_ai/data/repositories/finance_repository_impl.dart';

import '../entities/account.dart';
import '../entities/alert_item.dart';
import '../entities/autosave_plan.dart';
import '../entities/financial_health.dart';
import '../entities/forecast_point.dart';
import '../repositories/finance_repository.dart';
import '../../services/predictive_engine.dart';

class DashboardSummary {
  const DashboardSummary({
    required this.accounts,
    required this.aggregateBalance,
    required this.health,
    required this.forecast,
    required this.alerts,
    required this.autoSaveEnabled,
    required this.autoSavePlans,
  });

  final List<Account> accounts;
  final double aggregateBalance;
  final FinancialHealth health;
  final List<ForecastPoint> forecast;
  final List<AlertItem> alerts;
  final bool autoSaveEnabled;
  final List<AutosavePlan> autoSavePlans;
}

class GetDashboardSummaryUseCase {
  GetDashboardSummaryUseCase(this._repository, this._engine);

  final FinanceRepository _repository;
  final PredictiveEngine _engine;

  Future<DashboardSummary> call({int horizon = 14, bool refresh = false}) async {
    await _repository.seedIfNeeded();
    
    // Refresh data jika diperlukan (untuk pull-to-refresh)
    if (refresh) {
      await _repository.refreshAccounts();
      await _repository.refreshTransactions();
    }
    
    final accounts = await _repository.getAccounts();
    final transactions = await _repository.getRecentTransactions();
    final aggregateBalance =
        accounts.fold<double>(0, (sum, account) => sum + account.balance);
    final health = await _repository.getFinancialHealth();
    final alerts = await _repository.getAlerts();
    final autoSaveEnabled = await _repository.isAutoSaveEnabled();
    final autoSavePlans = await _repository.getAutosavePlans();
    final forecast = _engine.forecast(transactions, horizon);

    return DashboardSummary(
      accounts: accounts,
      aggregateBalance: aggregateBalance,
      health: health,
      forecast: forecast,
      alerts: alerts,
      autoSaveEnabled: autoSaveEnabled,
      autoSavePlans: autoSavePlans,
    );
  }
}

final getDashboardSummaryProvider =
    FutureProvider.autoDispose<DashboardSummary>((ref) async {
  final repository = ref.watch(financeRepositoryProvider);
  final engine = ref.watch(predictiveEngineProvider);
  final useCase = GetDashboardSummaryUseCase(repository, engine);
  return useCase();
});
