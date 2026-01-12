import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';

import '../domain/repositories/finance_repository.dart';

class BackupService {
  BackupService(this._repository);

  final FinanceRepository _repository;

  Future<String> exportDataToJson() async {
    final accounts = await _repository.getAccounts();
    final transactions = await _repository.getRecentTransactions();
    final goals = await _repository.getGoals();
    final autosavePlans = await _repository.getAutosavePlans();
    final alerts = await _repository.getAlerts();

    final data = {
      'exportDate': DateTime.now().toIso8601String(),
      'version': '1.0',
      'accounts': accounts.map((a) => {
            'id': a.id,
            'bankName': a.bankName,
            'masked': a.masked,
            'balance': a.balance,
          }).toList(),
      'transactions': transactions.map((t) => {
            'id': t.id,
            'accountId': t.accountId,
            'date': t.date.toIso8601String(),
            'amount': t.amount,
            'category': t.category,
            'merchant': t.merchant,
            'note': t.note,
          }).toList(),
      'goals': goals.map((g) => {
            'id': g.id,
            'name': g.name,
            'targetAmount': g.targetAmount,
            'currentAmount': g.currentAmount,
            'monthlyPlan': g.monthlyPlan,
            'dueDate': g.dueDate.toIso8601String(),
          }).toList(),
      'autosavePlans': autosavePlans.map((p) => {
            'date': p.date.toIso8601String(),
            'amount': p.amount,
            'confirmed': p.confirmed,
          }).toList(),
      'alerts': alerts.map((a) => {
            'id': a.id,
            'type': a.type.name,
            'title': a.title,
            'detail': a.detail,
            'date': a.date.toIso8601String(),
          }).toList(),
    };

    return const JsonEncoder.withIndent('  ').convert(data);
  }

  Future<String?> saveBackupFile(String jsonData) async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final timestamp = DateTime.now().toIso8601String().replaceAll(':', '-').split('.')[0];
      final file = File('${directory.path}/smartspend_backup_$timestamp.json');
      await file.writeAsString(jsonData);
      return file.path;
    } catch (e) {
      debugPrint('Error saving backup file: $e');
      return null;
    }
  }
}

