import 'dart:io';
import 'dart:math';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:fire_alarm_app/commons/constant.dart';
import 'package:fire_alarm_app/configs/app_config.dart';
import 'package:fire_alarm_app/gen/assets.gen.dart';
import 'package:fire_alarm_app/generated/l10n.dart';
import 'package:fire_alarm_app/model/device_info.dart';
import 'package:fire_alarm_app/res/app_colors/app_colors.dart';
import 'package:fire_alarm_app/res/app_padding/app_padding.dart';
import 'package:fire_alarm_app/res/app_size/app_size.dart';
import 'package:fire_alarm_app/res/fonts/app_fonts.dart';
import 'package:fire_alarm_app/widget_element/custom_text_field/custom_text_field_widget.dart';
import 'package:fire_alarm_app/widget_element/high_light_button/high_light_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:network_info_plus/network_info_plus.dart';
import 'package:permission_handler/permission_handler.dart';

abstract interface class Common {
  static const SOURCE_CHARACTERS = {
    'À',
    'Á',
    'Â',
    'Ã',
    'È',
    'É',
    'Ê',
    'Ì',
    'Í',
    'Ò',
    'Ó',
    'Ô',
    'Õ',
    'Ù',
    'Ú',
    'Ý',
    'à',
    'á',
    'â',
    'ã',
    'è',
    'é',
    'ê',
    'ì',
    'í',
    'ò',
    'ó',
    'ô',
    'õ',
    'ù',
    'ú',
    'ý',
    'Ă',
    'ă',
    'Đ',
    'đ',
    'Ĩ',
    'ĩ',
    'Ũ',
    'ũ',
    'Ơ',
    'ơ',
    'Ư',
    'ư',
    'Ạ',
    'ạ',
    'Ả',
    'ả',
    'Ấ',
    'ấ',
    'Ầ',
    'ầ',
    'Ẩ',
    'ẩ',
    'Ẫ',
    'ẫ',
    'Ậ',
    'ậ',
    'Ắ',
    'ắ',
    'Ằ',
    'ằ',
    'Ẳ',
    'ẳ',
    'Ẵ',
    'ẵ',
    'Ặ',
    'ặ',
    'Ẹ',
    'ẹ',
    'Ẻ',
    'ẻ',
    'Ẽ',
    'ẽ',
    'Ế',
    'ế',
    'Ề',
    'ề',
    'Ể',
    'ể',
    'Ễ',
    'ễ',
    'Ệ',
    'ệ',
    'Ỉ',
    'ỉ',
    'Ị',
    'ị',
    'Ọ',
    'ọ',
    'Ỏ',
    'ỏ',
    'Ố',
    'ố',
    'Ồ',
    'ồ',
    'Ổ',
    'ổ',
    'Ỗ',
    'ỗ',
    'Ộ',
    'ộ',
    'Ớ',
    'ớ',
    'Ờ',
    'ờ',
    'Ở',
    'ở',
    'Ỡ',
    'ỡ',
    'Ợ',
    'ợ',
    'Ụ',
    'ụ',
    'Ủ',
    'ủ',
    'Ứ',
    'ứ',
    'Ừ',
    'ừ',
    'Ử',
    'ử',
    'Ữ',
    'ữ',
    'Ự',
    'ự'
  };

  static bool checkStringHasEmoji(String text) {
    final RegExp regExp = RegExp(
        r'(?:[\u2700-\u27bf]|(?:\ud83c[\udde6-\uddff]){2}|[\ud800-\udbff][\udc00-\udfff]|[\u0023-\u0039]\ufe0f?\u20e3|\u3299|\u3297|\u303d|\u3030|\u24c2|\ud83c[\udd70-\udd71]|\ud83c[\udd7e-\udd7f]|\ud83c\udd8e|\ud83c[\udd91-\udd9a]|\ud83c[\udde6-\uddff]|\ud83c[\ude01-\ude02]|\ud83c\ude1a|\ud83c\ude2f|\ud83c[\ude32-\ude3a]|\ud83c[\ude50-\ude51]|\u203c|\u2049|[\u25aa-\u25ab]|\u25b6|\u25c0|[\u25fb-\u25fe]|\u00a9|\u00ae|\u2122|\u2139|\ud83c\udc04|[\u2600-\u26FF]|\u2b05|\u2b06|\u2b07|\u2b1b|\u2b1c|\u2b50|\u2b55|\u231a|\u231b|\u2328|\u23cf|[\u23e9-\u23f3]|[\u23f8-\u23fa]|\ud83c\udccf|\u2934|\u2935|[\u2190-\u21ff])');

    return text.contains(regExp);
  }

