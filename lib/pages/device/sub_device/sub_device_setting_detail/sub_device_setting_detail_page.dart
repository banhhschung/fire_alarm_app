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

class SubDeviceSettingDetailPage extends StatefulWidget {
  final Device device;

  const SubDeviceSettingDetailPage({super.key, required this.device});

  @override
  State<StatefulWidget> createState() => _SubDeviceSettingDetailPageState();
}

class _SubDeviceSettingDetailPageState extends State<SubDeviceSettingDetailPage> {
  late DeviceManagerBloc _deviceManagerBloc;

  late Device _device;

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
        title: S.current.device_information,
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
          child: _buildSubDeviceSettingDetailLayout()),
    );
  }

  Widget _buildSubDeviceSettingDetailLayout() {
    return CustomLoadingWidget(
      showLoading: _isShowProcess,
      child: Padding(
        padding: const EdgeInsets.all(AppPadding.p16),
        child: Column(
          children: [
            _buildDeviceSettingItem(),
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

  Widget _buildDeviceSettingItem() {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).pushNamed(AppRoutes.deviceInformationSettingPage, arguments: _device);
      },
      child: Container(
        padding: const EdgeInsets.all(AppPadding.p16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(S.current.device_information, style: AppFonts.title()),
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
