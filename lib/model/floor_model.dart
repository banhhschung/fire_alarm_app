import 'dart:convert';

import 'package:hive/hive.dart';

import 'room_model.dart';

part 'adapters/floor_model.g.dart';


FloorModel floorFromJson(String str) => FloorModel.fromMap(json.decode(str));

String floorToJson(FloorModel data) => json.encode(data.toMap());

List<FloorModel> listFloorFromJson(String str) => List<FloorModel>.from(json.decode(str).map((x) => FloorModel.fromJson(x)));

@HiveType(typeId: 3)
class FloorModel {
  @HiveField(1)
  int? id;

  @HiveField(2)
  String? name;

  @HiveField(3)
  int? homeId;

  List<RoomModel>? rooms;

  FloorModel({
    this.id,
    this.name,
    this.homeId,
    this.rooms
  });

  Map<String, dynamic> toBEMap() {
    Map<String, dynamic> map = Map<String, dynamic>();
    if (id != null) {
      map['id'] = id;
    }
    if (name != null) {
      map['name'] = name;
    }
    if (homeId != null) {
      map['homeId'] = homeId;
    }

    return map;
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
      'id' : id,
      'name' : name,
      'homeId' : homeId,
    };

    return map;
  }

  FloorModel.fromMap(Map<String, dynamic> map) {
    this.id = map['id'];
    this.name = map['name'];
    this.homeId = map['homeId'];
  }

  factory FloorModel.fromBackEndData(Map<String, dynamic> json) => FloorModel(
    id: json["id"],
    name: json["name"] == null? '' : json["name"],
    homeId: json["homeId"]
  );

  factory FloorModel.fromJson(Map<String, dynamic> json) => FloorModel(
    id: json["id"],
    name: json["name"],
    homeId: json['homeId']
  );
}