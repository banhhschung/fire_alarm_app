
import 'package:fire_alarm_app/generated/l10n.dart';
import 'package:fire_alarm_app/model/room_model.dart';
import 'package:fire_alarm_app/res/app_padding/app_padding.dart';
import 'package:fire_alarm_app/res/app_size/app_size.dart';
import 'package:fire_alarm_app/res/fonts/app_fonts.dart';
import 'package:fire_alarm_app/routes/app_routes/app_routes.dart';
import 'package:fire_alarm_app/widget_element/custom_app_bar/custom_app_bar_widget.dart';
import 'package:fire_alarm_app/widget_element/custom_text_field/custom_text_field_widget.dart';
import 'package:fire_alarm_app/widget_element/high_light_button/high_light_button.dart';
import 'package:flutter/material.dart';

class UserRoomDetailSettingPage extends StatefulWidget{
  final RoomModel roomModel;

  const UserRoomDetailSettingPage({super.key, required this.roomModel});

  @override
  State<StatefulWidget> createState() => _UserRoomDetailSettingPageState();
}

class _UserRoomDetailSettingPageState extends State<UserRoomDetailSettingPage>{
  late TextEditingController _nameRoomTextEditingController = TextEditingController();

  late RoomModel _roomModel;

  @override
  void initState() {
    _roomModel = widget.roomModel;
    _nameRoomTextEditingController.text = _roomModel.name ?? "";
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBarWidget(
        title: _roomModel.name ?? " ",
      ),
      body: _buildUserRoomDetailSettingLayout(),
    );
  }

  Widget _buildUserRoomDetailSettingLayout(){
    return Padding(
      padding: const EdgeInsets.all(AppPadding.p16),
      child: Column(
        children: [
          Expanded(
            child: Column(
              children: [
                _buildNameAndRoomImageLayout(),
                const SizedBox(height: AppSize.a24,),
                _buildLocationBuildingSettingLayout()
              ],
            ),
          ),

          HighLightButton(onPress: (){}, title: S.current.save_information)
        ],
      ),
    );
  }

  Widget _buildNameAndRoomImageLayout(){
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppPadding.p12),
      child: Column(
        children: [
          _buildImageRoomItemLayout(),
          const SizedBox(height: AppSize.a16,),
          CustomTextFieldWidget(
            controller: _nameRoomTextEditingController,
            titleInput: S.current.room_name,),
        ],
      ),
    );
  }

  Widget _buildImageRoomItemLayout(){
    double widthSize = MediaQuery.of(context).size.width;
    double heightSize = widthSize * 9 / 16;
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppSize.a8)
      ),
      width: widthSize,
      height: heightSize,
      child: Image.network(
        'https://cdn11.dienmaycholon.vn/filewebdmclnew/public/userupload/files/Image%20FP_2024/avatar-cute-54.png',
      ),
    );
  }

  Widget _buildLocationBuildingSettingLayout(){
    return GestureDetector(
      onTap: (){
        Navigator.of(context).pushNamed(AppRoutes.userRoomListDeviceManagerPage);
      },
      child: Container(
        padding: const EdgeInsets.all(AppPadding.p16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(S.current.room_equipment, style: AppFonts.title(),),
            const Icon(Icons.chevron_right_outlined, size: AppSize.a16,)
          ],
        ),
      ),
    );
  }
}