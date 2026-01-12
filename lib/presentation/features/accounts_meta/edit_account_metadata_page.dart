import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/utils/currency.dart';
import '../../../data/metas/models/accounts_meta.dart';
import '../../../providers/accounts_meta_providers.dart';

class EditAccountMetadataPage extends ConsumerStatefulWidget {
  const EditAccountMetadataPage({super.key, this.accountId});

  final String? accountId;

  @override
  ConsumerState<EditAccountMetadataPage> createState() =>
      _EditAccountMetadataPageState();
}

class _EditAccountMetadataPageState
    extends ConsumerState<EditAccountMetadataPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _maskedController = TextEditingController();
  String? _selectedAccountId;
  String _selectedBank = _bankOptions.first;
  bool _isSaving = false;

  bool get _isEdit => widget.accountId != null;

  @override
  void initState() {
    super.initState();
    _selectedAccountId = widget.accountId;
    Future<void>.microtask(_loadInitial);
  }

  Future<void> _loadInitial() async {
    if (widget.accountId == null) {
      return;
    }
    final metaRepo = ref.read(accountsMetaRepositoryProvider);
    final meta = await metaRepo.getByAccountId(widget.accountId!);
    if (!mounted) return;
    setState(() {
      _nameController.text = meta?.name ?? 'Akun';
      _selectedBank = meta?.bankName ?? _bankOptions.first;
      _maskedController.text = meta?.accountNumberMasked ?? '•••• 0000';
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _maskedController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final accountViewsAsync = ref.watch(accountViewsProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(_isEdit ? 'Edit Metadata Akun' : 'Tambah Metadata Akun'),
      ),
      body: accountViewsAsync.when(
        data: (views) {
          if (!_isEdit && _selectedAccountId == null && views.isNotEmpty) {
            _selectedAccountId = views.first.accountId;
          }
          return Form(
            key: _formKey,
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                DropdownButtonFormField<String>(
                  initialValue: _selectedAccountId,
                  items: views
                      .map(
                        (view) => DropdownMenuItem(
                          value: view.accountId,
                          child: Text(
                            '${view.accountId} • ${CurrencyUtils.format(view.balance)}',
                          ),
                        ),
                      )
                      .toList(),
                  onChanged: _isEdit
                      ? null
                      : (value) => setState(() {
                            _selectedAccountId = value;
                          }),
                  decoration: const InputDecoration(
                    labelText: 'Akun',
                  ),
                  validator: (value) =>
                      value == null || value.isEmpty ? 'Pilih akun' : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    labelText: 'Nama Akun',
                    hintText: 'Contoh: Dompet Harian',
                  ),
                  textCapitalization: TextCapitalization.words,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Nama akun wajib diisi';
                    }
                    if (value.trim().length < 3) {
                      return 'Minimal 3 karakter';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  initialValue: _selectedBank,
                  items: _bankOptions
                      .map(
                        (bank) => DropdownMenuItem(
                          value: bank,
                          child: Text(bank),
                        ),
                      )
                      .toList(),
                  onChanged: (value) => setState(() {
                    _selectedBank = value ?? _bankOptions.first;
                  }),
                  decoration: const InputDecoration(
                    labelText: 'Nama Bank',
                  ),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _maskedController,
                  decoration: const InputDecoration(
                    labelText: 'Nomor Rekening (Masked)',
                    hintText: '•••• 1098',
                  ),
                  validator: (value) {
                    final masked = value?.trim() ?? '';
                    final regex = RegExp(r'^•{4}\s\d{4}$');
                    if (masked.isEmpty) {
                      return 'Nomor rekening wajib diisi';
                    }
                    if (!regex.hasMatch(masked)) {
                      return 'Gunakan format •••• 1234';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 32),
                FilledButton(
                  onPressed: _isSaving ? null : _handleSubmit,
                  child: _isSaving
                      ? const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Text('Simpan'),
                ),
                if (_isEdit) ...[
                  const SizedBox(height: 16),
                  OutlinedButton(
                    onPressed: _isSaving ? null : _handleDelete,
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Theme.of(context).colorScheme.error,
                    ),
                    child: const Text('Hapus Metadata'),
                  ),
                ],
              ],
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Text(
              'Tidak dapat memuat daftar akun:\n${error.toString()}',
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _handleSubmit() async {
    if (!_formKey.currentState!.validate()) return;
    final accountId = _selectedAccountId;
    if (accountId == null) return;

    setState(() => _isSaving = true);
    final repo = ref.read(accountsMetaRepositoryProvider);

    final meta = AccountsMeta(
      accountId: accountId,
      name: _nameController.text.trim(),
      bankName: _selectedBank,
      accountNumberMasked: _maskedController.text.trim(),
      updatedAt: DateTime.now(),
    );

    await repo.upsert(meta);
    if (!mounted) return;
    setState(() => _isSaving = false);
    Navigator.of(context).pop();
  }

  Future<void> _handleDelete() async {
    final accountId = _selectedAccountId;
    if (accountId == null) return;

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Hapus metadata?'),
        content: const Text(
          'Tindakan ini hanya menghapus metadata akun. Data saldo dan transaksi tetap aman.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Batal'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Hapus'),
          ),
        ],
      ),
    );

    if (confirmed != true) return;
    setState(() => _isSaving = true);
    final repo = ref.read(accountsMetaRepositoryProvider);
    await repo.remove(accountId);
    if (!mounted) return;
    setState(() => _isSaving = false);
    Navigator.of(context).pop();
  }
}

const List<String> _bankOptions = [
  'BCA',
  'Mandiri',
  'BRI',
  'Jenius',
  'Custom',
];
