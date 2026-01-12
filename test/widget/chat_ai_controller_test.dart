import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:smartspend_ai/domain/entities/account.dart';
import 'package:smartspend_ai/domain/entities/transaction.dart';
import 'package:smartspend_ai/presentation/features/chat/chat_ai_controller.dart';
import 'package:smartspend_ai/providers/predictive_providers.dart';

void main() {
  test('ChatAiController replies based on safety simulation', () async {
    final now = DateTime.now();
    final transactions = List.generate(
      10,
      (i) => Transaction(
        id: 't$i',
        accountId: 'a1',
        amount: (100000 + (i * 10000)).toDouble(),
        category: 'Food',
        merchant: 'M$i',
        date: now.subtract(Duration(days: i + 1)),
      ),
    );

    final highBalanceContainer = ProviderContainer(
      overrides: [
        accountsStreamProvider.overrideWith(
          (ref) => Stream.value(const [
            Account(
              id: 'a1',
              bankName: 'BCA',
              masked: '**** 0000',
              balance: 5_000_000,
            ),
          ]),
        ),
        transactionsStreamProvider.overrideWith(
          (ref) => Stream.value(transactions),
        ),
      ],
    );

    final aiHigh = highBalanceContainer.read(chatAiControllerProvider);
    final ok = await aiHigh.reply('Aman menabung Rp300k besok?');
    expect(ok.toLowerCase().contains('aman'), true);
    highBalanceContainer.dispose();

    final lowBalanceContainer = ProviderContainer(
      overrides: [
        accountsStreamProvider.overrideWith(
          (ref) => Stream.value(const [
            Account(
              id: 'a1',
              bankName: 'BCA',
              masked: '**** 0000',
              balance: 200_000,
            ),
          ]),
        ),
        transactionsStreamProvider.overrideWith(
          (ref) => Stream.value(transactions),
        ),
      ],
    );

    final aiLow = lowBalanceContainer.read(chatAiControllerProvider);
    final notOk = await aiLow.reply('Aman nabung 300000 besok?');
    expect(notOk.toLowerCase().contains('tidak disarankan'), true);
    lowBalanceContainer.dispose();
  });
}


















