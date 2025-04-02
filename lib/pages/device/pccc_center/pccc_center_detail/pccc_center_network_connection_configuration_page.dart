import 'package:fire_alarm_app/blocs/mqtt_bloc/mqtt_bloc.dart';
import 'package:fire_alarm_app/blocs/mqtt_bloc/mqtt_event.dart';
import 'package:fire_alarm_app/blocs/mqtt_bloc/mqtt_state.dart';
import 'package:fire_alarm_app/generated/l10n.dart';
import 'package:fire_alarm_app/model/device_model.dart';
import 'package:fire_alarm_app/res/app_colors/app_colors.dart';
import 'package:fire_alarm_app/res/app_padding/app_padding.dart';
import 'package:fire_alarm_app/res/app_size/app_size.dart';
import 'package:fire_alarm_app/res/fonts/app_fonts.dart';
import 'package:fire_alarm_app/utils/common_utils.dart';
import 'package:fire_alarm_app/widget_element/custom_app_bar/custom_app_bar_widget.dart';
import 'package:fire_alarm_app/widget_element/custom_ratio_button/custom_ratio_button.dart';
import 'package:fire_alarm_app/widget_element/high_light_button/high_light_button.dart';
import 'package:fire_alarm_app/widget_element/loading_custom/custom_loading_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PCCCCenterNetworkConnectionConfigurationPage extends StatefulWidget {
  final Device device;

  const PCCCCenterNetworkConnectionConfigurationPage({super.key, required this.device});

  @override
  State<StatefulWidget> createState() => _PCCCCenterNetworkConnectionConfigurationPageState();
}

class _PCCCCenterNetworkConnectionConfigurationPageState extends State<PCCCCenterNetworkConnectionConfigurationPage> {
  final int USE_4G = 1;
  final int USE_ETHERNET = 2;

  late MqttBloc _mqttBloc;

  late Device _device;

  late bool _isShowProcess = false;

  late int networkUse = 0;

  @override
  void initState() {
    _device = widget.device;
    _mqttBloc = BlocProvider.of<MqttBloc>(context)..add(MqttCmdGetExtraConfigEvent(device: _device));
    _toggleProcess(true);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBarWidget(
        title: S.current.network_connection_configuration,
      ),
      body: BlocListener<MqttBloc, MqttState>(
          bloc: _mqttBloc,
          listener: (context, state) {
            _toggleProcess(false);
            if (state is MqttGetExtraConfigMessageState && state.mqttExtraConfigModel.devExtAddr == _device.address) {
              setState(() {
                networkUse = state.mqttExtraConfigModel.networkUse ?? 0;
              });
            } else if (state is MqttSetExtraConfigMessageState && state.mqttExtraConfigModel.devExtAddr == _device.address) {
              if (state.mqttExtraConfigModel.errorCode == 50000) {
                Common.showSnackBarMessage(context, S.current.update_successful);
              } else {
                Common.showSnackBarMessage(context, S.current.update_failed_please_try_again);
              }
            }
          },
          child: _buildPCCCCenterNetworkConnectionConfigurationPageLayout()),
    );
  }

  Widget _buildPCCCCenterNetworkConnectionConfigurationPageLayout() {
    return CustomLoadingWidget(
      showLoading: _isShowProcess,
      child: Padding(
        padding: const EdgeInsets.all(AppPadding.p16),
        child: Column(
          children: [
            Expanded(
              child: Column(
                children: [_buildNetworkTypeConnectLayout()],
              ),
            ),
            HighLightButton(
              title: S.current.save_information,
              onPress: () {
                _saveNetworkConnectionConfigurationFunction();
              },
            )
          ],
        ),
      ),
    );
  }

  Widget _buildNetworkTypeConnectLayout() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          S.current.select_preferred_network_when_connecting,
          style: AppFonts.title6(color: AppColors.primaryText),
        ),
        const SizedBox(
          height: AppSize.a32,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppPadding.p16),
          child: Column(
            children: [
              CustomRadioButton(
                label: '  4G',
                value: networkUse == USE_4G,
                onChanged: (bool value) {
                  setState(() {
                    networkUse = USE_4G;
                  });
                },
              ),
              const SizedBox(
                height: AppSize.a32,
              ),
              CustomRadioButton(
                label: '  Lan',
                value: networkUse == USE_ETHERNET,
                onChanged: (bool value) {
                  setState(() {
                    networkUse = USE_ETHERNET;
                  });
                },
              ),
            ],
          ),
        )
      ],
    );
  }

  Future<void> _saveNetworkConnectionConfigurationFunction() async {
    _toggleProcess(true);
    if (await Common.isConnectToServer()) {
      _mqttBloc.add(MqttCmdSetExtraConfigEvent(param: 'networkUse', value: networkUse, device: _device));
    } else {
      _toggleProcess(false);
      Common.showSnackBarMessage(context, S.current.can_not_connect_to_server, isError: true);
    }
  }

  void _toggleProcess(bool isShow) {
    setState(() {
      _isShowProcess = isShow;
    });
  }
}
