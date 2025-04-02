import 'dart:convert';

// import 'package:vhomenex/generated/l10n.dart';
// import 'package:vhomenex/utils/common.dart';

List<DeviceParamModel> deviceParamModelFromJson(String str) => List<DeviceParamModel>.from(json.decode(str).map((x) => DeviceParamModel.fromJson(x)));

String deviceParamModelToJson(List<DeviceParamModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class DeviceParamModel {
  int? id;
  String? name;
  int? type;
  int? status;
  int? deviceId;
  String? unit;
  int? reportType;
  String? paramKey;
  int? subAddress;
  int? sensorDataId;


  dynamic value;
  bool? isLinked;
  String? iconButtonName;

  DeviceParamModel({
    this.id,
    this.name,
    // cac loai types : 1: control on/off, 2: open/close, 3: move/nomove, 4: normal/hasAlert, 5: pin, 6: normalValue
    this.type,
    this.status,
    this.deviceId,
    this.unit,
    this.reportType,
    this.paramKey,
    this.subAddress,
    this.value,
    this.isLinked,
    this.iconButtonName,
    this.sensorDataId
  });

  factory DeviceParamModel.fromJson(Map<String, dynamic> json) => DeviceParamModel(
    id: json["id"] == null ? null : json["id"],
    name: json["name"] == null ? null : json["name"],
    type: json["type"] == null ? null : json["type"],
    status: json["status"] == null ? null : json["status"],
    deviceId: json["deviceId"] == null ? null : json["deviceId"],
    unit: json["unit"] == null ? null : json["unit"],
    reportType: json["reportType"] == null ? null : json["reportType"],
    paramKey: json["paramKey"] == null ? null : json["paramKey"],
    subAddress: json["subAddress"] == null ? null : json["subAddress"],
    iconButtonName: json["iconButtonName"] == null? null : json["iconButtonName"],
      sensorDataId: json["sensorDataId"] == null ? null : json["sensorDataId"]
    // value: json["value"]
  );

  Map<String, dynamic> toJson() => {
    "id": id == null ? null : id,
    "name": name == null ? null : name,
    "type": type == null ? null : type,
    "status": status == null ? null : status,
    "deviceId": deviceId == null ? null : deviceId,
    "unit": unit == null ? null : unit,
    "reportType": reportType == null ? null : reportType,
    "paramKey": paramKey == null ? null : paramKey,
    "subAddress": subAddress == null ? null : subAddress,
    "iconButtonName": iconButtonName?? null,
    // "value": value?? null
  };

  // String convertParamType() {
  //
  //   if (paramKey == 'motion') {
  //     if (value == null) return '__';
  //     else if (value == 1) return S.current.yes;
  //     else return S.current.no;
  //   }
  //   else if (paramKey == 'waterLeak') {
  //     if (value == null) return '__';
  //     else if (value == 1) return S.current.water_leak_detection;
  //     else return S.current.normal;
  //   }
  //   else if (paramKey == 'smokeAlarm') {
  //     if (value == null) return '__';
  //     else if (value == 1) return S.current.detect_smoke;
  //     else return S.current.heater_safe;
  //   }
  //   else if (paramKey == 'lux') {
  //     if (value == null) return '__';
  //     else return value.toStringAsFixed(0);
  //   }
  //   else if (paramKey == 'open_level') {
  //     if (value == null) return '__';
  //     else return value.toStringAsFixed(0);
  //   }
  //
  //   switch (this.type) {
  //     case 1: // on off
  //       return '';
  //     break;
  //     case 2: // open/close
  //       if (value == null) return '__';
  //       else if (value == 1) return S.current.open;
  //       else return S.current.close;
  //       break;
  //     case 3: // move, nomove
  //       if (value == null) return '__';
  //       else if (value == 1) return  S.current.motion_detection;
  //       else return S.current.no_motion;
  //       break;
  //     case 4: // normal, alert
  //       if (value == null) return '__';
  //       else if (value == 1) return S.current.alert;
  //       else return S.current.normal;
  //       break;
  //     case 5: // pin
  //       if (value == null) return '__';
  //       return value is double? Common.roundDoubleValue(value, 0) : value.toString();
  //       break;
  //     case 6: // normal value
  //       if (value == null) return '__';
  //       return value is double? Common.roundDoubleValue(value, 2) : value.toString();
  //       break;
  //   }
  //   return '';
  // }
}