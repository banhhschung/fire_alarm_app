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
import 'package:fire_alarm_app/utils/common_utils.dart';
import 'package:fire_alarm_app/widget_element/custom_app_bar/custom_app_bar_widget.dart';
import 'package:fire_alarm_app/widget_element/custom_text_field/custom_text_field_widget.dart';
import 'package:fire_alarm_app/widget_element/high_light_button/high_light_button.dart';
import 'package:fire_alarm_app/widget_element/loading_custom/custom_loading_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DeviceInformationSettingPage extends StatefulWidget {
  final Device device;

  const DeviceInformationSettingPage({super.key, required this.device});

  @override
  State<StatefulWidget> createState() => _DeviceInformationSettingPageState();
}

class _DeviceInformationSettingPageState extends State<DeviceInformationSettingPage> {
  late DeviceManagerBloc _deviceManagerBloc;

  late TextEditingController _textEditingController = TextEditingController();
  late Device _device;
  late bool _isShowProcess = false;

  @override
  void initState() {
    _device = widget.device;
    _textEditingController.text = _device.name ?? "";
    _deviceManagerBloc = DeviceManagerBloc(BlocProvider.of<MqttBloc>(context));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: CustomAppBarWidget(
        title: S.current.device_information,
      ),
      body: BlocListener<DeviceManagerBloc, DeviceManagerState>(
          bloc: _deviceManagerBloc,
          listener: (context, state) {
            _toggleProcess(false);
            if (state is UpdateInformationDeviceSuccessState) {
              Common.showSnackBarMessage(context, S.current.update_successful);
            } else if (state is UpdateInformationDeviceFailState) {
              Common.showSnackBarMessage(context, S.current.update_failed_please_try_again, isError: true);
            }
          },
          child: _buildDeviceInformationSettingPageLayout()),
    );
  }

  Widget _buildDeviceInformationSettingPageLayout() {
    return CustomLoadingWidget(
      showLoading: _isShowProcess,
      child: Padding(
        padding: const EdgeInsets.all(AppPadding.p16),
        child: Column(
          children: [
            Expanded(
                child: Column(
              children: [
                _buildDeviceNamingLayout(),
                const SizedBox(
                  height: AppSize.a16,
                ),
                _buildWarrantyInformationLayout()
              ],
            )),
            HighLightButton(
                title: S.current.save_information,
                buttonColor: (_textEditingController.text != _device.name) ? AppColors.orangee : AppColors.orangee.withOpacity(AppSize.a0_5),
                onPress: () {
                  _saveDeviceUpdateInformationFunction();
                })
          ],
        ),
      ),
    );
  }

  Widget _buildDeviceNamingLayout() {
    return CustomTextFieldWidget(
      titleInput: S.current.device_naming,
      controller: _textEditingController,
      onChanged: (value) {
        setState(() {});
      },
    );
  }

  Widget _buildWarrantyInformationLayout() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          S.current.warranty_information,
          style: AppFonts.title5(fontSize: AppPadding.p18, color: AppColors.title),
        ),
        const SizedBox(
          height: AppSize.a8,
        ),
        _buildDeviceInformationDetailLayout(S.current.expiration_date, "04/08/2025"),
        const SizedBox(
          height: AppSize.a8,
        ),
        _buildDeviceParametersLayout()
      ],
    );
  }

  Widget _buildDeviceParametersLayout() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          S.current.device_parameters,
          style: AppFonts.title5(fontSize: AppPadding.p18, color: AppColors.title),
        ),
        const SizedBox(
          height: AppSize.a8,
        ),
        _buildDeviceInformationDetailLayout(S.current.device_type, _device.deviceTypeName),
        const SizedBox(
          height: AppSize.a8,
        ),
        _buildDeviceInformationDetailLayout(S.current.address, _device.address),
        const SizedBox(
          height: AppSize.a8,
        ),
        _buildDeviceInformationDetailLayout(S.current.version, "2"),
        const SizedBox(
          height: AppSize.a8,
        ),
        _buildDeviceInformationDetailLayout("SIM ICCID", "2"),
        const SizedBox(
          height: AppSize.a8,
        ),
      ],
    );
  }

  Widget _buildDeviceInformationDetailLayout(String titleDetail, String? valueDetail) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: AppPadding.p8, horizontal: AppPadding.p16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            titleDetail,
            style: AppFonts.buttonText2(),
          ),
          Text(
            valueDetail ?? "",
            style: AppFonts.title6(color: AppColors.title),
          )
        ],
      ),
    );
  }

  Future<void> _saveDeviceUpdateInformationFunction() async {
    if (_textEditingController.text == _device.name) {
      return;
    } else if (_textEditingController.text.isEmpty) {
      Common.showSnackBarMessage(context, S.current.device_name_cannot_be_blank, isError: true);
    } else if (_textEditingController.text.length > 50) {
      Common.showSnackBarMessage(context, S.current.device_name_cannot_be_longer_than_50_characters, isError: true);
    } else {
      _toggleProcess(true);
      if (await Common.isConnectToServer()) {
        _device.name = _textEditingController.text;
        _deviceManagerBloc.add(UpdateInformationDeviceEvent(device: _device));
      } else {
        _toggleProcess(false);
        Common.showSnackBarMessage(context, S.current.can_not_connect_to_server, isError: true);
      }
    }
  }

  void _toggleProcess(bool isShow) {
    setState(() {
      _isShowProcess = isShow;
    });
  }
}
