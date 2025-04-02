
import 'package:fire_alarm_app/gen/assets.gen.dart';
import 'package:fire_alarm_app/res/app_size/app_size.dart';
import 'package:flutter/material.dart';

class CustomBatteryWidget extends StatelessWidget{
  final int? batteryPercent;

  const CustomBatteryWidget({super.key, this.batteryPercent});
  @override
  Widget build(BuildContext context) {
    return Container(
      child: _buildBatteryPercentLayout(),
    );
  }

  Widget _buildBatteryPercentLayout(){
    const iconSize = AppSize.a20;
    if(batteryPercent != null){
      if (batteryPercent! > 75) {
        return Assets.images.battery100PercentIcon.image(width: iconSize, height: iconSize);
      } else if (batteryPercent! > 50) {
        return Assets.images.battery75PercentIcon.image(width: iconSize, height: iconSize);
      } else if (batteryPercent! > 20) {
        return Assets.images.battery50PercentIcon.image(width: iconSize, height: iconSize);
      } else {
        return Assets.images.battery25PercentIcon.image(width: iconSize, height: iconSize);
      }
    } else {
      return const SizedBox(height: iconSize, width: iconSize,);
    }
  }
}