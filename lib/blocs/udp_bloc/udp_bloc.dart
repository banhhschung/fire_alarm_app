
import 'dart:async';
import 'dart:convert';

import 'package:fire_alarm_app/blocs/udp_bloc/udp_event.dart';
import 'package:fire_alarm_app/blocs/udp_bloc/udp_state.dart';
import 'package:fire_alarm_app/provides/udp_provider.dart';
import 'package:fire_alarm_app/utils/common_utils.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UdpBloc extends Bloc<UdpEvent, UdpState> {
  late UdpProvider _udpProvider;
  UdpBloc() : super(InitialUdpState()){
    _udpProvider = UdpProvider(receivedUdpMessageCallback);
    on<StartConnectUdpEvent>(_onStartConnectUdpEvent);
    on<UdpReceiveGetDataMessageEvent>(_onUdpReceiveGetDataMessageEvent);
    on<CloseConnectUdpEvent>(_onCloseConnectUdpEvent);
  }


  void receivedUdpMessageCallback(String message, String ip) {
    try {
      Map<String, dynamic> mesMap = json.decode(message);
      if (mesMap['name'] == 'CmdGetData') {
        add(UdpReceiveGetDataMessageEvent(message));
      }
    } catch (e) {
      Common.printLog(e);
    }
  }

  void _onUdpReceiveGetDataMessageEvent(UdpReceiveGetDataMessageEvent event, Emitter<UdpState> emit) async {
    emit(ReceiveUDPGetDataMessageState(event.message));
  }

  void _onStartConnectUdpEvent(StartConnectUdpEvent event, Emitter<UdpState> emit) async {
    await _udpProvider.startUDP();
  }

  void _onCloseConnectUdpEvent(CloseConnectUdpEvent event, Emitter<UdpState> emit) async {
    await _udpProvider.closeUDP();
  }

  void sendUDPBroadcashMessageEventToState(String message) {
    _udpProvider.sendMessage(message, '255.255.255.255', isBroadcash: true);
  }
}