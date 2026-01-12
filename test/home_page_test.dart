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

  testWidgets('HomePage renders summary cards and alerts', (tester) async {
    final summary = DashboardSummary(
      accounts: const [
        Account(
          id: 'acc1',
          bankName: 'Mandiri',
          masked: '****1234',
          balance: 10000000,
        ),
        Account(
          id: 'acc2',
          bankName: 'BCA',
          masked: '****9876',
          balance: 5000000,
        ),
      ],
      aggregateBalance: 15000000,
      health: const FinancialHealth(
        score: 82,
        label: FinancialHealthLabel.healthy,
      ),
      forecast: [
        for (var i = 0; i < 7; i++)
          ForecastPoint(
            date: DateTime(2025, 10, i + 1),
            predictedSpend: 350000 + (i * 10000),
            risky: i.isEven,
          ),
      ],
      alerts: [
        AlertItem(
          id: 'alert1',
          type: AlertType.bill,
          title: 'Tagihan PLN',
          detail: 'Jatuh tempo 12 Okt',
          date: DateTime(2025, 10, 12),
        ),
      ],
      autoSaveEnabled: true,
      autoSavePlans: [
        AutosavePlan(
          date: DateTime(2025, 10, 5),
          amount: 250000,
        ),
      ],
    );

    final accountViews = summary.accounts
        .map(
          (account) => AccountView(
            accountId: account.id,
            name: account.bankName,
            bankName: account.bankName,
            accountNumberMasked: account.masked,
            balance: account.balance.round(),
          ),
        )
        .toList();

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
        child: const MaterialApp(
          home: HomePage(),
        ),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.textContaining('Total Saldo'), findsOneWidget);
  });
}
