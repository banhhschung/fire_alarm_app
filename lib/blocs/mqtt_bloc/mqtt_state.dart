import 'dart:math';

import 'package:equatable/equatable.dart';
import 'package:fire_alarm_app/model/mqtt_extra_config_model.dart';
import 'package:fire_alarm_app/model/mqtt_message_add_device_model.dart';
import 'package:fire_alarm_app/model/mqtt_message_data_model.dart';

abstract class MqttState extends Equatable {
  const MqttState();
}

class InitialMqttState extends MqttState {
  @override
  List get props => [];
}

class GetMqttMessageState extends MqttState {
  final MqttMessageDataModel mqttMessageDataModel;

  const GetMqttMessageState({required this.mqttMessageDataModel});

  @override
  List get props => [Random().nextInt(9999)];
}

class GetMqttMessageAddDeviceState extends MqttState {
  final MqttMessageAddDeviceModel mqttMessageAddDeviceModel;

  const GetMqttMessageAddDeviceState({required this.mqttMessageAddDeviceModel});

  @override
  List get props => [Random().nextInt(9999)];
}

class MqttGetExtraConfigMessageState extends MqttState {
  final MqttExtraConfigModel mqttExtraConfigModel;

  const MqttGetExtraConfigMessageState({required this.mqttExtraConfigModel});

  @override
  List get props => [Random().nextInt(9999)];
}

class MqttSetExtraConfigMessageState extends MqttState {
  final MqttExtraConfigModel mqttExtraConfigModel;

  const MqttSetExtraConfigMessageState({required this.mqttExtraConfigModel});

  @override
  List get props => [Random().nextInt(9999)];
}
