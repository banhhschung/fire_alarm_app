import 'package:fire_alarm_app/blocs/mqtt_bloc/mqtt_bloc.dart';
import 'package:fire_alarm_app/blocs/mqtt_bloc/mqtt_state.dart';
import 'package:fire_alarm_app/configs/device_type_code.dart';
import 'package:fire_alarm_app/gen/assets.gen.dart';
import 'package:fire_alarm_app/model/device_model.dart';
import 'package:fire_alarm_app/model/device_param_model.dart';
import 'package:fire_alarm_app/model/mqtt_message_data_model.dart';
import 'package:fire_alarm_app/res/app_colors/app_colors.dart';
import 'package:fire_alarm_app/res/app_padding/app_padding.dart';
import 'package:fire_alarm_app/res/app_size/app_size.dart';
import 'package:fire_alarm_app/res/fonts/app_fonts.dart';
import 'package:fire_alarm_app/routes/app_routes/app_routes.dart';
import 'package:fire_alarm_app/widget_element/custom_device_status_layout/pccc_device_status_layout.dart';
import 'package:fire_alarm_app/widget_element/custom_device_status_layout/sub_device_pin_status_layout.dart';
import 'package:fire_alarm_app/widget_element/custom_device_status_layout/sub_device_warning_status_layout.dart';
import 'package:fire_alarm_app/widget_element/empty_layout/empty_device_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SubHomeListParamGroupByRoom extends StatelessWidget {
  late List<Device> listDevice = [];

  SubHomeListParamGroupByRoom({super.key});

  changeListDevice(List<Device> devices) {
    listDevice.clear();
    listDevice.addAll(devices);
  }

  @override
  Widget build(BuildContext context) {
    return _buildSubHomeListParamGroupByRoomLayout(context);
  }

  Widget _buildSubHomeListParamGroupByRoomLayout(BuildContext context) {
    if (listDevice.isNotEmpty) {
      return _buildListDeviceLayout(context);
    } else {
      return EmptyDeviceWidget(
        onPress: () {
          Navigator.pushNamed(context, AppRoutes.listDeviceTypePage);
        },
      );
    }
  }

  Widget _buildListDeviceLayout(BuildContext context) {
    return BlocBuilder<MqttBloc, MqttState>(
      bloc: BlocProvider.of<MqttBloc>(context),
      builder: (BuildContext context, MqttState state) {
        if (state is GetMqttMessageState) {
          _changeDeviceDataByMqttMessage(state);
        }
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppPadding.p24),
          child: GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate:
                  const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, crossAxisSpacing: 12, mainAxisSpacing: 12, childAspectRatio: 1.6),
              itemCount: listDevice.length,
              itemBuilder: (context, index) {
                return _buildDeviceItemLayout(listDevice[index], context);
              }),
        );
      },
    );
  }

  Widget _buildDeviceItemLayout(Device device, BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (device.code == DeviceTypeCode.PCCC_CENTER) {
          Navigator.of(context).pushNamed(AppRoutes.pCCCCenterDetailPage, arguments: device);
        } else {
          Navigator.of(context).pushNamed(AppRoutes.subDeviceSettingDetailPage, arguments: device);
        }
      },
      child: Container(
        padding: const EdgeInsets.all(AppPadding.p8),
        decoration: BoxDecoration(
            color: _deviceItemLayoutColorByDeviceStatus(device) ? AppColors.deviceItemErrorPrimary : AppColors.white,
            borderRadius: BorderRadius.circular(AppSize.a8),
            border: Border.all(
              width: AppSize.a1,
              color: _deviceItemLayoutColorByDeviceStatus(device) ? AppColors.errorPrimary : AppColors.white,
            )),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [_buildDeviceImageLayout(device), if (device.code != DeviceTypeCode.PCCC_CENTER) _buildSensorWarningStatusLayout(device)],
                ),
                _buildStatusOfDeviceLayout(device)
              ],
            ),
            const SizedBox(
              height: AppSize.a6,
            ),
            _buildNameAndRoomNameOfDeviceLayout(device)
          ],
        ),
      ),
    );
  }

  //todo: check with other devices;
  Widget _buildDeviceImageLayout(Device device) {
    switch (device.code) {
      case DeviceTypeCode.PCCC_CENTER:
        return Assets.images.pcccCenterImg.image(width: AppSize.a38, height: AppSize.a38);
      case DeviceTypeCode.SMOKE_SENSOR_LORA:
        return Assets.images.smokeSensorImg.image(width: AppSize.a38, height: AppSize.a38);
      default:
        return Assets.images.pcccCenterImg.image(width: AppSize.a38, height: AppSize.a38);
    }
  }

  Widget _buildSensorWarningStatusLayout(Device device) {
    return Row(
      children: [
        const SizedBox(
          width: AppSize.a4,
        ),
        SubDeviceWarningStatusLayout(
          device: device,
        ),
      ],
    );
  }

  Widget _buildStatusOfDeviceLayout(Device device) {
    switch (device.code) {
      case DeviceTypeCode.PCCC_CENTER:
        return PCCCDeviceStatusLayout(
          device: device,
        );
      default:
        return SubDevicePinStatusLayout(
          device: device,
        );
    }
  }

  Widget _buildNameAndRoomNameOfDeviceLayout(Device device) {
    return Expanded(
      child: Row(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                device.name ?? "",
                style: AppFonts.deviceNameText(),
                textAlign: TextAlign.start,
              ),
              if (device.roomName != null)
                Column(
                  children: [
                    const SizedBox(
                      height: AppSize.a8,
                    ),
                    Text(
                      device.roomName!,
                      style: AppFonts.subTitle3(fontSize: AppSize.a10),
                    ),
                  ],
                )
            ],
          ),
        ],
      ),
    );
  }

  void _changeDeviceDataByMqttMessage(GetMqttMessageState state) {
    int changeItemIndex = listDevice.lastIndexWhere((device) => device.address == state.mqttMessageDataModel.devExtAddr);
    if (changeItemIndex >= 0) {
      Device device = listDevice[changeItemIndex];
      //todo: check device connect status
      /*if (state.mqttMessageDataModel.timeStamp != null &&
          _currentTimestamp ~/ 1000 -
              state.mqttGetDataModel.timeStamp! <
              86400) {
        device.connectStatus = Device.DEVICE_STATUS_CONNECTED;
      }*/
      if (state.mqttMessageDataModel.devV != null) {
        for (DeviceParamModel? model in device.params) {
          for (DevV devV in state.mqttMessageDataModel.devV!) {
            if (model!.paramKey == devV.param && devV.value != -1) {
              model.value = devV.value;
            }
          }
        }
      }
      listDevice[changeItemIndex] = device;
    }
  }

  bool _deviceItemLayoutColorByDeviceStatus(Device device) {
    if (device.code == DeviceTypeCode.PCCC_CENTER) {
      return false;
    } else {
      DeviceParamModel? deviceParamModel = device.params.firstWhere((deviceParam) => deviceParam.paramKey == 'fire', orElse: () => DeviceParamModel());
      if (deviceParamModel != null && deviceParamModel.value != null) {
        return deviceParamModel.value == 1 ? true : false;
      } else {
        return false;
      }
    }
  }
}
