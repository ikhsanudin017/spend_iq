import 'dart:convert';
import 'dart:math';

import 'package:dio/dio.dart';
import 'package:flutter/services.dart' show rootBundle;

class MockInterceptor extends Interceptor {
  MockInterceptor({this.assetPrefix = 'assets/data'});

  final String assetPrefix;
  
  // Base balance untuk setiap bank (akan divariasi ±25%)
  static const Map<String, int> _baseBalances = {
    'Mandiri': 8500000,  // Base 8.5 juta
    'BCA': 6200000,      // Base 6.2 juta
    'BRI': 4800000,      // Base 4.8 juta
    'Jenius': 3500000,   // Base 3.5 juta
  };

  @override
  void onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    try {
      final path = options.path.replaceFirst(RegExp('^/'), '');
      
      // Generate dynamic accounts data
      if (path == 'accounts') {
        final data = _generateDynamicAccounts();
        handler.resolve(
          Response(
            requestOptions: options,
            statusCode: 200,
            data: data,
          ),
        );
        return;
      }
      
      // Untuk path lain, gunakan file JSON seperti biasa
      final assetPath = _resolveAssetPath(options);
      final content = await rootBundle.loadString(assetPath);
      final data = jsonDecode(content);
      handler.resolve(
        Response(
          requestOptions: options,
          statusCode: 200,
          data: data,
        ),
      );
    } catch (error, stackTrace) {
      handler.reject(
        DioException(
          requestOptions: options,
          error: error,
          stackTrace: stackTrace,
        ),
      );
    }
  }

  /// Generate dynamic accounts dengan variasi balance
  /// Setiap bank memiliki base balance yang berbeda, dengan variasi ±25%
  List<Map<String, dynamic>> _generateDynamicAccounts() {
    final now = DateTime.now();
    // Gunakan timestamp untuk variasi yang konsisten per jam
    // Ini membuat data berubah setiap jam, menunjukkan dinamis
    final hourSeed = now.year * 1000000 + 
                     now.month * 10000 + 
                     now.day * 100 + 
                     now.hour;
    final random = Random(hourSeed); // Seed berdasarkan jam
    
    // Helper untuk generate balance dengan variasi
    int generateBalance(int base, Random rng) {
      // Variasi ±25% dari base balance
      final variation = (rng.nextDouble() * 0.5 - 0.25); // -0.25 sampai +0.25
      final balance = base * (1 + variation);
      // Round ke ribuan terdekat untuk lebih realistis
      return ((balance / 1000).round() * 1000);
    }
    
    return [
      {
        'id': 'acc_mandiri',
        'bankName': 'Mandiri',
        'masked': '****1234',
        'balance': generateBalance(_baseBalances['Mandiri']!, random),
      },
      {
        'id': 'acc_bca',
        'bankName': 'BCA',
        'masked': '****9876',
        'balance': generateBalance(_baseBalances['BCA']!, random),
      },
      {
        'id': 'acc_bri',
        'bankName': 'BRI',
        'masked': '****5521',
        'balance': generateBalance(_baseBalances['BRI']!, random),
      },
      {
        'id': 'acc_jenius',
        'bankName': 'Jenius',
        'masked': '****8899',
        'balance': generateBalance(_baseBalances['Jenius']!, random),
      },
    ];
  }

  String _resolveAssetPath(RequestOptions options) {
    final path = options.path.replaceFirst(RegExp('^/'), '');
    switch (path) {
      case 'accounts':
        // Tidak digunakan lagi karena generate dinamis
        return '$assetPrefix/accounts.json';
      case 'transactions':
        return '$assetPrefix/transactions.json';
      case 'bills':
        return '$assetPrefix/bills.json';
      default:
        return '$assetPrefix/$path.json';
    }
  }
}
