// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../account_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class AccountAdapter extends TypeAdapter<Account> {
  @override
  final int typeId = 1;

  @override
  Account read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Account(
      id: fields[0] as int?,
      gender: fields[1] as int?,
      name: fields[4] as String?,
      providerId: fields[2] as String?,
      email: fields[5] as String?,
      password: fields[6] as String?,
      iconPath: fields[7] as String?,
      birthDay: fields[8] as String?,
      phone: fields[9] as String?,
      address: fields[10] as String?,
      uuid: fields[3] as String?,
      provinceCode: fields[11] as String?,
      lat: fields[12] as String?,
      lon: fields[13] as String?,
      provinceId: fields[14] as int?,
      weatherContent: fields[15] as String?,
      districtId: fields[16] as int?,
      districtName: fields[17] as String?,
      phonePin: fields[18] as String?,
      pin: fields[19] as String?,
      statusOfPin: fields[20] as int?,
      activeTimePin: fields[21] as int?,
    );
  }

  @override
  void write(BinaryWriter writer, Account obj) {
    writer
      ..writeByte(22)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.gender)
      ..writeByte(2)
      ..write(obj.providerId)
      ..writeByte(3)
      ..write(obj.uuid)
      ..writeByte(4)
      ..write(obj.name)
      ..writeByte(5)
      ..write(obj.email)
      ..writeByte(6)
      ..write(obj.password)
      ..writeByte(7)
      ..write(obj.iconPath)
      ..writeByte(8)
      ..write(obj.birthDay)
      ..writeByte(9)
      ..write(obj.phone)
      ..writeByte(10)
      ..write(obj.address)
      ..writeByte(11)
      ..write(obj.provinceCode)
      ..writeByte(12)
      ..write(obj.lat)
      ..writeByte(13)
      ..write(obj.lon)
      ..writeByte(14)
      ..write(obj.provinceId)
      ..writeByte(15)
      ..write(obj.weatherContent)
      ..writeByte(16)
      ..write(obj.districtId)
      ..writeByte(17)
      ..write(obj.districtName)
      ..writeByte(18)
      ..write(obj.phonePin)
      ..writeByte(19)
      ..write(obj.pin)
      ..writeByte(20)
      ..write(obj.statusOfPin)
      ..writeByte(21)
      ..write(obj.activeTimePin);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AccountAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
