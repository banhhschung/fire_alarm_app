import 'package:fire_alarm_app/blocs/device_manager_bloc/device_manager_bloc.dart';
import 'package:fire_alarm_app/blocs/device_manager_bloc/device_manager_event.dart';
import 'package:fire_alarm_app/blocs/device_manager_bloc/device_manager_state.dart';
import 'package:fire_alarm_app/blocs/mqtt_bloc/mqtt_bloc.dart';
import 'package:fire_alarm_app/gen/assets.gen.dart';
import 'package:fire_alarm_app/generated/l10n.dart';
import 'package:fire_alarm_app/model/device_model.dart';
import 'package:fire_alarm_app/model/smart_config_wifi_device_args.dart';
import 'package:fire_alarm_app/res/app_padding/app_padding.dart';
import 'package:fire_alarm_app/res/app_size/app_size.dart';
import 'package:fire_alarm_app/routes/app_routes/app_routes.dart';
import 'package:fire_alarm_app/utils/common_utils.dart';
import 'package:fire_alarm_app/widget_element/custom_app_bar/custom_app_bar_widget.dart';
import 'package:fire_alarm_app/widget_element/custom_text_field/custom_text_field_widget.dart';
import 'package:fire_alarm_app/widget_element/high_light_button/high_light_button.dart';
import 'package:fire_alarm_app/widget_element/loading_custom/custom_loading_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

enum ConnectDeviceState { scanBarCode, waitConnecting, connectComplete, connectError }

class PCCCCenterAddSerialPage extends StatefulWidget {
  final SmartConfigWifiDeviceArgs args;

  const PCCCCenterAddSerialPage({super.key, required this.args});

  @override
  State<StatefulWidget> createState() => _PCCCCenterAddSerialPageState();
}

