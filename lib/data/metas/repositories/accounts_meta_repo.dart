import 'dart:async';

import '../datasources/accounts_meta_boxes.dart';
import '../models/accounts_meta.dart';

abstract class AccountsMetaRepository {
  Future<AccountsMeta?> getByAccountId(String accountId);
  Future<void> upsert(AccountsMeta meta);
  Future<void> remove(String accountId);
  Stream<AccountsMeta?> watchByAccountId(String accountId);
  Stream<List<AccountsMeta>> watchAll();
}

class AccountsMetaRepositoryImpl implements AccountsMetaRepository {
  AccountsMetaRepositoryImpl();

  @override
  Future<AccountsMeta?> getByAccountId(String accountId) async {
    await _ensureBoxReady();
    return getMeta(accountId);
  }

  @override
  Future<void> upsert(AccountsMeta meta) async {
    await _ensureBoxReady();
    await putMeta(meta);
  }

  @override
  Future<void> remove(String accountId) async {
    await _ensureBoxReady();
    await deleteMeta(accountId);
  }

  @override
  Stream<AccountsMeta?> watchByAccountId(String accountId) async* {
    await _ensureBoxReady();
    yield getMeta(accountId);
    yield* watchAllMeta().map(
      (metas) => _findMeta(metas, accountId),
    );
  }

  @override
  Stream<List<AccountsMeta>> watchAll() async* {
    await _ensureBoxReady();
    yield List<AccountsMeta>.from(accountsMetaBox.values);
    yield* watchAllMeta();
  }

  Future<void> _ensureBoxReady() async {
    if (!isAccountsMetaBoxOpen()) {
      await openAccountsMetaBox();
    }
  }

  AccountsMeta? _findMeta(List<AccountsMeta> metas, String accountId) {
    for (final meta in metas) {
      if (meta.accountId == accountId) {
        return meta;
      }
    }
    return null;
  }
}
