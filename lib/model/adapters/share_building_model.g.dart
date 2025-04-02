// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../share_building_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ShareBuildingModelAdapter extends TypeAdapter<ShareBuildingModel> {
  @override
  final int typeId = 8;

  @override
  ShareBuildingModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ShareBuildingModel(
      id: fields[1] as int?,
      buildingId: fields[2] as int?,
      userId: fields[3] as int?,
      type: fields[4] as int?,
      createdDate: fields[5] as String?,
      userName: fields[6] as String?,
      uuid: fields[7] as String?,
      email: fields[8] as String?,
      phoneNumber: fields[9] as String?,
      expiredDate: fields[10] as String?,
      expiredTime: fields[11] as int?,
    );
  }

  @override
  void write(BinaryWriter writer, ShareBuildingModel obj) {
    writer
      ..writeByte(11)
      ..writeByte(1)
      ..write(obj.id)
      ..writeByte(2)
      ..write(obj.buildingId)
      ..writeByte(3)
      ..write(obj.userId)
      ..writeByte(4)
      ..write(obj.type)
      ..writeByte(5)
      ..write(obj.createdDate)
      ..writeByte(6)
      ..write(obj.userName)
      ..writeByte(7)
      ..write(obj.uuid)
      ..writeByte(8)
      ..write(obj.email)
      ..writeByte(9)
      ..write(obj.phoneNumber)
      ..writeByte(10)
      ..write(obj.expiredDate)
      ..writeByte(11)
      ..write(obj.expiredTime);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ShareBuildingModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
