import 'package:fire_alarm_app/model/account_model.dart';
import 'package:fire_alarm_app/model/device_model.dart';
import 'package:fire_alarm_app/model/building_model.dart';
import 'package:fire_alarm_app/model/floor_model.dart';
import 'package:fire_alarm_app/model/room_model.dart';
import 'package:fire_alarm_app/model/share_building_model.dart';
import 'package:fire_alarm_app/model/smart_config_wifi_device_args.dart';
import 'package:fire_alarm_app/pages/device/device_setting_detail/device_information_setting_page.dart';
import 'package:fire_alarm_app/pages/device/list_device_type/list_device_type_page.dart';
import 'package:fire_alarm_app/pages/device/pccc_center/pccc_center_add_device/pccc_center_add_serial_page.dart';
import 'package:fire_alarm_app/pages/device/pccc_center/pccc_center_detail/pccc_center_detail_page.dart';
import 'package:fire_alarm_app/pages/device/pccc_center/pccc_center_detail/pccc_center_network_connection_configuration_page.dart';
import 'package:fire_alarm_app/pages/device/pccc_center/pccc_center_detail/pccc_center_set_up_warning_sounds_page.dart';
import 'package:fire_alarm_app/pages/device/pccc_center/pccc_center_detail/pccc_center_set_warning_time_page.dart';
import 'package:fire_alarm_app/pages/device/pccc_center/pccc_center_detail/pccc_center_setting_page.dart';
import 'package:fire_alarm_app/pages/device/sub_device/sub_device_add_device/sub_device_add_device_adding_and_result_page.dart';
import 'package:fire_alarm_app/pages/device/sub_device/sub_device_add_device/sub_device_add_device_tutorial_page.dart';
import 'package:fire_alarm_app/pages/device/sub_device/sub_device_setting_detail/sub_device_setting_detail_page.dart';
import 'package:fire_alarm_app/pages/login/login_page.dart';
import 'package:fire_alarm_app/pages/splash/splash_page.dart';
import 'package:fire_alarm_app/pages/tab_bar/setting/user_setting/user_building_setting/user_building_address_setting_page.dart';
import 'package:fire_alarm_app/pages/tab_bar/setting/user_setting/user_building_setting/user_building_management_page.dart';
import 'package:fire_alarm_app/pages/tab_bar/setting/user_setting/user_building_setting/user_building_setting_page.dart';
import 'package:fire_alarm_app/pages/tab_bar/setting/user_setting/user_detail_change_password_page.dart';
import 'package:fire_alarm_app/pages/tab_bar/setting/user_setting/user_detail_page.dart';
import 'package:fire_alarm_app/pages/tab_bar/setting/user_setting/user_detail_setting_page.dart';
import 'package:fire_alarm_app/pages/tab_bar/setting/user_setting/user_device_management/user_device_management_page.dart';
import 'package:fire_alarm_app/pages/tab_bar/setting/user_setting/user_floor_setting/user_floor_detail_setting_page.dart';
import 'package:fire_alarm_app/pages/tab_bar/setting/user_setting/user_floor_setting/user_floor_management_page.dart';
import 'package:fire_alarm_app/pages/tab_bar/setting/user_setting/user_room_setting/user_room_detail_setting_page.dart';
import 'package:fire_alarm_app/pages/tab_bar/setting/user_setting/user_room_setting/user_room_list_device_manager_page.dart';
import 'package:fire_alarm_app/pages/tab_bar/setting/user_setting/user_room_setting/user_room_management_page.dart';
import 'package:fire_alarm_app/pages/tab_bar/setting/user_setting/user_share_management/user_add_share_member_page.dart';
import 'package:fire_alarm_app/pages/tab_bar/setting/user_setting/user_share_management/user_building_share_detail_page.dart';
import 'package:fire_alarm_app/pages/tab_bar/setting/user_setting/user_share_management/user_setting_share_type_page.dart';
import 'package:fire_alarm_app/pages/tab_bar/setting/user_setting/user_share_management/user_share_management_page.dart';
import 'package:fire_alarm_app/pages/tab_bar/tab_bar_page.dart';
import 'package:fire_alarm_app/pages/verify_otp/verify_otp_page.dart';
import 'package:flutter/material.dart';

