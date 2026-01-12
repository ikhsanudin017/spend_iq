import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/entities/account.dart' as domain;

part 'account.freezed.dart';
part 'account.g.dart';

@freezed
class AccountModel with _$AccountModel {
  const factory AccountModel({
    required String id,
    required String bankName,
    required String masked,
    required double balance,
  }) = _AccountModel;

  const AccountModel._();

  factory AccountModel.fromJson(Map<String, dynamic> json) =>
      _$AccountModelFromJson(json);

  domain.Account toEntity() => domain.Account(
        id: id,
        bankName: bankName,
        masked: masked,
        balance: balance,
      );

  static AccountModel fromEntity(domain.Account entity) => AccountModel(
        id: entity.id,
        bankName: entity.bankName,
        masked: entity.masked,
        balance: entity.balance,
      );
}
