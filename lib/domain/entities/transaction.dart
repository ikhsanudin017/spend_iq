import 'package:freezed_annotation/freezed_annotation.dart';

part 'transaction.freezed.dart';

@freezed
class Transaction with _$Transaction {
  const factory Transaction({
    required String id,
    required String accountId,
    required DateTime date,
    required double amount,
    required String category,
    required String merchant,
    String? note,
  }) = _Transaction;
}
