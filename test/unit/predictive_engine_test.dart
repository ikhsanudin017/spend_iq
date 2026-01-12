import 'package:flutter_test/flutter_test.dart';

import 'package:smartspend_ai/domain/entities/account.dart';
import 'package:smartspend_ai/domain/entities/transaction.dart';
import 'package:smartspend_ai/services/predictive_engine.dart';

void main() {
  group('PredictiveEngine', () {
    final engine = PredictiveEngine();

    List<Transaction> txSeed() {
      final now = DateTime.now();
      return List.generate(30, (i) {
        final date = now.subtract(Duration(days: i + 1));
        final spend = 100000 + (i % 5) * 20000; // some variance
        return Transaction(
          id: 't$i',
          accountId: 'a1',
          amount: spend.toDouble(),
          category: i % 7 == 0 ? 'Bill' : 'Food',
          merchant: 'M$i',
          date: date,
        );
      });
    }

    test('forecast horizon length', () {
      final tx = txSeed();
      final points = engine.forecast(tx, 14);
      expect(points.length, 14);
    });

    test('risk flag present for spikes', () {
      final tx = txSeed();
      final points = engine.forecast(tx, 14);
      expect(points.any((p) => p.risky), true);
    });

    test('health in 0..100', () {
      const accounts = [Account(id: 'a1', bankName: 'BCA', masked: '•••• 0000', balance: 3_000_000)];
      final tx = txSeed();
      final score = engine.healthScore(accounts: accounts, transactions: tx, goals: const []);
      expect(score >= 0 && score <= 100, true);
    });

    test('safeDays at least 2', () {
      final tx = txSeed();
      final days = engine.safeDays(tx, 14);
      expect(days.length >= 2, true);
    });
  });
}





