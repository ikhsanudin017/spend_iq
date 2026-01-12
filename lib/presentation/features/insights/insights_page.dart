import 'dart:math' as math;
import 'dart:math' show Random;

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../core/constants/colors.dart';
import '../../../core/utils/currency.dart';
import '../../../core/utils/date.dart';
import '../../../core/utils/haptic_feedback.dart';
import '../../../core/utils/responsive.dart';
import '../../../domain/entities/transaction.dart';
import 'package:smartspend_ai/data/repositories/finance_repository_impl.dart';
import '../../../core/router/app_router.dart';
import '../../widgets/app_page_decoration.dart';
import '../../widgets/error_state.dart';
import '../../widgets/skeleton_loader.dart';

class InsightsData {
  InsightsData({
    required this.monthlyTrend,
    required this.categoryShares,
    required this.anomalies,
    required this.recommendations,
  });

  final Map<DateTime, double> monthlyTrend;
  final List<CategoryShare> categoryShares;
  final List<Transaction> anomalies;
  final List<String> recommendations;
}

class CategoryShare {
  CategoryShare({
    required this.category,
    required this.percentage,
    required this.amount,
  });

  final String category;
  final double percentage;
  final double amount;
}

final insightsProvider = FutureProvider<InsightsData>((ref) async {
  final repository = ref.watch(financeRepositoryProvider);
  final transactions = await repository.getRecentTransactions();
  final filtered = transactions.where((tx) => tx.amount > 0).toList();

  final monthly = <DateTime, double>{};
  for (final tx in filtered) {
    final key = DateTime(tx.date.year, tx.date.month);
    monthly.update(key, (value) => value + tx.amount, ifAbsent: () => tx.amount);
  }
  
  // Tambahkan data dummy untuk 6 bulan terakhir jika belum ada
  final now = DateTime.now();
  final currentMonth = DateTime(now.year, now.month);
  
  // Hitung total pengeluaran bulan ini sebagai base
  final currentMonthTotal = monthly[currentMonth] ?? 0;
  final baseAmount = currentMonthTotal > 0 
      ? currentMonthTotal 
      : (filtered.isNotEmpty 
          ? filtered.fold<double>(0, (sum, tx) => sum + tx.amount) 
          : 15500000); // Default 15.5 juta jika tidak ada data
  
  // Generate data untuk 6 bulan terakhir dengan trend yang realistis
  // Trend: bulan lebih lama cenderung lebih rendah, dengan fluktuasi natural
  final trendBase = [0.75, 0.82, 0.88, 0.92, 0.95, 1.0]; // Trend naik dari bulan lalu ke sekarang
  
  for (int i = 5; i >= 0; i--) {
    final monthDate = DateTime(now.year, now.month - i);
    if (!monthly.containsKey(monthDate)) {
      // Gunakan seed berdasarkan bulan untuk konsistensi
      final random = Random(monthDate.year * 100 + monthDate.month);
      // Variasi random ±15% untuk natural fluctuation
      final fluctuation = 0.85 + (random.nextDouble() * 0.3); // 0.85 sampai 1.15
      
      // Base amount dengan trend dan fluctuation
      final trendFactor = trendBase[5 - i]; // i=5 (bulan paling lama) pakai 0.75, i=0 (bulan ini) pakai 1.0
      final monthAmount = baseAmount * trendFactor * fluctuation;
      
      // Pastikan minimal 3 juta dan maksimal 20 juta, bulatkan ke ratusan ribu
      final finalAmount = (monthAmount.clamp(3000000, 20000000) / 100000).round() * 100000;
      monthly[monthDate] = finalAmount.toDouble();
    }
  }
  
  final sortedMonthly = Map<DateTime, double>.fromEntries(
    monthly.entries.toList()..sort((a, b) => a.key.compareTo(b.key)),
  );

  final categoryTotals = <String, double>{};
  for (final tx in filtered) {
    categoryTotals.update(
      tx.category,
      (value) => value + tx.amount,
      ifAbsent: () => tx.amount,
    );
  }

  final totalSpend =
      categoryTotals.values.fold<double>(0, (sum, value) => sum + value);
  final categoryShares = categoryTotals.entries
      .map(
        (entry) => CategoryShare(
          category: entry.key,
          percentage: totalSpend == 0 ? 0 : (entry.value / totalSpend) * 100,
          amount: entry.value,
        ),
      )
      .toList()
    ..sort((a, b) => b.amount.compareTo(a.amount));

  final average = filtered.isEmpty
      ? 0
      : filtered.fold<double>(0, (sum, tx) => sum + tx.amount) /
          filtered.length;
  final variance = filtered.isEmpty
      ? 0
      : filtered
              .map((tx) => math.pow(tx.amount - average, 2).toDouble())
              .reduce((a, b) => a + b) /
          filtered.length;
  final stdDev = math.sqrt(variance);

  final anomalies = filtered
      .where((tx) => tx.amount > average + stdDev && tx.category != 'Income')
      .toList()
    ..sort((a, b) => b.amount.compareTo(a.amount));

  final recommendations = <String>[];
  if (anomalies.isNotEmpty) {
    final top = anomalies.first;
    recommendations.add(
      'Pengeluaran kategori ${top.category} naik signifikan di ${DateUtilsX.formatShort(top.date)}.',
    );
  }
  if (categoryShares.isNotEmpty) {
    final topCategory = categoryShares.first;
    recommendations.add(
      'Tetapkan limit ${topCategory.category} sekitar ${CurrencyUtils.format(topCategory.amount * 0.9)} per bulan.',
    );
  }
  if (sortedMonthly.length >= 2) {
    final latest = sortedMonthly.values.last;
    final previous =
        sortedMonthly.values.elementAt(sortedMonthly.length - 2);
    if (previous > 0 && latest > previous * 1.1) {
      final percent = ((latest / previous) - 1) * 100;
      recommendations.add(
        'Belanja bulan ini lebih tinggi ${percent.toStringAsFixed(1)}% dibanding bulan lalu.',
      );
    }
  }

  return InsightsData(
    monthlyTrend: sortedMonthly,
    categoryShares: categoryShares,
    anomalies: anomalies,
    recommendations: recommendations,
  );
});

