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
import 'package:smartspend_ai/presentation/features/accounts_meta/accounts_meta_list_page.dart';
import 'package:smartspend_ai/presentation/features/home/home_page.dart';
import 'package:smartspend_ai/providers/accounts_home_providers.dart';
import 'package:smartspend_ai/providers/predictive_providers.dart' as pred;

void main() {
  setUpAll(() async {
    await initializeDateFormatting('id_ID');
  });

  testWidgets('Home shows aggregate balance and account summary list',
      (tester) async {
    final summary = DashboardSummary(
      accounts: const [
        Account(
          id: 'acc1',
          bankName: 'BCA',
          masked: '****1098',
          balance: 1_000_000,
        ),
        Account(
          id: 'acc2',
          bankName: 'Jenius',
          masked: '****4456',
          balance: 2_500_000,
        ),
      ],
      aggregateBalance: 3_500_000,
      health: const FinancialHealth(
        score: 80,
        label: FinancialHealthLabel.stable,
      ),
      forecast: [
        for (var i = 0; i < 7; i++)
          ForecastPoint(
            date: DateTime(2025, 10, i + 1),
            predictedSpend: 250000 + (i * 15000),
            risky: i == 2,
          ),
      ],
      alerts: [
        AlertItem(
          id: 'alert1',
          type: AlertType.save,
          title: 'Peluang menabung',
          detail: 'Saldo aman untuk autosave Rp150k',
          date: DateTime(2025, 10, 4),
        ),
      ],
      autoSaveEnabled: true,
      autoSavePlans: [
        AutosavePlan(
          date: DateTime(2025, 10, 5),
          amount: 150000,
        ),
      ],
    );

    final accountViews = [
      const AccountView(
        accountId: 'acc1',
        name: 'Gaji Bulanan',
        bankName: 'BCA',
        accountNumberMasked: '•••• 1098',
        balance: 1_000_000,
      ),
      const AccountView(
        accountId: 'acc2',
        name: 'Dana Darurat',
        bankName: 'Jenius',
        accountNumberMasked: '•••• 4456',
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

    expect(find.textContaining('Total Saldo'), findsOneWidget);
    expect(find.textContaining('3.500.000'), findsWidgets);

    expect(find.text('BCA'), findsWidgets);
    expect(find.text('•••• 1098'), findsWidgets);
    expect(find.textContaining('1.000.000'), findsWidgets);

    expect(find.text('Jenius'), findsWidgets);
    expect(find.text('•••• 4456'), findsWidgets);
    expect(find.textContaining('2.500.000'), findsWidgets);

    await tester.tap(find.widgetWithText(TextButton, 'Kelola Metadata Akun'));
    await tester.pumpAndSettle();

    expect(find.byType(AccountsMetaListPage), findsOneWidget);
  });
}
