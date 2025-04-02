import 'package:fire_alarm_app/blocs/device_manager_bloc/device_manager_bloc.dart';
import 'package:fire_alarm_app/blocs/device_manager_bloc/device_manager_event.dart';
import 'package:fire_alarm_app/blocs/device_manager_bloc/device_manager_state.dart';
import 'package:fire_alarm_app/blocs/mqtt_bloc/mqtt_bloc.dart';
import 'package:fire_alarm_app/generated/l10n.dart';
import 'package:fire_alarm_app/model/device_model.dart';
import 'package:fire_alarm_app/res/app_colors/app_colors.dart';
import 'package:fire_alarm_app/res/app_padding/app_padding.dart';
import 'package:fire_alarm_app/res/app_size/app_size.dart';
import 'package:fire_alarm_app/res/fonts/app_fonts.dart';
import 'package:fire_alarm_app/routes/app_routes/app_routes.dart';
import 'package:fire_alarm_app/utils/common_utils.dart';
import 'package:fire_alarm_app/widget_element/custom_app_bar/custom_app_bar_widget.dart';
import 'package:fire_alarm_app/widget_element/high_light_button/high_light_button.dart';
import 'package:fire_alarm_app/widget_element/loading_custom/custom_loading_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PCCCCenterSettingPage extends StatefulWidget {
  final Device device;

  const PCCCCenterSettingPage({super.key, required this.device});

  @override
  State<StatefulWidget> createState() => _PCCCCenterSettingPageState();
}

class _PCCCCenterSettingPageState extends State<PCCCCenterSettingPage> {
  late DeviceManagerBloc _deviceManagerBloc;

  late Device _device;

  final String DEVICE_INFORMATION = "DEVICE_INFORMATION";
  final String NETWORK_CONNECTION_CONFIGURATION = "NETWORK_CONNECTION_CONFIGURATION";
  final String NETWORK_WARNING_TIME = "NETWORK_WARNING_TIME";
  final String SET_UP_WARNING_SOUNDS = "SET_UP_WARNING_SOUNDS";

  late bool _isShowProcess = false;

  @override
  void initState() {
    _deviceManagerBloc = DeviceManagerBloc(BlocProvider.of<MqttBloc>(context));
    _device = widget.device;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBarWidget(
        title: S.current.device_details,
      ),
      body: BlocListener<DeviceManagerBloc, DeviceManagerState>(
          bloc: _deviceManagerBloc,
          listener: (context, state) {
            _toggleProcess(false);
            if (state is RemoveDeviceSuccessState) {
              Common.showNormalPopup(
                context,
                title: S.current.delete_device,
                content: Center(
                  child: Text(
                    S.current.update_successful,
                    textAlign: TextAlign.center,
                  ),
                ),
                onPressedDone: () {
                  Navigator.of(context).popUntil((route) => route.isFirst);
                },
              );
            } else if (state is RemoveDeviceFailState) {
              Common.showSnackBarMessage(context, S.current.update_failed_please_try_again, isError: true);
            }
          },
          child: _buildPCCCCenterSettingPageLayout()),
    );
  }

  Widget _buildPCCCCenterSettingPageLayout() {
    return CustomLoadingWidget(
      showLoading: _isShowProcess,
      child: Padding(
        padding: const EdgeInsets.all(AppPadding.p16),
        child: Column(
          children: [
            Column(
              children: [
                _buildDeviceSettingItem(DEVICE_INFORMATION),
                _buildDeviceSettingItem(NETWORK_CONNECTION_CONFIGURATION),
                _buildDeviceSettingItem(NETWORK_WARNING_TIME),
                _buildDeviceSettingItem(SET_UP_WARNING_SOUNDS),
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: AppPadding.p40),
              child: HighLightButton(
                buttonColor: Colors.white,
                title: S.current.delete_device,
                textStyle: AppFonts.buttonText(color: AppColors.orangee),
                onPress: () {
                  _deleteDeviceFunction();
                },
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildDeviceSettingItem(String itemKey) {
    return GestureDetector(
      onTap: () {
        _openDetailDeviceSettingItem(itemKey);
      },
      child: Container(
        padding: const EdgeInsets.all(AppPadding.p16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(_buildDeviceTitleText(itemKey), style: AppFonts.title()),
            const Icon(
              Icons.chevron_right_outlined,
              size: AppSize.a20,
              color: AppColors.secondaryText,
            )
          ],
        ),
      ),
    );
  }

  String _buildDeviceTitleText(String itemKey) {
    switch (itemKey) {
      case "DEVICE_INFORMATION":
        return S.current.device_information;
      case "NETWORK_CONNECTION_CONFIGURATION":
        return S.current.network_connection_configuration;
      case "SET_UP_WARNING_SOUNDS":
        return S.current.set_up_warning_sounds;
      case 'NETWORK_WARNING_TIME':
        return S.current.set_warning_time;
      default:
        return "";
    }
  }

  void _openDetailDeviceSettingItem(String itemKey) {
    switch (itemKey) {
      case 'DEVICE_INFORMATION':
        Navigator.of(context).pushNamed(AppRoutes.deviceInformationSettingPage, arguments: _device);
        break;
      case 'NETWORK_CONNECTION_CONFIGURATION':
        Navigator.of(context).pushNamed(AppRoutes.pCCCCenterNetworkConnectionConfigurationPage, arguments: _device);
        break;
      case 'NETWORK_WARNING_TIME':
        Navigator.of(context).pushNamed(AppRoutes.pCCCCenterSetWarningTimePage, arguments: _device);
        break;
      case 'SET_UP_WARNING_SOUNDS':
        Navigator.of(context).pushNamed(AppRoutes.pCCCCenterSetUpWarningSoundsPage, arguments: _device);
        break;
      default:
        return;
    }
  }

  Future<void> _deleteDeviceFunction() async {
    _toggleProcess(true);
    if (await Common.isConnectToServer()) {
      _toggleProcess(false);
      Common.showNormalPopup(context,
          title: S.current.delete_device,
          content: Center(
            child: Text(
              S.current.are_you_sure_you_want_to_erase_the_device,
              textAlign: TextAlign.center,
            ),
          ), onPressedDone: () {
        _toggleProcess(true);
        _deviceManagerBloc.add(RemoveDeviceEvent(device: _device));
      });
    } else {
      _toggleProcess(false);
      Common.showSnackBarMessage(context, S.current.can_not_connect_to_server, isError: false);
    }
  }

  void _toggleProcess(bool isShow) {
    setState(() {
      _isShowProcess = isShow;
    });
  }
}
