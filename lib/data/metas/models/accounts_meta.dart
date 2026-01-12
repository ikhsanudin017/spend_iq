import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hive/hive.dart';

part 'accounts_meta.freezed.dart';
part 'accounts_meta.g.dart';

@freezed
@HiveType(typeId: 41, adapterName: 'AccountsMetaAdapter')
class AccountsMeta with _$AccountsMeta {
  const factory AccountsMeta({
    @HiveField(0) required String accountId,
    @HiveField(1) required String name,
    @HiveField(2) required String bankName,
    @HiveField(3) required String accountNumberMasked,
    @HiveField(4) required DateTime updatedAt,
  }) = _AccountsMeta;

  const AccountsMeta._();

  factory AccountsMeta.empty({required String accountId}) => AccountsMeta(
        accountId: accountId,
        name: 'Akun',
        bankName: 'Custom',
        accountNumberMasked: '•••• 0000',
        updatedAt: DateTime.now(),
      );

  factory AccountsMeta.fromJson(Map<String, dynamic> json) =>
      _$AccountsMetaFromJson(json);
}
