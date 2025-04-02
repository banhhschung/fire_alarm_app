import 'package:fire_alarm_app/generated/l10n.dart';
import 'package:fire_alarm_app/model/device_model.dart';
import 'package:fire_alarm_app/model/device_param_model.dart';
import 'package:fire_alarm_app/res/app_colors/app_colors.dart';
import 'package:fire_alarm_app/res/app_size/app_size.dart';
import 'package:fire_alarm_app/res/fonts/app_fonts.dart';
import 'package:flutter/material.dart';

class PCCCDeviceStatusLayout extends StatelessWidget {
  final Device device;

  const PCCCDeviceStatusLayout({super.key, required this.device});

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Column(
        children: [
          _buildTypeConnectLayout(),
          const SizedBox(
            height: AppSize.a4,
          ),
          _buildNumberOfConnectedDevices()
        ],
      ),
    );
  }

  Widget _buildTypeConnectLayout() {
    return Row(
      children: [
        Text("4G",
            style: AppFonts.deviceStatusText(
                color: _changeColorsWhenUsingConnectionType() != null && _changeColorsWhenUsingConnectionType() == true
                    ? AppColors.successPrimary
                    : AppColors.subtitle)),
        const SizedBox(
          width: AppSize.a12,
        ),
        Text("Lan",
            style: AppFonts.deviceStatusText(
                color: _changeColorsWhenUsingConnectionType() != null && _changeColorsWhenUsingConnectionType() == false
                    ? AppColors.errorPrimary
                    : AppColors.subtitle))
      ],
    );
  }

  Widget _buildNumberOfConnectedDevices() {
    return Text(
      "${S.current.connected}: 3/3",
      style: AppFonts.subTitle(fontSize: AppSize.a10, color: AppColors.primaryText),
    );
  }

  bool? _changeColorsWhenUsingConnectionType() {
    DeviceParamModel? deviceParamModel =
        device.params.firstWhere((deviceParam) => deviceParam.paramKey == 'networkUse', orElse: () => DeviceParamModel());
    //todo: 1:4G, 2:Ethernet, 3:Auto
    if (deviceParamModel != null && deviceParamModel.value != null) {
      return (deviceParamModel.value == 1) ? true : false;
    } else {
      return null;
    }
  }
}