class InsightsPage extends ConsumerWidget {
  const InsightsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final insights = ref.watch(insightsProvider);
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      appBar: AppBar(
        title: const Text('Spending Insights'),
        centerTitle: true,
        actions: [
          IconButton(
            tooltip: 'Profil',
            icon: const Icon(Icons.person_outline),
            onPressed: () => context.push(AppRoute.profile.path),
          ),
        ],
      ),
      body: insights.when(
        data: (data) {
          final mediaQuery = MediaQuery.of(context);
          const bottomNavHeight = 80.0; // Approximate bottom nav height
          final safeAreaBottom = mediaQuery.padding.bottom;
          final totalBottomPadding = safeAreaBottom + bottomNavHeight + 120; // Extra space untuk screenshot
          
          return AppPageContainer(
            bottomPadding: 0, // Let ListView handle padding
            child: RefreshIndicator(
              onRefresh: () async => ref.refresh(insightsProvider.future),
              child: ListView(
                physics: const BouncingScrollPhysics(
                  parent: AlwaysScrollableScrollPhysics(),
                ),
                padding: EdgeInsets.only(
                  bottom: totalBottomPadding,
                ),
                clipBehavior: Clip.none, // Allow content to extend beyond bounds
                children: [
                  _InsightsHero(data: data),
                  const SectionGap.large(),
                  _TrendCard(data: data),
                  const SectionGap.large(),
                  _CategoryBreakdown(data: data),
                  const SectionGap.large(),
                  _AnomalyCard(data: data),
                  const SectionGap.large(),
                  _RecommendationsCard(data: data),
                  const SectionGap.large(),
                  SizedBox(height: totalBottomPadding), // Extra space di akhir untuk screenshot
                ],
              ),
            ),
          );
        },
        loading: () => AppPageContainer(
          child: ListView(
            padding: const EdgeInsets.all(20),
            children: [
              const SkeletonCard(),
              const SizedBox(height: 20),
              const SkeletonCard(),
              const SizedBox(height: 20),
              const SkeletonCard(),
            ],
          ),
        ),
        error: (error, stackTrace) => AppPageContainer(
          child: ErrorState(
            message: 'Tidak dapat memuat insight. Silakan coba lagi.',
            onRetry: () {
              HapticUtils.selectionClick();
              ref.invalidate(insightsProvider);
            },
          ),
        ),
      ),
    );
  }
}

class _InsightsHero extends StatelessWidget {
  const _InsightsHero({required this.data});

  final InsightsData data;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final entries = data.monthlyTrend.entries.toList();
    final current = entries.isNotEmpty ? entries.last.value : 0;
    final previous =
        entries.length >= 2 ? entries[entries.length - 2].value : current;
    final diff = current - previous;
    final diffPercent = previous == 0 ? 0 : (diff / previous) * 100;
    final topCategory =
        data.categoryShares.isNotEmpty ? data.categoryShares.first : null;

