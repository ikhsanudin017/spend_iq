import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:smartspend_ai/app.dart';

void main() {
  testWidgets('SmartSpendApp renders splash', (tester) async {
    await tester.pumpWidget(const ProviderScope(child: SmartSpendApp()));
    await tester.pump(const Duration(milliseconds: 100));

    expect(find.text('SmartSpend AI'), findsOneWidget);
  });
}
