// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../building_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class BuildingModelAdapter extends TypeAdapter<BuildingModel> {
  @override
  final int typeId = 2;

  @override
  BuildingModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return BuildingModel(
      id: fields[1] as int?,
      name: fields[2] as String?,
      userId: fields[3] as int?,
      type: fields[4] as int?,
      imageUrl: fields[5] as String?,
      address: fields[6] as String?,
      provinceCode: fields[7] as String?,
      provinceId: fields[8] as int?,
      districtId: fields[9] as int?,
      districtName: fields[10] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, BuildingModel obj) {
    writer
      ..writeByte(10)
      ..writeByte(1)
      ..write(obj.id)
      ..writeByte(2)
      ..write(obj.name)
      ..writeByte(3)
      ..write(obj.userId)
      ..writeByte(4)
      ..write(obj.type)
      ..writeByte(5)
      ..write(obj.imageUrl)
      ..writeByte(6)
      ..write(obj.address)
      ..writeByte(7)
      ..write(obj.provinceCode)
      ..writeByte(8)
      ..write(obj.provinceId)
      ..writeByte(9)
      ..write(obj.districtId)
      ..writeByte(10)
      ..write(obj.districtName);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BuildingModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
