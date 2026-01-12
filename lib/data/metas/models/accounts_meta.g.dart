// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'accounts_meta.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$AccountsMetaImpl _$$AccountsMetaImplFromJson(Map<String, dynamic> json) =>
    _$AccountsMetaImpl(
      accountId: json['accountId'] as String,
      name: json['name'] as String,
      bankName: json['bankName'] as String,
      accountNumberMasked: json['accountNumberMasked'] as String,
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$$AccountsMetaImplToJson(_$AccountsMetaImpl instance) =>
    <String, dynamic>{
      'accountId': instance.accountId,
      'name': instance.name,
      'bankName': instance.bankName,
      'accountNumberMasked': instance.accountNumberMasked,
      'updatedAt': instance.updatedAt.toIso8601String(),
    };