class AppRoutes {
  static const String loginPage = '/loginPage';
  static const String splashPage = '/splashPage';
  static const String verifyOTPPage = '/verifyOTPPage';
  static const String tabBarPage = '/tabBarPage';
  static const String listDeviceTypePage = '/listDeviceTypePage';
  static const String pcccCenterAddSerialPage = '/pcccCenterAddSerialPage';
  static const String subDeviceAddDeviceTutorialPage = '/subDeviceAddDeviceTutorialPage';
  static const String subDeviceAddDeviceAddingAndResultPage = '/subDeviceAddDeviceAddingAndResultPage';
  static const String userDetailPage = '/userDetailPage';
  static const String userDetailSettingPage = '/userDetailSettingPage';
  static const String userDetailChangePasswordPage = '/userDetailChangePasswordPage';
  static const String userBuildingManagementPage = '/userBuildingManagementPage';
  static const String userBuildingSettingPage = '/userBuildingSettingPage';
  static const String userBuildingAddressSettingPage = '/userBuildingAddressSettingPage';
  static const String userFloorManagementPage = '/userFloorManagementPage';
  static const String userFloorDetailSettingPage = '/userFloorDetailSettingPage';
  static const String userRoomManagementPage = '/userRoomManagementPage';
  static const String userRoomDetailSettingPage = '/userRoomDetailSettingPage';
  static const String userRoomListDeviceManagerPage = '/userRoomListDeviceManagerPage';
  static const String userDeviceManagementPage = '/userDeviceManagementPage';
  static const String userShareManagementPage = '/userShareManagementPage';
  static const String userAddShareMemberPage = '/userAddShareMemberPage';
  static const String userBuildingShareDetailPage = '/userBuildingShareDetailPage';
  static const String userSettingShareTypePage = '/userSettingShareTypePage';
  static const String pCCCCenterDetailPage = '/pCCCCenterDetailPage';
  static const String pCCCCenterSettingPage = '/pCCCCenterSettingPage';
  static const String deviceInformationSettingPage = '/deviceInformationSettingPage';
  static const String pCCCCenterNetworkConnectionConfigurationPage = '/pCCCCenterNetworkConnectionConfigurationPage';
  static const String pCCCCenterSetWarningTimePage = '/pCCCCenterSetWarningTimePage';
  static const String pCCCCenterSetUpWarningSoundsPage = '/pCCCCenterSetUpWarningSoundsPage';
  static const String subDeviceSettingDetailPage = '/subDeviceSettingDetailPage';

