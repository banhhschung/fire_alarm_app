

import 'package:fire_alarm_app/model/device_model.dart';
import 'package:fire_alarm_app/model/device_type_model.dart';

class SmartConfigWifiDeviceArgs {
  final String? routerSSID;
  final String? routerBSSID;
  final String? routerPassword;
  final DeviceTypeModel? deviceTypeModel; // cập nhật kết nối thì deviceTypeModel == null, add thiết bị thì deviceTypeModel != null
  int? configMode; //1: ez mode, 2: ap mode, 3: ble mesh mode, 4:zig bee, 5 : vconnex camera auto, 6 : vconnex camera QR code, 7: transfer, 8: repeater

  final int? roomId;
  final bool? isUpdateWifiInfo;
  final Device? device;// cập nhật kết nối thì deviceTypeModel != null, add thiết bị thì deviceTypeModel == null
  final TypeConnectModel? typeConnectModel;

  SmartConfigWifiDeviceArgs(
      {this.routerSSID,
      this.routerBSSID,
      this.routerPassword,
      this.deviceTypeModel,
      this.configMode,
      this.roomId,
      this.isUpdateWifiInfo,
      this.device,
      this.typeConnectModel});
}