class _PCCCCenterAddSerialPageState extends State<PCCCCenterAddSerialPage> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR_Add_Smoke');

  late QRViewController _qrViewController;
  final TextEditingController _serialTextController = TextEditingController();

  late DeviceManagerBloc _deviceManagerBloc;

  ConnectDeviceState _connectDeviceState = ConnectDeviceState.scanBarCode;
  late Device _selectedDevice;
  late int _addingCountingTime = 120;

  bool _isShowProcess = false;

  @override
  void initState() {
    _deviceManagerBloc = DeviceManagerBloc(BlocProvider.of<MqttBloc>(context));
    Future.delayed(const Duration(seconds: 1)).then((value) => Common.getCurrentLocationPermission(context));
    super.initState();
  }

  @override
  void dispose() {
    _qrViewController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBarWidget(
        title: S.current.connect_device,
      ),
      body: BlocListener<DeviceManagerBloc, DeviceManagerState>(
          listener: (_, state) {
            if (state is AddDeviceBySerialSuccessState) {
              Future.delayed(Duration(seconds: 5)).then((_) {
                _toggleProcess(false);
                setState(() {
                  _connectDeviceState = ConnectDeviceState.waitConnecting;
                });
              });
              _selectedDevice = state.device;
              _loopCheckAddDeviceResult();
            } else if (state is AddDeviceBySerialFailState) {
              _toggleProcess(false);
              Common.showSnackBarMessage(context, "Kết nối thiết bị thất bại", isError: true);
            } else if (state is ActiveDeviceBySerialSuccessState){
              _connectDeviceState = ConnectDeviceState.connectComplete;
            } else if (state is ActiveDeviceBySerialFailState){
              _connectDeviceState = ConnectDeviceState.connectError;
            }
          },
          bloc: _deviceManagerBloc,
          child: CustomLoadingWidget(showLoading: _isShowProcess, child: _mainBodyWidget())),
    );
  }

  Widget _mainBodyWidget() {
    if (_connectDeviceState == ConnectDeviceState.scanBarCode) {
      return _scanBarcodeWidget();
    } else {
      return _connectingDeviceWidget();
    }
  }

  Widget _scanBarcodeWidget() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Stack(
          alignment: AlignmentDirectional.center,
          children: [
            Container(
              height: 146,
              child: QRView(
                key: qrKey,
                onQRViewCreated: _onQRViewCreated,
              ),
            ),
            // Image.asset('assets/images/add_smoke_square_scan_ic.png'),
          ],
        ),
        Expanded(
          child: Padding(
            padding: EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(S.current.device_code,
                    style: const TextStyle(
                        color: const Color(0xff27272a), fontWeight: FontWeight.w500, fontFamily: "Inter", fontStyle: FontStyle.normal, fontSize: 14.0),
                    textAlign: TextAlign.left),
                SizedBox(
                  height: 10,
                ),
                CustomTextFieldWidget(
                  controller: _serialTextController,
                  titleInput: '',
                ),
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        stepLayout('1', S.current.add_barcode_or_enter_code_on_device, imageDescription: imageStep1Description()),
                        stepLayout('2', S.current.enter_button_3_times_util_light_flash /*, imageDescription: imageStep2Description()*/),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(right: 20, bottom: 20, left: 20),
          child: HighLightButton(
            title: S.current.add_device,
            onPress: () async {
              if (_serialTextController.text.isEmpty || _serialTextController.text.trim() == "") {
                // Common.createSnackBarWarningByErrorOrSuccessMode(_scaffoldKey.currentState, S.current.you_need_scan_device_code, true);
                Common.showSnackBarMessage(context, S.current.you_need_scan_device_code, isError: true);
              } else {
                // if (await Common.getCurrentLocationPermission(context)) {
                _toggleProcess(true);
                _addDeviceToBE(serial: _serialTextController.text, code: 4000);
                // }
              }
            },
          ),
        )
      ],
    );
  }

  Widget _connectingDeviceWidget() {
    return Padding(
      padding: const EdgeInsets.all(AppPadding.p18),
      child: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  deviceInfoItem(title: S.current.device_type, content: _selectedDevice != null ? _selectedDevice.deviceTypeName ?? '' : ''),
                  deviceInfoItem(title: 'Serial', content: _selectedDevice != null ? _selectedDevice.serial ?? '' : ''),
                  deviceInfoItem(title: 'MAC', content: _selectedDevice != null ? _selectedDevice.address ?? '' : ''),
                  //todo: xem lại model Device
                  // deviceInfoItem(title: 'CCID SIM', content: _selectedDevice != null ? _selectedDevice.iccid ?? '' : ''),
                  const SizedBox(
                    height: AppSize.a16,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: AppPadding.p100 - AppPadding.p18),
                    child: Assets.images.addDeviceBySerialWaitingImg.image(),
                  ),
                  const SizedBox(
                    height: AppSize.a16,
                  ),
                  _addDeviceResultWidget(),
                  const SizedBox(
                    height: AppSize.a16,
                  ),
                  Text(S.current.enter_button_3_times_util_light_flash,
                      style: const TextStyle(
                          color: const Color(0xff343434), fontWeight: FontWeight.w400, fontFamily: "Inter", fontStyle: FontStyle.normal, fontSize: 14.0),
                      textAlign: TextAlign.center),
                ],
              ),
            ),
          ),
          _resultButtonWidget()
        ],
      ),
    );
  }

  stepLayout(String stepNumber, String stepDetail, {Widget? imageDescription}) {
    TextStyle styleStep = TextStyle(color: Colors.black, fontSize: 14, fontWeight: FontWeight.w400);
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Row(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(right: 12),
                    child: Container(
                      height: 24,
                      width: 24,
                      decoration: BoxDecoration(color: Theme.of(context).primaryColor, shape: BoxShape.circle),
                      child: Center(
                        child: Text(stepNumber, style: TextStyle(color: Colors.white)),
                      ),
                    ),
                  ),
                  Expanded(child: Text(stepDetail, style: styleStep))
                ],
              ),
            ),
            imageDescription ?? Container(),
          ],
        ),
      ),
    );
  }

  Widget deviceInfoItem({String title = "", String content = "", bool isShowUnderline = true}) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Row(
            children: [
              Text("$title: ",
                  style: const TextStyle(
                      color: const Color(0xff6e6e6e), fontWeight: FontWeight.w500, fontFamily: "Inter", fontStyle: FontStyle.normal, fontSize: 16.0),
                  textAlign: TextAlign.left),
              Text(content ?? '',
                  style: const TextStyle(
                      color: const Color(0xff262626), fontWeight: FontWeight.w400, fontFamily: "Inter", fontStyle: FontStyle.normal, fontSize: 16.0),
                  textAlign: TextAlign.left)
            ],
          ),
        ),
        isShowUnderline
            ? Container(
                width: double.infinity,
                height: 0.5,
                color: Colors.grey,
              )
            : Container()
      ],
    );
  }

  Widget _addDeviceResultWidget() {
    if (_connectDeviceState == ConnectDeviceState.waitConnecting) {
      return Text('${S.current.time_to_connect_device}: ${_addingCountingTime}s',
          style: const TextStyle(color: const Color(0xff343434), fontWeight: FontWeight.w600, fontFamily: "Inter", fontStyle: FontStyle.normal, fontSize: 14.0),
          textAlign: TextAlign.center);
    } else if (_connectDeviceState == ConnectDeviceState.connectError) {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset('assets/images/add_smoke_nv_v2_fail_ic.png'),
          const SizedBox(
            width: AppSize.a8,
          ),
          Text(S.current.connect_device_fail,
              style: const TextStyle(
                  color: const Color(0xffc61212), fontWeight: FontWeight.w500, fontFamily: "Inter", fontStyle: FontStyle.normal, fontSize: 14.0),
              textAlign: TextAlign.center)
        ],
      );
    } else if (_connectDeviceState == ConnectDeviceState.connectComplete) {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset('assets/images/add_smoke_vb_v2_success_ic.png'),
          const SizedBox(
            width: AppSize.a8,
          ),
          Text(S.current.add_device_success,
              style: const TextStyle(
                  color: const Color(0xff079449), fontWeight: FontWeight.w500, fontFamily: "Inter", fontStyle: FontStyle.normal, fontSize: 14.0),
              textAlign: TextAlign.center)
        ],
      );
    } else {
      return Container();
    }
  }

  void _onQRViewCreated(QRViewController controller) {
    this._qrViewController = controller;
    controller.scannedDataStream.listen((scanData) {
      setState(() {
        _serialTextController.text = scanData.code ?? "";
      });
    });
  }

  _resultButtonWidget() {
    return _connectDeviceState == ConnectDeviceState.connectError || _connectDeviceState == ConnectDeviceState.connectComplete
        ? Padding(
            padding: const EdgeInsets.all(20),
            child: HighLightButton(
              title: _connectDeviceState == ConnectDeviceState.connectError ? S.current.try_again : "S.current.complete",
              onPress: () {
                if (_connectDeviceState == ConnectDeviceState.connectError) {
                  // _loopCheckAddDeviceResult();
                } else {
                  Navigator.pushNamedAndRemoveUntil(context, AppRoutes.tabBarPage, (_) => false);
                }
              },
            ),
          )
        : Container();
  }

  Widget imageStep1Description() {
    return Stack(
      alignment: Alignment.center,
      children: [
        Assets.images.tutorialAddDeviceStepOneBoxImg.image(),
      ],
    );
  }

  void _addDeviceToBE({String serial = "", int code = 4000}) {
    Device device = Device(code: code, serial: serial);

    if (widget.args.roomId != null) {
      device.roomId = widget.args.roomId;
    }
    _deviceManagerBloc.add(AddDeviceBySerialEvent(device: device));

    _toggleProcess(true);
  }

  _loopCheckAddDeviceResult() async {
    _connectDeviceState = ConnectDeviceState.waitConnecting;
    _toggleProcess(false);
    _addingCountingTime = 120;
    while (_addingCountingTime > 0 && _connectDeviceState == ConnectDeviceState.waitConnecting) {
      _addingCountingTime -= 1;
      await Future.delayed(const Duration(seconds: 1));

      if (_addingCountingTime % 10 == 0) {
        _deviceManagerBloc.add(ActiveDeviceBySerialEvent(serial: _selectedDevice != null ? _selectedDevice.serial ?? '' : ''));
      }

      if (_addingCountingTime == 0) {
        _connectDeviceState = ConnectDeviceState.connectError;
      }

      setState(() {});
    }
  }

  void _toggleProcess(bool isShow) {
    setState(() {
      _isShowProcess = isShow;
    });
  }
}
