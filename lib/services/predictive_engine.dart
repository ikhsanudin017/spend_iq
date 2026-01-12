import 'dart:math';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/utils/date.dart';
import '../domain/entities/account.dart';
import '../domain/entities/alert_item.dart';
import '../domain/entities/forecast_point.dart';
import '../domain/entities/goal.dart';
import '../domain/entities/transaction.dart';

class PredictiveEngine {
  PredictiveEngine();

  static void ensureRegistered() {}

  List<ForecastPoint> forecast(List<Transaction> transactions, int horizon) {
    final today = DateUtilsX.startOfDay(DateTime.now());
    final startDate = today.subtract(const Duration(days: 90)); // Use last 90 days
    
    // Filter only relevant transactions (last 90 days, only expenses)
    final relevantTransactions = transactions
        .where((tx) => 
            tx.date.isAfter(startDate) && 
            tx.date.isBefore(today) &&
            tx.amount > 0) // Only expenses (positive amounts)
        .toList();
    
    if (relevantTransactions.isEmpty) {
      return List.generate(
        horizon,
        (index) => ForecastPoint(
          date: DateUtilsX.startOfDay(today.add(Duration(days: index + 1))),
          predictedSpend: 0,
          risky: false,
        ),
      );
    }

    final grouped = <DateTime, double>{};
    for (final tx in relevantTransactions) {
      final key = DateUtilsX.startOfDay(tx.date);
      grouped.update(key, (value) => value + tx.amount, ifAbsent: () => tx.amount);
    }

    final spends = grouped.values.toList()..sort();
    final average = spends.isEmpty
        ? 0
        : spends.reduce((a, b) => a + b) / max(spends.length, 1);
    final variance =
        spends.map((value) => pow(value - average, 2)).fold<double>(
                  0,
                  (acc, value) => acc + (value as double),
                ) /
            max(spends.length, 1);
    final stdDev = sqrt(variance);

    return List.generate(horizon, (index) {
      final date = DateUtilsX.startOfDay(today.add(Duration(days: index + 1)));
      final weekday = date.weekday;
      var predicted = average;

      if (weekday == DateTime.saturday || weekday == DateTime.sunday) {
        predicted *= 1.12; // weekend bump
      } else if (weekday == DateTime.friday) {
        predicted *= 1.08;
      }

      // Add spike if similar bills due around that day-of-month (next month)
      final dateMonth = date.month;
      final recentBills = relevantTransactions
          .where((tx) => 
              tx.category.toLowerCase().contains('bill') ||
              tx.category.toLowerCase().contains('subscription'))
          .toSet(); // Remove duplicates
      
      for (final bill in recentBills) {
        // Check if this bill typically occurs on this day of month
        if (bill.date.day == date.day) {
          // Only add if it's in the next month or current month
          final billMonth = bill.date.month;
          if (dateMonth == billMonth || 
              (dateMonth == billMonth + 1) ||
              (billMonth == 12 && dateMonth == 1)) {
            predicted += stdDev * 0.8;
          }
        }
      }

      final riskyThreshold = average + stdDev;
      final isRisky = predicted > riskyThreshold;
      final reason = isRisky
          ? (predicted > riskyThreshold * 1.1
              ? 'Perkiraan belanja di atas batas aman'
              : 'Belanja mendekati batas aman')
          : null;

      return ForecastPoint(
        date: date,
        predictedSpend: double.parse(predicted.toStringAsFixed(0)),
        risky: isRisky,
        riskReason: reason,
      );
    });
  }

  int healthScore({
    required List<Account> accounts,
    required List<Transaction> transactions,
    required List<Goal> goals,
  }) {
    final balance = accounts.fold<double>(0, (sum, acc) => sum + acc.balance);
    final monthlySpend = _monthlySpend(transactions);
    
    // Goal progress: average completion of all goals
    final goalProgress = goals.isEmpty
        ? 0.5
        : goals
                .map((goal) => min(1.0, goal.currentAmount / max(goal.targetAmount, 1)))
                .reduce((a, b) => a + b) /
            goals.length;

    // Liquidity score: how many months of expenses can be covered
    // Ideal: 3-6 months of expenses
    final liquidityScore = balance <= 0 
        ? 0.0 
        : monthlySpend <= 0
            ? 1.0 // No spending = perfect liquidity
            : min(1.0, balance / max(monthlySpend * 6, 1)); // 6 months = 100%
    
    // Spending ratio: balance to monthly spend ratio
    // Higher is better, but we want reasonable spending
    final spendingRatio = monthlySpend <= 0
        ? 1.0 // No spending = perfect
        : balance / max(monthlySpend, 1);
    
    // Spending score: inverse of spending ratio (lower spending relative to balance = better)
    // But we don't want to punish too much for high balance
    final spendingScore = spendingRatio >= 12 
        ? 1.0 // 12+ months of expenses = excellent
        : spendingRatio >= 6
            ? 0.9 // 6-12 months = very good
            : spendingRatio >= 3
                ? 0.7 // 3-6 months = good
                : spendingRatio >= 1
                    ? 0.5 // 1-3 months = moderate
                    : spendingRatio >= 0.5
                        ? 0.3 // 0.5-1 months = low
                        : 0.1; // < 0.5 months = critical

    // Composite score with weighted components
    final composite = (liquidityScore * 0.5) + // 50% liquidity (most important)
        (spendingScore * 0.3) + // 30% spending habits
        (goalProgress * 0.2); // 20% goal progress
    
    return (composite * 100).clamp(0, 100).round();
  }

