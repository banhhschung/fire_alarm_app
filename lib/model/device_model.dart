
import 'dart:convert';

import 'package:fire_alarm_app/model/device_param_model.dart';
import 'package:fire_alarm_app/utils/common_utils.dart';
import 'package:hive_flutter/hive_flutter.dart';

part 'adapters/device_model.g.dart';

Device deviceFromJson(String str) => Device.fromMap(json.decode(str));

String deviceToJson(Device data) => json.encode(data.toMap());

@HiveType(typeId: 5)
class Device extends HiveObject {
  static const int DEVICE_STATUS_CONNECTED = 1;
  static const int DEVICE_STATUS_DISCONNECTED = 0;
  static const int DEVICE_STATUS_UNKNOWN = 2;
  static const int DEVICE_IS_OWN = 1;
  static const int DEVICE_IS_SHARED = 2;
  static const int DEVICE_FOLK_UPDATE = 1;
  static const int DEVICE_NO_HAVE_UPDATE = 2;
  static const int DEVICE_UPDATE_FROM_WIFI_TO_MESH = 9;

  @HiveField(1)
  int? id;

  @HiveField(2)
  String? name;

  @HiveField(3)
  String? iconPath;

  @HiveField(4)
  int? type; // id cua loai thiet bi

  @HiveField(5)
  String? address; // = deviceId back end gui ve, voi camera la dia chi ip

  @HiveField(6)
  int? subAddress;

  @HiveField(7)
  int? parentId;

  @HiveField(8)
  int? roomId;

  @HiveField(9)
  int? createdUser;

  @HiveField(10)
  int? typeConnect;

  @HiveField(11)
  int? connectMode; // loai ket noi cua thiet bi

  @HiveField(12)
  String? paramsJson;

  @HiveField(13)
  String? userName;

  @HiveField(14)
  String? password;

  @HiveField(15)
  int? code;

  @HiveField(16)
  String? deviceTypeName;

  @HiveField(17)
  String? gatewayId;

  @HiveField(18)
  String? roomName;

  @HiveField(19)
  int? deviceAlert;

  @HiveField(20)
  int? alertActive;

  @HiveField(21)
  String? topicContent;

  @HiveField(22)
  String? topicCommand;

  @HiveField(23)
  String? topicAlert;

  @HiveField(24)
  int? status;

  @HiveField(25)
  int? ownerType;

  @HiveField(26)
  int? otaFolkUpd;

  @HiveField(27)
  String? secretKey; // only smart lock use it

  @HiveField(28)
  String? metadata;

  @HiveField(29)
  String? note;

  @HiveField(30)
  int? favorite;

  @HiveField(31)
  String? activeDate;

  @HiveField(32)
  String? meshConfig;

  @HiveField(33)
  String? version;

  @HiveField(34)
  int? groupType;

  @HiveField(35)
  int? devicePin;

  @HiveField(36)
  int? floorId;

  @HiveField(37)
  String? floorName;

  @HiveField(38)
  String? expireDate;

  @HiveField(39)
  String? deviceNameParent;

  @HiveField(40)
  String? serial;

  @HiveField(41)
  int? connectStatus;

  // dùng trong api danh sách chia sẻ, ko lưu database
  int? share;

  // dùng trong cấu hình các thiết bị vào 1 phòng cụ thể, không lưu database
  bool isSelected = false;

  //save status connect of device, not save to database and BE
  // 0: disconnect, 1: connect, 2, unknown
  // int connectStatus = DEVICE_STATUS_UNKNOWN;

  List<DeviceParamModel> params = [];

  MeshConfigModel? meshConfigModel;

  double? lat;
  double? lon;

