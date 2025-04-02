import 'dart:math';

import 'package:equatable/equatable.dart';

abstract class UdpEvent extends Equatable {
  const UdpEvent();
}

class StartConnectUdpEvent extends UdpEvent {
  @override
  List get props => [];
}

class UdpReceiveGetDataMessageEvent extends UdpEvent {
  final String message;

  const UdpReceiveGetDataMessageEvent(this.message);

  @override
  List get props => [Random().nextInt(9999)];
}

class CloseConnectUdpEvent extends UdpEvent {
  @override
  List get props => [];
}