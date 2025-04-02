
import 'package:fire_alarm_app/generated/l10n.dart';
import 'package:fire_alarm_app/res/app_padding/app_padding.dart';
import 'package:fire_alarm_app/widget_element/custom_app_bar/custom_app_bar_widget.dart';
import 'package:fire_alarm_app/widget_element/high_light_button/high_light_button.dart';
import 'package:flutter/material.dart';

class UserRoomListDeviceManagerPage extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => _UserRoomListDeviceManagerPageState();
}

class _UserRoomListDeviceManagerPageState extends State<UserRoomListDeviceManagerPage>{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBarWidget(
        title: S.current.room_equipment,
      ),
      body: _buildUserRoomListDeviceManagerLayout(),
    );
  }

  Widget _buildUserRoomListDeviceManagerLayout() {
    return Padding(
      padding: const EdgeInsets.all(AppPadding.p16),
      child: Column(
        children: [
          Expanded(child: _buildListDeviceInRoomLayout()),

          HighLightButton(onPress: (){

          }, title: S.current.update_current_location)
        ],
      ),
    );
  }

  Widget _buildListDeviceInRoomLayout() {
    return Container();
  }
}