import 'package:hive/hive.dart';

import 'accounts_meta.dart';

/// Manual Hive Adapter for AccountsMeta
/// Generated manually because of dependency conflicts with hive_generator
class AccountsMetaAdapter extends TypeAdapter<AccountsMeta> {
  @override
  final int typeId = 41;

  @override
  AccountsMeta read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return AccountsMeta(
      accountId: fields[0] as String,
      name: fields[1] as String,
      bankName: fields[2] as String,
      accountNumberMasked: fields[3] as String,
      updatedAt: fields[4] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, AccountsMeta obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.accountId)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.bankName)
      ..writeByte(3)
      ..write(obj.accountNumberMasked)
      ..writeByte(4)
      ..write(obj.updatedAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AccountsMetaAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

