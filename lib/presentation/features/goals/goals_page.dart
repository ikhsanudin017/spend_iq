import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/colors.dart';
import '../../../core/router/app_router.dart';
import '../../../core/utils/currency.dart';
import '../../../core/utils/date.dart';
import '../../../domain/entities/goal.dart';
import '../../../domain/usecases/get_goals.dart';

class GoalsPage extends ConsumerWidget {
  const GoalsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final goals = ref.watch(goalsControllerProvider);
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      appBar: AppBar(        title: const Text('Tujuan Keuangan'),
        actions: [
          IconButton(            tooltip: 'Profil',
            icon: const Icon(Icons.person_outline),
            onPressed: () => context.push(AppRoute.profile.path),
          ),
        ],
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showGoalForm(context, ref, null),
        icon: const Icon(Icons.flag_rounded),
        label: const Text('Tambah Tujuan'),
      ),
      body: goals.when(
        data: (items) {
          if (items.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.flag_outlined, size: 64),
                    const SizedBox(height: 16),
                    Text(
                      'Belum ada tujuan. Tambah tujuan untuk memantau progres tabungan dan estimasi waktu tercapai.',
                      style: theme.textTheme.bodyMedium,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 24),
                    FilledButton.icon(
                      onPressed: () => _showGoalForm(context, ref, null),
                      icon: const Icon(Icons.add_rounded),
                      label: const Text('Buat Tujuan'),
                    ),
                  ],
                ),
              ),
            );
          }

          final totalTarget = items.fold<double>(
            0,
            (sum, goal) => sum + goal.targetAmount,
          );
          final totalCurrent = items.fold<double>(
            0,
            (sum, goal) => sum + goal.currentAmount,
          );
          final overallProgress = totalTarget == 0
              ? 0.0
              : (totalCurrent / totalTarget).clamp(0.0, 1.0).toDouble();
          final activeGoals = items
              .where((goal) => goal.currentAmount < goal.targetAmount)
              .length;
          final nearestGoal = (items.toList()
                ..sort((a, b) => a.dueDate.compareTo(b.dueDate)))
              .first;

          return ListView(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
            children: [
              _GoalsHeroCard(
                totalTarget: totalTarget,
                totalCurrent: totalCurrent,
                progress: overallProgress,
                activeGoals: activeGoals,
                nearestGoal: nearestGoal,
              ),
              const SizedBox(height: 24),
              ...items.map(
                (goal) => _GoalCard(
                  goal: goal,
                  onEdit: () => _showGoalForm(context, ref, goal),
                  onDelete: () => ref
                      .read(goalsControllerProvider.notifier)
                      .deleteGoal(goal.id),
                ),
              ),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) => Center(
          child: Text('Gagal memuat goals: $error'),
        ),
      ),
    );
  }

  Future<void> _showGoalForm(
    BuildContext context,
    WidgetRef ref,
    Goal? goal,
  ) async {
    final formKey = GlobalKey<FormState>();
    final nameController = TextEditingController(text: goal?.name ?? '');
    final targetController = TextEditingController(
      text: goal != null ? goal.targetAmount.toStringAsFixed(0) : '',
    );
    final currentController = TextEditingController(
      text: goal != null ? goal.currentAmount.toStringAsFixed(0) : '',
    );
    final monthlyController = TextEditingController(
      text: goal != null ? goal.monthlyPlan.toStringAsFixed(0) : '',
    );
    var dueDate =
        goal?.dueDate ?? DateTime.now().add(const Duration(days: 180));

    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Theme.of(context).colorScheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (context) => StatefulBuilder(
        builder: (context, setModalState) => Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
            left: 20,
            right: 20,
            top: 24,
          ),
          child: Form(
            key: formKey,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 48,
                    height: 4,
                    margin: const EdgeInsets.only(bottom: 18),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.outlineVariant,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  Text(
                    goal == null ? 'Tambah Tujuan' : 'Edit Tujuan',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: nameController,
                    decoration: const InputDecoration(labelText: 'Nama tujuan'),
                    validator: (value) => value == null || value.isEmpty
                        ? 'Nama wajib diisi'
                        : null,
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: targetController,
                    decoration: const InputDecoration(
                      labelText: 'Target dana',
                      prefixText: 'Rp ',
                    ),
                    keyboardType: TextInputType.number,
                    validator: (value) =>
                        (double.tryParse(value ?? '') ?? 0) <= 0
                            ? 'Harus lebih dari 0'
                            : null,
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: currentController,
                    decoration: const InputDecoration(
                      labelText: 'Dana terkumpul',
                      prefixText: 'Rp ',
                    ),
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: monthlyController,
                    decoration: const InputDecoration(
                      labelText: 'Rencana bulanan',
                      prefixText: 'Rp ',
                    ),
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: 12),
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text('Tenggat - ${DateUtilsX.formatFull(dueDate)}'),
                    trailing: IconButton(
                      icon: const Icon(Icons.calendar_today_rounded),
                      onPressed: () async {
                        final picked = await showDatePicker(
                          context: context,
                          initialDate: dueDate,
                          firstDate: DateTime.now(),
                          lastDate:
                              DateTime.now().add(const Duration(days: 1095)),
                        );
                        if (picked != null) {
                          setModalState(() {
                            dueDate = picked;
                          });
                        }
                      },
                    ),
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton(
                      onPressed: () {
                        if (!formKey.currentState!.validate()) {
                          return;
                        }
                        final notifier =
                            ref.read(goalsControllerProvider.notifier);
                        final newGoal = Goal(
                          id: goal?.id ??
                              DateTime.now().millisecondsSinceEpoch.toString(),
                          name: nameController.text.trim(),
                          targetAmount: double.parse(targetController.text),
                          currentAmount:
                              double.tryParse(currentController.text) ?? 0,
                          monthlyPlan:
                              double.tryParse(monthlyController.text) ?? 0,
                          dueDate: dueDate,
                        );
                        notifier.upsertGoal(newGoal);
                        Navigator.of(context).pop();
                      },
                      child: Text(
                        goal == null ? 'Simpan Tujuan' : 'Perbarui Tujuan',
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _GoalsHeroCard extends StatelessWidget {
  const _GoalsHeroCard({
    required this.totalTarget,
    required this.totalCurrent,
    required this.progress,
    required this.activeGoals,
    required this.nearestGoal,
  });

  final double totalTarget;
  final double totalCurrent;
  final double progress;
  final int activeGoals;
  final Goal nearestGoal;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.primary, AppColors.primaryLight],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.all(Radius.circular(28)),
        boxShadow: [
          BoxShadow(
            color: Color(0x261E3A8A),
            blurRadius: 32,
            offset: Offset(0, 20),
          ),
        ],
      ),
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Progress tujuan',
            style: theme.textTheme.titleLarge?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 16),
          LinearProgressIndicator(
            value: progress,
            minHeight: 10,
            backgroundColor: Colors.white.withAlpha(38),
            valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
            borderRadius: BorderRadius.circular(12),
          ),
          const SizedBox(height: 20),
          Wrap(
            spacing: 16,
            runSpacing: 16,
            children: [
              _GoalsHeroStat(
                label: 'Dana terkumpul',
                value: CurrencyUtils.format(totalCurrent),
                caption: 'Dari target ${CurrencyUtils.format(totalTarget)}',
              ),
              _GoalsHeroStat(
                label: 'Tujuan aktif',
                value: '$activeGoals',
                caption: 'Sedang mengejar target',
              ),
              _GoalsHeroStat(
                label: 'Tenggat terdekat',
                value: nearestGoal.name,
                caption: DateUtilsX.formatFull(nearestGoal.dueDate),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _GoalsHeroStat extends StatelessWidget {
  const _GoalsHeroStat({
    required this.label,
    required this.value,
    required this.caption,
  });

  final String label;
  final String value;
  final String caption;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white.withAlpha(36),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: theme.textTheme.labelMedium?.copyWith(
              color: Colors.white.withAlpha(220),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: theme.textTheme.titleMedium?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            caption,
            style: theme.textTheme.bodySmall?.copyWith(
              color: Colors.white.withAlpha(210),
            ),
          ),
        ],
      ),
    );
  }
}

class _GoalCard extends StatelessWidget {
  const _GoalCard({
    required this.goal,
    required this.onEdit,
    required this.onDelete,
  });

  final Goal goal;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final progress =
        (goal.currentAmount / goal.targetAmount).clamp(0, 1).toDouble();
    final remaining = goal.targetAmount - goal.currentAmount;

    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(26),
        border: Border.all(color: AppColors.surfaceAlt),
        boxShadow: const [
          BoxShadow(
            color: Color(0x151E3A8A),
            blurRadius: 24,
            offset: Offset(0, 16),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.accent.withAlpha(40),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Icon(
                  Icons.flag_rounded,
                  color: AppColors.accent,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      goal.name,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Estimasi tercapai: ${DateUtilsX.formatFull(goal.dueDate)}',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                tooltip: 'Edit tujuan',
                onPressed: onEdit,
                icon: const Icon(Icons.edit_rounded),
              ),
              IconButton(
                tooltip: 'Hapus tujuan',
                onPressed: onDelete,
                icon: const Icon(Icons.delete_outline_rounded),
              ),
            ],
          ),
          const SizedBox(height: 16),
          LinearProgressIndicator(
            value: progress,
            minHeight: 10,
            backgroundColor: theme.colorScheme.surfaceContainerHighest,
            valueColor: AlwaysStoppedAnimation<Color>(
              theme.colorScheme.primary,
            ),
            borderRadius: BorderRadius.circular(10),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: Text(
                  'Terkumpul: ${CurrencyUtils.format(goal.currentAmount)}',
                  style: theme.textTheme.bodyMedium,
                ),
              ),
              Text(
                'Target: ${CurrencyUtils.format(goal.targetAmount)}',
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'Sisa ${CurrencyUtils.format(remaining)} - Rencana bulanan ${CurrencyUtils.format(goal.monthlyPlan)}',
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}




