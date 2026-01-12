import '../../../data/metas/models/accounts_meta.dart';

const String kDefaultAccountName = 'Akun';
const String kDefaultBankName = 'Custom';
const String kDefaultMaskedNumber = '•••• 0000';

({AccountsMeta meta, bool hasCustom}) resolveMeta(
  AccountsMeta? meta, {
  required String accountId,
}) {
  if (meta == null) {
    return (
      meta: AccountsMeta.empty(accountId: accountId),
      hasCustom: false,
    );
  }
  return (meta: meta, hasCustom: true);
}
