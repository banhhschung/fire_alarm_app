import 'dart:convert';

import 'package:fire_alarm_app/configs/app_config.dart';
import 'package:fire_alarm_app/provides/udp_provider.dart';
import 'package:fire_alarm_app/utils/common_utils.dart';
import 'package:mqtt_client/mqtt_client.dart' as mqtt;
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';
import 'dart:async';

typedef ReceivedMQTTMessageCallback = void Function(String);
typedef ReceivedMQTTStateCallback = void Function(Map<String, dynamic>);

class MQTTProvider {
  MqttServerClient? client;
  StreamSubscription? subscription;

  String? broker, clientId;
  int? port;

  bool isLocal;

  final List<String> _subscribeTopics = [];

  final ReceivedMQTTMessageCallback receivedMessageCallback;
  final ReceivedMQTTStateCallback receivedStateCallback;

  bool _isRefreshConnection = false;
  bool _isDisconnected = false;

  int _timeReceivedPong = DateTime.now().millisecondsSinceEpoch;

  final int _pingTime = 10;

  MQTTProvider(this.receivedMessageCallback, this.receivedStateCallback, {this.broker, this.port, this.clientId, this.isLocal = false});

  Future<bool> connect() async {
    _isDisconnected = false;
    if (broker != null) {
      client = MqttServerClient.withPort(broker!, 'vconnex_smarthome_flutter_${DateTime.now().millisecondsSinceEpoch}', port!);
      client!.setProtocolV311();
      client!.keepAlivePeriod = _pingTime;
      client!.secure = true;

      client!.onDisconnected = _onDisconnected;
      client!.onConnected = _onConnected;
      client!.onSubscribed = _onSubscribed;
      client!.onUnsubscribed = _onUnsubscribed;
      client!.pongCallback = _pongCallback;
    }

    final mqtt.MqttConnectMessage connMess = mqtt.MqttConnectMessage()
        .withClientIdentifier('vconnex_smarthome_flutter_${DateTime.now().millisecondsSinceEpoch}')
        .startClean()
        .withWillQos(mqtt.MqttQos.atMostOnce)
        .withWillTopic('willtopic${'vconnex_smarthome_flutter_${DateTime.now().millisecondsSinceEpoch}'}') // If you set this you must set a will message
        .withWillMessage('My Will message${'vconnex_smarthome_flutter_${DateTime.now().millisecondsSinceEpoch}'}');
    client!.connectionMessage = connMess;

    try {
      await client!.connect(ConfigApp.username, ConfigApp.passwd).timeout(const Duration(seconds: 5));

      if (client!.connectionStatus!.state != mqtt.MqttConnectionState.connected) {
        _disconnect();
        return false;
      }

      subscriptionOnMessage();
    } catch (e) {
      Common.printLog('client connect fail ${isLocal ? 'local' : 'remote'} : $e');
      return false;
    }

    return true;
  }

  Future<bool> localConnect(String gatewayId, String clientId, int port) async {
    if (client != null) {
      disConnect();
    }

    this.clientId = clientId;
    this.port = port;

    Map<String, dynamic>? message = await UdpProvider.getMacAddress('{"name":"CmdGetMAC","value":0}');
    if (message != null) {
      String mac = message['value'];

      if (gatewayId.toLowerCase() == mac.replaceAll(':', '').toLowerCase()) {
        broker = message['ip'];
      }
    }
    return broker != null ? await connect() : false;
  }

  void disConnect() {
    try {
      _isDisconnected = true;

      if (client != null) {
        client!.disconnect();
        client = null;
      }
    } catch (e) {
      Common.printLog('------Disconnect------');
    }
  }

  void subscribeToTopic(String topic, {bool forceSub = false}) {
    if (!_subscribeTopics.contains(topic) || forceSub) {
      if (client != null && client!.connectionStatus!.state == mqtt.MqttConnectionState.connected) {
        client!.subscribe(topic, mqtt.MqttQos.exactlyOnce);
        Common.printLog('====== subscribeToTopic: $topic  time: ${DateTime.now().toString()}');
        if (!_subscribeTopics.contains(topic)) {
          _subscribeTopics.add(topic);
        }
      } else {}
    }
  }

  void unSubscribeTopic(String? topic) {
    Common.printLog('------unSubcribeTopic: $topic');
    if (client != null && _subscribeTopics.contains(topic)) {
      _subscribeTopics.remove(topic);
    }
  }

