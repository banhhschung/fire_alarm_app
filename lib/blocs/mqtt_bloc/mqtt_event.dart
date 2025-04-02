import 'dart:math';

import 'package:equatable/equatable.dart';
import 'package:fire_alarm_app/model/device_model.dart';

abstract class MqttEvent extends Equatable {
  const MqttEvent();
}

class StartConnectMqttEvent extends MqttEvent {
  @override
  List get props => [];
}

class DisconnectMqttEvent extends MqttEvent {
  @override
  List get props => [];
}

class RefreshConnectMqttEvent extends MqttEvent {
  @override
  List get props => [];
}

class GetMqttMessageEvent extends MqttEvent {
  final String message;

  const GetMqttMessageEvent(this.message);

  @override
  String toString() {
    return 'GetMessageEvent';
  }

  @override
  List get props => [];
}

class MqttOnConnectedEvent extends MqttEvent {
  @override
  List get props => [];
}

class MqttOnDisconnectedEvent extends MqttEvent {
  @override
  List get props => [];
}

class MqttOnSubscribedEvent extends MqttEvent {
  final String topic;

  const MqttOnSubscribedEvent(this.topic);

  @override
  List get props => [];
}

class MqttOnUnSubScribedEvent extends MqttEvent {
  @override
  List get props => [];
}

class MqttGetWifiDeviceMessageEvent extends MqttEvent {
  final Device device;

  const MqttGetWifiDeviceMessageEvent(this.device);

  @override
  List get props => [Random().nextInt(9999)];
}

class PublishMessageEvent extends MqttEvent {
  final String message;
  final String? gatewayId;

  const PublishMessageEvent(this.message, this.gatewayId);

  @override
  List get props => [Random().nextInt(9999)];
}

class MqttCmdGetExtraConfigEvent extends MqttEvent {
  final Device device;

  const MqttCmdGetExtraConfigEvent({required this.device});

  @override
  List get props => [Random().nextInt(9999)];
}

class MqttCmdSetExtraConfigEvent extends MqttEvent{
  final String param;
  final int value;
  final Device device;

  const MqttCmdSetExtraConfigEvent({required this.param, required this.value, required this.device});

  @override
  List get props => [Random().nextInt(9999)];
}
