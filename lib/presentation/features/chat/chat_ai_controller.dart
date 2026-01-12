import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/utils/currency.dart';
import '../../../core/utils/date.dart';
import '../../../domain/entities/account.dart';
import '../../../domain/entities/transaction.dart';
import '../../../providers/predictive_providers.dart';
import '../../../services/predictive_engine.dart';

class ChatAiController {
  ChatAiController(this._ref);

  final Ref _ref;

  Future<String> reply(String userText) async {
    final amount = _extractRupiah(userText) ?? 150000;
    final targetDay = _extractDay(userText) ?? DateUtilsX.startOfDay(DateTime.now().add(const Duration(days: 1)));

    final PredictiveEngine engine = _ref.read(predictiveEngineProvider);
    final List<Transaction> tx = await _ref.read(transactionsStreamProvider.future);
    final List<Account> ac = await _ref.read(accountsStreamProvider.future);

    final isSafe = _simulateIsSafe(engine, ac, tx, targetDay, amount);
    if (isSafe) {
      const reason = 'prediksi saldo ≥ Rp500.000 dan tidak ada spike besar.';
      return 'Aman. Disarankan menabung ${CurrencyUtils.format(amount)} pada ${DateUtilsX.formatFull(targetDay)} — $reason';
    } else {
      final alt = _suggestAlt(engine, ac, tx, targetDay, amount);
      return 'Tidak disarankan menabung ${CurrencyUtils.format(amount)} pada ${DateUtilsX.formatFull(targetDay)}. $alt';
    }
  }

  int? _extractRupiah(String text) {
    final lower = text.toLowerCase().replaceAll('.', '').replaceAll(',', '');
    final regex = RegExp(r'(rp\s*([0-9]+)k|rp\s*([0-9]+)|([0-9]+)k|([0-9]{3,}))');
    final match = regex.firstMatch(lower);
    if (match == null) return null;
    if (match.group(2) != null) return int.tryParse(match.group(2)!)! * 1000;
    if (match.group(3) != null) return int.tryParse(match.group(3)!)!;
    if (match.group(4) != null) return int.tryParse(match.group(4)!)! * 1000;
    if (match.group(5) != null) return int.tryParse(match.group(5)!)!;
    return null;
  }

  DateTime? _extractDay(String text) {
    final lower = text.toLowerCase();
    final now = DateTime.now();
    if (lower.contains('besok')) {
      return DateUtilsX.startOfDay(now.add(const Duration(days: 1)));
    }
    if (lower.contains('lusa')) {
      return DateUtilsX.startOfDay(now.add(const Duration(days: 2)));
    }
    const Map<String, int> days = {
      'senin': DateTime.monday,
      'selasa': DateTime.tuesday,
      'rabu': DateTime.wednesday,
      'kamis': DateTime.thursday,
      'jumat': DateTime.friday,
      'sabtu': DateTime.saturday,
      'minggu': DateTime.sunday,
    };
    for (final entry in days.entries) {
      if (lower.contains(entry.key)) {
        var date = DateUtilsX.startOfDay(now);
        while (date.weekday != entry.value) {
          date = date.add(const Duration(days: 1));
        }
        if (!date.isAfter(now)) {
          date = date.add(const Duration(days: 7));
        }
        return date;
      }
    }
    return null;
  }

  bool _simulateIsSafe(
    PredictiveEngine engine,
    List<Account> accounts,
    List<Transaction> tx,
    DateTime target,
    int amount,
  ) {
    final total = accounts.fold<double>(0, (s, a) => s + a.balance);
    const horizon = 14;
    final forecast = engine.forecast(tx, horizon);
    double projectedSpend = 0;
    for (final p in forecast) {
      if (p.date.isAfter(target)) break;
      projectedSpend += p.predictedSpend;
    }
    final remaining = total - projectedSpend - amount;
    return remaining >= 500000; // minSafeBalance
  }

  String _suggestAlt(
    PredictiveEngine engine,
    List<Account> accounts,
    List<Transaction> tx,
    DateTime target,
    int amount,
  ) {
    final totalBalance = accounts.fold<double>(0, (s, a) => s + a.balance);
    
    // Try lower amount
    final candidates = [amount ~/ 2, amount ~/ 3, 100000, 50000];
    for (final cand in candidates) {
      if (_simulateIsSafe(engine, accounts, tx, target, cand)) {
        return 'Coba tabung ${CurrencyUtils.format(cand)} pada ${DateUtilsX.formatFull(target)}. Jumlah lebih kecil lebih aman untuk saldo Anda.';
      }
    }
    
    // Try a later safe day with balance consideration
    final safe = engine.safeDays(
      tx, 
      14,
      currentBalance: totalBalance > 0 ? totalBalance : null,
    );
    if (safe.isNotEmpty) {
      final nextSafeDay = safe.firstWhere(
        (day) => day.isAfter(target),
        orElse: () => safe.first,
      );
      return 'Pertimbangkan menabung ${CurrencyUtils.format(amount)} pada ${DateUtilsX.formatFull(nextSafeDay)}. Hari tersebut lebih aman berdasarkan prediksi pengeluaran.';
    }
    
    // Final suggestion based on balance
    if (totalBalance < amount * 2) {
      return 'Saldo Anda tidak cukup untuk menabung ${CurrencyUtils.format(amount)} saat ini. Tunggu hingga saldo lebih sehat atau kurangi jumlah tabungan.';
    }
    
    return 'Tunda menabung beberapa hari hingga saldo lebih aman. Periksa forecast di halaman Insights untuk melihat hari yang lebih aman.';
  }
}

final chatAiControllerProvider = Provider((ref) => ChatAiController(ref));


