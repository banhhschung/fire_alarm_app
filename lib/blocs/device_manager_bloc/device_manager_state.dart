import 'dart:math';

import 'package:equatable/equatable.dart';
import 'package:fire_alarm_app/model/alert_notification_model.dart';
import 'package:fire_alarm_app/model/device_model.dart';
import 'package:fire_alarm_app/model/device_type_model.dart';

class DeviceManagerState extends Equatable {
  @override
  List get props => [];
}

class InitialDeviceManagerState extends DeviceManagerState {
  @override
  List get props => [];
}

class GetListDeviceTypeState extends DeviceManagerState {
  final List<DeviceTypeModel> listDeviceType;

  GetListDeviceTypeState(this.listDeviceType);

  @override
  List get props => [listDeviceType];
}

class AddDeviceBySerialSuccessState extends DeviceManagerState {
  final Device device;

  AddDeviceBySerialSuccessState(this.device);

  @override
  List get props => [Random().nextInt(9999)];
}

class AddDeviceBySerialEmptyState extends DeviceManagerState {
  @override
  List get props => [];
}

class AddDeviceBySerialFailState extends DeviceManagerState {
  String? address;

  AddDeviceBySerialFailState({this.address});

  @override
  List get props => [];
}

class ActiveDeviceBySerialSuccessState extends DeviceManagerState {
  int code;
  int status;

  ActiveDeviceBySerialSuccessState(this.code, this.status);

  @override
  List get props => [code, status];
}

class ActiveDeviceBySerialFailState extends DeviceManagerState {
  @override
  List get props => [];
}

class GetListDeviceInAccountDeviceSuccessState extends DeviceManagerState {
  final List<Device> listDevice;

  GetListDeviceInAccountDeviceSuccessState({required this.listDevice});

  @override
  List get props => [Random().nextInt(9999)];
}

class GetListDeviceInAccountDeviceFailState extends DeviceManagerState {
  @override
  List get props => [Random().nextInt(9999)];
}

class ActiveDeviceInBESuccessState extends DeviceManagerState {}

class ActiveDeviceInBEFailState extends DeviceManagerState {}

class UpdateInformationDeviceSuccessState extends DeviceManagerState {}

class UpdateInformationDeviceFailState extends DeviceManagerState {}

class AddDeviceToBESuccessState extends DeviceManagerState {}

class AddDeviceToBEFailState extends DeviceManagerState {}

class RemoveDeviceSuccessState extends DeviceManagerState {}

class RemoveDeviceFailState extends DeviceManagerState {}

class GetWarningSoundsSuccessState extends DeviceManagerState {
  final AlertNotificationModel alertNotificationModel;

  GetWarningSoundsSuccessState({required this.alertNotificationModel});

  @override
  List get props => [Random().nextInt(9999)];
}

class GetWarningSoundsFailState extends DeviceManagerState {
  @override
  List get props => [Random().nextInt(9999)];
}

class SaveWarningSoundByDeviceSuccessState extends DeviceManagerState {
  @override
  List get props => [Random().nextInt(9999)];
}

class SaveWarningSoundByDeviceFailState extends DeviceManagerState {
  @override
  List get props => [Random().nextInt(9999)];
}
