import 'package:flutter_test/flutter_test.dart';

import 'package:smartspend_ai/data/metas/models/accounts_meta.dart';

void main() {
  group('AccountsMeta model', () {
    test('toJson/fromJson round trip', () {
      final meta = AccountsMeta(
        accountId: 'acc1',
        name: 'Gaji Bulanan',
        bankName: 'BCA',
        accountNumberMasked: '•••• 1098',
        updatedAt: DateTime.utc(2025, 10),
      );

      final json = meta.toJson();
      final result = AccountsMeta.fromJson(json);
      expect(result, equals(meta));
    });

    test('copyWith updates selected fields', () {
      final meta = AccountsMeta(
        accountId: 'acc1',
        name: 'Gaji Bulanan',
        bankName: 'BCA',
        accountNumberMasked: '•••• 1098',
        updatedAt: DateTime.utc(2025, 10),
      );

      final updated = meta.copyWith(
        name: 'Dana Darurat',
        bankName: 'Mandiri',
        accountNumberMasked: '•••• 2211',
      );

      expect(updated.name, 'Dana Darurat');
      expect(updated.bankName, 'Mandiri');
      expect(updated.accountNumberMasked, '•••• 2211');
      expect(updated.accountId, meta.accountId);
    });

    test('empty factory provides defaults', () {
      final meta = AccountsMeta.empty(accountId: 'acc2');
      expect(meta.accountId, 'acc2');
      expect(meta.name, 'Akun');
      expect(meta.bankName, 'Custom');
      expect(meta.accountNumberMasked, '•••• 0000');
    });
  });
}
