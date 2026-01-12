
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/constants/colors.dart';
import '../../../core/router/app_router.dart';
import '../../../data/repositories/finance_repository_impl.dart';
import '../../../providers/theme_providers.dart';
import '../../../providers/locale_providers.dart';
import '../../../providers/profile_providers.dart';
import '../../../services/backup_service.dart';
import '../../widgets/app_page_decoration.dart';

final packageInfoProvider = FutureProvider<PackageInfo>((ref) async => PackageInfo.fromPlatform());

class SettingsPage extends ConsumerWidget {
  const SettingsPage({super.key});

  Future<void> _launchURL(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final packageInfo = ref.watch(packageInfoProvider);

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      appBar: AppBar(
        title: const Text('Pengaturan'),
        centerTitle: true,
      ),
      body: AppPageContainer(
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            SectionCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Akun & Data',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Profil Section - inline
                  _ProfileSection(ref: ref),
                  const Divider(),
                  // Koneksi Bank Section - inline
                  _BankConnectionsSection(ref: ref),
                  const Divider(),
                  ListTile(
                    leading: const Icon(Icons.backup_outlined),
                    title: const Text('Backup Data'),
                    subtitle: const Text('Ekspor data ke file lokal'),
                    trailing: const Icon(Icons.chevron_right_rounded),
                    onTap: () async {
                      final repository = ref.read(financeRepositoryProvider);
                      final backupService = BackupService(repository);
                      
                      try {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Row(
                              children: [
                                SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(strokeWidth: 2),
                                ),
                                SizedBox(width: 12),
                                Text('Mengekspor data...'),
                              ],
                            ),
                            duration: Duration(seconds: 2),
                          ),
                        );

                        final jsonData = await backupService.exportDataToJson();
                        final filePath = await backupService.saveBackupFile(jsonData);

                        if (!context.mounted) return;

                        if (filePath != null) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Backup berhasil disimpan di: ${filePath.split('/').last}'),
                              action: SnackBarAction(
                                label: 'OK',
                                onPressed: () {},
                              ),
                            ),
                          );
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Gagal menyimpan backup'),
                            ),
                          );
                        }
                      } catch (e) {
                        if (!context.mounted) return;
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Error: ${e.toString()}'),
                          ),
                        );
                      }
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            SectionCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Tampilan',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 16),
                  ListTile(
                    leading: const Icon(Icons.dark_mode_outlined),
                    title: const Text('Tema'),
                    subtitle: Builder(
                      builder: (context) {
                        final themeMode = ref.watch(themeControllerProvider);
                        String subtitle;
                        switch (themeMode) {
                          case ThemeMode.light:
                            subtitle = 'Mode terang';
                            break;
                          case ThemeMode.dark:
                            subtitle = 'Mode gelap';
                            break;
                          case ThemeMode.system:
                            subtitle = 'Mengikuti sistem';
                            break;
                        }
                        return Text(subtitle);
                      },
                    ),
                    trailing: Builder(
                      builder: (context) {
                        final isDark = theme.brightness == Brightness.dark;
                        return Switch(
                          value: isDark,
                          onChanged: (value) {
                            ref.read(themeControllerProvider.notifier).toggleTheme();
                          },
                        );
                      },
                    ),
                    onTap: () {
                      final themeMode = ref.read(themeControllerProvider);
                      showModalBottomSheet<void>(
                        context: context,
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
                        ),
                        builder: (context) => _ThemeSelector(
                          currentMode: themeMode,
                          onModeSelected: (mode) {
                            ref.read(themeControllerProvider.notifier).setTheme(mode);
                            Navigator.pop(context);
                          },
                        ),
                      );
                    },
                  ),
                  const Divider(),
                  ListTile(
                    leading: const Icon(Icons.language_outlined),
                    title: const Text('Bahasa'),
                    subtitle: Builder(
                      builder: (context) {
                        final locale = ref.watch(localeControllerProvider);
                        String subtitle;
                        if (locale == null) {
                          subtitle = 'Mengikuti sistem';
                        } else if (locale.languageCode == 'id') {
                          subtitle = 'Bahasa Indonesia';
                        } else {
                          subtitle = 'English';
                        }
                        return Text(subtitle);
                      },
                    ),
                    trailing: const Icon(Icons.chevron_right_rounded),
                    onTap: () {
                      final currentLocale = ref.read(localeControllerProvider);
                      showModalBottomSheet<void>(
                        context: context,
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
                        ),
                        builder: (context) => _LocaleSelector(
                          currentLocale: currentLocale,
                          onLocaleSelected: (locale) {
                            ref.read(localeControllerProvider.notifier).setLocale(locale);
                            Navigator.pop(context);
                          },
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            SectionCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Bantuan & Dukungan',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 16),
                  ListTile(
                    leading: const Icon(Icons.help_outline_rounded),
                    title: const Text('Bantuan'),
                    subtitle: const Text('FAQ dan panduan penggunaan'),
                    trailing: const Icon(Icons.chevron_right_rounded),
                    onTap: () => context.push(AppRoute.help.path),
                  ),
                  const Divider(),
                  ListTile(
                    leading: const Icon(Icons.feedback_outlined),
                    title: const Text('Kirim Feedback'),
                    subtitle: const Text('Saran dan masukan untuk aplikasi'),
                    trailing: const Icon(Icons.chevron_right_rounded),
                    onTap: () => _launchURL('mailto:support@spend-iq.ai?subject=Feedback'),
                  ),
                  const Divider(),
                  ListTile(
                    leading: const Icon(Icons.privacy_tip_outlined),
                    title: const Text('Kebijakan Privasi'),
                    subtitle: const Text('Baca kebijakan privasi kami'),
                    trailing: const Icon(Icons.chevron_right_rounded),
                    onTap: () => context.push(AppRoute.privacy.path),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            packageInfo.when(
              data: (info) => SectionCard(
                child: Column(
                  children: [
                    ListTile(
                      leading: const Icon(Icons.info_outline_rounded),
                      title: const Text('Tentang Aplikasi'),
                      subtitle: Text('Spend-IQ v${info.version}'),
                      trailing: const Icon(Icons.chevron_right_rounded),
                      onTap: () {
                        showAboutDialog(
                          context: context,
                          applicationName: 'Spend-IQ',
                          applicationVersion: info.version,
                          applicationIcon: const Icon(
                            Icons.auto_graph_rounded,
                            size: 48,
                            color: AppColors.primary,
                          ),
                          children: [
                            const SizedBox(height: 16),
                            const Text(
                              'Aplikasi manajemen keuangan pintar dengan AI untuk membantu Anda mengoptimalkan cashflow dan mencapai tujuan finansial.',
                            ),
                          ],
                        );
                      },
                    ),
                  ],
                ),
              ),
              loading: () => const SizedBox.shrink(),
              error: (_, __) => const SizedBox.shrink(),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}

class _ThemeSelector extends StatelessWidget {
  const _ThemeSelector({
    required this.currentMode,
    required this.onModeSelected,
  });

  final ThemeMode currentMode;
  final ValueChanged<ThemeMode> onModeSelected;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 40,
            height: 4,
            margin: const EdgeInsets.only(bottom: 20),
            decoration: BoxDecoration(
              color: theme.colorScheme.onSurfaceVariant.withAlpha(100),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          Text(
            'Pilih Tema',
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 20),
          _ThemeOption(
            icon: Icons.light_mode_rounded,
            title: 'Mode Terang',
            subtitle: 'Selalu menggunakan tema terang',
            isSelected: currentMode == ThemeMode.light,
            onTap: () => onModeSelected(ThemeMode.light),
          ),
          _ThemeOption(
            icon: Icons.dark_mode_rounded,
            title: 'Mode Gelap',
            subtitle: 'Selalu menggunakan tema gelap',
            isSelected: currentMode == ThemeMode.dark,
            onTap: () => onModeSelected(ThemeMode.dark),
          ),
          _ThemeOption(
            icon: Icons.brightness_auto_rounded,
            title: 'Mengikuti Sistem',
            subtitle: 'Otomatis sesuai pengaturan perangkat',
            isSelected: currentMode == ThemeMode.system,
            onTap: () => onModeSelected(ThemeMode.system),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}

class _ThemeOption extends StatelessWidget {
  const _ThemeOption({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.isSelected,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ListTile(
      leading: Icon(
        icon,
        color: isSelected ? theme.colorScheme.primary : theme.colorScheme.onSurfaceVariant,
      ),
      title: Text(
        title,
        style: theme.textTheme.titleSmall?.copyWith(
          fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
          color: isSelected ? theme.colorScheme.primary : theme.colorScheme.onSurface,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: theme.textTheme.bodySmall?.copyWith(
          color: theme.colorScheme.onSurfaceVariant,
        ),
      ),
      trailing: isSelected
          ? Icon(
              Icons.check_circle_rounded,
              color: theme.colorScheme.primary,
            )
          : null,
      onTap: onTap,
    );
  }
}

class _LocaleSelector extends StatelessWidget {
  const _LocaleSelector({
    required this.currentLocale,
    required this.onLocaleSelected,
  });

  final Locale? currentLocale;
  final ValueChanged<Locale?> onLocaleSelected;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 40,
            height: 4,
            margin: const EdgeInsets.only(bottom: 20),
            decoration: BoxDecoration(
              color: theme.colorScheme.onSurfaceVariant.withAlpha(100),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          Text(
            'Pilih Bahasa',
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 20),
          _LocaleOption(
            icon: Icons.language_rounded,
            title: 'Bahasa Indonesia',
            subtitle: 'Gunakan Bahasa Indonesia',
            locale: const Locale('id'),
            isSelected: currentLocale?.languageCode == 'id',
            onTap: () => onLocaleSelected(const Locale('id')),
          ),
          _LocaleOption(
            icon: Icons.language_rounded,
            title: 'English',
            subtitle: 'Use English',
            locale: const Locale('en'),
            isSelected: currentLocale?.languageCode == 'en',
            onTap: () => onLocaleSelected(const Locale('en')),
          ),
          _LocaleOption(
            icon: Icons.settings_suggest_rounded,
            title: 'Mengikuti Sistem',
            subtitle: 'Otomatis sesuai pengaturan perangkat',
            locale: null,
            isSelected: currentLocale == null,
            onTap: () => onLocaleSelected(null),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}

class _LocaleOption extends StatelessWidget {
  const _LocaleOption({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.locale,
    required this.isSelected,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final Locale? locale;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ListTile(
      leading: Icon(
        icon,
        color: isSelected ? theme.colorScheme.primary : theme.colorScheme.onSurfaceVariant,
      ),
      title: Text(
        title,
        style: theme.textTheme.titleSmall?.copyWith(
          fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
          color: isSelected ? theme.colorScheme.primary : theme.colorScheme.onSurface,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: theme.textTheme.bodySmall?.copyWith(
          color: theme.colorScheme.onSurfaceVariant,
        ),
      ),
      trailing: isSelected
          ? Icon(
              Icons.check_circle_rounded,
              color: theme.colorScheme.primary,
            )
          : null,
      onTap: onTap,
    );
  }
}

class _ProfileSection extends ConsumerStatefulWidget {
  const _ProfileSection({required this.ref});

  final WidgetRef ref;

  @override
  ConsumerState<_ProfileSection> createState() => _ProfileSectionState();
}

class _ProfileSectionState extends ConsumerState<_ProfileSection> {
  final _nameController = TextEditingController();
  bool _saving = false;

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _saveProfile() async {
    setState(() => _saving = true);
    await ref
        .read(profileControllerProvider.notifier)
        .setName(_nameController.text);
    if (!mounted) return;
    setState(() => _saving = false);
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Profil tersimpan')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final profile = ref.watch(profileControllerProvider);

    // ignore: cascade_invocations
    profile.whenData((value) {
      if (_nameController.text != value) {
        _nameController.text = value;
      }
    });

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Profil',
          style: theme.textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 12),
        TextFormField(
          controller: _nameController,
          decoration: const InputDecoration(
            labelText: 'Nama Tampilan',
            hintText: 'Contoh: Ikhsan',
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 12),
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
      ],
    );
  }
}

class _BankConnectionsSection extends ConsumerWidget {
  const _BankConnectionsSection({required this.ref});

  final WidgetRef ref;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final banks = ref.watch(availableBanksForProfileProvider);
    final connections = ref.watch(bankConnectionsForProfileProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Koneksi Bank',
          style: theme.textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Pilih bank yang ingin dihubungkan untuk agregasi saldo dan insight.',
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
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


