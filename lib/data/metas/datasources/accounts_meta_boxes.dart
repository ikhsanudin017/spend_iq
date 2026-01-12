import 'dart:async';

import 'package:hive/hive.dart';

import '../models/accounts_meta.dart';
import '../models/accounts_meta_adapter.dart';

const String _accountsMetaBoxName = 'accounts_meta_box_v1';

void registerAccountsMetaAdapter() {
  if (!Hive.isAdapterRegistered(41)) {
    Hive.registerAdapter(AccountsMetaAdapter());
  }
}

Future<void> openAccountsMetaBox() async {
  if (Hive.isBoxOpen(_accountsMetaBoxName)) {
    return;
  }
  await Hive.openBox<AccountsMeta>(_accountsMetaBoxName);
}

bool isAccountsMetaBoxOpen() => Hive.isBoxOpen(_accountsMetaBoxName);

Box<AccountsMeta> get accountsMetaBox => Hive.box<AccountsMeta>(_accountsMetaBoxName);

AccountsMeta? getMeta(String accountId) => accountsMetaBox.get(accountId);

Future<void> putMeta(AccountsMeta meta) => accountsMetaBox.put(meta.accountId, meta);

Future<void> deleteMeta(String accountId) => accountsMetaBox.delete(accountId);

Stream<List<AccountsMeta>> watchAllMeta() {
  Future<void> ensureOpen() async {
    if (!Hive.isBoxOpen(_accountsMetaBoxName)) {
      await openAccountsMetaBox();
    }
  }

  return Stream<List<AccountsMeta>>.multi((controller) async {
    await ensureOpen();
    controller.add(List<AccountsMeta>.from(accountsMetaBox.values));
    final subscription = accountsMetaBox.watch().listen(
      (_) => controller.add(List<AccountsMeta>.from(accountsMetaBox.values)),
      onError: controller.addError,
    );
    controller.onCancel = subscription.cancel;
  });
}
