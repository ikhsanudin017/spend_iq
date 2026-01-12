import 'package:flutter/material.dart';

import '../../core/utils/currency.dart';
import '../../data/metas/facade/accounts_read_facade.dart';

class AccountSummaryCard extends StatelessWidget {
  const AccountSummaryCard({
    super.key,
    required this.view,
    this.onEditMeta,
  });

  final AccountView view;
  final VoidCallback? onEditMeta;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final initials = _initials(view.name);
    final balanceText = CurrencyUtils.format(view.balance);

    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: theme.colorScheme.primary.withAlpha(40)),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          CircleAvatar(
            radius: 20,
            backgroundColor: theme.colorScheme.primary.withAlpha(40),
            child: Text(
              initials,
              style: theme.textTheme.titleMedium?.copyWith(
                color: theme.colorScheme.primary,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        view.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      balanceText,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 2),
                Text(
                  view.bankName,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.textTheme.bodySmall?.color?.withAlpha(180),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  view.accountNumberMasked,
                  style: theme.textTheme.bodySmall,
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          IconButton(
            onPressed: onEditMeta,
            icon: const Icon(Icons.edit_outlined),
            tooltip: 'Edit',
            color: theme.colorScheme.primary,
          ),
        ],
      ),
    );
  }

  String _initials(String name) {
    final parts = name.trim().split(RegExp(r'\s+'));
    if (parts.isEmpty) return 'A';
    if (parts.length == 1) return parts.first.substring(0, 1).toUpperCase();
    return (parts[0].isNotEmpty ? parts[0][0] : '') +
        (parts[1].isNotEmpty ? parts[1][0] : '');
  }
}



