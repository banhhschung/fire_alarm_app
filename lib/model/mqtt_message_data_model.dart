import 'dart:convert';

MqttMessageDataModel mqttMessageDataModelFromJson(String str) => MqttMessageDataModel.fromJson(json.decode(str));

class MqttMessageDataModel {
  String? name;
  int? devT;
  String? devExtAddr;
  List<DevV>? devV;

  MqttMessageDataModel({
    this.name,
    this.devT,
    this.devExtAddr,
    this.devV,
  });

  factory MqttMessageDataModel.fromJson(Map<String, dynamic> json) => MqttMessageDataModel(
        name: json["name"],
        devT: json["devT"],
        devExtAddr: json["devExtAddr"],
        devV: json["devV"] != null ? List<DevV>.from(json["devV"].map((x) => DevV.fromJson(x))) : null,
      );
}

class DevV {
  String? param;
  dynamic? value;

  DevV({
    this.param,
    this.value,
  });

  factory DevV.fromJson(Map<String, dynamic> json) => DevV(
        param: json["param"],
        value: json["value"],
      );
}
