import 'package:cached_network_image/cached_network_image.dart';
import 'package:fire_alarm_app/blocs/device_manager_bloc/device_manager_bloc.dart';
import 'package:fire_alarm_app/blocs/device_manager_bloc/device_manager_event.dart';
import 'package:fire_alarm_app/blocs/device_manager_bloc/device_manager_state.dart';
import 'package:fire_alarm_app/blocs/mqtt_bloc/mqtt_bloc.dart';
import 'package:fire_alarm_app/configs/device_type_code.dart';
import 'package:fire_alarm_app/generated/l10n.dart';
import 'package:fire_alarm_app/model/device_model.dart';
import 'package:fire_alarm_app/model/device_type_model.dart';
import 'package:fire_alarm_app/model/smart_config_wifi_device_args.dart';
import 'package:fire_alarm_app/res/app_colors/app_colors.dart';
import 'package:fire_alarm_app/res/app_size/app_size.dart';
import 'package:fire_alarm_app/res/fonts/app_fonts.dart';
import 'package:fire_alarm_app/routes/app_routes/app_routes.dart';
import 'package:fire_alarm_app/widget_element/custom_app_bar/custom_app_bar_widget.dart';
import 'package:fire_alarm_app/widget_element/empty_layout/empty_device_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ListDeviceTypePage extends StatefulWidget {
  final Device? deviceCenter;

  const ListDeviceTypePage({super.key, this.deviceCenter});
  @override
  State<StatefulWidget> createState() => _ListDeviceTypePageState();
}

class _ListDeviceTypePageState extends State<ListDeviceTypePage> {
  final List<DeviceTypeModel> _listDeviceType = [];
  late DeviceManagerBloc _deviceManagerBloc;

  late Device? _deviceCenter;
  @override
  void initState() {
    _deviceManagerBloc = DeviceManagerBloc(BlocProvider.of<MqttBloc>(context))..add(GetListDeviceTypeEvent());
    _deviceCenter = widget.deviceCenter;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBarWidget(
        title: S.current.choose_device_type,
      ),
      body: BlocBuilder<DeviceManagerBloc, DeviceManagerState>(
        bloc: _deviceManagerBloc,
        builder: (BuildContext context, DeviceManagerState state) {
          if (state is GetListDeviceTypeState) {
            if (state.listDeviceType.isNotEmpty) {
              if(_deviceCenter != null){
                state.listDeviceType.removeWhere((deviceTypeModel)=> deviceTypeModel.code == DeviceTypeCode.PCCC_CENTER);
              }
              return _listDeviceTypeLayout(state.listDeviceType);
            } else {
              return const EmptyDeviceWidget(
                showButtonPress: false,
              );
            }
          } else {
            return const SizedBox();
          }
        },
      ),
    );
  }

  Widget _listDeviceTypeLayout(List<DeviceTypeModel> listDeviceType) {
    return SizedBox(
      height: MediaQuery.of(context).size.height,
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, childAspectRatio: 1),
        itemBuilder: (context, index) {
          return _deviceTypeModelItemLayout(listDeviceType[index]);
        },
        itemCount: listDeviceType.length,
      ),
    );
  }

  Widget _deviceTypeModelItemLayout(DeviceTypeModel model) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        _deviceTypeModelHandler(model.code);
      },
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Container(
          decoration: BoxDecoration(color: AppColors.white, borderRadius: BorderRadius.circular(AppSize.a8)),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CachedNetworkImage(
                    placeholder: (context, url) => const Center(
                      child: SizedBox(height: AppSize.a30, width: AppSize.a30, child: CircularProgressIndicator()),
                    ),
                    imageUrl: model.urlImage ?? "abc",
                    height: AppSize.a80,
                  ),
                  const SizedBox(
                    height: AppSize.a8,
                  ),
                  Text('${model.name}', textAlign: TextAlign.center, style: AppFonts.subTitle())
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _deviceTypeModelHandler(int? deviceTypeCode){
    if(deviceTypeCode != null){
      switch(deviceTypeCode){
        case DeviceTypeCode.PCCC_CENTER:
          Navigator.pushNamed(context, AppRoutes.pcccCenterAddSerialPage, arguments: SmartConfigWifiDeviceArgs());
          break;
        default:
          Navigator.pushNamed(context, AppRoutes.subDeviceAddDeviceTutorialPage, arguments: _deviceCenter);
          break;
      }
    }
  }
}
