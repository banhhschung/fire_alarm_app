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
import 'package:fire_alarm_app/widget_element/high_light_button/high_light_button.dart';
import 'package:fire_alarm_app/widget_element/loading_custom/custom_loading_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PCCCCenterSetWarningTimePage extends StatefulWidget {
  final Device device;

  const PCCCCenterSetWarningTimePage({super.key, required this.device});

  @override
  State<StatefulWidget> createState() => _PCCCCenterSetWarningTimePageState();
}

class _PCCCCenterSetWarningTimePageState extends State<PCCCCenterSetWarningTimePage> {
  late MqttBloc _mqttBloc;

  late Device _device;
  late bool _isShowProcess = false;
  late int delayTime = 0;

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
        title: S.current.set_warning_time,
      ),
      body: BlocListener<MqttBloc, MqttState>(
          bloc: _mqttBloc,
          listener: (context, state) {
            _toggleProcess(false);
            if (state is MqttGetExtraConfigMessageState && state.mqttExtraConfigModel.devExtAddr == _device.address) {
              setState(() {
                delayTime = state.mqttExtraConfigModel.delayTime ?? 0;
              });
            }  else if (state is MqttSetExtraConfigMessageState && state.mqttExtraConfigModel.devExtAddr == _device.address) {
              if (state.mqttExtraConfigModel.errorCode == 50000) {
                Common.showSnackBarMessage(context, S.current.update_successful);
              } else {
                Common.showSnackBarMessage(context, S.current.update_failed_please_try_again);
              }
            }
          },
          child: _buildPCCCCenterSetWarningTimePageLayout()),
    );
  }

  Widget _buildPCCCCenterSetWarningTimePageLayout() {
    return CustomLoadingWidget(
      showLoading: _isShowProcess,
      child: Padding(
        padding: const EdgeInsets.all(AppPadding.p16),
        child: Column(
          children: [
            Expanded(
              child: Column(
                children: [_buildSettingWarningTimeLayout()],
              ),
            ),
            HighLightButton(
              title: S.current.save_information,
              onPress: () {
                _saveWarningTimeFunction();
              },
            )
          ],
        ),
      ),
    );
  }

  Widget _buildSettingWarningTimeLayout() {
    return Column(
      children: [
        Text(
          S.current.users_can_customize_the_confirmation_time_before_the_system_sends_an_alert,
          style: AppFonts.title6(color: AppColors.primaryText),
        ),
        const SizedBox(
          height: AppSize.a32,
        ),
        _buildSettingTimeLayout()
      ],
    );
  }

  Widget _buildSettingTimeLayout() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppPadding.p16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            S.current.warning_confirmation_time,
            style: AppFonts.title3(),
          ),
          GestureDetector(
            onTap: () {
              _showTimePicker();
            },
            child: Text(
              formatDuration(),
              style: AppFonts.title3(color: AppColors.orangee),
            ),
          ),
        ],
      ),
    );
  }

  String formatDuration() {
    int minutes = delayTime ~/ 60;
    int secs = delayTime % 60;
    return '${minutes.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';
  }

  Future<void> _saveWarningTimeFunction() async {
    _toggleProcess(true);
    if (await Common.isConnectToServer()) {
      _mqttBloc.add(MqttCmdSetExtraConfigEvent(param: 'delayTime', value: delayTime, device: _device));
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

  void _showTimePicker() {
    int selectedMinutes = delayTime ~/ 60;
    int selectedSeconds = delayTime % 60;
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return SizedBox(
          height: 300,
          child: Column(
            children: [
              // Header
              Padding(
                padding: const EdgeInsets.all(AppPadding.p16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: (){
                        Navigator.pop(context);
                      },
                      iconSize: AppSize.a24,
                    ),
                    Text(S.current.choose_time, style: AppFonts.title3(fontSize: AppSize.a24)),
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                        setState(() {
                          delayTime = selectedMinutes * 60 + selectedSeconds;
                        });
                      },
                      child: Text(S.current.save, style: AppFonts.title3(fontSize: AppSize.a16, color: AppColors.orangee)),
                    ),
                  ],
                ),
              ),
              const Divider(height: 1),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: CupertinoPicker(
                        itemExtent: 40,
                        scrollController: FixedExtentScrollController(
                          initialItem: selectedMinutes,
                        ),
                        onSelectedItemChanged: (int value) {
                          setState(() {
                            selectedMinutes = value;
                          });
                        },
                        children: List.generate(60, (index) {
                          return Center(child: Text("$index", style: AppFonts.datetimePickerPopup(fontSize: AppSize.a24)));
                        }),
                      ),
                    ),
                    Text(S.current.minute, style: AppFonts.datetimePickerPopup()),
                    const SizedBox(
                      width: AppSize.a40,
                    ),
                    Expanded(
                      child: CupertinoPicker(
                        itemExtent: 40,
                        scrollController: FixedExtentScrollController(
                          initialItem: selectedSeconds,
                        ),
                        onSelectedItemChanged: (int value) {
                          setState(() {
                            selectedSeconds = value;
                          });
                        },
                        children: List.generate(60, (index) {
                          return Center(child: Text("$index", style: AppFonts.datetimePickerPopup(fontSize: AppSize.a24)));
                        }),
                      ),
                    ),
                    Text(S.current.second, style: AppFonts.datetimePickerPopup()),
                    const SizedBox(
                      width: AppSize.a40,
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
