// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../device_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class DeviceAdapter extends TypeAdapter<Device> {
  @override
  final int typeId = 5;

  @override
  Device read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Device(
      id: fields[1] as int?,
      name: fields[2] as String?,
      iconPath: fields[3] as String?,
      type: fields[4] as int?,
      address: fields[5] as String?,
      subAddress: fields[6] as int?,
      parentId: fields[7] as int?,
      roomId: fields[8] as int?,
      createdUser: fields[9] as int?,
      paramsJson: fields[12] as String?,
      userName: fields[13] as String?,
      password: fields[14] as String?,
      code: fields[15] as int?,
      deviceTypeName: fields[16] as String?,
      gatewayId: fields[17] as String?,
      roomName: fields[18] as String?,
      typeConnect: fields[10] as int?,
      deviceAlert: fields[19] as int?,
      alertActive: fields[20] as int?,
      topicContent: fields[21] as String?,
      status: fields[24] as int?,
      ownerType: fields[25] as int?,
      otaFolkUpd: fields[26] as int?,
      secretKey: fields[27] as String?,
      activeDate: fields[31] as String?,
      expireDate: fields[38] as String?,
      metadata: fields[28] as String?,
      connectMode: fields[11] as int?,
      meshConfig: fields[32] as String?,
      version: fields[33] as String?,
      groupType: fields[34] as int?,
      devicePin: fields[35] as int?,
      floorId: fields[36] as int?,
      floorName: fields[37] as String?,
      deviceNameParent: fields[39] as String?,
      serial: fields[40] as String?,
    )
      ..topicCommand = fields[22] as String?
      ..topicAlert = fields[23] as String?
      ..note = fields[29] as String?
      ..favorite = fields[30] as int?
      ..connectStatus = fields[41] as int?;
  }

  @override
  void write(BinaryWriter writer, Device obj) {
    writer
      ..writeByte(41)
      ..writeByte(1)
      ..write(obj.id)
      ..writeByte(2)
      ..write(obj.name)
      ..writeByte(3)
      ..write(obj.iconPath)
      ..writeByte(4)
      ..write(obj.type)
      ..writeByte(5)
      ..write(obj.address)
      ..writeByte(6)
      ..write(obj.subAddress)
      ..writeByte(7)
      ..write(obj.parentId)
      ..writeByte(8)
      ..write(obj.roomId)
      ..writeByte(9)
      ..write(obj.createdUser)
      ..writeByte(10)
      ..write(obj.typeConnect)
      ..writeByte(11)
      ..write(obj.connectMode)
      ..writeByte(12)
      ..write(obj.paramsJson)
      ..writeByte(13)
      ..write(obj.userName)
      ..writeByte(14)
      ..write(obj.password)
      ..writeByte(15)
      ..write(obj.code)
      ..writeByte(16)
      ..write(obj.deviceTypeName)
      ..writeByte(17)
      ..write(obj.gatewayId)
      ..writeByte(18)
      ..write(obj.roomName)
      ..writeByte(19)
      ..write(obj.deviceAlert)
      ..writeByte(20)
      ..write(obj.alertActive)
      ..writeByte(21)
      ..write(obj.topicContent)
      ..writeByte(22)
      ..write(obj.topicCommand)
      ..writeByte(23)
      ..write(obj.topicAlert)
      ..writeByte(24)
      ..write(obj.status)
      ..writeByte(25)
      ..write(obj.ownerType)
      ..writeByte(26)
      ..write(obj.otaFolkUpd)
      ..writeByte(27)
      ..write(obj.secretKey)
      ..writeByte(28)
      ..write(obj.metadata)
      ..writeByte(29)
      ..write(obj.note)
      ..writeByte(30)
      ..write(obj.favorite)
      ..writeByte(31)
      ..write(obj.activeDate)
      ..writeByte(32)
      ..write(obj.meshConfig)
      ..writeByte(33)
      ..write(obj.version)
      ..writeByte(34)
      ..write(obj.groupType)
      ..writeByte(35)
      ..write(obj.devicePin)
      ..writeByte(36)
      ..write(obj.floorId)
      ..writeByte(37)
      ..write(obj.floorName)
      ..writeByte(38)
      ..write(obj.expireDate)
      ..writeByte(39)
      ..write(obj.deviceNameParent)
      ..writeByte(40)
      ..write(obj.serial)
      ..writeByte(41)
      ..write(obj.connectStatus);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DeviceAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