  List<DateTime> safeDays(
    List<Transaction> transactions, 
    int horizon, {
    double? currentBalance,
  }) {
    final forecastPoints = forecast(transactions, horizon);
    
    if (forecastPoints.isEmpty) {
      // If no forecast, return next few days as safe
      final today = DateUtilsX.startOfDay(DateTime.now());
      return List.generate(
        min(horizon, 7),
        (index) => today.add(Duration(days: index + 1)),
      );
    }
    
    // Calculate median spend for better threshold
    final spends = forecastPoints.map((p) => p.predictedSpend).toList()..sort();
    final medianSpend = spends.length.isOdd
        ? spends[spends.length ~/ 2]
        : (spends[spends.length ~/ 2 - 1] + spends[spends.length ~/ 2]) / 2;
    
    // Use median for threshold (more robust to outliers)
    // Safe days are days with predicted spend below 70% of median
    final threshold = medianSpend * 0.7;

    // Filter safe days (not risky and below threshold)
    final safeDaysList = forecastPoints
        .where((point) => 
            !point.risky && 
            point.predictedSpend <= threshold)
        .map((point) => point.date)
        .toList();

    // If we have balance info, ensure safe days won't cause balance issues
    // Note: We don't filter by cumulative spend here because safe days are for saving,
    // not spending. We just ensure the day itself is safe for saving.

    // Ensure we have at least 2 safe days for stability
    if (safeDaysList.length < 2 && forecastPoints.isNotEmpty) {
      // Find days with lowest predicted spend
      final sortedBySpend = List<ForecastPoint>.from(forecastPoints)
        ..sort((a, b) => a.predictedSpend.compareTo(b.predictedSpend));
      
      for (final point in sortedBySpend.take(2)) {
        if (!safeDaysList.contains(point.date)) {
          safeDaysList.add(point.date);
        }
      }
    }
    
    return safeDaysList..sort();
  }

