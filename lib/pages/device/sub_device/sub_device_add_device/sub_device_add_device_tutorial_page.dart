import 'package:fire_alarm_app/gen/assets.gen.dart';
import 'package:fire_alarm_app/generated/l10n.dart';
import 'package:fire_alarm_app/model/device_model.dart';
import 'package:fire_alarm_app/res/app_colors/app_colors.dart';
import 'package:fire_alarm_app/res/app_padding/app_padding.dart';
import 'package:fire_alarm_app/res/app_size/app_size.dart';
import 'package:fire_alarm_app/res/fonts/app_fonts.dart';
import 'package:fire_alarm_app/routes/app_routes/app_routes.dart';
import 'package:fire_alarm_app/widget_element/custom_app_bar/custom_app_bar_widget.dart';
import 'package:fire_alarm_app/widget_element/high_light_button/high_light_button.dart';
import 'package:flutter/material.dart';

class SubDeviceAddDeviceTutorialPage extends StatefulWidget {
  final Device deviceCenter;

  const SubDeviceAddDeviceTutorialPage({super.key, required this.deviceCenter});

  @override
  State<StatefulWidget> createState() => _SubDeviceAddDeviceTutorialPageState();
}

class _SubDeviceAddDeviceTutorialPageState extends State<SubDeviceAddDeviceTutorialPage> {
  late Device _deviceCenter;

  @override
  void initState() {
    _deviceCenter = widget.deviceCenter;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBarWidget(),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppPadding.p16, vertical: AppPadding.p18),
        child: Column(
          children: [
            Expanded(child: _buildAddingTutorialLayout()),
            HighLightButton(
                onPress: () {
                  Navigator.pushNamed(context, AppRoutes.subDeviceAddDeviceAddingAndResultPage, arguments: _deviceCenter);
                },
                title: S.current.continued)
          ],
        ),
      ),
    );
  }

  Widget _buildAddingTutorialLayout() {
    return Column(
      children: [
        stepLayoutAddDevice(1, S.current.please_press_and_hold_the_button_on_the_device_until_the_light_flashes),
        const SizedBox(
          height: AppSize.a14,
        ),
        stepLayoutAddDevice(2, S.current.choose_continue),
        const SizedBox(
          height: AppSize.a40,
        ),
        _buildAddSmokeDeviceTutorialLayout()
      ],
    );
  }

  stepLayoutAddDevice(int stepNumber, String stepDetail) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppPadding.p8),
        boxShadow: const [BoxShadow(color: Color(0x1a000000), offset: Offset(0, 1), blurRadius: 1, spreadRadius: 0)],
      ),
      child: Row(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(AppSize.a12),
            child: Container(
              height: AppSize.a20,
              width: AppSize.a20,
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  stepNumber.toString(),
                  style: AppFonts.title(color: AppColors.title),
                ),
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(top: AppPadding.p8, bottom: AppPadding.p8, right: AppPadding.p4),
              child: Text(stepDetail, style: AppFonts.subTitle()),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildAddSmokeDeviceTutorialLayout() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppPadding.p137),
      child: Assets.images.tutorialAddSmokeDeviceImg.image(),
    );
  }
}
