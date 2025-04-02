// To parse this JSON data, do
//
//     final alertNotification = alertNotificationFromJson(jsonString);

import 'dart:convert';

AlertNotificationModel alertNotificationFromJson(String str) => AlertNotificationModel.fromJson(json.decode(str));

String alertNotificationToJson(AlertNotificationModel data) => json.encode(data.toJson());

class AlertNotificationModel {
  int? id;
  int? mode;
  int? periodic;
  int? numberOfRepetition;
  int? deviceId;
  int? userId;
  int? homeId;
  int? warningSoundId;
  String? androidChannelId;
  List<WarningSound>? warningSounds;
  List<WarningContent>? warningContents;

  AlertNotificationModel({
    this.id,
    this.mode,
    this.periodic,
    this.numberOfRepetition,
    this.deviceId,
    this.userId,
    this.homeId,
    this.warningSoundId,
    this.warningSounds,
    this.warningContents,
    this.androidChannelId,
  });

  factory AlertNotificationModel.fromJson(Map<String, dynamic> json) => AlertNotificationModel(
    id: json["id"],
    mode: json["mode"],
    periodic: json["periodic"],
    numberOfRepetition: json["numberOfRepetition"],
    deviceId: json["deviceId"],
    userId: json["userId"],
    homeId: json["homeId"],
    warningSoundId: json["warningSoundId"],
    androidChannelId: json["androidChannelId"],
    warningSounds: List<WarningSound>.from(json["warningSounds"].map((x) => WarningSound.fromJson(x))),
    warningContents: List<WarningContent>.from(json["warningContents"].map((x) => WarningContent.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "mode": mode,
    "periodic": periodic,
    "numberOfRepetition": numberOfRepetition,
    "deviceId": deviceId,
    "userId": userId,
    "homeId": homeId,
    "warningSoundId": warningSoundId,
    "warningSounds": List<dynamic>.from(warningSounds!.map((x) => x.toJson())),
    "warningContents": List<dynamic>.from(warningContents!.map((x) => x.toJson())),
    "androidChannelId": androidChannelId,
  };
}

class WarningContent {
  int? id;
  int? warningConfigId;
  String? name;
  String? code;

  WarningContent({
    this.id,
    this.warningConfigId,
    this.name,
    this.code,
  });

  factory WarningContent.fromJson(Map<String, dynamic> json) => WarningContent(
    id: json["id"],
    warningConfigId: json["warningConfigId"],
    name: json["name"],
    code: json["code"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "warningConfigId": warningConfigId,
    "name": name,
    "code": code,
  };
}

class WarningSound {
  int? id;
  String? name;
  String? fileName;
  String? audioLink;
  String? fileType;
  int? fileSize;

  WarningSound({
    this.id,
    this.name,
    this.fileName,
    this.audioLink,
    this.fileType,
    this.fileSize,
  });

  factory WarningSound.fromJson(Map<String, dynamic> json) => WarningSound(
    id: json["id"],
    name: json["name"],
    fileName: json["fileName"],
    audioLink: json["link"],
    fileType: json["fileType"],
    fileSize: json["fileSize"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "fileName": fileName,
    "link": audioLink,
    "fileType": fileType,
    "fileSize": fileSize,
  };
}
