import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../core/constants/colors.dart';
import '../../../core/router/app_router.dart';
import '../../../services/notifications_service.dart';

final notificationPermissionProvider =
    FutureProvider<bool>((ref) async => Permission.notification.isGranted);

class PermissionsPage extends ConsumerWidget {
  const PermissionsPage({super.key});

  Future<void> _requestPermissions(BuildContext context, WidgetRef ref) async {
    final granted =
        await ref.read(notificationsServiceProvider).requestPermission();
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          granted ? 'Notifikasi diaktifkan' : 'Izin notifikasi ditolak',
        ),
      ),
    );
    ref.invalidate(notificationPermissionProvider);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final permission = ref.watch(notificationPermissionProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Aktifkan Notifikasi Cerdas'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          children: [
            const SizedBox(height: 20),
            Container(
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [
                    AppColors.primary,
                    AppColors.accent,
                  ],
                ),
                borderRadius: BorderRadius.circular(24),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x1A1E3A8A),
                    blurRadius: 24,
                    offset: Offset(0, 16),
                  ),
                ],
              ),
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Jangan lewatkan momentum finansial penting.',
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 14),
                  const Wrap(
                    spacing: 12,
                    runSpacing: 8,
                    children: [
                      _PermissionHighlight(
                        icon: Icons.receipt_long_rounded,
                        text: 'Pengingat tagihan otomatis',
                      ),
                      _PermissionHighlight(
                        icon: Icons.trending_up_rounded,
                        text: 'Forecast risiko saldo rendah',
                      ),
                      _PermissionHighlight(
                        icon: Icons.savings_rounded,
                        text: 'Alert hari aman menabung',
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            DecoratedBox(
              decoration: BoxDecoration(
                color: theme.colorScheme.surface,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppColors.surfaceAlt),
              ),
              child: permission.when(
                data: (value) => SwitchListTile.adaptive(
                  value: value,
                  onChanged: (_) => _requestPermissions(context, ref),
                  title: Text(
                    value
                        ? 'Notifikasi sudah aktif'
                        : 'Aktifkan notifikasi cerdas',
                    style: theme.textTheme.titleMedium,
                  ),
                  subtitle: Text(
                    value
                        ? 'Kami akan memberi tahu ketika ada insight baru.'
                        : 'Izinkan Spend-IQ mengirim pengingat penting.',
                  ),
                ),
                loading: () => const ListTile(
                  title: Text('Memeriksa status...'),
                  trailing: SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                ),
                error: (_, __) => ListTile(
                  title: const Text('Tidak dapat memeriksa izin'),
                  subtitle: const Text('Coba lagi beberapa saat lagi.'),
                  trailing: IconButton(
                    icon: const Icon(Icons.refresh),
                    onPressed: () =>
                        ref.invalidate(notificationPermissionProvider),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.surfaceAlt,
                borderRadius: BorderRadius.circular(18),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    Icons.shield_rounded,
                    color: theme.colorScheme.primary,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Spend-IQ hanya menggunakan notifikasi untuk informasi finansial penting. Anda dapat menonaktifkannya kapan saja dari pengaturan.',
                      style: theme.textTheme.bodySmall,
                    ),
                  ),
                ],
              ),
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: permission.maybeWhen(
                  data: (granted) => () {
                    // Skip permission atau langsung lanjut ke home
                    // Permission bisa diaktifkan nanti dari settings
                    context.go(AppRoute.home.path);
                  },
                  orElse: () => () => context.go(AppRoute.home.path),
                ),
                child: const Text('Mulai Spend-IQ'),
              ),
            ),
            if (permission.valueOrNull == false) ...[
              const SizedBox(height: 12),
              TextButton(
                onPressed: () => context.go(AppRoute.home.path),
                child: const Text('Lewati untuk sekarang'),
              ),
            ],
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}

class _PermissionHighlight extends StatelessWidget {
  const _PermissionHighlight({
    required this.icon,
    required this.text,
  });

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) => Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white.withAlpha(36),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 18, color: Colors.white),
          const SizedBox(width: 8),
          Text(
            text,
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
                  color: Colors.white,
                ),
          ),
        ],
      ),
    );
}

