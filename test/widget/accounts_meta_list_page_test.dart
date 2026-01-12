import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:smartspend_ai/data/metas/facade/accounts_read_facade.dart';
import 'package:smartspend_ai/data/metas/models/accounts_meta.dart';
import 'package:smartspend_ai/data/metas/repositories/accounts_meta_repo.dart';
import 'package:smartspend_ai/presentation/features/accounts_meta/accounts_meta_list_page.dart';
import 'package:smartspend_ai/presentation/features/accounts_meta/edit_account_metadata_page.dart';
import 'package:smartspend_ai/providers/accounts_meta_providers.dart';

class FakeAccountsMetaRepository implements AccountsMetaRepository {
  final Map<String, AccountsMeta> _store = {};
  final StreamController<List<AccountsMeta>> _controller =
      StreamController<List<AccountsMeta>>.broadcast();

  String? removedId;

  void _emit() {
    if (!_controller.isClosed) {
      _controller.add(_store.values.toList());
    }
  }

  @override
  Future<AccountsMeta?> getByAccountId(String accountId) async =>
      _store[accountId];

  @override
  Future<void> upsert(AccountsMeta meta) async {
    _store[meta.accountId] = meta;
    _emit();
  }

  @override
  Future<void> remove(String accountId) async {
    removedId = accountId;
    _store.remove(accountId);
    _emit();
  }

  @override
  Stream<AccountsMeta?> watchByAccountId(String accountId) async* {
    yield _store[accountId];
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
    yield _store.values.toList();
    yield* _controller.stream;
  }
}

class StubAccountsReadFacade implements AccountsReadFacade {
  StubAccountsReadFacade(this._views);

  final List<AccountView> _views;

  @override
  Future<List<AccountView>> getAccountViewsOnce() async => _views;

  @override
  Stream<List<AccountView>> watchAccountViews() => Stream.value(_views);
}

void main() {
  testWidgets('AccountsMetaListPage menampilkan metadata & fallback',
      (tester) async {
    final metaRepo = FakeAccountsMetaRepository();
    final views = [
      const AccountView(
        accountId: 'acc1',
        name: 'Gaji Bulanan',
        bankName: 'BCA',
        accountNumberMasked: '**** 1098',
        balance: 1_000_000,
      ),
      const AccountView(
        accountId: 'acc2',
        name: 'Akun',
        bankName: 'Custom',
        accountNumberMasked: '**** 0000',
        balance: 2_500_000,
      ),
    ];

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          accountsMetaRepositoryProvider.overrideWithValue(metaRepo),
          accountsReadFacadeProvider.overrideWithValue(
            StubAccountsReadFacade(views),
          ),
          accountViewsProvider.overrideWith(
            (ref) => Stream.value(views),
          ),
        ],
        child: const MaterialApp(
          home: AccountsMetaListPage(),
        ),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text('Gaji Bulanan'), findsOneWidget);
    expect(find.text('BCA'), findsOneWidget);
    expect(find.text('**** 1098'), findsOneWidget);
    expect(find.textContaining('1.000.000'), findsOneWidget);

    expect(find.text('Akun'), findsWidgets);
    expect(find.text('Custom'), findsWidgets);
    expect(find.text('**** 0000'), findsWidgets);
    expect(find.textContaining('2.500.000'), findsOneWidget);

    await tester.tap(find.byIcon(Icons.more_vert).last);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Ubah Metadata'));
    await tester.pumpAndSettle();

    expect(find.byType(EditAccountMetadataPage), findsOneWidget);
    expect(find.text('Nama Akun'), findsWidgets);
  });
}