  Device({
    this.id,
    this.name,
    this.iconPath,
    this.type,
    this.address,
    this.subAddress,
    this.parentId,
    this.roomId,
    this.createdUser,
    this.paramsJson,
    this.userName,
    this.password,
    this.code,
    this.deviceTypeName,
    this.gatewayId,
    this.roomName,
    this.typeConnect,
    this.deviceAlert,
    this.alertActive,
    this.topicContent,
    this.status,
    this.ownerType,
    this.otaFolkUpd,
    this.secretKey,
    this.activeDate,
    this.expireDate,
    this.metadata,
    this.connectMode,
    this.meshConfig,
    this.meshConfigModel,
    this.version,
    this.groupType,
    this.devicePin,
    this.floorId,
    this.floorName,
    this.share,
    this.isSelected = false,
    this.deviceNameParent,
    this.serial,
    this.lat,
    this.lon,
  });

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {'id': id, 'type': type, 'address': address};

    if (name != null && name != '') {
      map['name'] = name;
    }

    if (devicePin != null ) {
      map['devicePin'] = devicePin;
    }
    if (userName != null && userName != '') {
      map['username'] = userName;
    }

    if (password != null && password != '') {
      map['password'] = password;
    }

    if (parentId != null) {
      map['parentId'] = parentId;
    }

    if (createdUser != null) {
      map['createdUser'] = createdUser;
    }

    if (gatewayId != null) {
      map['gatewayId'] = gatewayId;
    }

    map['paramsJson'] = deviceParamModelToJson(params);

    if (code != null) {
      map['code'] = code;
    }

    if (deviceTypeName != null) {
      map['deviceTypeName'] = deviceTypeName;
    }

    if (subAddress != null) {
      map['subAddress'] = subAddress;
    }

    if (iconPath != null) {
      map['iconPath'] = iconPath;
    }

    if (typeConnect != null) {
      map['typeConnect'] = typeConnect;
    }

    if (deviceAlert != null) {
      map['deviceAlert'] = deviceAlert;
    }

    if (topicContent != null) {
      map['topicContent'] = topicContent;
    }

    if (topicCommand != null) {
      map['topicCommand'] = topicCommand;
    }

    if (topicAlert != null) {
      map['topicAlert'] = topicAlert;
    }

    if (alertActive != null) {
      map['alertActive'] = alertActive;
    }

    if (status != null) {
      map['status'] = status;
    }

    map['roomId'] = roomId;

    if (connectStatus != null) {
      map['connectStatus'] = connectStatus;
    }

    if (ownerType != null) {
      map['ownerType'] = ownerType;
    }

    if (otaFolkUpd != null) {
      map['otaFolkUpd'] = otaFolkUpd;
    }

    if (metadata != null) {
      map['metadata'] = metadata;
    }

    if (activeDate != null){
      map['activeDate'] = activeDate;
    }

    if (expireDate != null){
      map['expireDate'] = expireDate;
    }

    if(connectMode != null) {
      map['connectMode'] = connectMode;
    }

    if(version != null) {
      map['version'] = version;
    }
    if (secretKey != null) {
      map['secretKey'] = secretKey;
    }

    if (groupType != null) {
      map['groupType'] = groupType;
    }

    if (meshConfigModel != null) {
      try {
        map['meshConfig'] = meshConfigModelToJson(meshConfigModel!);
      }
      catch (e) {
      }
    }

    if (floorId != null) {
      map['floorId'] = floorId;
    }

    if (floorName != null) {
      map['floorName'] = floorName;
    }

    if (roomName != null) {
      map['roomName'] = roomName;
    }

    if (share != null) {
      map['share'] = share;
    }

    if (serial != null) {
      map['serial'] = serial;
    }

