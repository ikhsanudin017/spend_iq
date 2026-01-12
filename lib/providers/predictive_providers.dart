import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/repositories/finance_repository_impl.dart';
import '../domain/entities/account.dart';
import '../domain/entities/alert_item.dart';
import '../domain/entities/forecast_point.dart';
import '../domain/entities/transaction.dart';
import '../services/predictive_engine.dart';

final accountsStreamProvider = StreamProvider<List<Account>>((ref) {
  final repo = ref.watch(financeRepositoryProvider);
  return Stream.fromFuture(repo.getAccounts());
});

final transactionsStreamProvider = StreamProvider<List<Transaction>>((ref) {
  final repo = ref.watch(financeRepositoryProvider);
  return Stream.fromFuture(repo.getRecentTransactions());
});

final forecastProvider = Provider.autoDispose<List<ForecastPoint>>((ref) {
  final engine = ref.watch(predictiveEngineProvider);
  final tx = ref
      .watch(transactionsStreamProvider)
      .maybeWhen(data: (v) => v, orElse: () => const <Transaction>[]);
  return engine.forecast(tx, 14);
});

// Optional health provider: use repository's existing computation via Future elsewhere if needed.

final smartAlertsProvider = Provider.autoDispose<List<AlertItem>>((ref) {
  final engine = ref.watch(predictiveEngineProvider);
  final tx = ref
      .watch(transactionsStreamProvider)
      .maybeWhen(data: (v) => v, orElse: () => const <Transaction>[]);
  final accounts = ref
      .watch(accountsStreamProvider)
      .maybeWhen(data: (v) => v, orElse: () => const <Account>[]);
  final forecast = ref.watch(forecastProvider);
  return engine.buildAlerts(
    tx,
    accounts: accounts,
    forecast: forecast,
  );
});

final safeDaysProvider = Provider.autoDispose<List<DateTime>>((ref) {
  final engine = ref.watch(predictiveEngineProvider);
  final tx = ref
      .watch(transactionsStreamProvider)
      .maybeWhen(data: (v) => v, orElse: () => const <Transaction>[]);
  return engine.safeDays(tx, 7);
});


