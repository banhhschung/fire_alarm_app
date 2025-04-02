// To parse this JSON data, do
//
//     final mqttMessageAddDeviceModel = mqttMessageAddDeviceModelFromJson(jsonString);

import 'dart:convert';

MqttMessageAddDeviceModel mqttMessageAddDeviceModelFromJson(String str) => MqttMessageAddDeviceModel.fromJson(json.decode(str));

class MqttMessageAddDeviceModel {
  String? name;
  int? devT;
  String? devExtAddr;
  int? timeStamp;
  List<DevList>? devList;

  MqttMessageAddDeviceModel({
    this.name,
    this.devT,
    this.devExtAddr,
    this.timeStamp,
    this.devList,
  });

  factory MqttMessageAddDeviceModel.fromJson(Map<String, dynamic> json) => MqttMessageAddDeviceModel(
    name: json["name"],
    devT: json["devT"],
    devExtAddr: json["devExtAddr"],
    timeStamp: json["timeStamp"],
    devList: List<DevList>.from(json["devList"].map((x) => DevList.fromJson(x))),
  );
}

class DevList {
  int? devT;
  String? devExtAddr;
  int? errorCode;

  DevList({
    this.devT,
    this.devExtAddr,
    this.errorCode,
  });

  factory DevList.fromJson(Map<String, dynamic> json) => DevList(
    devT: json["devT"],
    devExtAddr: json["devExtAddr"],
    errorCode: json["errorCode"],
  );

  Map<String, dynamic> toJson() => {
    "devT": devT,
    "devExtAddr": devExtAddr,
    "errorCode": errorCode,
  };
}
