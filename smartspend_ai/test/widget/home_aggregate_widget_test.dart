import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:smartspend_ai/data/metas/facade/accounts_read_facade.dart';
import 'package:smartspend_ai/domain/entities/account.dart' as d;
import 'package:smartspend_ai/domain/entities/alert_item.dart' as d;
import 'package:smartspend_ai/domain/entities/autosave_plan.dart' as d;
import 'package:smartspend_ai/domain/entities/financial_health.dart' as d;
import 'package:smartspend_ai/domain/entities/forecast_point.dart' as d;
import 'package:smartspend_ai/domain/usecases/get_dashboard_summary.dart';
import 'package:smartspend_ai/presentation/features/accounts_meta/accounts_meta_list_page.dart';
import 'package:smartspend_ai/presentation/features/home/home_page.dart';
import 'package:smartspend_ai/providers/accounts_home_providers.dart' as home;
import 'package:smartspend_ai/providers/accounts_meta_providers.dart';

class StubFacade implements AccountsReadFacade {
  StubFacade(this.views);
  final List<AccountView> views;

  @override
  Future<List<AccountView>> getAccountViewsOnce() async => views;

  @override
  Stream<List<AccountView>> watchAccountViews() => Stream.value(views);
}

void main() {
  testWidgets('Home shows aggregate balance and account summaries', (tester) async {
    final facade = StubFacade(const [
      AccountView(
        accountId: 'acc1',
        name: 'Gaji Bulanan',
        bankName: 'BCA',
        accountNumberMasked: '•••• 1098',
        balance: 1_000_000,
      ),
      AccountView(
        accountId: 'acc2',
        name: 'Dana Darurat',
        bankName: 'Jenius',
        accountNumberMasked: '•••• 4456',
        balance: 2_500_000,
      ),
    ]);

    const summary = DashboardSummary(
      accounts: [
        d.Account(id: 'acc1', bankName: 'BCA', masked: '•••• 1098', balance: 0),
      ],
      aggregateBalance: 0,
      health: d.FinancialHealth(score: 80, label: d.FinancialHealthLabel.healthy),
      forecast: <d.ForecastPoint>[],
      alerts: <d.AlertItem>[],
      autoSaveEnabled: true,
      autoSavePlans: <d.AutosavePlan>[],
    );

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          accountsReadFacadeProvider.overrideWithValue(facade),
          home.accountViewsProvider.overrideWith((ref) => Stream.value(facade.views)),
          getDashboardSummaryProvider.overrideWith((ref) => Future.value(summary)),
        ],
        child: const MaterialApp(home: HomePage()),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text('Saldo Agregat'), findsOneWidget);
    expect(find.text('Rp 3.500.000'), findsOneWidget);

    expect(find.text('Gaji Bulanan'), findsOneWidget);
    expect(find.text('BCA'), findsOneWidget);
    expect(find.text('•••• 1098'), findsOneWidget);
    expect(find.text('Rp 1.000.000'), findsOneWidget);

    expect(find.text('Dana Darurat'), findsOneWidget);
    expect(find.text('Jenius'), findsOneWidget);
    expect(find.text('•••• 4456'), findsOneWidget);
    expect(find.text('Rp 2.500.000'), findsOneWidget);

    await tester.tap(find.text('Kelola Metadata Akun'));
    await tester.pumpAndSettle();
    expect(find.byType(AccountsMetaListPage), findsOneWidget);
    expect(find.text('Akun & Metadata'), findsOneWidget);
  });
}

