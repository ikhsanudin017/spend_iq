// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transaction.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$TransactionModelImpl _$$TransactionModelImplFromJson(
        Map<String, dynamic> json) =>
    _$TransactionModelImpl(
      id: json['id'] as String,
      accountId: json['accountId'] as String,
      date: const DateTimeIsoConverter().fromJson(json['date'] as String),
      amount: (json['amount'] as num).toDouble(),
      category: json['category'] as String,
      merchant: json['merchant'] as String,
      note: json['note'] as String?,
    );

Map<String, dynamic> _$$TransactionModelImplToJson(
        _$TransactionModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'accountId': instance.accountId,
      'date': const DateTimeIsoConverter().toJson(instance.date),
      'amount': instance.amount,
      'category': instance.category,
      'merchant': instance.merchant,
      'note': instance.note,
    };
