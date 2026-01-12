import 'package:flutter_test/flutter_test.dart';

import 'package:smartspend_ai/domain/entities/transaction.dart';
import 'package:smartspend_ai/services/predictive_engine.dart';

void main() {
  final engine = PredictiveEngine();
  final baseDate = DateTime(2025, 10);

  List<Transaction> buildTransactions() => List.generate(14, (index) {
      final date = baseDate.subtract(Duration(days: index));
      return Transaction(
        id: 'tx_$index',
        accountId: 'acc',
        date: date,
        amount: 300000 + (index * 10000),
        category: index % 3 == 0 ? 'Bills' : 'Groceries',
        merchant: 'Merchant $index',
      );
    });

  test('forecast returns expected horizon length', () {
    final transactions = buildTransactions();
    final forecast = engine.forecast(transactions, 7);
    expect(forecast, hasLength(7));
  });

  test('forecast has risky days when predicted spike occurs', () {
    final transactions = buildTransactions();
    final forecast = engine.forecast(transactions, 14);
    final riskyDays = forecast.where((point) => point.risky).toList();
    expect(riskyDays, isNotEmpty);
  });

  test('safeDays returns at least two days even for sparse data', () {
    final transactions = [
      Transaction(
        id: 'tx_single',
        accountId: 'acc',
        date: baseDate,
        amount: 250000,
        category: 'Groceries',
        merchant: 'Supermarket',
      ),
    ];
    final safeDays = engine.safeDays(transactions, 7);
    expect(safeDays.length, greaterThanOrEqualTo(2));
  });
}
