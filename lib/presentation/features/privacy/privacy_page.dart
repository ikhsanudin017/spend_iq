import 'package:flutter/material.dart';

import '../../../core/constants/colors.dart';
import '../../widgets/app_page_decoration.dart';

class PrivacyPage extends StatelessWidget {
  const PrivacyPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      appBar: AppBar(
        title: const Text('Kebijakan Privasi'),
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
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withAlpha(36),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: const Icon(
                          Icons.privacy_tip_rounded,
                          color: AppColors.primary,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Kebijakan Privasi',
                              style: theme.textTheme.titleLarge?.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Terakhir diperbarui: ${DateTime.now().day} ${_getMonthName(DateTime.now().month)} ${DateTime.now().year}',
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: theme.colorScheme.onSurfaceVariant,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            const _PrivacySection(
              title: '1. Data yang Kami Kumpulkan',
              content:
                  'Spend-IQ mengumpulkan data finansial Anda termasuk saldo akun, transaksi, dan metadata akun untuk memberikan layanan analisis dan prediksi. Semua data disimpan secara lokal di perangkat Anda.',
            ),
            const SizedBox(height: 20),
            const _PrivacySection(
              title: '2. Penggunaan Data',
              content:
                  'Data yang dikumpulkan digunakan semata-mata untuk:\n\nâ€¢ Menghasilkan prediksi pengeluaran\nâ€¢ Memberikan rekomendasi autosave\nâ€¢ Menghitung health score finansial\nâ€¢ Menampilkan insights dan analisis\n\nKami tidak membagikan data Anda kepada pihak ketiga.',
            ),
            const SizedBox(height: 20),
            const _PrivacySection(
              title: '3. Penyimpanan Data',
              content:
                  'Semua data finansial Anda disimpan secara lokal di perangkat menggunakan enkripsi. Data tidak dikirim ke server eksternal kecuali Anda secara eksplisit menggunakan fitur backup atau share.',
            ),
            const SizedBox(height: 20),
            const _PrivacySection(
              title: '4. Keamanan',
              content:
                  'Kami menggunakan enkripsi lokal dan praktik keamanan terbaik untuk melindungi data Anda. Akses ke data memerlukan autentikasi perangkat.',
            ),
            const SizedBox(height: 20),
            const _PrivacySection(
              title: '5. Hak Anda',
              content:
                  'Anda memiliki hak untuk:\n\nâ€¢ Mengakses data Anda kapan saja\nâ€¢ Menghapus data Anda\nâ€¢ Mengekspor data Anda\nâ€¢ Menolak pengumpulan data tertentu',
            ),
            const SizedBox(height: 20),
            const _PrivacySection(
              title: '6. Kontak',
              content:
                  'Jika Anda memiliki pertanyaan tentang kebijakan privasi ini, silakan hubungi kami di support@smartspend.ai',
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  String _getMonthName(int month) {
    const months = [
      'Januari',
      'Februari',
      'Maret',
      'April',
      'Mei',
      'Juni',
      'Juli',
      'Agustus',
      'September',
      'Oktober',
      'November',
      'Desember',
    ];
    return months[month - 1];
  }
}

class _PrivacySection extends StatelessWidget {
  const _PrivacySection({
    required this.title,
    required this.content,
  });

  final String title;
  final String content;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SectionCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            content,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }
}











