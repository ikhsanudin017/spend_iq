// ignore_for_file: avoid_redundant_argument_values

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:integration_test/integration_test.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'package:smartspend_ai/app.dart';
import 'package:smartspend_ai/core/config/app_config.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() async {
    await initializeDateFormatting('id_ID');
    await AppBootstrapper.initialize();
  });

  testWidgets(
    'Onboarding to autosave confirmation flow',
    (tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: SmartSpendApp(),
        ),
      );

      await tester.pumpAndSettle();

      // Permissions page
      expect(find.text('Izin Notifikasi'), findsOneWidget);

      final toggle = find.byType(Switch);
      if (toggle.evaluate().isNotEmpty) {
        await tester.tap(toggle);
        await tester.pumpAndSettle();
      }

      await tester.tap(find.text('Mulai SmartSpend AI'));
      await tester.pumpAndSettle();

      // Home page loaded
      expect(find.textContaining('Smart Alerts'), findsWidgets);

      // Navigate to Autosave tab
      await tester.tap(find.text('Save'));
      await tester.pumpAndSettle();

      expect(find.text('Auto-Saving Adaptif'), findsOneWidget);

      // Confirm autosave plan
      final startButton = find.text('Mulai Autosave');
      await tester.ensureVisible(startButton);
      await tester.tap(startButton);
      await tester.pumpAndSettle();

      // Snackbar confirmation
      expect(find.byType(SnackBar), findsOneWidget);
    },
    semanticsEnabled: true,
  );
}
