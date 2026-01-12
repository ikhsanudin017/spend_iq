import 'dart:async';

import 'package:dio/dio.dart';

import '../../models/account.dart';
import '../../models/alert_item.dart';
import '../../models/transaction.dart';
import '../local/boxes.dart';
import 'mock_interceptor.dart';

class OpenBankingApi {
  OpenBankingApi({Dio? dio})
      : _dio = (dio ?? Dio())
          ..options = BaseOptions(
            baseUrl: 'https://mock.smartspend.ai',
            connectTimeout: const Duration(seconds: 5),
            receiveTimeout: const Duration(seconds: 5),
          )
          ..interceptors.add(MockInterceptor());

  final Dio _dio;

  Future<List<AccountModel>> getAccounts({List<String>? connectedBanks}) async {
    final response = await _dio.get<List<dynamic>>('/accounts');
    final data = _asMapList(response.data);
    var accounts = data.map(AccountModel.fromJson).toList();
    
    // Filter berdasarkan connected banks jika ada
    if (connectedBanks != null && connectedBanks.isNotEmpty) {
      accounts = accounts
          .where((account) => connectedBanks.contains(account.bankName))
          .toList();
    }
    
    return accounts;
  }

  Future<List<TransactionModel>> getTransactions({
    DateTime? start,
    DateTime? end,
  }) async {
    final response = await _dio.get<List<dynamic>>('/transactions');
    final data = _asMapList(response.data);
    var transactions = data.map(TransactionModel.fromJson).toList();
    if (start != null || end != null) {
      transactions = transactions.where((tx) {
        final afterStart = start == null || !tx.date.isBefore(start);
        final beforeEnd = end == null || !tx.date.isAfter(end);
        return afterStart && beforeEnd;
      }).toList();
    }
    transactions.sort((a, b) => b.date.compareTo(a.date));
    return transactions;
  }

  Future<List<AlertItemModel>> getBills() async {
    final response = await _dio.get<List<dynamic>>('/bills');
    final data = _asMapList(response.data);
    return data
        .map(
          (bill) => AlertItemModel(
            id: bill['id']?.toString() ?? '',
            type: AlertItemType.bill,
            title: bill['title']?.toString() ?? '',
            detail: bill['detail']?.toString() ?? '',
            date: DateTime.tryParse(bill['dueDate']?.toString() ?? '') ??
                DateTime.now(),
          ),
        )
        .toList();
  }

  Future<void> registerBankConnections(List<String> banks) async {
    await HiveBoxes.saveConnectedBanks(banks);
  }
}

List<Map<String, dynamic>> _asMapList(List<dynamic>? raw) {
  if (raw == null) {
    return const <Map<String, dynamic>>[];
  }
  return raw.whereType<Map<String, dynamic>>().toList();
}
