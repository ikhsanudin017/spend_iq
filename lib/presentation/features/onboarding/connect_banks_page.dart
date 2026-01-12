import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/colors.dart';
import '../../../core/router/app_router.dart';
import '../../../domain/repositories/finance_repository.dart';
import '../../../domain/usecases/get_dashboard_summary.dart';
import '../../../providers/accounts_home_providers.dart';
import 'package:smartspend_ai/data/repositories/finance_repository_impl.dart';

final availableBanksProvider = FutureProvider<List<String>>((ref) async {
  final repository = ref.watch(financeRepositoryProvider);
  return repository.getAvailableBanks();
});

class BankConnectionsController extends AsyncNotifier<List<String>> {
  late final FinanceRepository _repository;

  @override
  Future<List<String>> build() async {
    _repository = ref.read(financeRepositoryProvider);
    return _repository.getConnectedBanks();
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
    await _repository.saveBankConnections(current);
    
    // Invalidate cache untuk memastikan data baru di-fetch
    await _repository.refreshAccounts();
    
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

final bankConnectionsProvider =
    AsyncNotifierProvider<BankConnectionsController, List<String>>(
  BankConnectionsController.new,
);

class ConnectBanksPage extends ConsumerWidget {
  const ConnectBanksPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final availableBanks = ref.watch(availableBanksProvider);
    final connections = ref.watch(bankConnectionsProvider);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Hubungkan Bank'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            const SizedBox(height: 16),
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    theme.colorScheme.primary,
                    AppColors.primaryLight,
                  ],
                ),
                borderRadius: BorderRadius.circular(24),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x1A1E3A8A),
                    blurRadius: 28,
                    offset: Offset(0, 18),
                  ),
                ],
              ),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 22),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Sinkronkan rekening untuk insight menyeluruh.',
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Wrap(
                    spacing: 12,
                    runSpacing: 8,
                    children: [
                      _HeroChip(
                        icon: Icons.lock_rounded,
                        label: 'Keamanan berlapis',
                      ),
                      _HeroChip(
                        icon: Icons.auto_graph_rounded,
                        label: 'Analitik real-time',
                      ),
                      _HeroChip(
                        icon: Icons.insights_rounded,
                        label: 'Prediksi personal',
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Expanded(
              child: availableBanks.when(
                data: (banks) => connections.when(
                  data: (selected) => ListView.separated(
                    itemCount: banks.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      final bank = banks[index];
                      final isSelected = selected.contains(bank);
                      return _BankSelectorTile(
                        label: bank,
                        isSelected: isSelected,
                        onTap: () => ref
                            .read(bankConnectionsProvider.notifier)
                            .toggleBank(bank),
                      );
                    },
                  ),
                  loading: () =>
                      const Center(child: CircularProgressIndicator()),
                  error: (error, _) => Center(
                    child: Text('Gagal memuat bank: $error'),
                  ),
                ),
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (error, _) => Center(
                  child: Text('Tidak dapat memuat bank: $error'),
                ),
              ),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: AppColors.surfaceAlt,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: [
                  Icon(Icons.shield_moon_rounded,
                      size: 18, color: theme.colorScheme.primary),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Dengan melanjutkan Anda menyetujui ketentuan penggunaan dan kebijakan privasi Spend-IQ.',
                      style: theme.textTheme.bodySmall,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: connections.maybeWhen(
                  data: (selected) => selected.isNotEmpty
                      ? () => context.go(AppRoute.permissions.path)
                      : null,
                  orElse: () => null,
                ),
                child: const Text('Lanjutkan'),
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}

class _BankSelectorTile extends ConsumerWidget {
  const _BankSelectorTile({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  // Base balance untuk preview (akan divariasi)
  static const Map<String, int> _previewBalances = {
    'Mandiri': 8500000,
    'BCA': 6200000,
    'BRI': 4800000,
    'Jenius': 3500000,
  };

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    
    // Generate preview balance dinamis
    final baseBalance = _previewBalances[label] ?? 5000000;
    final now = DateTime.now();
    final hourSeed = now.year * 1000000 + now.month * 10000 + now.day * 100 + now.hour;
    final random = Random(hourSeed);
    final variation = (random.nextDouble() * 0.5 - 0.25);
    final previewBalance = ((baseBalance * (1 + variation) / 1000).round() * 1000);
    
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeInOut,
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
      decoration: BoxDecoration(
        color: isSelected
            ? theme.colorScheme.primary.withAlpha(20)
            : theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isSelected ? theme.colorScheme.primary : AppColors.surfaceAlt,
          width: 1.3,
        ),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: theme.colorScheme.primary.withAlpha(40),
              foregroundColor: theme.colorScheme.primary,
              child: Text(
                label.characters.first.toUpperCase(),
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    isSelected 
                        ? 'Saldo: ${_formatCurrency(previewBalance)}'
                        : 'Koneksi aman & terenkripsi',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: isSelected
                          ? theme.colorScheme.primary
                          : theme.colorScheme.onSurfaceVariant,
                      fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                    ),
                  ),
                ],
              ),
            ),
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                color:
                    isSelected ? theme.colorScheme.primary : Colors.transparent,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: isSelected
                      ? theme.colorScheme.primary
                      : AppColors.surfaceAlt,
                ),
              ),
              child: isSelected
                  ? const Icon(Icons.check, size: 16, color: Colors.white)
                  : null,
            ),
          ],
        ),
      ),
    );
  }

  String _formatCurrency(int amount) {
    if (amount >= 1000000) {
      return 'Rp${(amount / 1000000).toStringAsFixed(1)} jt';
    } else if (amount >= 1000) {
      return 'Rp${(amount / 1000).toStringAsFixed(0)} rb';
    }
    return 'Rp${amount.toString()}';
  }
}

class _HeroChip extends StatelessWidget {
  const _HeroChip({
    required this.icon,
    required this.label,
  });

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) => Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white.withAlpha(40),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 18, color: Colors.white),
          const SizedBox(width: 8),
          Text(
            label,
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
                  color: Colors.white,
                ),
          ),
        ],
      ),
    );
}

