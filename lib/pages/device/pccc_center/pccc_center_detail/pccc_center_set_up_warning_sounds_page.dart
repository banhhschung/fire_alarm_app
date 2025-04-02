import 'package:fire_alarm_app/blocs/device_manager_bloc/device_manager_bloc.dart';
import 'package:fire_alarm_app/blocs/device_manager_bloc/device_manager_event.dart';
import 'package:fire_alarm_app/blocs/device_manager_bloc/device_manager_state.dart';
import 'package:fire_alarm_app/blocs/mqtt_bloc/mqtt_bloc.dart';
import 'package:fire_alarm_app/commons/constant.dart';
import 'package:fire_alarm_app/generated/l10n.dart';
import 'package:fire_alarm_app/model/alert_notification_model.dart';
import 'package:fire_alarm_app/model/device_model.dart';
import 'package:fire_alarm_app/res/app_colors/app_colors.dart';
import 'package:fire_alarm_app/res/app_padding/app_padding.dart';
import 'package:fire_alarm_app/res/app_size/app_size.dart';
import 'package:fire_alarm_app/res/fonts/app_fonts.dart';
import 'package:fire_alarm_app/utils/common_utils.dart';
import 'package:fire_alarm_app/widget_element/custom_app_bar/custom_app_bar_widget.dart';
import 'package:fire_alarm_app/widget_element/custom_scroll_item_picker/item_picker_widget.dart';
import 'package:fire_alarm_app/widget_element/custom_scroll_item_picker/time_picker_widget.dart';
import 'package:fire_alarm_app/widget_element/custom_scroll_item_picker/warning_sounds_audio_picker_widget.dart';
import 'package:fire_alarm_app/widget_element/high_light_button/high_light_button.dart';
import 'package:fire_alarm_app/widget_element/loading_custom/custom_loading_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_switch/flutter_switch.dart';

class PCCCCenterSetUpWarningSoundsPage extends StatefulWidget {
  final Device device;

  const PCCCCenterSetUpWarningSoundsPage({super.key, required this.device});

  @override
  State<StatefulWidget> createState() => _PCCCCenterSetUpWarningSoundsPageState();
}

class _PCCCCenterSetUpWarningSoundsPageState extends State<PCCCCenterSetUpWarningSoundsPage> {
  static const int ACTIVE = 1;
  static const int NOT_ACTIVE = 0;

  late DeviceManagerBloc _deviceManagerBloc;

  late Device _device;
  late AlertNotificationModel? _alertNotificationModel = AlertNotificationModel();
  late bool _isShowProcess = false;

