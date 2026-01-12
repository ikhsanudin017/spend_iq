// ignore_for_file: prefer_expression_function_bodies
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/errors/app_exception.dart';
import '../../core/errors/failures.dart';
import '../../domain/entities/account.dart';
import '../../domain/entities/alert_item.dart';
import '../../domain/entities/autosave_plan.dart';
import '../../domain/entities/financial_health.dart';
import '../../domain/entities/forecast_point.dart';
import '../../domain/entities/goal.dart';
import '../../domain/entities/transaction.dart';
import '../../domain/repositories/finance_repository.dart';
import '../../services/notifications_service.dart';
import '../../services/predictive_engine.dart';
import '../datasources/local/boxes.dart';
import '../datasources/local/hive_adapters.dart';
import '../datasources/remote/open_banking_api.dart';
import '../models/account.dart';
import '../models/alert_item.dart';
import '../models/autosave_plan.dart';
import '../models/goal.dart';
import '../models/transaction.dart';

class FinanceRepositoryImpl implements FinanceRepository {
  FinanceRepositoryImpl({
    required OpenBankingApi api,
    required PredictiveEngine engine,
  })  : _api = api,
        _engine = engine {
    HiveAdapters.register();
  }

  final OpenBankingApi _api;
  final PredictiveEngine _engine;

  static const List<String> _availableBanks = [
    'Mandiri',
    'BCA',
    'BRI',
    'Jenius',
  ];

  List<AccountModel>? _accountCache;
  List<TransactionModel>? _transactionsCache;
  List<AlertItemModel>? _alertsCache;

  @override
  Future<List<String>> getAvailableBanks() async {
    return _availableBanks;
  }

  @override
  Future<void> connectBank(String bankName) async {
    final connections = HiveBoxes.getConnectedBanks();
    if (!connections.contains(bankName)) {
      connections.add(bankName);
      await HiveBoxes.saveConnectedBanks(connections);
      await _api.registerBankConnections(connections);
    }
  }

  @override
  Future<List<String>> getConnectedBanks() async {
    final banks = HiveBoxes.getConnectedBanks();
    // Return empty list if no banks connected (don't return default banks)
    return banks;
  }

  @override
  Future<void> saveBankConnections(List<String> banks) async {
    await HiveBoxes.saveConnectedBanks(List<String>.from(banks));
    // Selalu invalidate cache agar data baru di-fetch dengan bank terbaru
    _accountCache = null;
  }

  @override
  Future<void> refreshAccounts() async {
    // Invalidate cache untuk memaksa fetch data baru
    _accountCache = null;
  }

  @override
  Future<void> refreshTransactions() async {
    // Invalidate cache untuk memaksa fetch data baru
    _transactionsCache = null;
    _alertsCache = null; // Alerts juga perlu di-refresh karena bergantung pada transactions
  }

  @override
  Future<List<Account>> getAccounts() async {
    try {
      // Check if user has connected any banks
      final connectedBanks = await getConnectedBanks();
      if (connectedBanks.isEmpty) {
        // Return empty list if no banks connected
        _accountCache = null; // Clear cache jika tidak ada bank
        return [];
      }
      
      // Selalu cek apakah connected banks berubah
      // Jika cache ada, cek apakah connected banks masih sama
      bool shouldRefresh = false;
      if (_accountCache != null) {
        final cachedBanks = _accountCache!.map((a) => a.bankName).toSet();
        final currentBanks = connectedBanks.toSet();
        // Jika connected banks berubah, invalidate cache
        if (cachedBanks != currentBanks) {
          shouldRefresh = true;
          _accountCache = null;
        }
      } else {
        // Cache null, perlu fetch
        shouldRefresh = true;
      }
      
      // Fetch data baru jika perlu refresh
      if (shouldRefresh) {
        _accountCache = await _api.getAccounts(connectedBanks: connectedBanks);
      }
      
      // Pastikan semua bank yang di-connect ada di hasil
      final result = _accountCache!.map((model) => model.toEntity()).toList();
      final resultBanks = result.map((a) => a.bankName).toSet();
      final expectedBanks = connectedBanks.toSet();
      
      // Validasi: pastikan jumlah dan jenis bank sesuai
      if (resultBanks.length != expectedBanks.length || 
          resultBanks != expectedBanks) {
        // Jika tidak sesuai, force refresh
        _accountCache = null;
        _accountCache = await _api.getAccounts(connectedBanks: connectedBanks);
        final refreshedResult = _accountCache!.map((model) => model.toEntity()).toList();
        final refreshedBanks = refreshedResult.map((a) => a.bankName).toSet();
        
        // Double check setelah refresh
        if (refreshedBanks != expectedBanks) {
          // Jika masih tidak sesuai, log error dan return apa yang ada
          debugPrint('WARNING: Bank mismatch. Expected: $expectedBanks, Got: $refreshedBanks');
        }
        
        return refreshedResult;
      }
      
      return result;
    } catch (error, stackTrace) {
      // If error, log dan return empty list instead of throwing
      debugPrint('Error in getAccounts: $error');
      debugPrint('Stack trace: $stackTrace');
      // This allows app to show empty state instead of error
      return [];
    }
  }

  @override
  Future<List<Transaction>> getRecentTransactions() async {
    try {
      // Fetch data baru jika cache null
      _transactionsCache ??= await _api.getTransactions();
      return _transactionsCache!.map((model) => model.toEntity()).toList();
    } catch (error, stackTrace) {
      throw AppException(
          NetworkFailure('Failed to load transactions', error, stackTrace));
    }
  }

