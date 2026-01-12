import 'package:freezed_annotation/freezed_annotation.dart';

part 'account.freezed.dart';

@freezed
class Account with _$Account {
  const factory Account({
    required String id,
    required String bankName,
    required String masked,
    required double balance,
  }) = _Account;
}