  List<AlertItem> buildAlerts(
    List<Transaction> transactions, {
    List<Account>? accounts,
    List<ForecastPoint>? forecast,
  }) {
    final today = DateUtilsX.startOfDay(DateTime.now());
    final lastMonthStart = DateTime(today.year, today.month - 1);
    
    // Filter transactions from last 30 days for recent spending analysis
    final recentTransactions = transactions
        .where((tx) => 
            tx.date.isAfter(lastMonthStart) && 
            tx.date.isBefore(today.add(const Duration(days: 1))) &&
            tx.amount > 0)
        .toList();

    final alerts = <AlertItem>[];

    // 1. Risk alerts: High spending in categories (last 30 days)
    final categorySpending = <String, double>{};
    for (final tx in recentTransactions) {
      categorySpending.update(
        tx.category,
        (value) => value + tx.amount,
        ifAbsent: () => tx.amount,
      );
    }

    categorySpending.forEach((category, total) {
      // Alert if spending > 3M in a category this month
      if (total > 3000000) {
        alerts.add(
          AlertItem(
            id: 'alert-spend-$category-${today.toIso8601String()}',
            type: AlertType.risk,
            title: 'Pengeluaran kategori tinggi',
            detail:
                'Pengeluaran $category mencapai ${total.toStringAsFixed(0)} dalam 30 hari terakhir. Pertimbangkan untuk mengurangi.',
            date: today,
          ),
        );
      }
    });

    // 2. Forecast-based risk alerts
    if (forecast != null && forecast.isNotEmpty) {
      final riskyDays = forecast.where((point) => point.risky).toList();
      if (riskyDays.isNotEmpty) {
        final nextRiskyDay = riskyDays.first;
        if (nextRiskyDay.date.difference(today).inDays <= 7) {
          alerts.add(
            AlertItem(
              id: 'alert-forecast-${nextRiskyDay.date.toIso8601String()}',
              type: AlertType.risk,
              title: 'Hari risiko tinggi mendatang',
              detail:
                  '${DateUtilsX.formatShort(nextRiskyDay.date)} diperkirakan memiliki pengeluaran tinggi (${nextRiskyDay.predictedSpend.toStringAsFixed(0)}). ${nextRiskyDay.riskReason ?? ''}',
              date: today,
            ),
          );
        }
      }
    }

    // 3. Bill alerts: Predict next month bills based on historical pattern
    final billPatterns = <int, List<Transaction>>{}; // day of month -> bills
    for (final tx in transactions
        .where((tx) =>
            (tx.category.toLowerCase().contains('bill') ||
                tx.category.toLowerCase().contains('subscription')) &&
            tx.amount > 0)) {
      final dayOfMonth = tx.date.day;
      billPatterns.putIfAbsent(dayOfMonth, () => []).add(tx);
    }

    // Predict bills for next month
    final nextMonth = today.month == 12 
        ? DateTime(today.year + 1)
        : DateTime(today.year, today.month + 1);
    
    billPatterns.forEach((dayOfMonth, bills) {
      var adjustedDay = dayOfMonth;
      if (adjustedDay > 28) {
        // Handle month-end bills (use last day of month)
        adjustedDay = 28;
      }
      final dueDate = DateTime(nextMonth.year, nextMonth.month, adjustedDay);
      if (dueDate.isAfter(today) && dueDate.difference(today).inDays <= 14) {
        final avgAmount = bills
                .map((b) => b.amount)
                .reduce((a, b) => a + b) /
            bills.length;
        final alertDate = dueDate.subtract(const Duration(days: 3));
        
        alerts.add(
          AlertItem(
            id: 'alert-bill-$dayOfMonth-${nextMonth.toIso8601String()}',
            type: AlertType.bill,
            title: 'Tagihan rutin mendatang',
            detail:
                'Perkiraan tagihan jatuh tempo ${DateUtilsX.formatShort(dueDate)} sebesar ${avgAmount.toStringAsFixed(0)}. Siapkan dana sekarang.',
            date: alertDate.isBefore(today) ? today : alertDate,
          ),
        );
      }
    });

    // 4. Balance risk alerts
    if (accounts != null && accounts.isNotEmpty) {
      final totalBalance = accounts.fold<double>(0, (sum, acc) => sum + acc.balance);
      final monthlySpend = _monthlySpend(transactions);
      
      if (monthlySpend > 0) {
        final monthsRemaining = totalBalance / monthlySpend;
        if (monthsRemaining < 1) {
          alerts.add(
            AlertItem(
              id: 'alert-balance-low-${today.toIso8601String()}',
              type: AlertType.risk,
              title: 'Saldo rendah - Perhatian!',
              detail:
                  'Saldo Anda hanya cukup untuk ${(monthsRemaining * 30).toStringAsFixed(0)} hari dengan pola pengeluaran saat ini. Pertimbangkan mengurangi pengeluaran.',
              date: today,
            ),
          );
        } else if (monthsRemaining < 2) {
          alerts.add(
            AlertItem(
              id: 'alert-balance-warning-${today.toIso8601String()}',
              type: AlertType.risk,
              title: 'Saldo menipis',
              detail:
                  'Saldo Anda cukup untuk ${monthsRemaining.toStringAsFixed(1)} bulan. Pantau pengeluaran dengan lebih hati-hati.',
              date: today,
            ),
          );
        }
      }
    }

    // 5. Save opportunity alerts (only if conditions are good)
    if (alerts.isEmpty || alerts.every((a) => a.type != AlertType.save)) {
      if (accounts != null && accounts.isNotEmpty) {
        final totalBalance = accounts.fold<double>(0, (sum, acc) => sum + acc.balance);
        final monthlySpend = _monthlySpend(transactions);
        
        // Suggest saving if balance is healthy (3+ months of expenses)
        if (monthlySpend > 0 && totalBalance >= monthlySpend * 3) {
          final safeDaysList = safeDays(transactions, 14, currentBalance: totalBalance);
          if (safeDaysList.isNotEmpty) {
            alerts.add(
              AlertItem(
                id: 'alert-save-${today.toIso8601String()}',
                type: AlertType.save,
                title: 'Peluang menabung',
                detail:
                    'Saldo Anda sehat. ${safeDaysList.length} hari aman tersedia bulan ini untuk menabung. Aktifkan autosave di halaman Save.',
                date: today,
              ),
            );
          }
        }
      }
    }

    // Sort alerts by priority: risk > bill > save, then by date
    alerts.sort((a, b) {
      final priority = {
        AlertType.risk: 0,
        AlertType.bill: 1,
        AlertType.save: 2,
      };
      final priorityDiff = (priority[a.type] ?? 3).compareTo(priority[b.type] ?? 3);
      if (priorityDiff != 0) return priorityDiff;
      return a.date.compareTo(b.date);
    });

    return alerts;
  }
}

double _monthlySpend(List<Transaction> transactions) {
  final now = DateTime.now();
  final monthAgo = DateTime(now.year, now.month - 1, now.day);
  
  // Get transactions from last 30 days, only expenses (positive amounts)
  final monthlyTransactions = transactions
      .where((tx) => 
          tx.date.isAfter(monthAgo) && 
          tx.date.isBefore(now.add(const Duration(days: 1))) &&
          tx.amount > 0)
      .toList();
  
  if (monthlyTransactions.isEmpty) {
    return 0;
  }
  
  final total = monthlyTransactions.fold<double>(
    0,
    (sum, tx) => sum + tx.amount,
  );
  
  // Return average daily spend * 30 for monthly projection
  final daysDiff = now.difference(monthAgo).inDays;
  if (daysDiff == 0) return total;
  
  return (total / daysDiff) * 30;
}

final predictiveEngineProvider = Provider<PredictiveEngine>((ref) => PredictiveEngine());
