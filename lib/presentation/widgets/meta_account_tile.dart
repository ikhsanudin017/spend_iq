import 'package:flutter/material.dart';

class MetaAccountTile extends StatelessWidget {
  const MetaAccountTile({
    super.key,
    required this.name,
    required this.bankName,
    required this.maskedNumber,
    required this.balanceText,
    required this.onEdit,
    required this.onDelete,
  });

  final String name;
  final String bankName;
  final String maskedNumber;
  final String balanceText;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final initial = name.isNotEmpty ? name.characters.first.toUpperCase() : 'A';

    return Card(
      clipBehavior: Clip.hardEdge,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 2,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        leading: CircleAvatar(
          radius: 24,
          backgroundColor: colorScheme.primary.withValues(alpha: 0.12),
          child: Text(
            initial,
            style: theme.textTheme.titleMedium?.copyWith(
              color: colorScheme.primary,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        title: Text(
          name,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w700,
            color: colorScheme.onSurface,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text(
              bankName,
              style: theme.textTheme.bodySmall?.copyWith(
                color: colorScheme.onSurfaceVariant,
                height: 1.2,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              maskedNumber,
              style: theme.textTheme.labelMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
                letterSpacing: 0.3,
              ),
            ),
          ],
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  balanceText,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: colorScheme.onSurface,
                  ),
                ),
              ],
            ),
            const SizedBox(width: 8),
            PopupMenuButton<_MetaMenuAction>(
              tooltip: 'Pengaturan metadata',
              onSelected: (value) {
                switch (value) {
                  case _MetaMenuAction.edit:
                    onEdit();
                    break;
                  case _MetaMenuAction.delete:
                    onDelete();
                    break;
                }
              },
              itemBuilder: (_) => const [
                PopupMenuItem(
                  value: _MetaMenuAction.edit,
                  child: Text('Ubah Metadata'),
                ),
                PopupMenuItem(
                  value: _MetaMenuAction.delete,
                  child: Text('Hapus Metadata'),
                ),
              ],
            ),
          ],
        ),
        onTap: onEdit,
      ),
    );
  }
}

enum _MetaMenuAction { edit, delete }
