import 'package:fire_alarm_app/gen/assets.gen.dart';
import 'package:fire_alarm_app/generated/l10n.dart';
import 'package:fire_alarm_app/model/device_model.dart';
import 'package:fire_alarm_app/res/app_colors/app_colors.dart';
import 'package:fire_alarm_app/res/app_padding/app_padding.dart';
import 'package:fire_alarm_app/res/app_size/app_size.dart';
import 'package:fire_alarm_app/res/fonts/app_fonts.dart';
import 'package:fire_alarm_app/routes/app_routes/app_routes.dart';
import 'package:fire_alarm_app/widget_element/custom_app_bar/custom_app_bar_widget.dart';
import 'package:fire_alarm_app/widget_element/custom_battery/custom_battery_widget.dart';
import 'package:fire_alarm_app/widget_element/high_light_button/high_light_button.dart';
import 'package:flutter/material.dart';

class PCCCCenterDetailPage extends StatefulWidget {
  final Device device;

  const PCCCCenterDetailPage({super.key, required this.device});

  @override
  State<StatefulWidget> createState() => _PCCCCenterDetailPageState();
}

class _PCCCCenterDetailPageState extends State<PCCCCenterDetailPage> {
  late Device _device;

  @override
  void initState() {
    _device = widget.device;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBarWidget(
        actions: [_buildSettingButtonLayout()],
        title: _device.name ?? "",
      ),
      body: _buildPCCCCenterDetailPageLayout(),
    );
  }

  Widget _buildPCCCCenterDetailPageLayout() {
    return Padding(
      padding: const EdgeInsets.all(AppPadding.p16),
      child: Column(
        children: [
          Expanded(
            child: Column(
              children: [
                _buildHeaderPCCCCenterDetailLayout(),
                const SizedBox(
                  height: AppSize.a24,
                ),
                _buildBottomOfPCCCCenterDetailLayout()
              ],
            ),
          ),
          HighLightButton(onPress: () {
            _addSubDeviceFunction();
          }, title: S.current.add_device)
        ],
      ),
    );
  }

  Widget _buildHeaderPCCCCenterDetailLayout() {
    return Column(
      children: [
        _buildEmergencyFireAlarmButtonLayout(),
        const SizedBox(
          height: AppSize.a10,
        ),
        Assets.images.pcccCenterImg.image(width: AppSize.a66, height: AppSize.a90),
        const SizedBox(
          height: AppSize.a12,
        ),
        _buildLocationOfDeviceInBuildingLayout(),
        const SizedBox(
          height: AppSize.a4,
        ),
        _buildLocationOfBuildingLayout(),
        const SizedBox(
          height: AppSize.a10,
        ),
        _buildDeviceConnectLayout()
      ],
    );
  }

  Widget _buildEmergencyFireAlarmButtonLayout() {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: AppSize.a54,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              Assets.images.emergencyFireAlarmPcccCenterDetailPageImg.image(),
              Text(
                S.current.emergency_fire_alarm,
                style: AppFonts.emergencyFireAlarmPCCCCenterDetailPage(),
              )
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLocationOfDeviceInBuildingLayout() {
    return RichText(
        text: TextSpan(text: '${S.current.location}: ', style: AppFonts.subTitle3(), children: [
      TextSpan(text: _device.floorName ?? "Tầng 1", style: AppFonts.subTitle3(color: AppColors.title)),
      TextSpan(text: " - ", style: AppFonts.subTitle3(color: AppColors.title)),
      TextSpan(text: _device.roomName ?? "Phòng bếp", style: AppFonts.subTitle3(color: AppColors.title))
    ]));
  }

  Widget _buildLocationOfBuildingLayout() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(
          Icons.location_on_outlined,
          size: AppSize.a16,
          color: AppColors.secondaryText,
        ),
        const SizedBox(
          width: AppSize.a4,
        ),
        RichText(
            text: TextSpan(text: '', children: [
          TextSpan(text: _device.floorName ?? "Mễ Trì", style: AppFonts.subTitle3(color: AppColors.title)),
          TextSpan(text: " - ", style: AppFonts.subTitle3(color: AppColors.title)),
          TextSpan(text: _device.roomName ?? "Nam Từ Liêm", style: AppFonts.subTitle3(color: AppColors.title))
        ]))
      ],
    );
  }

  Widget _buildDeviceConnectLayout() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildNumberOfDevicesConnectedLayout(),
        const SizedBox(
          width: AppSize.a40,
        ),
        _buildTypeConnectOfDeviceLayout()
      ],
    );
  }

  Widget _buildNumberOfDevicesConnectedLayout() {
    return Column(
      children: [
        Text(
          S.current.connected,
          style: AppFonts.subTitle3(fontSize: AppSize.a10),
        ),
        const SizedBox(
          height: AppSize.a4,
        ),
        Text(
          "3/3",
          style: AppFonts.subTitle3(fontSize: AppSize.a10, color: AppColors.title),
        )
      ],
    );
  }

  Widget _buildTypeConnectOfDeviceLayout() {
    return Column(
      children: [
        Text(
          S.current.network_connection,
          style: AppFonts.subTitle3(fontSize: AppSize.a10),
        ),
        const SizedBox(
          height: AppSize.a4,
        ),
        Text(
          "4G|Lan",
          style: AppFonts.subTitle3(fontSize: AppSize.a10, color: AppColors.title),
        )
      ],
    );
  }

  Widget _buildBottomOfPCCCCenterDetailLayout() {
    return Expanded(
      child: Column(
        children: [
          _buildHeaderOfBottomInPCCCCenterDetailLayout(),
          const SizedBox(
            height: AppSize.a8,
          ),
          _buildListChildDevicesLayout()
        ],
      ),
    );
  }

  Widget _buildHeaderOfBottomInPCCCCenterDetailLayout() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "${S.current.child_devices} (3/3)",
          style: AppFonts.title3(fontSize: AppSize.a16),
        ),
        const SizedBox(
          height: AppSize.a2,
        ),
        Row(
          children: [
            Text(
              "${S.current.lost_connected}: 0",
              style: AppFonts.title3(),
            ),
            const SizedBox(
              width: AppSize.a24,
            ),
            Text(
              "${S.current.low_battery}: 0",
              style: AppFonts.title3(),
            )
          ],
        )
      ],
    );
  }

  Widget _buildListChildDevicesLayout() {
    final List<Device> _devices = [
      Device(name: "abc"),
      Device(name: "def"),
      Device(name: "ghi"),
      Device(name: "klm"),
      Device(name: "dcm"),
    ];
    return Expanded(
      child: ListView.builder(itemCount: _devices.length, itemBuilder: (context, index) => _buildChildDeviceItemLayout(_devices[index])),
    );
  }

  Widget _buildChildDeviceItemLayout(Device device) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: AppPadding.p8, horizontal: AppPadding.p12),
      child: Row(
        children: [
          Image.network(
            'https://cdn11.dienmaycholon.vn/filewebdmclnew/public/userupload/files/Image%20FP_2024/avatar-cute-54.png',
            width: AppSize.a50,
            height: AppSize.a50,
          ),
          const SizedBox(
            width: AppSize.a4,
          ),
          Column(
            children: [
              Text(
                device.name ?? "",
                style: AppFonts.title5(color: AppColors.title),
              ),
              const SizedBox(
                width: AppSize.a8,
              ),
              const CustomBatteryWidget(
                batteryPercent: 70,
              )
            ],
          )
        ],
      ),
    );
  }

  Widget _buildSettingButtonLayout() {
    return Padding(
      padding: const EdgeInsets.only(right: AppPadding.p12),
      child: GestureDetector(
          onTap: () {
            Navigator.of(context).pushNamed(AppRoutes.pCCCCenterSettingPage, arguments: _device);
          },
          child: const Icon(
            Icons.settings_outlined,
            color: AppColors.secondaryText,
            size: AppSize.a24,
          )),
    );
  }

  void _addSubDeviceFunction(){
    Navigator.of(context).pushNamed(AppRoutes.listDeviceTypePage, arguments: _device);
  }
}
