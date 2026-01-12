import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:smartspend_ai/data/metas/facade/accounts_read_facade.dart';
import 'package:smartspend_ai/data/metas/models/accounts_meta.dart';
import 'package:smartspend_ai/data/metas/repositories/accounts_meta_repo.dart';
import 'package:smartspend_ai/presentation/features/accounts_meta/edit_account_metadata_page.dart';
import 'package:smartspend_ai/providers/accounts_meta_providers.dart';

class RecordingAccountsMetaRepository implements AccountsMetaRepository {
  final Map<String, AccountsMeta> store = {};
  final _controller = StreamController<List<AccountsMeta>>.broadcast();

  AccountsMeta? lastUpsert;
  String? lastRemoved;

  void _emit() {
    if (!_controller.isClosed) {
      _controller.add(store.values.toList());
    }
  }

  @override
  Future<AccountsMeta?> getByAccountId(String accountId) async => store[accountId];

  @override
  Future<void> upsert(AccountsMeta meta) async {
    store[meta.accountId] = meta;
    lastUpsert = meta;
    _emit();
  }

  @override
  Future<void> remove(String accountId) async {
    store.remove(accountId);
    lastRemoved = accountId;
    _emit();
  }

  @override
  Stream<AccountsMeta?> watchByAccountId(String accountId) async* {
    yield store[accountId];
    yield* _controller.stream.map((list) {
      for (final meta in list) {
        if (meta.accountId == accountId) {
          return meta;
        }
      }
      return null;
    });
  }

  @override
  Stream<List<AccountsMeta>> watchAll() async* {
    yield store.values.toList();
    yield* _controller.stream;
  }
}

class StubFacade implements AccountsReadFacade {
  StubFacade(this.views);

  final List<AccountView> views;

  @override
  Future<List<AccountView>> getAccountViewsOnce() async => views;

  @override
  Stream<List<AccountView>> watchAccountViews() => Stream.value(views);
}

void main() {
  testWidgets('Create metadata form saves values', (tester) async {
    final repo = RecordingAccountsMetaRepository();
    const views = [
      AccountView(
        accountId: 'acc1',
        name: 'Akun',
        bankName: 'Custom',
        accountNumberMasked: '•••• 0000',
        balance: 500000,
      ),
      AccountView(
        accountId: 'acc2',
        name: 'Akun',
        bankName: 'Custom',
        accountNumberMasked: '•••• 0000',
        balance: 250000,
      ),
    ];

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          accountsMetaRepositoryProvider.overrideWithValue(repo),
          accountsReadFacadeProvider.overrideWithValue(StubFacade(views)),
          accountViewsProvider.overrideWith((ref) => Stream.value(views)),
        ],
        child: const MaterialApp(
          home: EditAccountMetadataPage(),
        ),
      ),
    );

    await tester.pumpAndSettle();

    await tester.tap(find.byType(DropdownButtonFormField<String>).first);
    await tester.pumpAndSettle();
    await tester.tap(find.textContaining('acc2').last);
    await tester.pumpAndSettle();

    await tester.enterText(
      find.widgetWithText(TextFormField, 'Nama Akun'),
      'Dompet Harian',
    );

    await tester.tap(find.byType(DropdownButtonFormField<String>).at(1));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Mandiri').last);
    await tester.pumpAndSettle();

    await tester.enterText(
      find.widgetWithText(TextFormField, 'Nomor Rekening (Masked)'),
      '•••• 2231',
    );

    await tester.tap(find.text('Simpan'));
    await tester.pumpAndSettle();

    expect(repo.lastUpsert, isNotNull);
    expect(repo.lastUpsert?.accountId, 'acc2');
    expect(repo.lastUpsert?.name, 'Dompet Harian');
    expect(repo.lastUpsert?.bankName, 'Mandiri');
    expect(repo.lastUpsert?.accountNumberMasked, '•••• 2231');
  });

  testWidgets('Edit metadata can remove entry', (tester) async {
    final repo = RecordingAccountsMetaRepository()
      ..store['acc1'] = AccountsMeta(
        accountId: 'acc1',
        name: 'Gaji Bulanan',
        bankName: 'BCA',
        accountNumberMasked: '•••• 1098',
        updatedAt: DateTime.now(),
      );
    const views = [
      AccountView(
        accountId: 'acc1',
        name: 'Gaji Bulanan',
        bankName: 'BCA',
        accountNumberMasked: '•••• 1098',
        balance: 1_000_000,
      ),
    ];

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          accountsMetaRepositoryProvider.overrideWithValue(repo),
          accountsReadFacadeProvider.overrideWithValue(StubFacade(views)),
          accountViewsProvider.overrideWith((ref) => Stream.value(views)),
        ],
        child: const MaterialApp(
          home: EditAccountMetadataPage(accountId: 'acc1'),
        ),
      ),
    );

    await tester.pumpAndSettle();

    await tester.tap(find.text('Hapus Metadata'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Hapus'));
    await tester.pumpAndSettle();

    expect(repo.lastRemoved, 'acc1');
  });
}
