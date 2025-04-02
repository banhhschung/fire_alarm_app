
import 'dart:convert';

import 'package:hive_flutter/hive_flutter.dart';
part 'adapters/building_model.g.dart';
String buildingToJson(BuildingModel data) => json.encode(data.toJson());
List<BuildingModel> listBuildingFromJson(String str) => List<BuildingModel>.from(json.decode(str).map((x) => BuildingModel.fromJson(x)));

@HiveType(typeId: 2)
class BuildingModel{
  @HiveField(1)
  int? id;

  @HiveField(2)
  String? name;

  @HiveField(3)
  int? userId;

  @HiveField(4)
  int? type;

  @HiveField(5)
  String? imageUrl;

  @HiveField(6)
  String? address;

  @HiveField(7)
  String? provinceCode;

  @HiveField(8)
  int? provinceId;

  @HiveField(9)
  int? districtId;

  @HiveField(10)
  String? districtName;

  BuildingModel({
    this.id,
    this.name,
    this.userId,
    this.type,
    this.imageUrl,
    this.address,
    this.provinceCode,
    this.provinceId,
    this.districtId,
    this.districtName,
  });


  factory BuildingModel.fromJson(Map<String, dynamic> json) => BuildingModel(
    id: json["id"],
    name: json["name"],
    userId: json["userId"],
    type: json["type"],
    imageUrl: json["imageUrl"],
    address: json["address"],
    provinceCode: json["provinceCode"],
    provinceId: json["provinceId"],
    districtId: json["districtId"],
    districtName: json["districtName"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "userId": userId,
    "type": type,
    "imageUrl": imageUrl,
    'address' : address,
    'provinceCode' : provinceCode,
    'provinceId' : provinceId,
    'districtId' : districtId,
    'districtName' : districtName,
  };

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
      'id' : id,
      'name' : name,
      'userId' : userId,
      'type' : type,
      'imageUrl' : imageUrl,
      'address' : address,
      'provinceCode' : provinceCode,
      'provinceId' : provinceId,
      'districtId' : districtId,
      'districtName' : districtName,
    };
    return map;
  }

  BuildingModel.fromMap(Map<String, dynamic> map) {
    this.id = map['id'];
    this.name = map['name'];
    this.userId = map['userId'];
    this.type = map['type'];
    this.address = map['address'];
    this.provinceCode = map['provinceCode'];
    this.provinceId = map['provinceId'];
    this.districtId = map['districtId'];
    this.districtName = map['districtName'];
  }
}