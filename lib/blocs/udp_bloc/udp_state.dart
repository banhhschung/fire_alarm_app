import 'dart:math';

import 'package:equatable/equatable.dart';

abstract class UdpState extends Equatable {
  const UdpState();
}

class InitialUdpState extends UdpState {
  @override
  List get props => [];
}

class ReceiveUDPGetDataMessageState extends UdpState {
  final String message;

  const ReceiveUDPGetDataMessageState(this.message);

  @override
  List get props => [Random().nextInt(9999)];
}
