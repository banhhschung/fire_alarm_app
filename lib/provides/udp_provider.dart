import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:fire_alarm_app/utils/common_utils.dart';
import 'package:network_info_plus/network_info_plus.dart';

typedef ReceivedUDPMessageCallback = void Function(String, String);

class UdpProvider {
  final ReceivedUDPMessageCallback receivedUDPMessageCallback;

  UdpProvider(this.receivedUDPMessageCallback);

  RawDatagramSocket? udpSocket;
  StreamSubscription? _socketListen;
  final NetworkInfo _wifiInfo = NetworkInfo();

  bool _isResettingUDP = false;

  Future<void> startUDP() async {
    if (udpSocket == null) {
      try {
        udpSocket = await RawDatagramSocket.bind(InternetAddress.anyIPv4, 5001);
        udpSocket!.broadcastEnabled = true;
        udpSocket!.writeEventsEnabled = false;

        if (_socketListen != null) {
          await _socketListen!.cancel();
        }
      } catch (e) {
        await closeUDP();
      }

      _socketListen = udpSocket!.listen((RawSocketEvent e) {
        try {
          if (e == RawSocketEvent.read) {
            Datagram? dg = udpSocket!.receive();
            if (dg != null) {
              String message = String.fromCharCodes(dg.data);
              Common.printLog('-----------udp data message: $message, from ip: ${dg.address}');
              receivedUDPMessageCallback(message, dg.address.address);
            }
          }
        } catch (e) {
          Common.printLog("udp error $e");
        }
      });
    }

    return;
  }

  Future closeUDP() async {
    if (udpSocket != null) {
      udpSocket!.close();
      udpSocket = null;
    }

    if (_socketListen != null) {
      await _socketListen!.cancel();
    }
  }

  Future resetUDP() async {
    _isResettingUDP = true;
    Future.delayed(const Duration(seconds: 1)).then((value) => _isResettingUDP = false);
    await closeUDP();
    await startUDP();
  }

  void sendMessage(String message, String? ip, {bool? isBroadcash}) async {
    if (isBroadcash != null && isBroadcash) {
      ip = await _getBroadCashIp();
    }

    Common.printLog('---------UDP send message $message, ip: $ip, is Reset: $_isResettingUDP');

    if (!_isResettingUDP) {
      if (udpSocket != null) {
        final destinationAddress = InternetAddress(ip!);
        List<int> data = utf8.encode(message);
        int result = udpSocket!.send(data, destinationAddress, 5000);
        if (result == 0) {
          await resetUDP();
        }
        Common.printLog('udp send result : $result');
      } else {
        Common.printLog('reseting udp');
        await resetUDP();
      }
    }
  }

  Future<String> _getBroadCashIp() async {
    try {
      String? ip = await _wifiInfo.getWifiIP().timeout(const Duration(seconds: 3));
      if (ip != null && ip.isNotEmpty) {
        ip = ip.substring(0, ip.lastIndexOf('.'));
        ip += '.255';
      }

      return ip ?? '255.255.255.255';
    } catch (e) {
      return '255.255.255.255';
    }
  }

  static Future<Map<String, dynamic>?> getMacAddress(String dataStr) async {
    Map<String, dynamic>? receivedData;
    var destinationAddress = InternetAddress("255.255.255.255");

    RawDatagramSocket udpSocket = await RawDatagramSocket.bind(InternetAddress.anyIPv4, 5001);

    udpSocket.broadcastEnabled = true;
    udpSocket.multicastHops = 10;
    udpSocket.writeEventsEnabled = true;
    udpSocket.listen((e) {
      Datagram? dg = udpSocket.receive();
      if (dg != null) {
        String message = String.fromCharCodes(dg.data);
        Map<String, dynamic> mesMap = json.decode(message);
        if (mesMap['name'] == 'CmdGetMAC') {
          receivedData = mesMap;
          receivedData!['ip'] = dg.address.address;
        }
      }
    });

    List<int> data = utf8.encode(dataStr);
    udpSocket.send(data, destinationAddress, 5000);

    await Future.delayed(const Duration(seconds: 1));
    udpSocket.close();
    return receivedData;
  }

  static Future<Map<String, dynamic>?> sendSmartConfigMessage(String dataStr) async {
    Map<String, dynamic>? receivedData;
    var destinationAddress = InternetAddress("192.168.99.1");

    for (int i = 0; i < 5; i++) {
      RawDatagramSocket udpSocket = await RawDatagramSocket.bind(InternetAddress.anyIPv4, 5001);
      udpSocket.broadcastEnabled = true;
      udpSocket.listen((e) {
        Datagram? dg = udpSocket.receive();
        if (dg != null) {
          String message = String.fromCharCodes(dg.data);
          Map<String, dynamic> mesMap = json.decode(message);
          if (mesMap['name'] == 'CmdSetSSID') {
            receivedData = mesMap;
          }
        }
      });
      List<int> data = utf8.encode(dataStr);
      udpSocket.send(data, destinationAddress, 5001);

      await Future.delayed(const Duration(seconds: 1));
      udpSocket.close();
      await Future.delayed(const Duration(seconds: 1));
      if (receivedData != null) {
        return receivedData;
      }
    }

    return null;
  }
}
