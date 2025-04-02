import 'dart:convert';
import 'dart:developer';

import 'package:fire_alarm_app/model/device_param_model.dart';
import 'package:hive/hive.dart';


ParamGroup paramGroupFromJson(String str) => ParamGroup.fromJson(json.decode(str));

String paramGroupToJson(ParamGroup data) => json.encode(data.toJson());

List<ParamGroup> listParamGroupFromJson(String str) => List<ParamGroup>.from(json.decode(str).map((x) => ParamGroup.fromJson(x)));

String listParamGroupToJson(List<ParamGroup> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

@HiveType(typeId: 7)
class ParamGroup extends HiveObject {

  @HiveField(1)
  int? id;

  @HiveField(2)
  String? deviceName;

  @HiveField(3)
  String? name;

  @HiveField(4)
  int? status;

  @HiveField(5)
  int? type;

  @HiveField(6)
  String? deviceId; // MAC/address của device, không phải id của device

  @HiveField(7)
  int? homeId;

  @HiveField(8)
  int? roomId;

  @HiveField(9)
  int? floorId;

  @HiveField(10)
  int? otaFolkUpd;

  @HiveField(11)
  int? deviceTypeCode;

  @HiveField(12)
  String? deviceParamListJson;

  @HiveField(13)
  int? deviceState; // 1: ON, 0: OFF - giống connectStatus của device

  @HiveField(14)
  int? groupId;

  @HiveField(15)
  String? deviceParam;

  @HiveField(16)
  int? favourite;

  @HiveField(17)
  int? roomOder;

  @HiveField(18)
  int? typeScreen; // nhóm màn hình điều khiển hoặc nhóm màn hình cảm biến -> không dùng nữa

  @HiveField(19)
  String? metadata;

  @HiveField(20)
  String? roomName;

  @HiveField(21)
  int? hide; // 1: hiển thị đối với nhà chia sẻ

  @HiveField(22)
  String? floorName;

  @HiveField(23)
  int? gatewayId;

  @HiveField(24)
  String? iconPath;

  List<DeviceParamModel>? deviceParamList;
  bool? isSelected; // dung trong cac trang seup, chon param group

  bool? isSelectedRule;
  bool? isSwitchOn;

  ParamGroup({
    this.id,
    this.deviceName,
    this.name,
    this.status,
    this.type,
    this.deviceId,
    this.homeId,
    this.roomId,
    this.floorId,
    this.otaFolkUpd,
    this.deviceTypeCode,
    this.deviceParamListJson,
    this.deviceState,
    this.groupId,
    this.deviceParam,
    this.favourite,
    this.roomOder,
    this.typeScreen,
    this.deviceParamList,
    this.isSelected,
    this.roomName,
    this.metadata,
    this.hide,
    this.floorName,
    this.gatewayId,
    this.iconPath
  });

  factory ParamGroup.fromJson(Map<String, dynamic> json) {
    var model = ParamGroup(
        id: json["id"],
        deviceName: json["deviceName"],
        name: json["name"],
        status: json["status"],
        type: json["type"],
        deviceId: json["deviceId"],
        homeId: json["homeId"],
        roomId: json["roomId"],
        floorId: json["floorId"],
        otaFolkUpd: json["otaFolkUpd"],
        deviceTypeCode: json["deviceTypeCode"],
        deviceState: json["deviceState"],
        groupId: json["groupId"],
        deviceParam: json["deviceParam"],
        favourite: json["favourite"],
        roomOder: json["roomOder"],
        typeScreen: json["typeScreen"],
        deviceParamListJson: json['deviceParamListJson'],
        metadata: json['metadata'],
        hide: json['hide'],
        roomName: json['roomName'],
        floorName: json['floorName'],
        gatewayId: json['deviceIdParent'],
        iconPath:  json['iconPath']
    );

    if (json['deviceParamList'] != null) {
      try {
        model.deviceParamList = List<DeviceParamModel>.from(
            json['deviceParamList'].map((x) => DeviceParamModel.fromJson(x)));
        model.deviceParamListJson ??= deviceParamModelToJson(model.deviceParamList!);

      } catch (e) {
        log('err : $e');
      }
    }

    if(json['deviceParamListJson'] != null) {
      model.deviceParamList = deviceParamModelFromJson(json['deviceParamListJson']);
    }

    return model;
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> map = Map<String, dynamic>();
    if (id != null) {
      map['id'] = id;
    }
    if (deviceName != null) {
      map['deviceName'] = deviceName;
    }
    if (name != null) {
      map['name'] = name;
    }
    if (status != null) {
      map['status'] = status;
    }
    if (type != null) {
      map['type'] = type;
    }
    if (deviceId != null) {
      map['deviceId'] = deviceId;
    }
    if (homeId != null) {
      map['homeId'] = homeId;
    }
    if (roomId != null) {
      map['roomId'] = roomId;
    }
    if (roomName != null) {
      map['roomName'] = roomName;
    }
    if (floorId != null) {
      map['floorId'] = floorId;
    }
    if (otaFolkUpd != null) {
      map['otaFolkUpd'] = otaFolkUpd;
    }
    if (deviceTypeCode != null) {
      map['deviceTypeCode'] = deviceTypeCode;
    }
    if (deviceState != null) {
      map['deviceState'] = deviceState;
    }
    if (groupId != null) {
      map['groupId'] = groupId;
    }
    if (deviceParam != null) {
      map['deviceParam'] = deviceParam;
    }
    if (favourite != null) {
      map['favourite'] = favourite;
    }
    if (roomOder != null) {
      map['roomOder'] = roomOder;
    }
    if (typeScreen != null) {
      map['typeScreen'] = typeScreen;
    }
    if(metadata != null) {
      map['metadata'] = metadata;
    }
    if(hide != null) {
      map['hide'] = hide;
    }
    if(deviceParamListJson != null) {
      map['deviceParamListJson'] = deviceParamListJson;
    }
    if(floorName != null) {
      map['floorName'] = floorName;
    }
    if(gatewayId != null) {
      map['deviceIdParent'] = gatewayId;
    }
    if(iconPath != null) {
      map['iconPath'] = iconPath;
    }

    return map;
  }
}