import '../entities/account.dart';
import '../entities/alert_item.dart';
import '../entities/autosave_plan.dart';
import '../entities/financial_health.dart';
import '../entities/forecast_point.dart';
import '../entities/goal.dart';
import '../entities/transaction.dart';

abstract class FinanceRepository {
  Future<List<String>> getAvailableBanks();
  Future<void> connectBank(String bankName);
  Future<List<String>> getConnectedBanks();
  Future<void> saveBankConnections(List<String> banks);

  Future<List<Account>> getAccounts();
  Future<void> refreshAccounts();
  Future<List<Transaction>> getRecentTransactions();
  Future<void> refreshTransactions();
  Future<List<AlertItem>> getAlerts();
  Future<List<Goal>> getGoals();
  Future<void> upsertGoal(Goal goal);
  Future<void> deleteGoal(String id);

  Future<bool> isAutoSaveEnabled();
  Future<void> setAutoSaveEnabled(bool value);
  Future<List<AutosavePlan>> getAutosavePlans();
  Future<void> saveAutosavePlans(List<AutosavePlan> plans);

  Future<FinancialHealth> getFinancialHealth();
  Future<List<ForecastPoint>> getForecast({required int horizon});

  Future<void> seedIfNeeded();
}
