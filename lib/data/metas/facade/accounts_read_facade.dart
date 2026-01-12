import 'dart:async';

import '../../../core/utils/mappers/meta_mappers.dart';
import '../models/accounts_meta.dart';
import '../repositories/accounts_meta_repo.dart';

class AccountBalanceRecord {
  AccountBalanceRecord({
    required this.accountId,
    required this.balance,
    String? bankName,
    String? accountNumberMasked,
  })  : bankName = bankName ?? kDefaultBankName,
        accountNumberMasked = accountNumberMasked ?? kDefaultMaskedNumber;

  final String accountId;
  final int balance;
  final String bankName;
  final String accountNumberMasked;
}

abstract class AccountsBalanceSource {
  Stream<List<AccountBalanceRecord>> watchAccounts();
  Future<List<AccountBalanceRecord>> getAccountsOnce();
}

class AccountView {
  const AccountView({
    required this.accountId,
    required this.name,
    required this.bankName,
    required this.accountNumberMasked,
    required this.balance,
  });

  final String accountId;
  final String name;
  final String bankName;
  final String accountNumberMasked;
  final int balance;
}

abstract class AccountsReadFacade {
  Stream<List<AccountView>> watchAccountViews();
  Future<List<AccountView>> getAccountViewsOnce();
}

class AccountsReadFacadeImpl implements AccountsReadFacade {
  AccountsReadFacadeImpl({
    required AccountsMetaRepository metaRepository,
    required AccountsBalanceSource balanceSource,
  })  : _metaRepository = metaRepository,
        _balanceSource = balanceSource;

  final AccountsMetaRepository _metaRepository;
  final AccountsBalanceSource _balanceSource;

  @override
  Stream<List<AccountView>> watchAccountViews() {
    final controller = StreamController<List<AccountView>>.broadcast();
    var latestRecords = <AccountBalanceRecord>[];
    var latestMeta = <AccountsMeta>[];

    void emit() {
      controller.add(_buildViews(latestRecords, latestMeta));
    }

    late final StreamSubscription<List<AccountBalanceRecord>> recordsSub;
    late final StreamSubscription<List<AccountsMeta>> metaSub;

    controller
      ..onListen = () {
        recordsSub = _balanceSource.watchAccounts().listen(
          (records) {
            latestRecords = records;
            emit();
          },
          onError: controller.addError,
        );
        metaSub = _metaRepository.watchAll().listen(
          (metas) {
            latestMeta = metas;
            emit();
          },
          onError: controller.addError,
        );
      }
      ..onCancel = () async {
        await recordsSub.cancel();
        await metaSub.cancel();
        await controller.close();
      };

    return controller.stream;
  }

  @override
  Future<List<AccountView>> getAccountViewsOnce() async {
    final records = await _balanceSource.getAccountsOnce();
    final metaList = await _metaRepository.watchAll().first;
    return _buildViews(records, metaList);
  }

  List<AccountView> _buildViews(
    List<AccountBalanceRecord> records,
    List<AccountsMeta> metas,
  ) {
    final byId = {for (final meta in metas) meta.accountId: meta};
    return records.map((record) {
      final resolved = resolveMeta(
        byId[record.accountId],
        accountId: record.accountId,
      );
      final meta = resolved.meta;
      final hasCustom = resolved.hasCustom;

      final name = hasCustom && meta.name.isNotEmpty
          ? meta.name
          : kDefaultAccountName;
      final bankName = hasCustom && meta.bankName.isNotEmpty
          ? meta.bankName
          : (record.bankName.isNotEmpty ? record.bankName : kDefaultBankName);
      final masked = hasCustom && meta.accountNumberMasked.isNotEmpty
          ? meta.accountNumberMasked
          : (record.accountNumberMasked.isNotEmpty
              ? record.accountNumberMasked
              : kDefaultMaskedNumber);

      return AccountView(
        accountId: record.accountId,
        name: name,
        bankName: bankName,
        accountNumberMasked: masked,
        balance: record.balance,
      );
    }).toList();
  }
}




