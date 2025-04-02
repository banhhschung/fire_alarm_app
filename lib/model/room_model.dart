import 'dart:convert';

import 'package:hive/hive.dart';

part 'adapters/room_model.g.dart';

RoomModel roomFromJson(String str) => RoomModel.fromMap(json.decode(str));

String roomToJson(RoomModel data) => json.encode(data.toMap());

List<RoomModel> listRoomFromJson(String str) => List<RoomModel>.from(json.decode(str).map((x) => RoomModel.fromJson(x)));

@HiveType(typeId: 4)
class RoomModel {
  @HiveField(1)
  int? id;

  @HiveField(2)
  String? name;

  @HiveField(3)
  String? iconPath;

  @HiveField(4)
  String? imageUrl;

  @HiveField(5)
  int? createdUser;

  @HiveField(6)
  int? floorId;


  RoomModel({
    this.id,
    this.name,
    this.iconPath,
    this.imageUrl,
    this.createdUser,
    this.floorId
  });

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
      'id' : id,
      'name' : name,
      'iconPath' : iconPath,
      'imageUrl' : imageUrl,
      'createdUser' : createdUser,
      'floorId' : floorId
    };

    return map;
  }

  Map<String, dynamic> toBEMap() {
    Map<String, dynamic> map = {
      'id' : id,
      'name' : name,
      'icon' : iconPath,
      'imageUrl' : imageUrl,
      'floorId' : floorId,
    };

    return map;
  }

  RoomModel.fromMap(Map<String, dynamic> map) {
    this.id = map['id'];
    this.name = map['name'];
    this.iconPath = map['iconPath'];
    this.imageUrl = map['imageUrl'];
    this.createdUser = map['createdUser'];
    this.floorId = map['floorId'];
  }

  factory RoomModel.fromBackEndData(Map<String, dynamic> json) => RoomModel(
    id: json["id"],
    name: json["name"] == null? '' : json["name"],
    iconPath: json["icon"] == null? '' : json["icon"],
    imageUrl: json["imageUrl"] == null? '' : json["imageUrl"],
    floorId: json["floorId"] == null? '' : json["floorId"],
  );

  factory RoomModel.fromJson(Map<String, dynamic> json) => RoomModel(
      id: json["id"],
      name: json["name"],
      iconPath: json["iconPath"],
      imageUrl: json["imageUrl"],
      createdUser: json['createdUser'],
      floorId: json['floorId']
  );
}