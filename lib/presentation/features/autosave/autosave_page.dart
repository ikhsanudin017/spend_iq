import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/colors.dart';
import '../../../core/router/app_router.dart';
import '../../../core/utils/currency.dart';
import '../../../core/utils/date.dart';
import '../../../core/utils/responsive.dart';
import '../../../domain/entities/autosave_plan.dart';
import '../../../domain/usecases/toggle_autosave.dart';
import '../../../providers/accounts_home_providers.dart';
import '../../../services/notifications_service.dart';
import '../../widgets/error_state.dart';

class AutosavePage extends ConsumerStatefulWidget {
  const AutosavePage({super.key});

  @override
  ConsumerState<AutosavePage> createState() => _AutosavePageState();
}

class _AutosavePageState extends ConsumerState<AutosavePage> {
  List<AutosavePlan> _plans = const [];
  bool _hasUnsavedChanges = false;

  Future<AutosavePlan?> _showAddScheduleDialog(BuildContext context, List<DateTime> suggestedDays) async {
    DateTime selectedDate = suggestedDays.isNotEmpty 
        ? suggestedDays.first 
        : DateTime.now().add(const Duration(days: 3));
    final TextEditingController amountController = TextEditingController(text: '250000');
    
    return showDialog<AutosavePlan>(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: const Text('Tambah Jadwal Autosave'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (suggestedDays.isNotEmpty) ...[
                      const Text(
                        'Rekomendasi Hari Aman',
                        style: TextStyle(fontWeight: FontWeight.w600, fontSize: 12),
                      ),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: suggestedDays.take(4).map((day) {
                          final isSelected = DateUtilsX.isSameDay(day, selectedDate);
                          return ChoiceChip(
                            label: Text(DateUtilsX.formatShort(day)),
                            selected: isSelected,
                            onSelected: (selected) {
                              if (selected) {
                                setDialogState(() {
                                  selectedDate = day;
                                });
                              }
                            },
                          );
                        }).toList(),
                      ),
                      const SizedBox(height: 16),
                    ],
                    const Text(
                      'Atau Pilih Tanggal Manual',
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 12),
                    InkWell(
                      onTap: () async {
                        final picked = await showDatePicker(
                          context: context,
                          initialDate: selectedDate,
                          firstDate: DateTime.now(),
                          lastDate: DateTime.now().add(const Duration(days: 365)),
                        );
                        if (picked != null) {
                          setDialogState(() {
                            selectedDate = picked;
                          });
                        }
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        decoration: BoxDecoration(
                          border: Border.all(color: Theme.of(context).colorScheme.outline),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.calendar_today_rounded),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                DateUtilsX.formatFull(selectedDate),
                                style: Theme.of(context).textTheme.bodyLarge,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'Nominal Tabungan',
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: amountController,
                      decoration: const InputDecoration(
                        labelText: 'Nominal',
                        prefixText: 'Rp ',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(12)),
                        ),
                      ),
                      keyboardType: TextInputType.number,
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Batal'),
                ),
                FilledButton(
                  onPressed: () {
                    final amount = double.tryParse(
                      amountController.text.replaceAll(RegExp(r'[^0-9]'), '')
                    ) ?? 250000;
                    
                    Navigator.pop(
                      context,
                      AutosavePlan(
                        date: DateUtilsX.startOfDay(selectedDate),
                        amount: amount,
                      ),
                    );
                  },
                  child: const Text('Tambah'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Future<void> _handleStartAutosave(double monthlyTotal) async {
    final plansSnapshot = List<AutosavePlan>.from(_plans);
    final notifier = ref.read(autosaveControllerProvider.notifier);
    
    try {
      await notifier.savePlans(plansSnapshot);
      
      // Schedule notifications only if autosave is enabled
      final autosaveState = ref.read(autosaveControllerProvider);
      if (autosaveState.valueOrNull?.enabled ?? false) {
        final notifications = ref.read(notificationsServiceProvider);
        for (final plan in plansSnapshot.where((p) => p.confirmed)) {
          await notifications.scheduleSafeDay(
            date: plan.date,
            amount: plan.amount,
          );
        }
      }
      
      // Reset unsaved changes flag after successful save
      setState(() {
        _hasUnsavedChanges = false;
      });
      
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Rencana autosave disimpan: ${CurrencyUtils.format(monthlyTotal)} bulan ini.',
          ),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final autosave = ref.watch(autosaveControllerProvider);
    final theme = Theme.of(context);
    final horizontalPad = ResponsiveUtils.horizontalPadding(context);
    final verticalPad = ResponsiveUtils.verticalPadding(context);
    final screenHeight = ResponsiveUtils.screenHeight(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      appBar: AppBar(
        title: const Text('Auto-Saving Adaptif'),
        centerTitle: true,
        actions: [
          IconButton(
            tooltip: 'Profil',
            icon: const Icon(Icons.person_outline),
            onPressed: () => context.push(AppRoute.profile.path),
          ),
        ],
      ),
      body: autosave.when(
        data: (data) {
          // Only sync from provider if no unsaved changes
          if (!_hasUnsavedChanges && (_plans.isEmpty || _plans.length != data.plans.length)) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (mounted) {
                setState(() {
                  _plans = List<AutosavePlan>.from(data.plans);
                });
              }
            });
          }
          final monthlyTotal = _plans.fold<double>(
            0,
            (sum, plan) => sum + plan.amount,
          );

          return Column(
            children: [
              Expanded(
                child: ListView(
                  padding: EdgeInsets.fromLTRB(
                    horizontalPad,
                    verticalPad,
                    horizontalPad,
                    verticalPad * 1.5,
                  ),
                  children: [
                    _AutosaveHeroCard(
                      enabled: data.enabled,
                      planCount: _plans.length,
                      monthlyTotal: monthlyTotal,
                      onToggle: () =>
                          ref.read(autosaveControllerProvider.notifier).toggle(),
                    ),
                    const SizedBox(height: 20),
                    _SuggestionCard(
                      enabled: data.enabled,
                      suggestedDays: data.suggestedDays,
                      onRefresh: () => ref
                          .read(autosaveControllerProvider.notifier)
                          .refreshSuggestions(),
                      onAdd: (date) {
                        setState(() {
                          final exists = _plans.any(
                            (plan) => DateUtilsX.isSameDay(plan.date, date),
                          );
                          if (!exists) {
                            _plans = [
                              ..._plans,
                              AutosavePlan(
                                date: date,
                                amount: 250000,
                              ),
                            ]..sort(
                                (a, b) => a.date.compareTo(b.date),
                              );
                            _hasUnsavedChanges = true;
                          }
                        });
                      },
                    ),
                    const SizedBox(height: 24),
                    _PlansSection(
                      plans: _plans,
                      onAmountChanged: (index, amount) {
                        setState(() {
                          final updated = _plans[index]
                              .copyWith(amount: amount.clamp(0, double.infinity));
                          _plans = [
                            ..._plans.take(index),
                            updated,
                            ..._plans.skip(index + 1),
                          ];
                          _hasUnsavedChanges = true;
                        });
                      },
                      onConfirmedChanged: (index, confirmed) {
                        setState(() {
                          final updated =
                              _plans[index].copyWith(confirmed: confirmed);
                          _plans = [
                            ..._plans.take(index),
                            updated,
                            ..._plans.skip(index + 1),
                          ];
                          _hasUnsavedChanges = true;
                        });
                      },
                      onRemove: (index) async {
                        final confirmed = await showDialog<bool>(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: const Text('Hapus Jadwal?'),
                            content: Text(
                              'Yakin ingin menghapus jadwal ${DateUtilsX.formatFull(_plans[index].date)}?',
                            ),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context, false),
                                child: const Text('Batal'),
                              ),
                              FilledButton(
                                onPressed: () => Navigator.pop(context, true),
                                style: FilledButton.styleFrom(
                                  backgroundColor: Theme.of(context).colorScheme.error,
                                ),
                                child: const Text('Hapus'),
                              ),
                            ],
                          ),
                        );

                        if (confirmed == true) {
                          setState(() {
                            _plans = [
                              ..._plans.take(index),
                              ..._plans.skip(index + 1),
                            ];
                            _hasUnsavedChanges = true;
                          });
                          
                          if (mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: const Text('Jadwal dihapus. Klik "Simpan" untuk menyimpan ke database.'),
                                duration: const Duration(seconds: 3),
                                action: SnackBarAction(
                                  label: 'OK',
                                  onPressed: () {},
                                ),
                              ),
                            );
                          }
                        }
                      },
                      onAddPlan: () {
                        setState(() {
                          // Use suggested safe days if available
                          final nextSafeDay = data.suggestedDays.isNotEmpty
                              ? data.suggestedDays.firstWhere(
                                  (day) => !_plans.any((p) => DateUtilsX.isSameDay(p.date, day)),
                                  orElse: () => DateTime.now().add(const Duration(days: 3)),
                                )
                              : DateTime.now().add(const Duration(days: 3));
                          
                          _plans = [
                            ..._plans,
                            AutosavePlan(
                              date: DateUtilsX.startOfDay(nextSafeDay),
                              amount: 200000,
                            ),
                          ]..sort((a, b) => a.date.compareTo(b.date));
                          _hasUnsavedChanges = true;
                        });
                      },
                    ),
                  ],
                ),
              ),
              SafeArea(
                minimum: EdgeInsets.fromLTRB(
                  horizontalPad,
                  verticalPad * 0.75,
                  horizontalPad,
                  verticalPad * 1.5,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    OutlinedButton.icon(
                      onPressed: () async {
                        final result = await _showAddScheduleDialog(context, data.suggestedDays);
                        if (result != null) {
                          setState(() {
                            _plans = [
                              ..._plans,
                              result,
                            ]..sort((a, b) => a.date.compareTo(b.date));
                            _hasUnsavedChanges = true;
                          });
                          
                          if (mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: const Text('Jadwal ditambahkan. Klik "Simpan" untuk menyimpan ke database.'),
                                duration: const Duration(seconds: 3),
                                action: SnackBarAction(
                                  label: 'OK',
                                  onPressed: () {},
                                ),
                              ),
                            );
                          }
                        }
                      },
                      icon: const Icon(Icons.add_rounded),
                      label: const Text('Tambah Jadwal'),
                      style: OutlinedButton.styleFrom(
                        minimumSize: const Size.fromHeight(50),
                      ),
                    ),
                    SizedBox(height: verticalPad),
                    Builder(
                      builder: (context) {
                        final totalBalance = ref.watch(totalBalanceProvider);
                        final canSave = _plans.isNotEmpty && 
                            (totalBalance == 0 || monthlyTotal <= totalBalance * 0.6);
                        
                        return Column(
                          children: [
                            if (_hasUnsavedChanges)
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                margin: const EdgeInsets.only(bottom: 12),
                                decoration: BoxDecoration(
                                  color: theme.colorScheme.secondaryContainer,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      Icons.info_outline,
                                      size: 16,
                                      color: theme.colorScheme.onSecondaryContainer,
                                    ),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: Text(
                                        'Ada perubahan yang belum disimpan',
                                        style: theme.textTheme.bodySmall?.copyWith(
                                          color: theme.colorScheme.onSecondaryContainer,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            FilledButton.icon(
                              style: FilledButton.styleFrom(
                                minimumSize: const Size.fromHeight(56),
                                backgroundColor: canSave 
                                    ? (_hasUnsavedChanges ? theme.colorScheme.primary : theme.colorScheme.primary.withOpacity(0.7))
                                    : theme.colorScheme.error,
                              ),
                              onPressed: canSave
                                  ? () {
                                      _handleStartAutosave(monthlyTotal);
                                      // Show loading indicator briefly
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                          content: Row(
                                            children: [
                                              SizedBox(
                                                width: 20,
                                                height: 20,
                                                child: CircularProgressIndicator(
                                                  strokeWidth: 2,
                                                  valueColor: AlwaysStoppedAnimation<Color>(
                                                    theme.colorScheme.onPrimary,
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(width: 16),
                                              const Text('Menyimpan ke database...'),
                                            ],
                                          ),
                                          duration: const Duration(seconds: 1),
                                        ),
                                      );
                                    }
                                  : null,
                              icon: Icon(_hasUnsavedChanges ? Icons.save : Icons.check_circle_outline),
                              label: Text(
                                _plans.isEmpty
                                    ? 'Tambahkan Jadwal Terlebih Dahulu'
                                    : _hasUnsavedChanges
                                        ? 'Simpan Perubahan ke Database'
                                        : 'Tersimpan',
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                    if (monthlyTotal > 0) ...[
                      const SizedBox(height: 8),
                      Builder(
                        builder: (context) {
                          final totalBalance = ref.watch(totalBalanceProvider);
                          if (totalBalance > 0 && monthlyTotal > totalBalance * 0.5) {
                            return Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: theme.colorScheme.errorContainer,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.warning_rounded,
                                    color: theme.colorScheme.error,
                                    size: 20,
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Text(
                                      'Total autosave (${CurrencyUtils.format(monthlyTotal)}) melebihi 50% saldo. Kurangi jumlah atau tambahkan saldo.',
                                      style: theme.textTheme.bodySmall?.copyWith(
                                        color: theme.colorScheme.onErrorContainer,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }
                          return const SizedBox.shrink();
                        },
                      ),
                    ],
                  ],
                ),
              ),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) => ErrorState(
          message: error.toString().contains('melebihi')
              ? error.toString()
              : 'Tidak dapat memuat autosave. Silakan coba lagi.',
          onRetry: () => ref.invalidate(autosaveControllerProvider),
        ),
      ),
    );
  }
}

class _AutosaveHeroCard extends StatelessWidget {
  const _AutosaveHeroCard({
    required this.enabled,
    required this.planCount,
    required this.monthlyTotal,
    required this.onToggle,
  });

  final bool enabled;
  final int planCount;
  final double monthlyTotal;
  final VoidCallback onToggle;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final padding = ResponsiveUtils.horizontalPadding(context);
    
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.primary,
            AppColors.primaryLight,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.all(Radius.circular(28)),
        boxShadow: [
          BoxShadow(
            color: Color(0x261E3A8A),
            blurRadius: 30,
            offset: Offset(0, 18),
          ),
        ],
      ),
      padding: EdgeInsets.all(padding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      enabled ? 'Safe Days aktif' : 'Safe Days nonaktif',
                      style: theme.textTheme.titleLarge?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      enabled
                          ? 'Kami pantau cashflow dan pilih hari paling aman.'
                          : 'Aktifkan agar Spend-IQ membuat rencana otomatis.',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: Colors.white.withAlpha(220),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Semantics(
                label: 'Toggle mode autosave',
                child: Switch.adaptive(
                  value: enabled,
                  onChanged: (_) => onToggle(),
                  thumbColor: WidgetStateProperty.resolveWith(
                    (states) => states.contains(WidgetState.selected)
                        ? Colors.white
                        : theme.colorScheme.surface,
                  ),
                  trackColor: WidgetStateProperty.resolveWith(
                    (states) => states.contains(WidgetState.selected)
                        ? Colors.white.withAlpha(80)
                        : Colors.white.withAlpha(40),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Wrap(
            spacing: 16,
            runSpacing: 12,
            children: [
              _HeroStat(
                label: 'Target bulan ini',
                value: CurrencyUtils.format(monthlyTotal),
                caption:
                    planCount > 0 ? '$planCount jadwal aktif' : 'Belum ada jadwal',
              ),
              _HeroStat(
                label: 'Rekomendasi Smart AI',
                value: planCount > 0 ? 'Terjadwal' : 'Belum ada',
                caption: planCount > 0
                    ? 'Sesuaikan nominal jika perlu.'
                    : 'Tambahkan rencana agar cashflow optimal.',
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _HeroStat extends StatelessWidget {
  const _HeroStat({
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
        color: Colors.white.withAlpha(30),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: theme.textTheme.labelMedium?.copyWith(
              color: Colors.white.withAlpha(230),
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

class _SuggestionCard extends StatelessWidget {
  const _SuggestionCard({
    required this.enabled,
    required this.suggestedDays,
    required this.onRefresh,
    required this.onAdd,
  });

  final bool enabled;
  final List<DateTime> suggestedDays;
  final VoidCallback onRefresh;
  final ValueChanged<DateTime> onAdd;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(26)),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(22),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  'Rekomendasi Safe Days',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const Spacer(),
                TextButton.icon(
                  onPressed: onRefresh,
                  icon: const Icon(Icons.refresh_rounded),
                  label: const Text('Segarkan'),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              enabled
                  ? 'Tambah hari aman secara instan atau edit sesuai kebutuhan.'
                  : 'Aktifkan Safe Days untuk menerima rekomendasi otomatis.',
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 16),
            if (!enabled)
              Container(
                width: double.infinity,
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: AppColors.surfaceAlt,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Text(
                  'Mode Safe Days belum aktif.',
                  style: theme.textTheme.bodyMedium,
                ),
              )
            else if (suggestedDays.isEmpty)
              Container(
                width: double.infinity,
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: AppColors.surfaceAlt,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Text(
                  'Tidak ada jadwal aman baru saat ini.',
                  style: theme.textTheme.bodyMedium,
                ),
              )
            else
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: suggestedDays
                    .map(
                      (day) => ActionChip(
                        label: Text(DateUtilsX.formatShort(day)),
                        onPressed: () => onAdd(day),
                        avatar: const Icon(Icons.add_rounded, size: 16),
                      ),
                    )
                    .toList(),
              ),
          ],
        ),
      ),
    );
  }
}

class _PlansSection extends StatelessWidget {
  const _PlansSection({
    required this.plans,
    required this.onAmountChanged,
    required this.onConfirmedChanged,
    required this.onRemove,
    required this.onAddPlan,
  });

  final List<AutosavePlan> plans;
  final void Function(int index, double amount) onAmountChanged;
  final void Function(int index, bool confirmed) onConfirmedChanged;
  final void Function(int index) onRemove;
  final VoidCallback onAddPlan;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final spacing = ResponsiveUtils.spacing(context);
    final padding = ResponsiveUtils.horizontalPadding(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Rencana Autosave',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: spacing),
        if (plans.isEmpty)
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(padding),
            decoration: BoxDecoration(
              color: AppColors.surfaceAlt,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              'Belum ada jadwal. Tambahkan minimal dua Safe Days agar cashflow stabil.',
              style: theme.textTheme.bodyMedium,
            ),
          )
        else
          ...plans.asMap().entries.map(
            (entry) {
              final index = entry.key;
              final plan = entry.value;
              final formattedDate = DateUtilsX.formatFull(plan.date);

              return Container(
                margin: EdgeInsets.only(bottom: spacing),
                padding: EdgeInsets.all(padding * 0.9),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surface,
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: AppColors.surfaceAlt),
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0x151E3A8A),
                      blurRadius: 18,
                      offset: Offset(0, 12),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: AppColors.primary.withAlpha(32),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: const Icon(
                            Icons.calendar_today_rounded,
                            color: AppColors.primary,
                            size: 20,
                          ),
                        ),
                        SizedBox(width: spacing),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                formattedDate,
                                style: theme.textTheme.titleSmall?.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              Text(
                                'Hari aman menabung versi Smart AI.',
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color:
                                      theme.colorScheme.onSurfaceVariant,
                                ),
                              ),
                            ],
                          ),
                        ),
                        IconButton.filled(
                          tooltip: 'Hapus jadwal',
                          style: IconButton.styleFrom(
                            backgroundColor: theme.colorScheme.errorContainer,
                            foregroundColor: theme.colorScheme.error,
                          ),
                          onPressed: () => onRemove(index),
                          icon: const Icon(Icons.delete_outline_rounded),
                        ),
                      ],
                    ),
                    SizedBox(height: spacing),
                    TextFormField(
                      key: ValueKey(
                        '${plan.date.toIso8601String()}-${plan.confirmed}',
                      ),
                      initialValue: plan.amount.toStringAsFixed(0),
                      decoration: const InputDecoration(
                        labelText: 'Nominal tabungan',
                        prefixText: 'Rp ',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(12)),
                        ),
                      ),
                      keyboardType: TextInputType.number,
                      onChanged: (value) {
                        final digits =
                            value.replaceAll(RegExp(r'[^0-9]'), '');
                        final parsed =
                            double.tryParse(digits.isEmpty ? '0' : digits) ??
                                plan.amount;
                        onAmountChanged(index, parsed);
                      },
                    ),
                    SizedBox(height: spacing * 0.75),
                    Row(
                      children: [
                        Checkbox.adaptive(
                          value: plan.confirmed,
                          onChanged: (value) =>
                              onConfirmedChanged(index, value ?? false),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'Tandai sebagai sudah disetujui',
                            style: theme.textTheme.bodyMedium,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          ),
      ],
    );
  }
}