  @override
  void initState() {
    _toggleProcess(true);
    _device = widget.device;
    _deviceManagerBloc = DeviceManagerBloc(BlocProvider.of<MqttBloc>(context))..add(GetWarningSoundsEvent(deviceId: _device.id!));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBarWidget(
        title: S.current.set_up_warning_sounds,
      ),
      body: BlocListener<DeviceManagerBloc, DeviceManagerState>(
          bloc: _deviceManagerBloc,
          listener: (BuildContext context, state) {
            _toggleProcess(false);
            if (state is GetWarningSoundsSuccessState) {
              setState(() {
                _alertNotificationModel = state.alertNotificationModel;
              });
            } else if (state is GetWarningSoundsFailState) {
              Common.showSnackBarMessage(context, S.current.update_failed_please_try_again, isError: true);
            } else if (state is SaveWarningSoundByDeviceSuccessState) {
              Common.showSnackBarMessage(context, S.current.update_successful);
            } else if (state is SaveWarningSoundByDeviceFailState) {
              Common.showSnackBarMessage(context, S.current.update_failed_please_try_again, isError: true);
            }
          },
          child: _buildPCCCCenterSetUpWarningSoundsPageLayout()),
    );
  }

  Widget _buildPCCCCenterSetUpWarningSoundsPageLayout() {
    return CustomLoadingWidget(
      showLoading: _isShowProcess,
      child: Padding(
        padding: const EdgeInsets.all(AppPadding.p16),
        child: Column(
          children: [
            Expanded(
              child: Column(
                children: [_buildOnOffAlertWarningModeLayout(), if (_getModeOfAlert()) _buildWarningSoundsSettingLayout()],
              ),
            ),
            HighLightButton(
              title: S.current.save_information,
              onPress: () {
                _saveWarningSoundByDeviceFunction();
              },
            )
          ],
        ),
      ),
    );
  }

  Widget _buildOnOffAlertWarningModeLayout() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(S.current.mode, style: AppFonts.title2()),
            FlutterSwitch(
              activeColor: AppColors.orangee,
              width: AppSize.a40,
              height: AppSize.a24,
              toggleSize: AppSize.a16,
              value: _getModeOfAlert(),
              borderRadius: AppSize.a30,
              padding: AppPadding.p4,
              showOnOff: false,
              onToggle: (val) {
                setState(() {
                  if (_alertNotificationModel != null) {
                    _alertNotificationModel!.mode = val ? ACTIVE : NOT_ACTIVE;
                  }
                });
              },
            ),
          ],
        ),
        const SizedBox(height: AppSize.a8),
        Text("(${S.current.important_warnings_related_to_security_hazard_detection_incidents_etc})", style: AppFonts.title()),
      ],
    );
  }

  Widget _buildWarningSoundsSettingLayout() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppPadding.p16),
      child: Column(
        children: [
          const SizedBox(
            height: AppSize.a8,
          ),
          const Divider(
            height: AppSize.a1,
            color: AppColors.primaryText,
          ),
          const SizedBox(
            height: AppSize.a16,
          ),
          _buildSoundsSettingLayout(),
          const SizedBox(
            height: AppSize.a8,
          ),
          _buildWarningCycleSettingLayout()
        ],
      ),
    );
  }

  Widget _buildSoundsSettingLayout() {
    return GestureDetector(
      onTap: () {
        showBottomCustomSheetToChooseSoundLayout();
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              const Icon(
                Icons.sensors_outlined,
                size: AppSize.a20,
                color: AppColors.orangee,
              ),
              const SizedBox(
                width: AppSize.a8,
              ),
              Text(S.current.sound, style: AppFonts.title3()),
            ],
          ),
          Text(
            _getNameOfSound() ?? '',
            style: AppFonts.title(color: AppColors.orangee),
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.end,
          ),
        ],
      ),
    );
  }

  Widget _buildWarningCycleSettingLayout() {
    return Column(
      children: [
        Row(
          children: [
            const Icon(
              Icons.settings,
              size: AppSize.a20,
              color: AppColors.orangee,
            ),
            const SizedBox(
              width: AppSize.a8,
            ),
            Text(
              S.current.warning_sound_cycle,
              style: AppFonts.title3(),
            )
          ],
        ),
        const SizedBox(
          height: AppSize.a16,
        ),
        _buildSendWarningLaterSettingLayout(),
        const SizedBox(
          height: AppSize.a16,
        ),
        _buildNumberOfIterationsSettingLayout()
      ],
    );
  }

  Widget _buildSendWarningLaterSettingLayout() {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        showBottomSheetChooseTimeOfSendWarningLaterLayout();
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: AppPadding.p16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(S.current.send_warning_later, style: AppFonts.title()),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  "00:${formatDuration(_alertNotificationModel!.periodic ?? 0)}",
                  style: AppFonts.title(color: AppColors.orangee),
                ),
                const SizedBox(width: AppSize.a4),
                const Icon(
                  Icons.av_timer_outlined,
                  color: AppColors.orangee,
                  size: AppSize.a16,
                )
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _buildNumberOfIterationsSettingLayout() {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        showBottomSheetChooseTimesOfNumberOfIterationsLayout();
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: AppPadding.p16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(S.current.number_of_iterations, style: AppFonts.title()),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  "${_alertNotificationModel!.numberOfRepetition ?? ''} ${(_alertNotificationModel!.numberOfRepetition ?? 0) > 1 ? S.current.times : S.current.times}",
                  style: AppFonts.title(color: AppColors.orangee),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  void showBottomSheetChooseTimeOfSendWarningLaterLayout() {
    showModalBottomSheet(
      context: context,
      builder: (context) => TimePickerBottomSheet(
        duration: convertSecondsToMinutesSeconds(_alertNotificationModel!.periodic!),
        done: (duration) {
          setState(() {
            _alertNotificationModel!.periodic = duration!.inSeconds;
          });
        },
      ),
    );
  }

  void showBottomSheetChooseTimesOfNumberOfIterationsLayout() {
    showModalBottomSheet(
      context: context,
      builder: (context) => ItemPickerWidget(
        listData: List.generate(10, (index) => index + 1),
        preselectedIndex: _alertNotificationModel!.numberOfRepetition! - 1,
        done: (selectedIndex) {
          setState(() {
            _alertNotificationModel!.numberOfRepetition = selectedIndex! + 1;
          });
        },
      ),
    );
  }

  void showBottomCustomSheetToChooseSoundLayout() {
    int preselectedIndex = _alertNotificationModel!.warningSounds!
        .indexOf(_alertNotificationModel!.warningSounds!.firstWhere((soundItem) => soundItem.id == _alertNotificationModel!.warningSoundId));
    showModalBottomSheet(
      isDismissible: false,
      enableDrag: false,
      backgroundColor: Colors.transparent,
      context: context,
      builder: (context) => WarningSoundsAudioPickerWidget(
        listAudioData: _alertNotificationModel!.warningSounds!,
        preselectedIndex: preselectedIndex,
        done: (selectedIndex) {
          setState(() {
            _alertNotificationModel!.warningSoundId = _alertNotificationModel!.warningSounds![selectedIndex!].id;
            SoundModel androidChannelId =
                AppConstant.LIST_ALERT_SOUND.firstWhere((sound) => sound.fileName == _alertNotificationModel!.warningSounds![selectedIndex].fileName)!;
            _alertNotificationModel!.androidChannelId = androidChannelId.androidChannelId;
          });
        },
      ),
    );
  }

  Future<void> _saveWarningSoundByDeviceFunction() async {
    _toggleProcess(true);
    if(await Common.isConnectToServer()){
      _deviceManagerBloc.add(SaveWarningSoundByDeviceEvent(alertNotificationModel: _alertNotificationModel!));
    } else {
      _toggleProcess(false);
      Common.showSnackBarMessage(context, S.current.can_not_connect_to_server, isError: true);
    }
  }

  convertSecondsToMinutesSeconds(int seconds) {
    final int minute = seconds ~/ 60;
    final int second = seconds % 60;
    return Duration(minutes: minute, seconds: second);
  }

  bool _getModeOfAlert() {
    return _alertNotificationModel == null
        ? false
        : (_alertNotificationModel!.mode != null && _alertNotificationModel!.mode == ACTIVE)
            ? true
            : false;
  }

  String? _getNameOfSound() {
    return _alertNotificationModel == null
        ? ""
        : _alertNotificationModel!.warningSounds!.firstWhere((soundItem) => soundItem.id == _alertNotificationModel!.warningSoundId)?.name;
  }

  String formatDuration(int time) {
    int minutes = time ~/ 60;
    int secs = time % 60;
    return '${minutes.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';
  }

  void _toggleProcess(bool isShow) {
    setState(() {
      _isShowProcess = isShow;
    });
  }
}
