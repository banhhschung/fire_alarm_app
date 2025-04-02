// To parse this JSON data, do
//
//     final mqttExtraConfigModel = mqttExtraConfigModelFromJson(jsonString);

import 'dart:convert';

MqttExtraConfigModel mqttExtraConfigModelFromJson(String str) => MqttExtraConfigModel.fromJson(json.decode(str));

String mqttExtraConfigModelToJson(MqttExtraConfigModel data) => json.encode(data.toJson());

class MqttExtraConfigModel {
  String? name;
  int? devT;
  String? devExtAddr;
  int? timeStamp;
  int? delayTime;
  int? networkUse;
  int? errorCode;

  MqttExtraConfigModel({
    this.name,
    this.devT,
    this.devExtAddr,
    this.timeStamp,
    this.delayTime,
    this.networkUse,
    this.errorCode,
  });

  factory MqttExtraConfigModel.fromJson(Map<String, dynamic> json) => MqttExtraConfigModel(
    name: json["name"],
    devT: json["devT"],
    devExtAddr: json["devExtAddr"],
    timeStamp: json["timeStamp"],
    delayTime: json["delayTime"],
    networkUse: json["networkUse"],
    errorCode: json["errorCode"],
  );

  Map<String, dynamic> toJson() => {
    "name": name,
    "devT": devT,
    "devExtAddr": devExtAddr,
    "timeStamp": timeStamp,
    "delayTime": delayTime,
    "networkUse": networkUse,
    "errorCode": errorCode,
  };
}