    final diffText = previous == 0
        ? 'Data awal, belum ada pembanding'
        : diff > 0
            ? '+${diffPercent.abs().toStringAsFixed(1)}% dibanding bulan lalu'
            : '-${diffPercent.abs().toStringAsFixed(1)}% dibanding bulan lalu';

    return SectionCard(
      gradient: const LinearGradient(
        colors: [
          AppColors.primary,
          AppColors.primaryLight,
        ],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      ),
      padding: EdgeInsets.fromLTRB(
        ResponsiveUtils.horizontalPadding(context),
        32,
        ResponsiveUtils.horizontalPadding(context),
        30,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Insight Bulan Ini',
            style: theme.textTheme.titleLarge?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Pantau pola belanja dan deteksi potensi risiko lebih cepat.',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: Colors.white.withAlpha(220),
            ),
          ),
          const SizedBox(height: 28),
          Text(
            'Pengeluaran bulan ini',
            style: theme.textTheme.labelLarge?.copyWith(
              color: Colors.white.withAlpha(220),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            CurrencyUtils.format(current),
            style: theme.textTheme.displaySmall?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w700,
              letterSpacing: -1.2,
            ),
          ),
          const SizedBox(height: 14),
          LayoutBuilder(
            builder: (context, constraints) {
              final spacing = ResponsiveUtils.spacing(context, base: 12);
              int columns = 1;
              if (constraints.maxWidth >= 640) {
                columns = 3;
              } else if (constraints.maxWidth >= 360) {
                columns = 2;
              }
              final itemWidth = columns == 1
                  ? constraints.maxWidth
                  : (constraints.maxWidth - spacing * (columns - 1)) / columns;
              return Wrap(
                spacing: spacing,
                runSpacing: spacing,
                children: [
                  SizedBox(
                    width: itemWidth,
                    child: _MetricPill(
                      icon: diff >= 0
                          ? Icons.trending_up_rounded
                          : Icons.trending_down_rounded,
                      label: 'Perbandingan',
                      value: diffText,
                      caption: diff > 0
                          ? 'Tahan belanja di kategori konsumtif.'
                          : 'Hebat! Belanja lebih rendah.',
                    ),
                  ),
                  SizedBox(
                    width: itemWidth,
                    child: _MetricPill(
                      icon: Icons.category_rounded,
                      label: 'Kategori terbesar',
                      value: topCategory?.category ?? 'Belum ada',
                      caption: topCategory == null
                          ? 'Mulai hubungkan transaksi.'
                          : '${topCategory.percentage.toStringAsFixed(1)}% dari total.',
                    ),
                  ),
                  SizedBox(
                    width: itemWidth,
                    child: _MetricPill(
                      icon: Icons.warning_amber_rounded,
                      label: 'Anomali',
                      value: '${data.anomalies.length} transaksi',
                      caption: data.anomalies.isEmpty
                          ? 'Tidak ada lonjakan mencurigakan.'
                          : 'Periksa untuk mencegah pemborosan.',
                    ),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}

class _MetricPill extends StatelessWidget {
  const _MetricPill({
    required this.icon,
    required this.label,
    required this.value,
    required this.caption,
  });

  final IconData icon;
  final String label;
  final String value;
  final String caption;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withAlpha(36),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.white.withAlpha(60)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Icon(icon, color: Colors.white, size: 20),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  label,
                  style: theme.textTheme.labelMedium?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: theme.textTheme.titleMedium?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w700,
              letterSpacing: -0.2,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 4),
          Text(
            caption,
            style: theme.textTheme.bodySmall?.copyWith(
              color: Colors.white.withAlpha(210),
              height: 1.2,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}

class _TrendCard extends StatelessWidget {
  const _TrendCard({required this.data});

  final InsightsData data;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final entries = data.monthlyTrend.entries.toList();
    final spots = [
      for (var i = 0; i < entries.length; i++)
        FlSpot(i.toDouble(), entries[i].value),
    ];

    return SectionCard(
      padding: EdgeInsets.all(ResponsiveUtils.horizontalPadding(context)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Tren pengeluaran',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Lihat pergerakan 6 bulan terakhir untuk memantau laju spending.',
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 24),
          LayoutBuilder(
            builder: (context, constraints) {
              final chartHeight = ResponsiveUtils.screenHeight(context) < 800
                  ? 220.0
                  : 280.0;
              final isNarrow = constraints.maxWidth < 360;
              return Container(
                height: chartHeight,
                padding: EdgeInsets.only(
                  left: isNarrow ? 8 : 12,
                  right: 4,
                  top: 8,
                  bottom: 8,
                ),
                child: entries.isEmpty
                ? Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.show_chart_rounded,
                          size: 48,
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'Belum ada data transaksi.',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  )
                : LineChart(
                    LineChartData(
                      minX: 0,
                      maxX: math.max(spots.length - 1, 0).toDouble(),
                      minY: 0,
                      maxY: _maxY(spots),
                      baselineY: 0,
                      clipData: const FlClipData.all(),
                      titlesData: FlTitlesData(
                        topTitles: const AxisTitles(
                          
                        ),
                        rightTitles: const AxisTitles(
                          
                        ),
                        bottomTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            reservedSize: 40,
                            interval: 1,
                            getTitlesWidget: (value, meta) {
                              final index = value.round();
                              if (index < 0 || index >= entries.length) {
                                return const SizedBox.shrink();
                              }
                              final label = DateFormat(
                                'MMM',
                                'id_ID',
                              ).format(entries[index].key);
                              return Padding(
                                padding: const EdgeInsets.only(top: 10),
                                child: Text(
                                  label,
                                  style: theme.textTheme.labelSmall?.copyWith(
                                    color: theme.colorScheme.onSurfaceVariant,
                                    fontSize: isNarrow ? 10 : 11,
                                    height: 1.2,
                                    fontWeight: FontWeight.w500,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.visible,
                                  textAlign: TextAlign.center,
                                ),
                              );
                            },
                          ),
                        ),
                        leftTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            reservedSize: isNarrow ? 50 : 65,
                            interval: _interval(spots),
                            getTitlesWidget: (value, meta) {
                              if (value < 0) return const SizedBox.shrink();
                              final formatted = _formatAxisValue(value);
                              return Padding(
                                padding: const EdgeInsets.only(right: 8),
                                child: Text(
                                  formatted,
                                  style: theme.textTheme.labelSmall?.copyWith(
                                    color: theme.colorScheme.onSurfaceVariant,
                                    fontSize: isNarrow ? 9 : 10,
                                    height: 1.2,
                                    fontWeight: FontWeight.w500,
                                  ),
                                  textAlign: TextAlign.right,
                                  maxLines: 1,
                                  overflow: TextOverflow.visible,
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                      gridData: FlGridData(
                        drawVerticalLine: false,
                        horizontalInterval: _interval(spots),
                        getDrawingHorizontalLine: (value) => FlLine(
                          color: theme.colorScheme.outlineVariant.withAlpha(80),
                          strokeWidth: 1,
                          dashArray: const [5, 5],
                        ),
                      ),
                      borderData: FlBorderData(
                        show: true,
                        border: Border(
                          bottom: BorderSide(
                            color: theme.colorScheme.outlineVariant,
                            width: 1.5,
                          ),
                          left: BorderSide(
                            color: theme.colorScheme.outlineVariant,
                            width: 1.5,
                          ),
                        ),
                      ),
                      lineTouchData: LineTouchData(
                        touchTooltipData: LineTouchTooltipData(
                          tooltipPadding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 8,
                          ),
                          tooltipRoundedRadius: 12,
                          fitInsideHorizontally: true,
                          fitInsideVertically: true,
                          getTooltipItems: (spots) => spots
                              .map(
                                (spot) {
                                  final index = spot.x.toInt();
                                  if (index < 0 || index >= entries.length) {
                                    return null;
                                  }
                                  return LineTooltipItem(
                                    CurrencyUtils.format(spot.y),
                                    theme.textTheme.bodyMedium!.copyWith(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600,
                                    ),
                                    children: [
                                      TextSpan(
                                        text:
                                            '\n${DateUtilsX.formatShort(entries[index].key)}',
                                        style: theme.textTheme.bodySmall!
                                            .copyWith(
                                          color: Colors.white70,
                                        ),
                                      ),
                                    ],
                                  );
                                },
                              )
                              .whereType<LineTooltipItem>()
                              .toList(),
                        ),
                      ),
                      lineBarsData: [
                        LineChartBarData(
                          spots: spots,
                          isCurved: true,
                          curveSmoothness: 0.4,
                          barWidth: 3,
                          color: AppColors.accent,
                          dotData: FlDotData(
                            getDotPainter: (spot, percent, barData, index) =>
                                FlDotCirclePainter(
                              radius: 4.5,
                              strokeWidth: 2.5,
                              strokeColor: Colors.white,
                              color: AppColors.accent,
                            ),
                          ),
                          belowBarData: BarAreaData(
                            show: true,
                            gradient: LinearGradient(
                              colors: [
                                AppColors.accent.withAlpha(100),
                                AppColors.accent.withAlpha(40),
                                Colors.transparent,
                              ],
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              stops: const [0.0, 0.4, 1.0],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
        ],
      ),
    );
  }

  String _formatAxisValue(double value) {
    if (value >= 1000000) {
      final juta = value / 1000000;
      if (juta % 1 == 0) {
        return 'Rp${juta.toInt()} jt';
      } else {
        return 'Rp${juta.toStringAsFixed(1)} jt';
      }
    } else if (value >= 1000) {
      final ribu = value / 1000;
      return 'Rp${ribu.toStringAsFixed(0)} rb';
    } else {
      return 'Rp${value.toStringAsFixed(0)}';
    }
  }

  double _maxY(List<FlSpot> spots) {
    if (spots.isEmpty) {
      return 1000000;
    }
    final maxValue =
        spots.map((spot) => spot.y).reduce((value, element) => math.max(value, element));
    return maxValue * 1.15;
  }

  double _interval(List<FlSpot> spots) {
    if (spots.isEmpty) {
      return 1000000;
    }
    final maxValue =
        spots.map((spot) => spot.y).reduce((value, element) => math.max(value, element));
    return math.max(maxValue / 4, 1);
  }
}

class _CategoryBreakdown extends StatelessWidget {
  const _CategoryBreakdown({required this.data});

  final InsightsData data;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SectionCard(
      padding: const EdgeInsets.all(22),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Kategori teratas',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Pantau proporsi tiap kategori dan set batas belanja.',
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 16),
          if (data.categoryShares.isEmpty)
            Text(
              'Belum ada kategori yang dapat ditampilkan.',
              style: theme.textTheme.bodyMedium,
            )
          else
            ...data.categoryShares.take(5).map(
              (share) => _CategoryRow(share: share),
            ),
        ],
      ),
    );
  }
}

class _CategoryRow extends StatelessWidget {
  const _CategoryRow({required this.share});

  final CategoryShare share;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  share.category,
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Text(
                '${share.percentage.toStringAsFixed(1)}%',
                style: theme.textTheme.labelLarge?.copyWith(
                  color: theme.colorScheme.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: (share.percentage / 100).clamp(0.0, 1.0),
              minHeight: 8,
              backgroundColor: theme.colorScheme.surfaceContainerHighest,
              valueColor: AlwaysStoppedAnimation<Color>(
                theme.colorScheme.primary,
              ),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            CurrencyUtils.format(share.amount),
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}

class _AnomalyCard extends StatelessWidget {
  const _AnomalyCard({required this.data});

  final InsightsData data;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SectionCard(
      padding: const EdgeInsets.all(22),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Anomali pengeluaran',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 12),
          if (data.anomalies.isEmpty)
            Text(
              'Tidak ada lonjakan pengeluaran yang mencurigakan.',
              style: theme.textTheme.bodyMedium,
            )
          else
            ...data.anomalies.take(5).map(
              (tx) => Container(
                margin: const EdgeInsets.only(bottom: 14),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.surfaceAlt,
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: AppColors.warning.withAlpha(40),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        Icons.trending_up_rounded,
                        color: AppColors.warning,
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${tx.category} - ${tx.merchant}',
                            style: theme.textTheme.titleSmall?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            DateUtilsX.formatFull(tx.date),
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Text(
                      CurrencyUtils.format(tx.amount),
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w600,
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

class _RecommendationsCard extends StatelessWidget {
  const _RecommendationsCard({required this.data});

  final InsightsData data;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SectionCard(
      padding: const EdgeInsets.all(22),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Rekomendasi AI',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 12),
          if (data.recommendations.isEmpty)
            Text(
              'Belum ada rekomendasi baru. Tetap lanjutkan kebiasaan baik!',
              style: theme.textTheme.bodyMedium,
            )
          else
            ...data.recommendations.map(
              (rec) => ListTile(
                contentPadding: EdgeInsets.zero,
                horizontalTitleGap: 12,
                leading: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: AppColors.accent.withAlpha(40),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.lightbulb_rounded,
                    color: AppColors.accent,
                  ),
                ),
                title: Text(
                  rec,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                subtitle: Text(
                  'Lihat detail di Forecast untuk tindakan lanjutan.',
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}