  void unSubscribeAllTopic() {
    Common.printLog('------unSubcribeAllTopic');
    for (String topic in _subscribeTopics) {
      if (client != null) {
        client!.unsubscribe(topic);
      }
    }
    _subscribeTopics.clear();
  }

  void unSubscribeAndClearListTopic() {
    Common.printLog('------unSubcribeAndClearListTopic');
    for (String topic in _subscribeTopics) {
      if (client != null) {
        client!.unsubscribe(topic);
      }
    }
    _subscribeTopics.clear();
  }

  bool publishMessage(String? topic, String message) {
    if (client != null && client!.connectionStatus!.state == mqtt.MqttConnectionState.connected) {
      try {
        Common.printLog('------->MQTT ${isLocal ? 'local' : 'remote'} publishMessage $message, $topic');
        final mqtt.MqttClientPayloadBuilder builder = mqtt.MqttClientPayloadBuilder();
        builder.addUTF8String(message);
        client!.publishMessage(topic!, mqtt.MqttQos.exactlyOnce, builder.payload!);

        if (isTimeOutConnection()) {
          refreshConnection();
          return false;
        }
        return true;
      } catch (e) {
        return false;
      }
    }

    Common.printLog('------publishMessage Fail : $topic');
    return false;
  }

  void _onMessage(List<mqtt.MqttReceivedMessage> event) {
    final mqtt.MqttPublishMessage recMess = event[0].payload as mqtt.MqttPublishMessage;
    final String message = utf8.decode(recMess.payload.message, allowMalformed: true);
    if (!message.startsWith('data')) {
      Common.printLog('---mqtt message: $message');
    }
    receivedMessageCallback(message);

    _timeReceivedPong = DateTime.now().millisecondsSinceEpoch;
  }

  void _disconnect() {
    Common.printLog('------_disconnect');
    if (client != null) {
      client!.disconnect();
    }
  }

  void _onDisconnected() {
    Common.printLog('MQTT ${isLocal ? 'local' : 'remote'} onDisconnected ${client!.connectionStatus!.state}');
    if (!_isDisconnected) {
      refreshConnection();
    }

    receivedStateCallback({'onDisconnected': null});
  }

  void _onConnected() async {
    _timeReceivedPong = DateTime.now().millisecondsSinceEpoch;

    List<String> topicSubs = _subscribeTopics;
    for (String topic in topicSubs) {
      subscribeToTopic(topic, forceSub: true);
    }

    receivedStateCallback({'onConnected': null});
  }

  void _onSubscribed(String topic) {
    receivedStateCallback({'onSubscribed': topic});
  }

  void _onUnsubscribed(String? topic) {
    Common.printLog('MQTT ${isLocal ? 'local' : 'remote'} _onUnsubscribed $topic');
    if (_subscribeTopics.contains(topic)) {
      _subscribeTopics.remove(topic);
    }

    receivedStateCallback({'onUnsubscribed': topic});
  }

  void refreshConnection({bool forceRefresh = false}) async {
    if (!_isRefreshConnection) {
      _isRefreshConnection = true;
      Common.printLog('MQTT ${isLocal ? 'local' : 'remote'}: refreshConnection ');

      bool isConnect = await connect();
      if (isConnect) {
        _isRefreshConnection = false;

        List<String> topicSubs = _subscribeTopics;
        for (String topic in topicSubs) {
          if (client!.getSubscriptionsStatus(topic) != MqttSubscriptionStatus.active) {
            subscribeToTopic(topic, forceSub: true);
          }
        }
      } else {
        _isRefreshConnection = false;
        refreshConnection();
      }
      // }
    }
  }

  bool isConnected() {
    return (client != null && client!.connectionStatus!.state == mqtt.MqttConnectionState.connected);
  }

  bool isTimeOutConnection() {
    final deltaTime = DateTime.now().millisecondsSinceEpoch - _timeReceivedPong;
    return deltaTime > 20000;
  }

  void _pongCallback() {
    _timeReceivedPong = DateTime.now().millisecondsSinceEpoch;
  }

  void subscriptionOnMessage() {
    if (client != null) {
      try {
        if (subscription != null) {
          Common.printLog('cancel subscription-------');
          subscription!.cancel();
          subscription = null;
        }
        subscription = client!.updates!.listen(_onMessage);
        Common.printLog('add subscription-------');
      } catch (e) {
        Common.printLog(' subscription false------- $e');
        subscriptionOnMessage();
      }
    }
  }
}
