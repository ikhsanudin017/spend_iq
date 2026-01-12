import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/colors.dart';
import '../../../providers/profile_providers.dart';
import '../../features/accounts_meta/accounts_meta_list_page.dart';
import '../../features/settings/settings_page.dart';

class ProfilePage extends ConsumerStatefulWidget {
  const ProfilePage({super.key});

  @override
  ConsumerState<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends ConsumerState<ProfilePage> {
  final _nameController = TextEditingController();
  bool _saving = false;

  Future<void> _saveProfile() async {
    setState(() => _saving = true);
    await ref
        .read(profileControllerProvider.notifier)
        .setName(_nameController.text);
    if (!mounted) return;
    setState(() => _saving = false);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Profil tersimpan')),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final profile = ref.watch(profileControllerProvider);
    final banks = ref.watch(availableBanksForProfileProvider);
    final connections = ref.watch(bankConnectionsForProfileProvider);
    final theme = Theme.of(context);

    profile.whenData((value) => _nameController.text = value);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profil & Koneksi Bank'),
        actions: [
          IconButton(
            tooltip: 'Kelola Metadata Akun',
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute<void>(
                builder: (_) => const AccountsMetaListPage(),
              ),
            ),
            icon: const Icon(Icons.manage_accounts_outlined),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text('Profil', style: theme.textTheme.titleMedium),
          const SizedBox(height: 8),
          TextFormField(
            controller: _nameController,
            decoration: const InputDecoration(
              labelText: 'Nama Tampilan',
              hintText: 'Contoh: Ikhsan',
            ),
          ),
          const SizedBox(height: 8),
          Align(
            alignment: Alignment.centerLeft,
            child: FilledButton.icon(
              onPressed: _saving ? null : _saveProfile,
              icon: _saving
                  ? const SizedBox(
                      width: 14,
                      height: 14,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.save_outlined),
              label: const Text('Simpan'),
            ),
          ),
          const SizedBox(height: 24),
          Card(
            child: ListTile(
              leading: const Icon(Icons.settings_outlined),
              title: const Text('Pengaturan'),
              subtitle: const Text('Pengaturan aplikasi dan preferensi'),
              trailing: const Icon(Icons.chevron_right_rounded),
              onTap: () => Navigator.of(context).push(
                MaterialPageRoute<void>(
                  builder: (_) => const SettingsPage(),
                ),
              ),
            ),
          ),
          const SizedBox(height: 24),
          Text('Koneksi Bank', style: theme.textTheme.titleMedium),
          const SizedBox(height: 8),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Pilih bank yang ingin dihubungkan untuk agregasi saldo dan insight.',
                    style: theme.textTheme.bodySmall,
                  ),
                  const SizedBox(height: 12),
                  banks.when(
                    data: (available) => connections.when(
                      data: (selected) => Column(
                        children: [
                          for (final bank in available)
                            _BankSelectorTile(
                              label: bank,
                              isSelected: selected.contains(bank),
                              onTap: () => ref
                                  .read(bankConnectionsForProfileProvider.notifier)
                                  .toggleBank(bank),
                            ),
                        ],
                      ),
                      loading: () => const Center(
                        child: Padding(
                          padding: EdgeInsets.all(16),
                          child: CircularProgressIndicator(),
                        ),
                      ),
                      error: (e, _) => Padding(
                        padding: const EdgeInsets.all(8),
                        child: Text('Gagal memuat koneksi: $e'),
                      ),
                    ),
                    loading: () => const Center(
                      child: Padding(
                        padding: EdgeInsets.all(16),
                        child: CircularProgressIndicator(),
                      ),
                    ),
                    error: (e, _) => Padding(
                      padding: const EdgeInsets.all(8),
                      child: Text('Gagal memuat daftar bank: $e'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
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
      margin: const EdgeInsets.only(bottom: 12),
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