  static bool checkNullOrEmpty(Object? object) => ((object == null) || (object is String && object.isEmpty) || (object is List<dynamic> && object.isEmpty));

  static int convertInt(dynamic value) {
    if (value is String) {
      return int.parse(value);
    } else if (value is double) {
      return value.toInt();
    } else if (value is num) {
      return value.toInt();
    } else {
      return value;
    }
  }

  static const GET_INFO_AGAIN = 'get_info_again';

  static int next(int min, int max) => min + Random().nextInt(max - min);

  static Future<DeviceInfo> getDeviceUUID() async {
    DeviceInfo info = DeviceInfo();
    final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
    try {
      if (Platform.isAndroid) {
        var build = await deviceInfoPlugin.androidInfo;
        info.deviceName = build.model;
        info.deviceVersion = build.version.release;
        info.deviceId = build.id; //UUID for Android
      } else if (Platform.isIOS) {
        var data = await deviceInfoPlugin.iosInfo;
        info.deviceName = data.name;
        info.deviceVersion = data.systemVersion;
        info.deviceId = data.identifierForVendor; //UUID for iOS
      }
    } catch (e) {
      // print(e);
    }
    return info;
  }

  static String convertTimestampToTimeHHmmSSDDMMYYYY(int timestamp) {
    if (timestamp == null || timestamp < 0) {
      return '__';
    }
    var date = new DateTime.fromMillisecondsSinceEpoch(timestamp);
    return '${getTime(date.hour)}:${getTime(date.minute)}:${getTime(date.second)} ${getTime(date.day)}/${getTime(date.month)}/${getTime(date.year)}';
  }

  static final RegExp _versionRegex = RegExp(r"^([\d.]+)(-([0-9A-Za-z\-.]+))?(\+([0-9A-Za-z\-.]+))?$");

  static int? compareVersion(String? v1, String? v2) {
    if (v1 == null || v1 == '' || v2 == null || v2 == '') return null;
    if (!_versionRegex.hasMatch(v1) || !_versionRegex.hasMatch(v2)) return null;

    int? majorV1;
    int? minnorV1;
    int? patchV1;
    int? majorV2;
    int? minorV2;
    int? patchV2;

    final List<String> parts1 = v1.split(".");
    majorV1 = int.parse(parts1[0]);
    if (parts1.length > 1) {
      minnorV1 = int.parse(parts1[1]);
      if (parts1.length > 2) {
        patchV1 = int.parse(parts1[2]);
      }
    }

    final List<String> parts2 = v2.split(".");
    majorV2 = int.parse(parts2[0]);
    if (parts2.length > 1) {
      minorV2 = int.parse(parts2[1]);
      if (parts2.length > 2) {
        patchV2 = int.parse(parts2[2]);
      }
    }

    if (majorV1 > majorV2) return 1;
    if (majorV1 < majorV2) return -1;

    if (minnorV1! > minorV2!) return 1;
    if (minnorV1 < minorV2) return -1;

    if (patchV1! > patchV2!) return 1;
    if (patchV1 < patchV2) return -1;

    return 0;
  }

