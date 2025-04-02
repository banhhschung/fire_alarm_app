import 'package:fire_alarm_app/gen/assets.gen.dart';
import 'package:fire_alarm_app/generated/l10n.dart';
import 'package:fire_alarm_app/model/device_model.dart';
import 'package:fire_alarm_app/model/floor_model.dart';
import 'package:fire_alarm_app/res/app_colors/app_colors.dart';
import 'package:fire_alarm_app/res/app_padding/app_padding.dart';
import 'package:fire_alarm_app/res/app_size/app_size.dart';
import 'package:fire_alarm_app/res/fonts/app_fonts.dart';
import 'package:fire_alarm_app/routes/app_routes/app_routes.dart';
import 'package:fire_alarm_app/widget_element/high_light_button/high_light_button.dart';
import 'package:flutter/material.dart';

class SubDeviceManagementPage extends StatelessWidget {
  late List<Device> listDevice = [];
  late FloorModel floorModel;

  SubDeviceManagementPage({super.key});

  changeListDevice(List<Device> devices) {
    listDevice.clear();
    listDevice.addAll(devices);
  }

  @override
  Widget build(BuildContext context) {
    return _buildSubDeviceManagementLayout(context);
  }

  Widget _buildSubDeviceManagementLayout(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AppPadding.p16),
      child: Column(
        children: [
          _buildSearchBarForDeviceLayout(),
          Expanded(child: _buildListDeviceInFloorLayout()),
          HighLightButton(
            onPress: () {
              Navigator.pushNamed(context, AppRoutes.listDeviceTypePage);
            },
            title: S.current.add_device,
          )
        ],
      ),
    );
  }

  Widget _buildSearchBarForDeviceLayout() {
    return Row(
      children: [
        Assets.images.searchIcon.image(width: AppSize.a20),
        const SizedBox(
          width: AppSize.a8,
        ),
        _buildTextFieldSearchLayout(),
        const SizedBox(
          width: AppSize.a12,
        ),
        Text(
          S.current.choose,
          style: AppFonts.buttonText2(color: AppColors.orangee),
        )
      ],
    );
  }

  Widget _buildTextFieldSearchLayout() {
    return Expanded(
      child: TextFormField(
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: S.current.search,
          hintStyle: AppFonts.body2(color: AppColors.secondaryText),
        ),
      ),
    );
  }

  Widget _buildListDeviceInFloorLayout() {
    return ListView.builder(itemCount: listDevice.length, itemBuilder: (context, index) => _buildDeviceItemInFloorLayout(listDevice[index]));
  }

  Widget _buildDeviceItemInFloorLayout(Device device) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppPadding.p16),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppSize.a8),
        ),
        padding: const EdgeInsets.all(AppPadding.p8),
        child: Row(
          children: [
            /*Image.network(
              device.iconPath ?? "",
              width: AppSize.a45,
            ),*/
            const SizedBox(
              width: AppSize.a8,
            ),
            Expanded(
              child: Text(
                device.name ?? "",
                style: AppFonts.subTitle3(),
              ),
            ),
            const SizedBox(
              width: AppSize.a8,
            ),
            Assets.images.editPenIcon.image(width: AppSize.a24)
          ],
        ),
      ),
    );
  }
}
