import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'package:smartspend_ai/data/metas/facade/accounts_read_facade.dart';
import 'package:smartspend_ai/domain/entities/account.dart';
import 'package:smartspend_ai/domain/entities/alert_item.dart';
import 'package:smartspend_ai/domain/entities/autosave_plan.dart';
import 'package:smartspend_ai/domain/entities/financial_health.dart';
import 'package:smartspend_ai/domain/entities/forecast_point.dart';
import 'package:smartspend_ai/domain/usecases/get_dashboard_summary.dart';
import 'package:smartspend_ai/presentation/features/home/home_page.dart';
import 'package:smartspend_ai/providers/accounts_home_providers.dart';
import 'package:smartspend_ai/providers/predictive_providers.dart' as pred;

void main() {
  setUpAll(() async {
    await initializeDateFormatting('id_ID');
  });

  testWidgets('Home shows forecast and smart alerts', (tester) async {
    final now = DateTime(2025, 10);

    final summary = DashboardSummary(
      accounts: const [
        Account(
          id: 'acc1',
          bankName: 'BCA',
          masked: '****0000',
          balance: 2_500_000,
        ),
      ],
      aggregateBalance: 2_500_000,
      health: const FinancialHealth(
        score: 72,
        label: FinancialHealthLabel.stable,
      ),
      forecast: List.generate(
        10,
        (i) => ForecastPoint(
          date: now.add(Duration(days: i)),
          predictedSpend: 200000 + (i * 25000),
          risky: i == 4 || i == 6,
        ),
      ),
      alerts: [
        AlertItem(
          id: 'alert1',
          type: AlertType.risk,
          title: 'Pengeluaran melonjak',
          detail: 'Kategori Food +45% minggu ini',
          date: now.add(const Duration(days: 3)),
        ),
        AlertItem(
          id: 'alert2',
          type: AlertType.bill,
          title: 'Tagihan Internet',
          detail: 'Bayar sebelum 18 Okt',
          date: now.add(const Duration(days: 10)),
        ),
      ],
      autoSaveEnabled: true,
      autoSavePlans: [
        AutosavePlan(
          date: DateTime(2025, 10, 6),
          amount: 200000,
        ),
      ],
    );

    final accountViews = [
      const AccountView(
        accountId: 'acc1',
        name: 'Akun Utama',
        bankName: 'BCA',
        accountNumberMasked: '•••• 0000',
        balance: 2_500_000,
      ),
    ];

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          getDashboardSummaryProvider
              .overrideWith((ref) => Future.value(summary)),
          pred.forecastProvider.overrideWith((ref) => summary.forecast),
          pred.smartAlertsProvider.overrideWith((ref) => summary.alerts),
          accountViewsProvider.overrideWith(
            (ref) => Stream.value(accountViews),
          ),
        ],
        child: const MaterialApp(home: HomePage()),
      ),
    );

    await tester.pumpAndSettle();
    await tester.drag(find.byType(ListView).first, const Offset(0, -600));
    await tester.pumpAndSettle();

    expect(find.textContaining('Smart Alerts'), findsOneWidget);
    expect(find.textContaining('Prediksi'), findsWidgets);
  });
}
