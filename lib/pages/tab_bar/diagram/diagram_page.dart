import 'package:fire_alarm_app/gen/assets.gen.dart';
import 'package:fire_alarm_app/generated/l10n.dart';
import 'package:fire_alarm_app/res/app_colors/app_colors.dart';
import 'package:fire_alarm_app/res/app_padding/app_padding.dart';
import 'package:fire_alarm_app/res/app_size/app_size.dart';
import 'package:fire_alarm_app/res/fonts/app_fonts.dart';
import 'package:fire_alarm_app/widget_element/custom_app_bar/custom_app_bar_widget.dart';
import 'package:fire_alarm_app/widget_element/dashed_line_painter/dashed_line_painter_widget.dart';
import 'package:flutter/material.dart';

class DiagramPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _DiagramPageState();
}

class _DiagramPageState extends State<DiagramPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBarWidget(
        title: S.current.diagram,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: AppPadding.p16, top: AppPadding.p12, bottom: AppPadding.p60),
            child: _representsTheStateOfTheDiagram(),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppPadding.p48),
            child: _diagramDetailLayout(),
          ),
        ],
      ),
    );
  }

  Widget _representsTheStateOfTheDiagram(){
    return Row(
      children: [
        _statusOfDiagramItem(true),
        const SizedBox(width: AppSize.a34,),
        _statusOfDiagramItem(false),
      ],
    );
  }

  Widget _diagramDetailLayout(){
    return Column(
      children: [
        _buildFloor1OfDiagramLayout(),
        const SizedBox(height: AppSize.a10,),
        const DashedLineWidget(length: AppSize.a58, axis: Axis.vertical,),
        const SizedBox(height: AppSize.a10,),
        _buildFloor2OfDiagramLayout(),
        const SizedBox(height: AppSize.a10,),
        const DashedLineWidget(length: AppSize.a58, axis: Axis.vertical,),
        const SizedBox(height: AppSize.a10,),
        _buildFloor3OfDiagramLayout(),
      ],
    );
  }

  Widget _buildFloor3OfDiagramLayout(){
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _temperatureSensorImgLayout()
      ],
    );
  }

  Widget _buildFloor2OfDiagramLayout(){
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _smokeSensorLayout(),
        const DashedLineWidget(length: AppSize.a70, axis: Axis.horizontal,),
        _pcccCenterLayout(),
        const DashedLineWidget(length: AppSize.a70, axis: Axis.horizontal,),
        _fireAlarmButtonLayout()
      ],
    );
  }

  Widget _buildFloor1OfDiagramLayout(){
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Assets.images.fireAlarmCabinetImg.image(width: AppSize.a25, height: AppSize.a39),
      ],
    );
  }

  Widget _pcccCenterLayout(){
    return Assets.images.pcccCenterImg.image(width: AppSize.a43, height: AppSize.a58);
  }

  Widget _smokeSensorLayout(){
    return Assets.images.smokeSensorImg.image(width: AppSize.a32, height: AppSize.a32);
  }

  Widget _fireAlarmButtonLayout(){
    return Assets.images.fireAlarmButtonImg.image(width: AppSize.a25, height: AppSize.a27);
  }

  Widget _temperatureSensorImgLayout(){
    return Assets.images.temperatureSensorImg.image(width: AppSize.a24, height: AppSize.a24);
  }

  Widget _statusOfDiagramItem(bool isOnline){
    return Row(
      children: [
        Icon(Icons.circle, color: isOnline ? AppColors.successPrimary : AppColors.errorPrimary, size: AppSize.a6,),
        const SizedBox(width: AppSize.a6,),
        Text(isOnline ? S.current.connected : S.current.lost_connected, style: AppFonts.subTitle(),)
      ],
    );
  }
}
