import 'dart:convert';

List<DeviceTypeModel> deviceTypeModelFromJson(String str) {
  final List<dynamic> jsonData = json.decode(str)['data'];
  return jsonData.map((x) => DeviceTypeModel.fromJson(x)).toList();
}

String deviceTypeModelToJson(List<DeviceTypeModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class DeviceTypeModel {
  int? id;
  int? code;
  String? name;
  String? note;
  String? urlImage;
  String? urlIcon;
  int? status;
  int? typeConnect;
  List<TypeConnectModel>? typeConnects;
  int? deviceAlert;

  DeviceTypeModel({
    this.id,
    this.name,
    this.urlImage,
    this.urlIcon,
    this.code,
    this.note,
    this.status,
    this.typeConnect,
    this.typeConnects,
    this.deviceAlert
  });

  factory DeviceTypeModel.fromJson(Map<String, dynamic> json) =>
      DeviceTypeModel(
          id: json["id"] == null ? null : json["id"],
          name: json["name"] == null ? null : json["name"],
          urlIcon: json["urlIcon"] == null ? null : json["urlIcon"],
          urlImage: json["urlImg"] ?? null,
          code: json["code"],
          status: json["status"],
          note: json['note'],
          typeConnects: json['typeConnects'] != null? List<TypeConnectModel>.from(json['typeConnects'].map((x) => TypeConnectModel.fromJson(x))) : null,
          typeConnect: json['typeConnect'],
          deviceAlert: json['deviceAlert']);

  Map<String, dynamic> toJson() => {
    "id": id == null ? null : id,
    "name": name == null ? null : name,
    "urlIcon": urlIcon == null ? null : urlIcon,
    "urlImage": urlImage ?? null,
    "code" : code,
    "status" : status,
    "note" : note,
    "typeConnect" : typeConnect,
    "typeConnects" : typeConnects,
    'deviceAlert' : deviceAlert
  };
}


TypeConnectModel typeConnectModelFromJson(String str) => TypeConnectModel.fromJson(json.decode(str));

String typeConnectModelToJson(TypeConnectModel data) => json.encode(data.toJson());

class TypeConnectModel {
  TypeConnectModel({
    this.id,
    this.deviceTypeGroupId,
    this.deviceConnectTypeId,
  });

  int? id;
  int? deviceTypeGroupId;
  int? deviceConnectTypeId;

  factory TypeConnectModel.fromJson(Map<String, dynamic> json) => TypeConnectModel(
    id: json["id"],
    deviceTypeGroupId: json["deviceTypeGroupId"],
    deviceConnectTypeId: json["deviceConnectTypeId"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "deviceTypeGroupId": deviceTypeGroupId,
    "deviceConnectTypeId": deviceConnectTypeId,
  };
}