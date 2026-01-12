import 'package:freezed_annotation/freezed_annotation.dart';

import '../../core/utils/json_converters.dart';
import '../../domain/entities/transaction.dart' as domain;

part 'transaction.freezed.dart';
part 'transaction.g.dart';

@freezed
class TransactionModel with _$TransactionModel {
  const factory TransactionModel({
    required String id,
    required String accountId,
    @DateTimeIsoConverter() required DateTime date,
    required double amount,
    required String category,
    required String merchant,
    String? note,
  }) = _TransactionModel;

  const TransactionModel._();

  factory TransactionModel.fromJson(Map<String, dynamic> json) =>
      _$TransactionModelFromJson(json);

  domain.Transaction toEntity() => domain.Transaction(
        id: id,
        accountId: accountId,
        date: date,
        amount: amount,
        category: category,
        merchant: merchant,
        note: note,
      );

  static TransactionModel fromEntity(domain.Transaction entity) =>
      TransactionModel(
        id: entity.id,
        accountId: entity.accountId,
        date: entity.date,
        amount: entity.amount,
        category: entity.category,
        merchant: entity.merchant,
        note: entity.note,
      );
}
