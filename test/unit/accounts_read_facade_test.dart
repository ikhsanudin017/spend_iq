import 'dart:async';

import 'package:flutter_test/flutter_test.dart';

import 'package:smartspend_ai/data/metas/facade/accounts_read_facade.dart';
import 'package:smartspend_ai/data/metas/models/accounts_meta.dart';
import 'package:smartspend_ai/data/metas/repositories/accounts_meta_repo.dart';

class InMemoryAccountsMetaRepository implements AccountsMetaRepository {
  final _storage = <String, AccountsMeta>{};
  final _controller = StreamController<List<AccountsMeta>>.broadcast();

  void _emit() => _controller.add(_storage.values.toList());

  @override
  Future<AccountsMeta?> getByAccountId(String accountId) async => _storage[accountId];

  @override
  Future<void> upsert(AccountsMeta meta) async {
    _storage[meta.accountId] = meta;
    _emit();
  }

  @override
  Future<void> remove(String accountId) async {
    _storage.remove(accountId);
    _emit();
  }

  @override
  Stream<AccountsMeta?> watchByAccountId(String accountId) async* {
    yield _storage[accountId];
    yield* _controller.stream.map(
      (list) => list.firstWhere(
        (meta) => meta.accountId == accountId,
        orElse: () => AccountsMeta.empty(accountId: accountId),
      ),
    );
  }

  @override
  Stream<List<AccountsMeta>> watchAll() async* {
    yield _storage.values.toList();
    yield* _controller.stream;
  }
}

class StubAccountsBalanceSource implements AccountsBalanceSource {
  StubAccountsBalanceSource({
    required this.initialRecords,
  });

  final List<AccountBalanceRecord> initialRecords;

  @override
  Future<List<AccountBalanceRecord>> getAccountsOnce() async => initialRecords;

  @override
  Stream<List<AccountBalanceRecord>> watchAccounts() async* {
    yield initialRecords;
  }
}

void main() {
  test('AccountsReadFacade merges metadata with balance data', () async {
    final metaRepository = InMemoryAccountsMetaRepository();
    final balanceSource = StubAccountsBalanceSource(
      initialRecords: [
        AccountBalanceRecord(
          accountId: 'acc1',
          balance: 1_000_000,
          bankName: 'Existing Bank',
          accountNumberMasked: '•••• 1111',
        ),
        AccountBalanceRecord(
          accountId: 'acc2',
          balance: 2_500_000,
          bankName: 'Existing Bank 2',
          accountNumberMasked: '•••• 2222',
        ),
      ],
    );
    final facade = AccountsReadFacadeImpl(
      metaRepository: metaRepository,
      balanceSource: balanceSource,
    );

    await metaRepository.upsert(
      AccountsMeta.empty(accountId: 'acc1').copyWith(
        name: 'Gaji Bulanan',
        bankName: 'BCA',
        accountNumberMasked: '•••• 1098',
      ),
    );

    final views = await facade.getAccountViewsOnce();
    final acc1 = views.firstWhere((view) => view.accountId == 'acc1');
    final acc2 = views.firstWhere((view) => view.accountId == 'acc2');

    expect(acc1.name, 'Gaji Bulanan');
    expect(acc1.bankName, 'BCA');
    expect(acc1.accountNumberMasked, '•••• 1098');
    expect(acc1.balance, 1_000_000);

    expect(acc2.name, 'Akun');
    expect(acc2.bankName, 'Existing Bank 2');
    expect(acc2.accountNumberMasked, '•••• 2222');
    expect(acc2.balance, 2_500_000);
  });
}