  @override
  Future<List<AlertItem>> getAlerts() async {
    _alertsCache ??= await _loadAlerts();
    return _alertsCache!
        .map(
          (model) => model.toEntity(),
        )
        .toList()
      ..sort((a, b) => b.date.compareTo(a.date));
  }

  Future<List<AlertItemModel>> _loadAlerts() async {
    final bills = await _api.getBills();
    final notifications = NotificationsService.instance;
    for (final bill in bills) {
      await notifications.scheduleBillReminder(
        id: bill.id,
        dueDate: bill.date,
        title: bill.title,
        body: bill.detail,
      );
    }
    final transactions = await getRecentTransactions();
    final alerts = List<AlertItemModel>.from(bills);
    final riskyDays = _engine.buildAlerts(transactions);
    alerts.addAll(riskyDays.map((alert) => AlertItemModel(
          id: alert.id,
          type: AlertItemType.values[alert.type.index],
          title: alert.title,
          detail: alert.detail,
          date: alert.date,
          read: alert.read,
        )));
    return alerts;
  }

  @override
  Future<List<Goal>> getGoals() async {
    final goals = HiveBoxes.getGoals();
    return goals.map((model) => model.toEntity()).toList();
  }

  @override
  Future<void> upsertGoal(Goal goal) async {
    final models = HiveBoxes.getGoals();
    final updated = [
      ...models.where((item) => item.id != goal.id),
      GoalModel.fromEntity(goal),
    ]..sort((a, b) => a.dueDate.compareTo(b.dueDate));
    await HiveBoxes.saveGoals(updated);
  }

  @override
  Future<void> deleteGoal(String id) async {
    final models = HiveBoxes.getGoals();
    final updated = models.where((goal) => goal.id != id).toList();
    await HiveBoxes.saveGoals(updated);
  }

  @override
  Future<bool> isAutoSaveEnabled() async {
    return HiveBoxes.getAutoSaveEnabled();
  }

  @override
  Future<void> setAutoSaveEnabled(bool value) async {
    await HiveBoxes.setAutoSaveEnabled(value);
  }

  @override
  Future<List<AutosavePlan>> getAutosavePlans() async {
    final plans = HiveBoxes.getAutosavePlans();
    return plans.map((model) => model.toEntity()).toList();
  }

  @override
  Future<void> saveAutosavePlans(List<AutosavePlan> plans) async {
    final models = plans.map(AutosavePlanModel.fromEntity).toList();
    await HiveBoxes.saveAutosavePlans(models);
  }

  @override
  Future<FinancialHealth> getFinancialHealth() async {
    final accounts = await getAccounts();
    final transactions = await getRecentTransactions();
    final goals = await getGoals();
    final score = _engine.healthScore(
      accounts: accounts,
      transactions: transactions,
      goals: goals,
    );
    final label = _mapScoreToLabel(score);
    return FinancialHealth(score: score, label: label);
  }

  FinancialHealthLabel _mapScoreToLabel(int score) {
    if (score >= 80) return FinancialHealthLabel.healthy;
    if (score >= 65) return FinancialHealthLabel.stable;
    if (score >= 45) return FinancialHealthLabel.caution;
    return FinancialHealthLabel.risk;
  }

  @override
  Future<List<ForecastPoint>> getForecast({required int horizon}) async {
    final transactions = await getRecentTransactions();
    return _engine.forecast(transactions, horizon);
  }

  @override
  Future<void> seedIfNeeded() async {
    if (HiveBoxes.getSeeded()) {
      return;
    }

    final sampleGoals = [
      GoalModel(
        id: 'goal_emergency',
        name: 'Emergency Fund',
        targetAmount: 20000000,
        currentAmount: 6000000,
        monthlyPlan: 2000000,
        dueDate: DateTime.now().add(const Duration(days: 240)),
      ),
      GoalModel(
        id: 'goal_travel',
        name: 'Liburan Keluarga',
        targetAmount: 15000000,
        currentAmount: 4500000,
        monthlyPlan: 1500000,
        dueDate: DateTime.now().add(const Duration(days: 180)),
      ),
      GoalModel(
        id: 'goal_dp',
        name: 'DP Rumah',
        targetAmount: 80000000,
        currentAmount: 12000000,
        monthlyPlan: 5000000,
        dueDate: DateTime.now().add(const Duration(days: 540)),
      ),
    ];

    final today = DateTime.now();
    final samplePlans = List.generate(4, (index) {
      final date = today.add(Duration(days: (index + 1) * 5));
      return AutosavePlanModel(
        date: date,
        amount: 250000 + (index * 50000),
        confirmed: index == 0,
      );
    });

    await HiveBoxes.saveGoals(sampleGoals);
    await HiveBoxes.saveAutosavePlans(samplePlans);
    // Don't seed bank connections - user must connect manually
    // await HiveBoxes.saveConnectedBanks(_availableBanks.take(2).toList());
    await HiveBoxes.setAutoSaveEnabled(false); // Default to disabled
    await HiveBoxes.setSeeded(true);
  }
}

final openBankingApiProvider = Provider<OpenBankingApi>((ref) {
  return OpenBankingApi();
});

final financeRepositoryProvider = Provider<FinanceRepository>((ref) {
  final api = ref.watch(openBankingApiProvider);
  final engine = ref.watch(predictiveEngineProvider);
  return FinanceRepositoryImpl(api: api, engine: engine);
});
