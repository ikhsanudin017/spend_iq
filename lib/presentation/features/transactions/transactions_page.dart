import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/colors.dart';
import '../../../core/router/app_router.dart';
import '../../../core/utils/currency.dart';
import '../../../core/utils/date.dart';
import '../../../data/repositories/finance_repository_impl.dart';
import '../../../domain/entities/transaction.dart';
import '../../widgets/app_page_decoration.dart';

final transactionsProvider = FutureProvider<List<Transaction>>((ref) async {
  final repository = ref.watch(financeRepositoryProvider);
  return repository.getRecentTransactions();
});

class TransactionsPage extends ConsumerStatefulWidget {
  const TransactionsPage({super.key});

  @override
  ConsumerState<TransactionsPage> createState() => _TransactionsPageState();
}

class _TransactionsPageState extends ConsumerState<TransactionsPage> {
  final _searchController = TextEditingController();
  String _searchQuery = '';
  String? _selectedCategory;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<Transaction> _filterTransactions(List<Transaction> transactions) {
    var filtered = transactions;

    if (_searchQuery.isNotEmpty) {
      final query = _searchQuery.toLowerCase();
      filtered = filtered.where((tx) => tx.merchant.toLowerCase().contains(query) ||
            tx.category.toLowerCase().contains(query) ||
            (tx.note?.toLowerCase().contains(query) ?? false)).toList();
    }

    if (_selectedCategory != null) {
      filtered = filtered.where((tx) => tx.category == _selectedCategory).toList();
    }

    return filtered;
  }

  List<String> _getCategories(List<Transaction> transactions) {
    final categories = transactions.map((tx) => tx.category).toSet().toList();
    // ignore: cascade_invocations
    categories.sort();
    return categories;
  }

  @override
  Widget build(BuildContext context) {
    final transactions = ref.watch(transactionsProvider);
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      appBar: AppBar(
        title: const Text('Riwayat Transaksi'),
        actions: [
          IconButton(
            tooltip: 'Profil',
            icon: const Icon(Icons.person_outline),
            onPressed: () => context.push(AppRoute.profile.path),
          ),
        ],
        centerTitle: true,
      ),
      body: transactions.when(
        data: (data) {
          final categories = _getCategories(data);
          final filtered = _filterTransactions(data);
          final sorted = List<Transaction>.from(filtered)
            ..sort((a, b) => b.date.compareTo(a.date));

          return AppPageContainer(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      TextField(
                        controller: _searchController,
                        decoration: InputDecoration(
                          hintText: 'Cari transaksi...',
                          prefixIcon: const Icon(Icons.search_rounded),
                          suffixIcon: _searchQuery.isNotEmpty
                              ? IconButton(
                                  icon: const Icon(Icons.clear_rounded),
                                  onPressed: () {
                                    _searchController.clear();
                                    setState(() => _searchQuery = '');
                                  },
                                )
                              : null,
                        ),
                        onChanged: (value) {
                          setState(() => _searchQuery = value);
                        },
                      ),
                      const SizedBox(height: 12),
                      if (categories.isNotEmpty)
                        SizedBox(
                          height: 40,
                          child: ListView.separated(
                            scrollDirection: Axis.horizontal,
                            itemCount: categories.length + 1,
                            separatorBuilder: (_, __) => const SizedBox(width: 8),
                            itemBuilder: (context, index) {
                              if (index == 0) {
                                final isSelected = _selectedCategory == null;
                                return FilterChip(
                                  label: const Text('Semua'),
                                  selected: isSelected,
                                  onSelected: (selected) {
                                    setState(() => _selectedCategory = null);
                                  },
                                );
                              }
                              final category = categories[index - 1];
                              final isSelected = _selectedCategory == category;
                              return FilterChip(
                                label: Text(category),
                                selected: isSelected,
                                onSelected: (selected) {
                                  setState(() => _selectedCategory = selected ? category : null);
                                },
                              );
                            },
                          ),
                        ),
                    ],
                  ),
                ),
                Expanded(
                  child: sorted.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.receipt_long_rounded,
                                size: 64,
                                color: theme.colorScheme.onSurfaceVariant,
                              ),
                              const SizedBox(height: 16),
                              Text(
                                _searchQuery.isNotEmpty || _selectedCategory != null
                                    ? 'Tidak ada transaksi yang sesuai filter'
                                    : 'Belum ada transaksi',
                                style: theme.textTheme.bodyLarge?.copyWith(
                                  color: theme.colorScheme.onSurfaceVariant,
                                ),
                              ),
                            ],
                          ),
                        )
                      : ListView.separated(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          itemCount: sorted.length,
                          separatorBuilder: (_, __) => const SizedBox(height: 12),
                          itemBuilder: (context, index) {
                            final tx = sorted[index];
                            return _TransactionCard(transaction: tx);
                          },
                        ),
                ),
              ],
            ),
          );
        },
        loading: () => const AppPageContainer(
          child: Center(child: CircularProgressIndicator()),
        ),
        error: (error, stackTrace) => AppPageContainer(
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.error_outline_rounded, size: 48),
                const SizedBox(height: 16),
                Text(
                  'Tidak dapat memuat transaksi: $error',
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodyMedium,
                ),
                const SizedBox(height: 16),
                FilledButton(
                  onPressed: () => ref.invalidate(transactionsProvider),
                  child: const Text('Coba lagi'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _TransactionCard extends StatelessWidget {
  const _TransactionCard({required this.transaction});

  final Transaction transaction;

  Color _getCategoryColor(String category) {
    switch (category.toLowerCase()) {
      case 'income':
        return AppColors.accent;
      case 'bills':
        return AppColors.warning;
      case 'groceries':
        return AppColors.primaryLight;
      case 'dining':
        return AppColors.danger;
      default:
        return AppColors.primary;
    }
  }

  IconData _getCategoryIcon(String category) {
    switch (category.toLowerCase()) {
      case 'income':
        return Icons.arrow_downward_rounded;
      case 'bills':
        return Icons.receipt_long_rounded;
      case 'groceries':
        return Icons.shopping_cart_rounded;
      case 'dining':
        return Icons.restaurant_rounded;
      case 'transport':
        return Icons.directions_car_rounded;
      case 'entertainment':
        return Icons.movie_rounded;
      default:
        return Icons.category_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isIncome = transaction.amount < 0;
    final categoryColor = _getCategoryColor(transaction.category);
    final categoryIcon = _getCategoryIcon(transaction.category);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.surfaceAlt),
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: categoryColor.withAlpha(36),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(categoryIcon, color: categoryColor, size: 24),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  transaction.merchant,
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Text(
                      transaction.category,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                    if (transaction.note != null) ...[
                      const SizedBox(width: 8),
                      Text(
                        '•',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          transaction.note!,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  DateUtilsX.formatFull(transaction.date),
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                CurrencyUtils.format(transaction.amount.abs()),
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: isIncome ? AppColors.accent : theme.colorScheme.onSurface,
                ),
              ),
              const SizedBox(height: 2),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: (isIncome ? AppColors.accent : AppColors.danger).withAlpha(28),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  isIncome ? 'Masuk' : 'Keluar',
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: isIncome ? AppColors.accent : AppColors.danger,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
















