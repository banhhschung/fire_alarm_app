// To parse this JSON data, do
//
//     final homeSharedModel = homeSharedModelFromJson(jsonString);

import 'package:hive/hive.dart';
import 'dart:convert';

part 'adapters/share_building_model.g.dart';

List<ShareBuildingModel> shareBuildingModelFromJson(String str) => List<ShareBuildingModel>.from(json.decode(str).map((x) => ShareBuildingModel.fromJson(x)));

String shareBuildingModelToJson(List<ShareBuildingModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

@HiveType(typeId: 8)
class ShareBuildingModel {
  ShareBuildingModel({
    this.id,
    this.buildingId,
    this.userId,
    this.type,
    this.createdDate,
    this.userName,
    this.uuid,
    this.email,
    this.phoneNumber,
    this.expiredDate,
    this.expiredTime,
  });

  @HiveField(1)
  int? id;
  @HiveField(2)
  int? buildingId;
  @HiveField(3)
  int? userId;
  @HiveField(4)
  int? type;
  @HiveField(5)
  String? createdDate;
  @HiveField(6)
  String? userName;
  @HiveField(7)
  String? uuid;
  @HiveField(8)
  String? email;
  @HiveField(9)
  String? phoneNumber;
  @HiveField(10)
  String? expiredDate;
  @HiveField(11)
  int? expiredTime;


  factory ShareBuildingModel.fromJson(Map<String, dynamic> json) => ShareBuildingModel(
    id: json["id"],
    buildingId: json["homeId"],
    userId: json["userId"],
    type: json["type"],
    createdDate: json["createdDate"],
    userName: json["userName"],
    uuid: json["uuid"],
    email: json["email"],
    phoneNumber: json["phoneNumber"],
    expiredDate: json["expiredDate"],
    expiredTime: json["expiredTime"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "homeId": buildingId,
    "userId": userId,
    "type": type,
    "createdDate": createdDate,
    "userName": userName,
    "uuid": uuid,
    "email": email,
    "phoneNumber": phoneNumber,
    "expiredDate": expiredDate,
    "expiredTime": expiredTime,
  };
}
