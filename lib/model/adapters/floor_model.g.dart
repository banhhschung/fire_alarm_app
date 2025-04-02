// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../floor_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class FloorAdapter extends TypeAdapter<FloorModel> {
  @override
  final int typeId = 3;

  @override
  FloorModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return FloorModel(
      id: fields[1] as int?,
      name: fields[2] as String?,
      homeId: fields[3] as int?,
    );
  }

  @override
  void write(BinaryWriter writer, FloorModel obj) {
    writer
      ..writeByte(3)
      ..writeByte(1)
      ..write(obj.id)
      ..writeByte(2)
      ..write(obj.name)
      ..writeByte(3)
      ..write(obj.homeId);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FloorAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
