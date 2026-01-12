import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/metas/datasources/accounts_meta_boxes.dart';
import '../data/metas/facade/accounts_read_facade.dart';
import '../data/metas/models/accounts_meta.dart';
import '../data/metas/repositories/accounts_meta_repo.dart';
import '../data/repositories/finance_repository_impl.dart';
import '../domain/entities/account.dart';
import '../domain/repositories/finance_repository.dart';

final accountsMetaRepositoryProvider = Provider<AccountsMetaRepository>((ref) {
  registerAccountsMetaAdapter();
  return AccountsMetaRepositoryImpl();
});

class AccountsBalanceSourceFromFinanceRepository implements AccountsBalanceSource {
  AccountsBalanceSourceFromFinanceRepository(this._repository);

  final FinanceRepository _repository;

  @override
  Future<List<AccountBalanceRecord>> getAccountsOnce() async {
    // Invalidate cache untuk mendapatkan data terbaru
    await _repository.refreshAccounts();
    final accounts = await _repository.getAccounts();
    return accounts.map(_mapAccount).toList();
  }

  @override
  Stream<List<AccountBalanceRecord>> watchAccounts() {
    // Stream dengan periodic refresh setiap 30 detik
    // Emit data pertama kali langsung, lalu refresh setiap 30 detik
    final controller = StreamController<List<AccountBalanceRecord>>.broadcast();
    Timer? timer;
    List<AccountBalanceRecord>? lastData;

    Future<void> fetchAndEmit() async {
      try {
        final data = await getAccountsOnce();
        // Hanya emit jika data berubah
        if (lastData == null ||
            lastData!.length != data.length ||
            !_isDataEqual(lastData!, data)) {
          lastData = data;
          controller.add(data);
        }
      } catch (e) {
        controller.addError(e);
      }
    }

    controller
      ..onListen = () {
        // Emit data pertama kali langsung
        fetchAndEmit();
        // Lalu refresh setiap 30 detik
        timer = Timer.periodic(
          const Duration(seconds: 30),
          (_) => fetchAndEmit(),
        );
      }
      ..onCancel = () {
        timer?.cancel();
        controller.close();
      };

    return controller.stream;
  }

  bool _isDataEqual(
    List<AccountBalanceRecord> prev,
    List<AccountBalanceRecord> next,
  ) {
    if (prev.length != next.length) return false;
    for (var i = 0; i < prev.length; i++) {
      if (prev[i].accountId != next[i].accountId ||
          prev[i].balance != next[i].balance) {
        return false;
      }
    }
    return true;
  }

  AccountBalanceRecord _mapAccount(Account account) {
    final balance = account.balance.round();
    return AccountBalanceRecord(
      accountId: account.id,
      balance: balance,
      bankName: account.bankName,
      accountNumberMasked: account.masked,
    );
  }
}

final accountsBalanceSourceProvider = Provider<AccountsBalanceSource>((ref) {
  final repo = ref.watch(financeRepositoryProvider);
  return AccountsBalanceSourceFromFinanceRepository(repo);
});

final accountsReadFacadeProvider = Provider<AccountsReadFacade>((ref) {
  final metaRepo = ref.watch(accountsMetaRepositoryProvider);
  final balanceSource = ref.watch(accountsBalanceSourceProvider);
  return AccountsReadFacadeImpl(
    metaRepository: metaRepo,
    balanceSource: balanceSource,
  );
});

final accountViewsProvider = StreamProvider<List<AccountView>>((ref) => ref.watch(accountsReadFacadeProvider).watchAccountViews());

final accountViewByIdProvider =
    FutureProvider.family<AccountView?, String>((ref, accountId) async {
  final views = await ref.watch(accountsReadFacadeProvider).getAccountViewsOnce();
  for (final view in views) {
    if (view.accountId == accountId) {
      return view;
    }
  }
  return null;
});

final accountMetaByIdProvider =
    StreamProvider.family<AccountsMeta?, String>((ref, accountId) => ref.watch(accountsMetaRepositoryProvider).watchByAccountId(accountId));