    return map;
  }

  Device.fromMap(Map<String, dynamic> map) {
    id = map['id'];
    name = map['name'];
    type = map['type'];
    iconPath = map['iconPath'];
    address = map['address'];
    subAddress = map['subAddress'];
    parentId = map['parentId'];
    gatewayId = map['gatewayId'];
    roomId = map['roomId'];
    createdUser = map['createdUser'];
    paramsJson = map['paramsJson'];
    userName = map['userName'];
    password = map['password'];
    code = map['code'];
    deviceTypeName = map['deviceTypeName'];
    roomName = map['roomName'];
    typeConnect = map['typeConnect'];
    connectMode = map['connectMode'];
    deviceAlert = map['deviceAlert'];
    alertActive = map['alertActive'];
    topicContent = map['topicContent'];
    topicCommand = map['topicCommand'];
    topicAlert = map['topicAlert'];
    status = map['status'];
    connectStatus = map['connectStatus'] ?? DEVICE_STATUS_UNKNOWN;
    ownerType = map['ownerType'];
    otaFolkUpd = map['otaFolkUpd'];
    version = map['version'];
    secretKey = map['secretKey'];
    devicePin = map['devicePin'];

    metadata = map['metadata'];
    activeDate = map['activeDate'];
    expireDate = map['expireDate'];
    meshConfig = map['meshConfig'];
    groupType = map['groupType'];
    floorId = map['floorId'];
    share = map['share'];
    floorName = map['floorName'];
    deviceNameParent = map['deviceNameParent'];
    serial = map['serial'];

    if (paramsJson != null &&
        paramsJson!.isNotEmpty &&
        paramsJson != '[]') {
      try {
        params = deviceParamModelFromJson(paramsJson!);
      } catch (e) {
        Common.printLog('decode error : $e');
      }
    }

    paramsJson ??= deviceParamModelToJson(params);

    if (meshConfig != null && meshConfig!.length > 2) {
      try {
        meshConfigModel = meshConfigModelFromJson(meshConfig!);
      }
      catch (e) {
        Common.printLog('meshConfigModel decode error : $e');
      }
    }
  }

  Device.fromBEJson(Map<String, dynamic> map) {
    id = map['id'];
    name = map['name'];
    type = map['type'];
    address = map['deviceId'];
    subAddress = map['subAddress'];
    parentId = map['parentId'];
    iconPath = map['deviceTypeUrlIcon'];
    gatewayId = map['deviceIdParent'];
    roomId = map['roomId'];
    code = map['deviceTypeCode'];
    typeConnect = map['typeConnect'];
    connectMode = map['connectMode'];
    createdUser = map['createdUser'];
    deviceAlert = map['deviceAlert'];
    alertActive = map['alertActive'];
    topicContent = map['topicContent'];
    topicCommand = map['topicCommand'];
    topicAlert = map['topicAlert'];
    status = map['status'];
    ownerType = map['ownerType'];
    otaFolkUpd = map['otaFolkUpd'];
    secretKey = map['secretKey'];
    note = map['note'];
    meshConfig = map['meshConfig'];
    metadata = map['metadata'];
    version = map['version'];
    groupType = map['groupType'];
    devicePin = map['devicePin'];
    roomName = map['roomName'];
    share = map['share'];
    floorId = map['floorId'];
    floorName = map['floorName'];
    deviceNameParent = map['deviceNameParent'];
    serial = map['serial'];

    if (map['deviceParamList'] != null) {
      try {
        params = List<DeviceParamModel>.from(
            map['deviceParamList'].map((x) => DeviceParamModel.fromJson(x)));
        paramsJson = deviceParamModelToJson(params);
      } catch (e) {
        Common.printLog('err : $e');
      }
    }
    if (map['deviceState'] != null) {
      try {
        connectStatus = map['deviceState']['active'] == true ? 1 : 0;
      }
      catch(e) {
        Common.printLog('device err : $e');
      }
    }

    if(map['activeDate'] != null){
      DateTime time = DateTime.parse(map['activeDate']);
      activeDate = '${Common.getTime(time.day)}/${Common.getTime(time.month)}/${time.year}';
    }
    if(map['expireDate'] != null){
      DateTime time = DateTime.parse(map['expireDate']);
      expireDate = '${Common.getTime(time.day)}/${Common.getTime(time.month)}/${time.year}';
    }
    userName = map['username'];
    password = map['password'];
    deviceTypeName = map['deviceTypeName'];

    if (meshConfig != null && meshConfig!.length > 2) {
      try {
        meshConfigModel = meshConfigModelFromJson(meshConfig!);
      }
      catch (e) {
        Common.printLog('meshConfigModel decode error : $e');
      }
    }
  }

  Map<String, dynamic> toBEJson() {
    Map<String, dynamic> map = {'type': type, 'deviceId': address};
    if (name != null) {
      map['name'] = name;
    }
    if (userName != null) {
      map['username'] = userName;
    }
    if (password != null) {
      map['password'] = password;
    }
    if (parentId != null) {
      map['parentId'] = parentId;
    }
    if (createdUser != null) {
      map['createdUser'] = createdUser;
    }
    if (roomId != null) {
      map['roomId'] = roomId;
    }
    if (id != null) {
      map['id'] = id;
    }
    if (code != null) {
      map['code'] = code;
    }
    if (code != null) {
      map['deviceTypeCode'] = code;
    }
    if (deviceTypeName != null) {
      map['deviceTypeName'] = deviceTypeName;
    }
    if (subAddress != null) {
      map['subAddress'] = subAddress;
    }
    if (iconPath != null) {
      map['deviceTypeUrlIcon'] = iconPath;
    }
    if (typeConnect != null) {
      map['typeConnect'] = typeConnect;
    }
    if (connectMode != null) {
      map['connectMode'] = connectMode;
    }
    if (deviceAlert != null) {
      map['deviceAlert'] = deviceAlert;
    }
    if (alertActive != null) {
      map['alertActive'] = alertActive;
    }
    if (topicContent != null) {
      map['topicContent'] = topicContent;
    }
    if (topicCommand != null) {
      map['topicCommand'] = topicCommand;
    }
    if (topicAlert != null) {
      map['topicAlert'] = topicAlert;
    }
    if (status != null) {
      map['status'] = status;
    }
    if (ownerType != null) {
      map['ownerType'] = ownerType;
    }
    if (otaFolkUpd != null) {
      map['otaFolkUpd'] = otaFolkUpd;
    }
    if (metadata != null) {
      map['metadata'] = metadata;
    }

    if (devicePin != null) {
      map['devicePin'] = devicePin;
    }
    if (version != null) {
      map['version'] = version;
    }

    if (groupType != null) {
      map['groupType'] = groupType;
    }

    if (serial != null) {
      map['serial'] = serial;
    }

    if (meshConfigModel != null) {
      try {
        map['meshConfig'] = meshConfigModelToJson(meshConfigModel!);
      }
      catch (e) {
      }
    }

    map["deviceParamList"] = params.map((x) => x.toJson()).toList();

    if (gatewayId != null && gatewayId!.isEmpty) {
      map["deviceIdParent"] = gatewayId;
    } else {
      map["deviceIdParent"] = '';
    }

    if (secretKey != null) {
      map['secretKey'] = secretKey;
    }

    if (share != null) {
      map["share"] = share;
    }

    if (floorId != null) {
      map["floorId"] = floorId;
    }

    if (floorName != null) {
      map["floorName"] = floorName;
    }

    if(lat != null){
      map["lat"] = lat;
    }
    if(lon != null){
      map["lon"] = lon;
    }
    return map;
  }
}

MeshConfigModel meshConfigModelFromJson(String str) => MeshConfigModel.fromJson(json.decode(str));
String meshConfigModelToJson(MeshConfigModel data) => json.encode(data.toJson());

class MeshConfigModel {
  MeshConfigModel({
    this.meshAddress,
    this.ttl,
    this.appKey,
    this.gatewayAddress,
    this.mainGateway
  });

  int? meshAddress;
  int? ttl;
  String? appKey;
  String? gatewayAddress;// lưu địa chỉ của gateway chính trong nhà (kể cả thiết bị wifi được gateway quản lý)
  int? mainGateway; // 1: Gateway chính, 2: gateway phụ

  factory MeshConfigModel.fromJson(Map<String, dynamic> json) => MeshConfigModel(
    meshAddress: json["meshAddress"],
    ttl: json["ttl"],
    appKey: json["appKey"],
    gatewayAddress: json["gatewayAddress"],
    mainGateway: json["mainGateway"],
  );

  Map<String, dynamic> toJson() => {
    "meshAddress": meshAddress,
    "ttl": ttl,
    "appKey": appKey,
    "gatewayAddress": gatewayAddress,
    "mainGateway": mainGateway,
  };
}