  static final routes = <String, WidgetBuilder>{
    splashPage: (BuildContext context) => SplashPage(),
    loginPage: (BuildContext context) => LoginPage(),
    verifyOTPPage: (BuildContext context) {
      final verifyCodeArgs = ModalRoute.of(context)!.settings.arguments as VerifyCodeArgs;
      return VerifyOtpPage(verifyCodeArgs: verifyCodeArgs);
    },
    tabBarPage: (BuildContext context) => TabBarPage(),
    listDeviceTypePage: (BuildContext context) {
      final deviceCenter = ModalRoute.of(context)!.settings.arguments as Device?;
      return ListDeviceTypePage(deviceCenter: deviceCenter);
    },
    pcccCenterAddSerialPage: (BuildContext context) {
      final args = ModalRoute.of(context)!.settings.arguments as SmartConfigWifiDeviceArgs;
      return PCCCCenterAddSerialPage(args: args);
    },
    subDeviceAddDeviceTutorialPage: (BuildContext context) {
      final deviceCenter = ModalRoute.of(context)!.settings.arguments as Device;
      return SubDeviceAddDeviceTutorialPage(
        deviceCenter: deviceCenter,
      );
    },
    subDeviceAddDeviceAddingAndResultPage: (BuildContext context) {
      final device = ModalRoute.of(context)!.settings.arguments as Device;
      return SubDeviceAddDeviceAddingAndResultPage(deviceCenter: device);
    },
    userDetailPage: (BuildContext context) => UserDetailPage(),
    userDetailSettingPage: (BuildContext context) {
      final account = ModalRoute.of(context)!.settings.arguments as Account;
      return UserDetailSettingPage(account: account);
    },
    userDetailChangePasswordPage: (BuildContext context) {
      final account = ModalRoute.of(context)!.settings.arguments as Account;
      return UserDetailChangePasswordPage(
        account: account,
      );
    },
    userBuildingManagementPage: (BuildContext context) => UserBuildingManagementPage(),
    userBuildingSettingPage: (BuildContext context) {
      final buildingModel = ModalRoute.of(context)!.settings.arguments as BuildingModel;
      return UserBuildingSettingPage(buildingModel: buildingModel);
    },
    userBuildingAddressSettingPage: (BuildContext context) {
      final buildingModel = ModalRoute.of(context)!.settings.arguments as BuildingModel;
      return UserBuildingAddressSettingPage(buildingModel: buildingModel);
    },
    userFloorManagementPage: (BuildContext context) => UserFloorManagementPage(),
    userFloorDetailSettingPage: (BuildContext context) => UserFloorDetailSettingPage(),
    userRoomManagementPage: (BuildContext context) {
      final floorModel = ModalRoute.of(context)!.settings.arguments as FloorModel;
      return UserRoomManagementPage(floorModel: floorModel);
    },
    userRoomDetailSettingPage: (BuildContext context) {
      final roomModel = ModalRoute.of(context)!.settings.arguments as RoomModel;
      return UserRoomDetailSettingPage(roomModel: roomModel);
    },
    userRoomListDeviceManagerPage: (BuildContext context) => UserRoomListDeviceManagerPage(),
    userDeviceManagementPage: (BuildContext context) => UserDeviceManagementPage(),
    userShareManagementPage: (BuildContext context) => UserShareManagementPage(),
    userAddShareMemberPage: (BuildContext context) => UserAddShareMemberPage(),
    userBuildingShareDetailPage: (BuildContext context) {
      final shareBuildingModel = ModalRoute.of(context)!.settings.arguments as ShareBuildingModel;
      return UserBuildingShareDetailPage(shareBuildingModel: shareBuildingModel);
    },
    userSettingShareTypePage: (BuildContext context) {
      final shareBuildingModel = ModalRoute.of(context)!.settings.arguments as ShareBuildingModel;
      return UserSettingShareTypePage(shareBuildingModel: shareBuildingModel);
    },
    pCCCCenterDetailPage: (BuildContext context) {
      final device = ModalRoute.of(context)!.settings.arguments as Device;
      return PCCCCenterDetailPage(
        device: device,
      );
    },
    pCCCCenterSettingPage: (BuildContext context) {
      final device = ModalRoute.of(context)!.settings.arguments as Device;
      return PCCCCenterSettingPage(
        device: device,
      );
    },
    deviceInformationSettingPage: (BuildContext context) {
      final device = ModalRoute.of(context)!.settings.arguments as Device;
      return DeviceInformationSettingPage(
        device: device,
      );
    },
    pCCCCenterNetworkConnectionConfigurationPage: (BuildContext context) {
      final device = ModalRoute.of(context)!.settings.arguments as Device;
      return PCCCCenterNetworkConnectionConfigurationPage(
        device: device,
      );
    },
    pCCCCenterSetWarningTimePage: (BuildContext context) {
      final device = ModalRoute.of(context)!.settings.arguments as Device;
      return PCCCCenterSetWarningTimePage(
        device: device,
      );
    },
    pCCCCenterSetUpWarningSoundsPage: (BuildContext context) {
      final device = ModalRoute.of(context)!.settings.arguments as Device;
      return PCCCCenterSetUpWarningSoundsPage(
        device: device,
      );
    },
    subDeviceSettingDetailPage: (BuildContext context) {
      final device = ModalRoute.of(context)!.settings.arguments as Device;
      return SubDeviceSettingDetailPage(
        device: device,
      );
    }
  };
}
