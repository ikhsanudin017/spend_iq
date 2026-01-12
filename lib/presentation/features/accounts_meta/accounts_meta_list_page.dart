import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/utils/currency.dart';
import '../../../core/utils/haptic_feedback.dart';
import '../../../providers/accounts_meta_providers.dart';
import '../../widgets/empty_state.dart';
import '../../widgets/error_state.dart';
import '../../widgets/skeleton_loader.dart';
import '../../widgets/meta_account_tile.dart';
import 'edit_account_metadata_page.dart';
import '../../../data/metas/facade/accounts_read_facade.dart';

class AccountsMetaListPage extends ConsumerWidget {
  const AccountsMetaListPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final accountViewsAsync = ref.watch(accountViewsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Akun & Metadata'),
      ),
      body: accountViewsAsync.when(
        data: (views) {
          if (views.isEmpty) {
            return EmptyState(
              icon: Icons.account_balance_wallet_outlined,
              title: 'Belum ada akun',
              subtitle: 'Tambahkan metadata akun untuk menampilkan nama, bank, dan nomor rekening ter-mask.',
              actionLabel: 'Tambah Metadata',
              onAction: () {
                HapticUtils.selectionClick();
                _handleCreateMetadata(context, ref);
              },
            );
          }
          return ListView.builder(
            padding: const EdgeInsets.only(top: 16, bottom: 96),
            itemCount: views.length,
            itemBuilder: (context, index) {
              final view = views[index];
              final balanceText = CurrencyUtils.format(view.balance);
              return MetaAccountTile(
                name: view.name,
                bankName: view.bankName,
                maskedNumber: view.accountNumberMasked,
                balanceText: balanceText,
                onEdit: () {
                  HapticUtils.selectionClick();
                  _openEditPage(context, view.accountId);
                },
                onDelete: () {
                  HapticUtils.mediumImpact();
                  _confirmDeleteMeta(context, ref, view.accountId);
                },
              );
            },
          );
        },
        loading: () => ListView(
          padding: const EdgeInsets.all(16),
          children: [
            for (int i = 0; i < 5; i++) ...[
              const SkeletonListTile(),
              const SizedBox(height: 8),
            ],
          ],
        ),
        error: (error, _) => ErrorState(
          message: 'Tidak dapat memuat metadata akun. Silakan coba lagi.',
          onRetry: () => ref.invalidate(accountViewsProvider),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _handleCreateMetadata(context, ref),
        icon: const Icon(Icons.add_rounded),
        label: const Text('Tambah Metadata'),
      ),
    );
  }

  Future<void> _handleCreateMetadata(BuildContext context, WidgetRef ref) async {
    final facade = ref.read(accountsReadFacadeProvider);
    final metaRepo = ref.read(accountsMetaRepositoryProvider);
    final accounts = await facade.getAccountViewsOnce();
    final available = <AccountView>[];
    for (final account in accounts) {
      final existing = await metaRepo.getByAccountId(account.accountId);
      if (existing == null) {
        available.add(account);
      }
    }

    if (available.isEmpty) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Semua akun sudah memiliki metadata.')),
        );
      }
      return;
    }

    if (!context.mounted) return;
    final selectedId = await showDialog<String>(
      context: context,
      builder: (context) => SimpleDialog(
        title: const Text('Pilih Akun'),
        children: [
          for (final account in available)
            SimpleDialogOption(
              onPressed: () => Navigator.of(context).pop(account.accountId),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    account.accountId,
                    style: Theme.of(context).textTheme.labelMedium,
                  ),
                  Text(
                    CurrencyUtils.format(account.balance),
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
            ),
        ],
      ),
    );

    if (selectedId != null && context.mounted) {
      _openEditPage(context, selectedId);
    }
  }

  void _openEditPage(BuildContext context, String accountId) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => EditAccountMetadataPage(accountId: accountId),
      ),
    );
  }

  Future<void> _confirmDeleteMeta(
    BuildContext context,
    WidgetRef ref,
    String accountId,
  ) async {
    final metaRepo = ref.read(accountsMetaRepositoryProvider);
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Hapus metadata?'),
        content: const Text(
          'Tindakan ini hanya menghapus metadata akun. Data saldo dan transaksi tetap aman.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Batal'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Hapus'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await metaRepo.remove(accountId);
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Metadata akun dihapus.')),
        );
      }
    }
  }
}