  static showSnackBarMessage(BuildContext context, String title, {bool isError = false}) {
    var snackBar = SnackBar(
      shape: RoundedRectangleBorder(
        // Đặt bán kính cho Snackbar
        borderRadius: BorderRadius.circular(AppSize.a12), // Thiết lập bán kính ở đây
      ),
      backgroundColor: isError ? AppColors.errorPrimary : AppColors.successPrimary,
      content: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Assets.images.successImg.image(width: AppSize.a24),
          const SizedBox(
            width: AppSize.a10,
          ),
          Text(
            title,
            style: AppFonts.title(
              color: AppColors.white,
            ),
          )
        ],
      ),
      duration: const Duration(seconds: 3),
      // Thời gian hiển thị Snackbar
      behavior: SnackBarBehavior.floating, // Đặt hiệu ứng hiển thị cho Snackbar
      // action: SnackBarAction(
      //   label: 'Close',
      //   onPressed: () {
      //     ScaffoldMessenger.of(context)
      //         .hideCurrentSnackBar(); // Đóng Snackbar khi nhấn nút Close
      //   },
      // ),
    );
    ScaffoldMessenger.of(context).removeCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  static roundDoubleValue(double value, int fixedNumber) {
    return num.parse(value.toStringAsFixed(fixedNumber)).toString();
  }

  static const REFERENCE_TYPE_REVERSE = 1;
  static const REFERENCE_TYPE_NOT_REVERSE = 0;

  static const ESM_WATTAGE_USED_TYPE = 0;
  static const ESM_EXPORT_TYPE = 1;

  static double? checkDouble(dynamic value) {
    if (value is String) {
      return double.parse(value);
    } else if (value is int) {
      return 0.0 + value;
    } else {
      return value;
    }
  }

  static Uint8List convertStringToUint8List(String str) {
    final List<int> codeUnits = str.codeUnits;
    final Uint8List unit8List = Uint8List.fromList(codeUnits);
    return unit8List;
  }

  static Future<bool> isConnectToServerOverWifi() async {
    try {
      final result = await InternetAddress.lookup('google.com').timeout(AppConstant.duration1s);
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        return true;
      }
    } catch (e) {
      return false;
    }
    return false;
  }

  static Future<bool> isWifiConnected() async {
    final info = NetworkInfo();
    String? wifiIP = await info.getWifiIP();

    if (wifiIP != null && wifiIP != 'error') {
      return true;
    }
    return true;
  }

  static Future<bool> isConnectToServer() async {
    try {
      final result = await InternetAddress.lookup('google.com').timeout(AppConstant.duration5s);
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  static Future<int> getAndroidSdk() async {
    return (await DeviceInfoPlugin().androidInfo).version.sdkInt;
  }

  static Future<bool> requestBluetoothAccess() async {
    bool locationPermission = await Permission.location.isGranted;

    if (!locationPermission) {
      locationPermission = await requestAccess(Permission.location);
    }

    if (locationPermission) {
      if (Platform.isIOS || (Platform.isAndroid && await Common.getAndroidSdk() <= 30)) {
        return true;
      } else if (await Permission.bluetoothScan.isGranted && await Permission.bluetoothConnect.isGranted) {
        return true;
      } else {
        await requestAccess(Permission.bluetoothScan);
        await requestAccess(Permission.bluetoothConnect);
        return await Permission.bluetoothScan.isGranted && await Permission.bluetoothConnect.isGranted;
      }
    }

    return locationPermission;
  }

  static Future<bool> requestAccess(Permission permission) async {
    return await permission.request().isGranted;
  }

  static Future<bool> requestMicroAccess() async {
    if (await Permission.microphone.isGranted) {
      return true;
    } else {
      return await requestAccess(Permission.microphone);
    }
  }

  static Future<bool> requestAccessMediaLocation() async {
    if (await Permission.photos.isGranted) {
      return true;
    } else {
      return await requestAccess(Permission.photos);
    }
  }

  static String convertUint8ListToString(Uint8List uint8list) {
    return String.fromCharCodes(uint8list);
  }

  static void printLog(Object? object) {
    if (object != null && ConfigApp.ENABLE_LOG) {
      print(object);
    }
  }

  static bool checkValidPhoneNumber(String phone) {
    final phoneValid = RegExp(r"^(84|0[3|5|7|8|9])+([0-9]{8})$");
    return phoneValid.hasMatch(phone);
  }

  static bool checkValidEmail(String email) {
    final emailValid = RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9-_]+\.[a-zA-Z]+");
    return emailValid.hasMatch(email);
  }

  static String getTime(int value) {
    return value < 10 ? '0${value.toString()}' : value.toString();
  }

  static Future showNormalPopup(
    BuildContext context, {
    required String title,
    bool toUpperCaseTitle = true,
    required Widget content,
    bool isShowActionButton = true,
    bool isShowDoneButton = true,
    String titleDoneButton = "Done",
    VoidCallback? onPressedDone,
    bool isShowIgnoreButton = true,
    String titleIgnoreButton = "Ignore",
    VoidCallback? onPressedIgnore,
    double height = 280,
    bool isCloseWhenDone = true,
    bool barrierDismissible = true,
  }) {
    Dialog alertDialog = Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppPadding.p16)),
      child: Container(
        height: height ?? 380,
        width: MediaQuery.of(context).size.width - AppSize.a10,
        decoration: const BoxDecoration(color: AppColors.white, borderRadius: BorderRadius.all(Radius.circular(AppPadding.p16))),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              height: AppSize.a50,
              width: double.infinity,
              decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                  borderRadius: const BorderRadius.only(topLeft: Radius.circular(AppSize.a16), topRight: Radius.circular(AppSize.a16))),
              child: Center(
                  child: Text(
                toUpperCaseTitle ? (title ?? '').toUpperCase() : (title ?? ''),
                style: AppFonts.buttonText(color: AppColors.white, fontSize: AppSize.a16),
                textAlign: TextAlign.center,
              )),
            ),
            Container(
              width: double.infinity,
              height: AppSize.a0_5,
              color: AppColors.greyText,
            ),
            Expanded(
              child: content,
            ),
            Visibility(
              visible: isShowActionButton,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: _listButtonInShowNormalPopup(
                  context,
                  titleDoneButton: titleDoneButton,
                  onPressedDone: onPressedDone,
                  isShowDoneButton: isShowDoneButton,
                  titleIgnoreButton: titleIgnoreButton,
                  onPressedIgnore: onPressedIgnore,
                  isShowIgnoreButton: isShowIgnoreButton,
                  isCloseWhenDone: isCloseWhenDone,
                ),
              ),
            ),
            const SizedBox(height: AppSize.a8)
          ],
        ),
      ),
    );
    return showDialog(context: context, builder: (context) => alertDialog, barrierDismissible: barrierDismissible);
  }

  static _listButtonInShowNormalPopup(BuildContext context,
      {required String titleDoneButton,
      VoidCallback? onPressedDone,
      required bool isShowDoneButton,
      required String titleIgnoreButton,
      VoidCallback? onPressedIgnore,
      required bool isShowIgnoreButton,
      required bool isCloseWhenDone}) {
    List<Widget> listWidget = [];
    if (isShowIgnoreButton) {
      listWidget.add(
        HighLightButton(
          width: AppSize.a120,
          onPress: () {
            Navigator.of(context).pop();
            if (onPressedIgnore != null) {
              onPressedIgnore();
            }
          },
          title: titleIgnoreButton,
        ),
      );
    }
    if (isShowDoneButton) {
      listWidget.add(
        HighLightButton(
          width: AppSize.a120,
          buttonColor: Theme.of(context).primaryColor,
          onPress: () {
            if (isCloseWhenDone) {
              Navigator.of(context).pop();
            }
            if (onPressedDone != null) {
              onPressedDone();
            }
          },
          title: titleDoneButton,
        ),
      );
    }
    return listWidget;
  }

  static showRequiteAgreePopup(
      BuildContext context, {
        required String title,
        required String content,
        VoidCallback? onPressedDone,
        double height = 280,
      }) {
    Dialog alertDialog = Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppPadding.p16)),
      child: IntrinsicHeight(
        child: Container(
          // height: height ?? 380,
          width: MediaQuery.of(context).size.width - AppSize.a10,
          decoration: const BoxDecoration(color: AppColors.white, borderRadius: BorderRadius.all(Radius.circular(AppPadding.p16))),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                height: AppSize.a50,
                width: double.infinity,
                decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                    borderRadius: const BorderRadius.only(topLeft: Radius.circular(AppSize.a16), topRight: Radius.circular(AppSize.a16))),
                child: Center(
                    child: Text(
                      title ?? '',
                      style: AppFonts.buttonText(color: AppColors.white, fontSize: AppSize.a16),
                      textAlign: TextAlign.center,
                    ),
                ),
              ),
              Expanded(
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: AppPadding.p16, vertical: AppPadding.p24),
                    child: Text(content, style: AppFonts.title2(), textAlign: TextAlign.center,),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppPadding.p16),
                child: Row(
                  children: [
                    Expanded(
                      child: HighLightButton(
                        buttonColor: AppColors.white,
                        onPress: () {
                          Navigator.of(context).pop();
                        },
                        textStyle: AppFonts.buttonText(color: AppColors.title),
                        title: S.current.ignore,
                      ),
                    ),
                    const SizedBox(width: AppSize.a24,),
                    Expanded(
                      child: HighLightButton(
                        buttonColor: Theme.of(context).primaryColor,
                        onPress: () {
                          if(onPressedDone != null){
                            onPressedDone();
                          }
                            Navigator.of(context).pop();
                        },
                        title: S.current.accept,
                      ),
                    ),
                  ]
                ),
              ),
              const SizedBox(height: AppSize.a8)
            ],
          ),
        ),
      ),
    );
    return showDialog(context: context, builder: (context) => alertDialog, barrierDismissible: true);
  }

  static Future showTextFieldPopup(BuildContext context, {required String? titleInput, required String? title, required String? value}){
    late TextEditingController textEditingController = TextEditingController();
    textEditingController.text = value ?? "";
    Dialog alertDialog = Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppPadding.p16)),
    child: IntrinsicHeight(
      child: Container(
        width: MediaQuery.of(context).size.width - AppSize.a10,
        padding: const EdgeInsets.symmetric(vertical: AppPadding.p24, horizontal: AppPadding.p16),
        decoration: const BoxDecoration(color: AppColors.white, borderRadius: BorderRadius.all(Radius.circular(AppPadding.p16))),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
                child: Text(
                  (title ?? ''),
                  style: AppFonts.title2(),
                  textAlign: TextAlign.center,
                ),
            ),
            const SizedBox(height: AppSize.a16,),
            CustomTextFieldWidget(
              titleInput: titleInput ?? "",
              controller: textEditingController,
            ),
            const SizedBox(height: AppSize.a16,),
            Row(
              children: [
                Expanded(
                  child: HighLightButton(
                    buttonColor: AppColors.grey_4Background,
                    onPress: () {
                      Navigator.of(context).pop();
                    },
                    title: S.current.ignore,
                    textStyle: AppFonts.buttonText(color: AppColors.primaryText),
                  ),
                ),
                const SizedBox(width: 20,),
                Expanded(
                  child: HighLightButton(
                    buttonColor: Theme.of(context).primaryColor,
                    onPress: () {
                      if(textEditingController.text != null && textEditingController.text.trim().isNotEmpty){
                        Navigator.of(context).pop(textEditingController.text.trim());
                      } else {
                        Navigator.of(context).pop();
                      }
                    },
                    title: S.current.save,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSize.a8)
          ],
        ),
      ),
    ));
    return showDialog(context: context, builder: (context) => alertDialog);
  }

  static Future getCurrentLocationPermission(BuildContext context) async {
    if (await Permission.locationWhenInUse.serviceStatus.isEnabled) {
      if (await Common.requestAccess(Permission.location)) {
        return true;
      } else {
        _showPopupTurnOnGPS(context);
      }
    } else {
      _showPopupTurnOnGPS(context);
    }
  }

  static void _showPopupTurnOnGPS(BuildContext context) {
    Common.showNormalPopup(
      context,
      height: 250,
      title: "S.current.turn_on_gps",
      content: Center(
        child: Padding(
            padding: EdgeInsets.all(20),
            child: Text(
              "S.current.you_need_to_turn_on_gps_to_perform_wifi_configuration_for_your_device",
              textAlign: TextAlign.center,
            )),
      ),
      isCloseWhenDone: true,
      titleDoneButton: "S.current.open_setting",
      onPressedDone: () async {
        // await AppSettings.openLocationSettings();
        await openAppSettings();
      },
      isShowIgnoreButton: false,
    );
  }
}
