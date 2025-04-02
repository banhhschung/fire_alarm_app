import 'dart:async';

import 'package:fire_alarm_app/blocs/device_manager_bloc/device_manager_bloc.dart';
import 'package:fire_alarm_app/blocs/device_manager_bloc/device_manager_event.dart';
import 'package:fire_alarm_app/blocs/device_manager_bloc/device_manager_state.dart';
import 'package:fire_alarm_app/blocs/mqtt_bloc/mqtt_bloc.dart';
import 'package:fire_alarm_app/blocs/mqtt_bloc/mqtt_state.dart';
import 'package:fire_alarm_app/gen/assets.gen.dart';
import 'package:fire_alarm_app/generated/l10n.dart';
import 'package:fire_alarm_app/model/device_model.dart';
import 'package:fire_alarm_app/res/app_padding/app_padding.dart';
import 'package:fire_alarm_app/res/app_size/app_size.dart';
import 'package:fire_alarm_app/res/fonts/app_fonts.dart';
import 'package:fire_alarm_app/widget_element/custom_app_bar/custom_app_bar_widget.dart';
import 'package:fire_alarm_app/widget_element/high_light_button/high_light_button.dart';
import 'package:fire_alarm_app/widget_element/loading_custom/custom_adding_device_loading_widget.dart';
import 'package:fire_alarm_app/widget_element/loading_custom/custom_vertical_dot_loading_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

enum AddDeviceProcess { Scanning, Success, Failure }

class SubDeviceAddDeviceAddingAndResultPage extends StatefulWidget {
  final Device deviceCenter;

  const SubDeviceAddDeviceAddingAndResultPage({super.key, required this.deviceCenter});

  @override
  State<StatefulWidget> createState() => _SubDeviceAddDeviceAddingAndResultPageState();
}

class _SubDeviceAddDeviceAddingAndResultPageState extends State<SubDeviceAddDeviceAddingAndResultPage> {
  late MqttBloc _mqttBloc;
  late DeviceManagerBloc _deviceManagerBloc;

  late AddDeviceProcess _addDeviceProcess;

  late Device _deviceCenter;

  late Device _addingDevice;

  bool _getDeviceMessage = false;

  @override
  void initState() {
    _deviceCenter = widget.deviceCenter;
    _mqttBloc = BlocProvider.of<MqttBloc>(context);
    _deviceManagerBloc = DeviceManagerBloc(BlocProvider.of<MqttBloc>(context));
    _addDeviceProcess = AddDeviceProcess.Scanning;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBarWidget(
        title: S.current.connect_device,
      ),
      body: MultiBlocListener(
        listeners: [
          BlocListener<MqttBloc, MqttState>(
            bloc: _mqttBloc,
            listener: (context, state) {
              if (state is GetMqttMessageAddDeviceState /*&& state.mqttMessageAddDeviceModel.devExtAddr == _deviceCenter.address*/) {
                _getDeviceMessage = true;
                if (state.mqttMessageAddDeviceModel.devList != null &&
                    state.mqttMessageAddDeviceModel.devList!.first != null &&
                    state.mqttMessageAddDeviceModel.devList!.first.errorCode == 50000) {
                  _addingDevice = Device(address: state.mqttMessageAddDeviceModel.devList!.first.devExtAddr, code: 4001 /*state.mqttMessageAddDeviceModel.devT*/, parentId: _deviceCenter.id);
                  _deviceManagerBloc.add(AddDeviceToBEEvent(device: _addingDevice));
                } else {
                  setState(() {
                    _addDeviceProcess = AddDeviceProcess.Failure;
                  });
                }
              }
            },
          ),
          BlocListener<DeviceManagerBloc, DeviceManagerState>(
            bloc: _deviceManagerBloc,
            listener: (context, state) {
              if (state is AddDeviceToBESuccessState) {
                _deviceManagerBloc.add(ActiveDeviceInBEEvent("1.0.0", _addingDevice.address));
              } else if (state is AddDeviceToBEFailState) {
                setState(() {
                  _addDeviceProcess = AddDeviceProcess.Failure;
                });
              } else if (state is ActiveDeviceInBESuccessState) {
                setState(() {
                  _addDeviceProcess = AddDeviceProcess.Success;
                });
              } else if (state is ActiveDeviceInBEFailState) {
                setState(() {
                  _addDeviceProcess = AddDeviceProcess.Failure;
                });
              }
            },
          )
        ],
        child: _buildSmokeSensorAddDeviceAddingAndResultPageLayout(),
      ),
    );
  }

  Widget _buildSmokeSensorAddDeviceAddingAndResultPageLayout() {
    return Padding(
      padding: const EdgeInsets.all(AppPadding.p16),
      child: _buildAddDeviceStatusLayout(),
    );
  }

  Widget _buildAddDeviceStatusLayout() {
    switch (_addDeviceProcess) {
      case AddDeviceProcess.Scanning:
        return _buildAddDeviceScanningStatusLayout();
      case AddDeviceProcess.Success:
        return _buildAddDeviceResultStatusDetailLayout();
      case AddDeviceProcess.Failure:
        return _buildAddDeviceResultStatusDetailLayout(isSuccess: false);
    }
  }

  Widget _buildAddDeviceScanningStatusLayout() {
    return Stack(
      children: [
        SizedBox(width: MediaQuery.of(context).size.width, child: Assets.images.backgroundAddingDeviceImg.image(fit: BoxFit.fitWidth)),
        _buildAddDeviceScanningStatusDetailLayout()
      ],
    );
  }

  Widget _buildAddDeviceScanningStatusDetailLayout() {
    return Column(
      children: [
        CustomAddingDeviceLoadingWidget(),
        const SizedBox(height: AppSize.a35),
        const CustomVerticalDotLoadingWidget(),
        const SizedBox(height: AppSize.a16),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppPadding.p170),
          child: Assets.images.mobileDeviceInAddingDeviceImg.image(),
        ),
      ],
    );
  }

  Widget _buildAddDeviceResultStatusDetailLayout({bool isSuccess = true}) {
    return Column(
      children: [
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppPadding.p155),
                child: isSuccess ? Assets.images.successImg.image() : Assets.images.failureImg.image(),
              ),
              Text(
                isSuccess ? S.current.pairing_success : S.current.pairing_failure,
                style: AppFonts.title(),
              )
            ],
          ),
        ),
        HighLightButton(
          title: isSuccess ? S.current.complete : S.current.try_again,
          onPress: () {},
        )
      ],
    );
  }

  void countdown(int seconds) {
    Timer.periodic(const Duration(seconds: 1), (timer) {
      seconds--;
      if (seconds < 0) {
        timer.cancel();
      }
    });
  }
}
