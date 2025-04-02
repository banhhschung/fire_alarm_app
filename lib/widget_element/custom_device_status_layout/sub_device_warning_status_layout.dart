import 'package:fire_alarm_app/gen/assets.gen.dart';
import 'package:fire_alarm_app/generated/l10n.dart';
import 'package:fire_alarm_app/model/device_model.dart';
import 'package:fire_alarm_app/model/device_param_model.dart';
import 'package:fire_alarm_app/res/app_colors/app_colors.dart';
import 'package:fire_alarm_app/res/app_size/app_size.dart';
import 'package:fire_alarm_app/res/fonts/app_fonts.dart';
import 'package:flutter/material.dart';

class SubDeviceWarningStatusLayout extends StatelessWidget {
  final Device device;

  const SubDeviceWarningStatusLayout({super.key, required this.device});

  @override
  Widget build(BuildContext context) {
    return _fireWarningStatus()
        ? Column(
            children: [
              Assets.images.fireWarningImg.image(width: AppSize.a18, height: AppSize.a18),
              const SizedBox(
                height: AppSize.a2,
              ),
              Text(
                S.current.warning,
                style: AppFonts.emergencyFireAlarmPCCCCenterDetailPage(fontSize: AppSize.a10, color: AppColors.errorPrimary),
              )
            ],
          )
        : const SizedBox();
  }

  bool _fireWarningStatus() {
    DeviceParamModel? deviceParamModel = device.params.firstWhere((deviceParam) => deviceParam.paramKey == 'fire', orElse: () => DeviceParamModel());
    if (deviceParamModel != null && deviceParamModel.value != null) {
      return (deviceParamModel.value == 1) ? true : false;
    } else {
      return false;
    }
  }
}
