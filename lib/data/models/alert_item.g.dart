// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'alert_item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$AlertItemModelImpl _$$AlertItemModelImplFromJson(Map<String, dynamic> json) =>
    _$AlertItemModelImpl(
      id: json['id'] as String,
      type: $enumDecode(_$AlertItemTypeEnumMap, json['type']),
      title: json['title'] as String,
      detail: json['detail'] as String,
      date: const DateTimeIsoConverter().fromJson(json['date'] as String),
      read: json['read'] as bool? ?? false,
    );

Map<String, dynamic> _$$AlertItemModelImplToJson(
        _$AlertItemModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'type': _$AlertItemTypeEnumMap[instance.type]!,
      'title': instance.title,
      'detail': instance.detail,
      'date': const DateTimeIsoConverter().toJson(instance.date),
      'read': instance.read,
    };

const _$AlertItemTypeEnumMap = {
  AlertItemType.bill: 'bill',
  AlertItemType.risk: 'risk',
  AlertItemType.save: 'save',
};
