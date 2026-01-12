// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'account.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$AccountModelImpl _$$AccountModelImplFromJson(Map<String, dynamic> json) =>
    _$AccountModelImpl(
      id: json['id'] as String,
      bankName: json['bankName'] as String,
      masked: json['masked'] as String,
      balance: (json['balance'] as num).toDouble(),
    );

Map<String, dynamic> _$$AccountModelImplToJson(_$AccountModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'bankName': instance.bankName,
      'masked': instance.masked,
      'balance': instance.balance,
    };
