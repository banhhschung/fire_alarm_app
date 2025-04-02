
import 'package:fire_alarm_app/gen/assets.gen.dart';
import 'package:fire_alarm_app/res/app_padding/app_padding.dart';
import 'package:fire_alarm_app/res/app_size/app_size.dart';
import 'package:flutter/material.dart';

class CustomAddingDeviceLoadingWidget extends StatelessWidget{

  @override
  Widget build(BuildContext context) {
    double size = MediaQuery.of(context).size.width;

    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(AppPadding.p52),
            child: Assets.images.circleBackGroundLoadingImg.image(),
          ),
          Container(
            width: size,
            height: size,
            alignment: Alignment.center,
            child: Padding(
              padding: const EdgeInsets.all(AppPadding.p90),
              child: SizedBox(
                width: size, // Điều chỉnh kích thước
                height: size,
                child: const CircularProgressIndicator(
                  strokeWidth: AppSize.a35,
                  color: Colors.orange,
                ),
              ),
            ),
          ),
          Assets.images.vconnexLogoImg.image(width: AppSize.a70, height: AppSize.a70)
        ],
      ),
    );
  }
}