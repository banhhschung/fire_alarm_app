import 'package:equatable/equatable.dart';
import 'package:fire_alarm_app/model/alert_notification_model.dart';
import 'package:fire_alarm_app/model/device_model.dart';

class DeviceManagerEvent extends Equatable {
  @override
  List get props => [];
}

class GetListDeviceTypeEvent extends DeviceManagerEvent {
  @override
  List get props => [];
}

class AddDeviceBySerialEvent extends DeviceManagerEvent {
  final Device device;

  AddDeviceBySerialEvent({required this.device});

  @override
  List get props => [device];
}

class ActiveDeviceBySerialEvent extends DeviceManagerEvent {
  final String serial;

  ActiveDeviceBySerialEvent({required this.serial});

  @override
  List get props => [serial];
}

class GetListDeviceInAccountDeviceEvent extends DeviceManagerEvent {
  @override
  List get props => [];
}

class ActiveDeviceInBEEvent extends DeviceManagerEvent {
  final String? version;
  final String? address;

  ActiveDeviceInBEEvent(this.version, this.address);
}

class UpdateInformationDeviceEvent extends DeviceManagerEvent {
  final Device device;

  UpdateInformationDeviceEvent({required this.device});
}

class AddDeviceToBEEvent extends DeviceManagerEvent {
  final Device device;

  AddDeviceToBEEvent({required this.device});
}

class RemoveDeviceEvent extends DeviceManagerEvent {
  final Device device;

  RemoveDeviceEvent({required this.device});
}

class GetWarningSoundsEvent extends DeviceManagerEvent {
  final int deviceId;

  GetWarningSoundsEvent({required this.deviceId});
}

class SaveWarningSoundByDeviceEvent extends DeviceManagerEvent {
  final AlertNotificationModel alertNotificationModel;

  SaveWarningSoundByDeviceEvent({required this.alertNotificationModel});
}
