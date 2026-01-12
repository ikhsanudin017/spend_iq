import 'package:flutter/material.dart';

import '../../../core/constants/colors.dart';
import '../../widgets/app_page_decoration.dart';

class HelpPage extends StatelessWidget {
  const HelpPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      appBar: AppBar(
        title: const Text('Bantuan'),
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
                          Icons.help_outline_rounded,
                          color: AppColors.primary,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Panduan Penggunaan',
                              style: theme.textTheme.titleLarge?.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Pelajari cara menggunakan Spend-IQ',
                              style: theme.textTheme.bodyMedium?.copyWith(
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
            const _HelpSection(
              title: 'Memulai',
              items: [
                _HelpItem(
                  question: 'Bagaimana cara menghubungkan bank?',
                  answer:
                      'Buka halaman Pengaturan, lalu pilih bank yang ingin dihubungkan. Spend-IQ akan mengagregasi saldo dan transaksi dari bank yang terhubung.',
                ),
                _HelpItem(
                  question: 'Apa itu Safe Days?',
                  answer:
                      'Safe Days adalah hari-hari yang direkomendasikan AI untuk menabung berdasarkan analisis cashflow Anda. Aktifkan di halaman Autosave.',
                ),
                _HelpItem(
                  question: 'Bagaimana cara melihat forecast?',
                  answer:
                      'Buka halaman Insights untuk melihat prediksi pengeluaran 14 hari ke depan dan hari-hari dengan risiko tinggi.',
                ),
              ],
            ),
            const SizedBox(height: 20),
            const _HelpSection(
              title: 'Fitur Utama',
              items: [
                _HelpItem(
                  question: 'Apa itu Health Score?',
                  answer:
                      'Health Score adalah skor kesehatan finansial (0-100) yang dihitung berdasarkan saldo, pengeluaran, dan tujuan finansial Anda.',
                ),
                _HelpItem(
                  question: 'Bagaimana Smart Alerts bekerja?',
                  answer:
                      'Smart Alerts memberikan notifikasi otomatis untuk tagihan yang akan jatuh tempo, risiko saldo rendah, dan peluang menabung.',
                ),
                _HelpItem(
                  question: 'Bagaimana cara mengatur Goals?',
                  answer:
                      'Buka halaman Goals, tambah tujuan finansial baru, set target dan jadwal. Spend-IQ akan membantu track progress Anda.',
                ),
              ],
            ),
            const SizedBox(height: 20),
            const _HelpSection(
              title: 'Tips & Trik',
              items: [
                _HelpItem(
                  question: 'Bagaimana mengoptimalkan cashflow?',
                  answer:
                      'Gunakan forecast untuk merencanakan pengeluaran, aktifkan autosave di Safe Days, dan ikuti rekomendasi AI di halaman Insights.',
                ),
                _HelpItem(
                  question: 'Kapan waktu terbaik untuk menabung?',
                  answer:
                      'Spend-IQ menganalisis pola pengeluaran Anda dan merekomendasikan Safe Days - hari-hari dengan risiko pengeluaran rendah.',
                ),
              ],
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}

class _HelpSection extends StatelessWidget {
  const _HelpSection({
    required this.title,
    required this.items,
  });

  final String title;
  final List<_HelpItem> items;

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
          const SizedBox(height: 16),
          ...items.map((item) => _ExpandableHelpItem(item: item)),
        ],
      ),
    );
  }
}

class _HelpItem {
  const _HelpItem({
    required this.question,
    required this.answer,
  });

  final String question;
  final String answer;
}

class _ExpandableHelpItem extends StatefulWidget {
  const _ExpandableHelpItem({required this.item});

  final _HelpItem item;

  @override
  State<_ExpandableHelpItem> createState() => _ExpandableHelpItemState();
}

class _ExpandableHelpItemState extends State<_ExpandableHelpItem> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      children: [
        InkWell(
          onTap: () => setState(() => _isExpanded = !_isExpanded),
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    widget.item.question,
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Icon(
                  _isExpanded
                      ? Icons.expand_less_rounded
                      : Icons.expand_more_rounded,
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ],
            ),
          ),
        ),
        if (_isExpanded) ...[
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Text(
              widget.item.answer,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
                height: 1.5,
              ),
            ),
          ),
        ],
        const Divider(),
      ],
    );
  }
}











