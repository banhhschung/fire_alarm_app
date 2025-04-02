import 'package:fire_alarm_app/model/device_model.dart';
import 'package:fire_alarm_app/model/device_param_model.dart';
import 'package:fire_alarm_app/widget_element/custom_battery/custom_battery_widget.dart';
import 'package:flutter/material.dart';

class SubDevicePinStatusLayout extends StatelessWidget {
  final Device device;

  const SubDevicePinStatusLayout({super.key, required this.device});

  @override
  Widget build(BuildContext context) {
    return CustomBatteryWidget(
      batteryPercent: getBatteryPercentage(),
    );
  }

  int? getBatteryPercentage() {
    DeviceParamModel? deviceParamModel = device.params.firstWhere((deviceParam) => deviceParam.paramKey == 'battery', orElse: () => DeviceParamModel());
    if (deviceParamModel != null && deviceParamModel.value != null) {
      return int.parse(deviceParamModel.value.toString());
    } else {
      return null;
    }
  }
}
