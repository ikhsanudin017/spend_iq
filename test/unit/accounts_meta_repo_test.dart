import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';

import 'package:smartspend_ai/data/metas/datasources/accounts_meta_boxes.dart';
import 'package:smartspend_ai/data/metas/models/accounts_meta.dart';
import 'package:smartspend_ai/data/metas/repositories/accounts_meta_repo.dart';

void main() {
  late Directory tempDir;
  late AccountsMetaRepository repository;

  setUp(() async {
    tempDir = await Directory.systemTemp.createTemp();
    Hive.init(tempDir.path);
    registerAccountsMetaAdapter();
    await openAccountsMetaBox();
    repository = AccountsMetaRepositoryImpl();
  });

  tearDown(() async {
    if (Hive.isBoxOpen('accounts_meta_box_v1')) {
      await Hive.box<AccountsMeta>('accounts_meta_box_v1').close();
    }
    await Hive.deleteFromDisk();
    await tempDir.delete(recursive: true);
  });

  test('upsert and getByAccountId returns stored metadata', () async {
    final meta = AccountsMeta.empty(accountId: 'acc1').copyWith(
      name: 'Gaji Bulanan',
      bankName: 'BCA',
      accountNumberMasked: '•••• 1098',
    );

    await repository.upsert(meta);
    final stored = await repository.getByAccountId('acc1');
    expect(stored, isNotNull);
    expect(stored!.name, 'Gaji Bulanan');
  });

  test('watchAll emits changes', () async {
    final emissions = <List<AccountsMeta>>[];
    final sub = repository.watchAll().listen(emissions.add);

    final metaOne = AccountsMeta.empty(accountId: 'acc1');
    await repository.upsert(metaOne);
    final metaTwo = AccountsMeta.empty(accountId: 'acc2');
    await repository.upsert(metaTwo);

    await Future<void>.delayed(const Duration(milliseconds: 10));
    await sub.cancel();

    // Should have initial emission plus updates.
    expect(emissions.length, greaterThanOrEqualTo(3));
    final last = emissions.last;
    expect(last.map((m) => m.accountId), containsAll(['acc1', 'acc2']));
  });

  test('remove deletes metadata', () async {
    final meta = AccountsMeta.empty(accountId: 'acc1');
    await repository.upsert(meta);
    await repository.remove('acc1');

    final stored = await repository.getByAccountId('acc1');
    expect(stored, isNull);
  });
}
