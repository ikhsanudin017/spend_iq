import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../data/repositories/finance_repository_impl.dart';
import '../domain/repositories/finance_repository.dart';
import 'accounts_home_providers.dart';
import 'package:smartspend_ai/domain/usecases/get_dashboard_summary.dart';

class ProfileController extends AsyncNotifier<String> {
  static const _kNameKey = 'profile_name';

  @override
  Future<String> build() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_kNameKey) ?? 'Spend-IQ';
  }

  Future<void> setName(String name) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_kNameKey, name.trim());
    state = AsyncData(name.trim());
  }
}

final profileControllerProvider =
    AsyncNotifierProvider<ProfileController, String>(ProfileController.new);

final availableBanksForProfileProvider = FutureProvider<List<String>>((ref) async {
  final repo = ref.watch(financeRepositoryProvider);
  return repo.getAvailableBanks();
});

class BankConnectionsForProfileController extends AsyncNotifier<List<String>> {
  late final FinanceRepository _repo;

  @override
  Future<List<String>> build() async {
    _repo = ref.read(financeRepositoryProvider);
    return _repo.getConnectedBanks();
  }

  Future<void> toggleBank(String bank) async {
    final current = List<String>.from(state.valueOrNull ?? await future);
    final wasSelected = current.contains(bank);
    
    if (wasSelected) {
      current.remove(bank);
    } else {
      current.add(bank);
    }
    
    // Save bank connections terlebih dahulu
    await _repo.saveBankConnections(current);
    
    // Invalidate cache untuk memastikan data baru di-fetch
    await _repo.refreshAccounts();
    
    // Update state
    state = AsyncData(current);
    
    // Invalidate semua provider yang terkait dengan accounts
    // Agar dashboard langsung update setelah connect/disconnect bank
    // Tunggu sedikit agar state sudah ter-update
    await Future<void>.delayed(const Duration(milliseconds: 100));
    ref
      ..invalidate(accountViewsProvider)
      ..invalidate(totalBalanceProvider)
      ..invalidate(getDashboardSummaryProvider);
  }
}

final bankConnectionsForProfileProvider = AsyncNotifierProvider<
    BankConnectionsForProfileController, List<String>>(
  BankConnectionsForProfileController.new,
);

