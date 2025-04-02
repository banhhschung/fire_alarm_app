import 'dart:async';
import 'dart:convert';

import 'package:fire_alarm_app/blocs/mqtt_bloc/mqtt_event.dart';
import 'package:fire_alarm_app/blocs/mqtt_bloc/mqtt_state.dart';
import 'package:fire_alarm_app/blocs/udp_bloc/udp_bloc.dart';
import 'package:fire_alarm_app/blocs/udp_bloc/udp_state.dart';
import 'package:fire_alarm_app/configs/app_config.dart';
import 'package:fire_alarm_app/configs/device_type_code.dart';
import 'package:fire_alarm_app/model/device_model.dart';
import 'package:fire_alarm_app/model/mqtt_extra_config_model.dart';
import 'package:fire_alarm_app/model/mqtt_message_add_device_model.dart';
import 'package:fire_alarm_app/model/mqtt_message_data_model.dart';
import 'package:fire_alarm_app/provides/database_provider.dart';
import 'package:fire_alarm_app/provides/mqtt_provider.dart';
import 'package:fire_alarm_app/utils/common_utils.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MqttBloc extends Bloc<MqttEvent, MqttState> {
  MQTTProvider? _mqttProvider;
  final UdpBloc _udpBloc;
  final DatabaseHelper _databaseHelper = DatabaseHelper.instance;
  late StreamSubscription _subscription;

  MqttBloc(this._udpBloc) : super(InitialMqttState()) {
    _mqttProvider = MQTTProvider(
      receivedMessageCallback,
      receivedStateCallback,
      broker: ConfigApp.getMQTTBroker(),
      clientId: 'vconnex_smarthome_flutter_${DateTime.now().millisecondsSinceEpoch}',
      port: ConfigApp.getMQTTPort(),
    );
    _subscription = _udpBloc.stream.listen((state) {
      if (state is ReceiveUDPGetDataMessageState) {
        add(GetMqttMessageEvent(state.message));
      }
    });

    on<StartConnectMqttEvent>(_onStartConnectMqttEvent);
    on<DisconnectMqttEvent>(_onDisconnectMqttEvent);
    on<RefreshConnectMqttEvent>(_onRefreshConnectMqttEvent);
    on<MqttOnSubscribedEvent>(_onMqttOnSubscribedEvent);
    on<GetMqttMessageEvent>(_onGetMqttMessageEvent);
    on<MqttGetWifiDeviceMessageEvent>(_onMqttGetWifiDeviceMessageEvent);
    on<PublishMessageEvent>(_onPublishMessageEvent);
    on<MqttCmdGetExtraConfigEvent>(_onMqttCmdGetExtraConfigEvent);
    on<MqttCmdSetExtraConfigEvent>(_onMqttCmdSetExtraConfigEvent);
  }

  @override
  Future<void> close() {
    _mqttProvider!.disConnect();
    _subscription.cancel();
    return super.close();
  }

  void receivedMessageCallback(String message) {
    add(GetMqttMessageEvent(message));
  }

  void receivedStateCallback(Map<String, dynamic> state) {
    if (state.containsKey('onConnected')) {
      Common.printLog('-----------> MQTT onConnected');
      subAllTopicListDevice();
    } else if (state.containsKey('onDisconnected')) {
    } else if (state.containsKey('onSubscribed')) {
      add(MqttOnSubscribedEvent(state['onSubscribed']));
    } else if (state.containsKey('onUnsubscribed')) {
      add(MqttOnUnSubScribedEvent());
    }
  }

  Future<bool> subAllTopicListDevice() async {
    List<Device> wifiDevices = _databaseHelper.getAllDevices();
    if (wifiDevices.isNotEmpty) {
      for (Device device in wifiDevices) {
        if (device.typeConnect == DeviceTypeCode.PCCC_CENTER || (device.share != Device.DEVICE_IS_OWN)) {
          Common.printLog('====== sub topic in restartConnectMqtt: ${device.topicContent}  time: ${DateTime.now().toString()}');
          _mqttProvider!.subscribeToTopic('${device.topicContent}');
        }
      }
    }
    return true;
  }

  Future<bool> _connectMqtt() async {
    if (!_mqttProvider!.isConnected()) {
      return await _mqttProvider!.connect();
    }
    return true;
  }

  void _onStartConnectMqttEvent(StartConnectMqttEvent event, Emitter<MqttState> emit) async {
    final isConnect = await _connectMqtt();
    if (!isConnect) {
      _mqttProvider!.refreshConnection();
    }
  }

  void _onDisconnectMqttEvent(DisconnectMqttEvent event, Emitter<MqttState> emit) async {
    if (_mqttProvider != null) {
      _mqttProvider!.disConnect();
    }
  }

  void _onRefreshConnectMqttEvent(RefreshConnectMqttEvent event, Emitter<MqttState> emit) async {
    _mqttProvider!.refreshConnection(forceRefresh: true);
  }

  void _onGetMqttMessageEvent(GetMqttMessageEvent event, Emitter<MqttState> emit) {
    Map<String, dynamic> mqttMessage = json.decode(event.message);
    if (mqttMessage['name'] == 'CmdGetData') {
      MqttMessageDataModel mqttMessageDataModel = MqttMessageDataModel.fromJson(mqttMessage);
      emit(GetMqttMessageState(mqttMessageDataModel: mqttMessageDataModel));
    } else if (mqttMessage['name'] == 'CmdAddDevice') {
      MqttMessageAddDeviceModel mqttMessageAddDeviceModel = MqttMessageAddDeviceModel.fromJson(mqttMessage);
      emit(GetMqttMessageAddDeviceState(mqttMessageAddDeviceModel: mqttMessageAddDeviceModel));
    } else if (mqttMessage['name'] == 'CmdGetExtraConfig') {
      MqttExtraConfigModel model = MqttExtraConfigModel.fromJson(mqttMessage);
      emit(MqttGetExtraConfigMessageState(mqttExtraConfigModel: model));
    } else if (mqttMessage['name'] == 'CmdSetExtraConfig') {
      MqttExtraConfigModel model = MqttExtraConfigModel.fromJson(mqttMessage);
      emit(MqttGetExtraConfigMessageState(mqttExtraConfigModel: model));
    }
  }

  void _onMqttOnSubscribedEvent(MqttOnSubscribedEvent event, Emitter<MqttState> emit) async {
    List<Device> wifiDevices = _databaseHelper.getListDeviceWithTopic(event.topic);
    if (wifiDevices.isNotEmpty) {
      for (Device device in wifiDevices) {
        if (device.connectMode == DeviceTypeCode.WIFI_DEVICE_TYPE || device.connectMode == null) {
          add(MqttGetWifiDeviceMessageEvent(device));
        }
      }
    }
  }

  FutureOr<void> _onMqttGetWifiDeviceMessageEvent(MqttGetWifiDeviceMessageEvent event, Emitter<MqttState> emit) async {
    String command = '{\"name\":\"CmdGetData\",\"value\":{\"devT\":${event.device.code}, \"devExtAddr\": \"${event.device.address}\"}}';
    add(PublishMessageEvent(command, event.device.topicCommand));
  }

  void _onPublishMessageEvent(PublishMessageEvent event, Emitter<MqttState> emit) async {
    bool isSuccess = _mqttProvider!.publishMessage(event.gatewayId, event.message);
    if (!isSuccess) {
      Common.printLog('send UDP from !isSuccess');
      _udpBloc.sendUDPBroadcashMessageEventToState(event.message);
    } else if (_mqttProvider!.isTimeOutConnection()) {
      Common.printLog('send UDP from isTimeOutConnection');
      _udpBloc.sendUDPBroadcashMessageEventToState(event.message);
    } else if (!(await Common.isConnectToServerOverWifi())) {
      Common.printLog('send UDP from isConnectToServerOverWifi');
      _udpBloc.sendUDPBroadcashMessageEventToState(event.message);
    } else if (!(await Common.isWifiConnected())) {
      Common.printLog('send UDP from isWifiConnected');
      _udpBloc.sendUDPBroadcashMessageEventToState(event.message);
    }
  }

  FutureOr<void> _onMqttCmdGetExtraConfigEvent(MqttCmdGetExtraConfigEvent event, Emitter<MqttState> emit) {
    String command = '{\"name\":\"CmdGetExtraConfig\",\"value\":{\"devT\":${event.device.code},\"devExtAddr\":\"${event.device.address}\"}}';
    add(PublishMessageEvent(command, event.device.topicCommand));
  }

  FutureOr<void> _onMqttCmdSetExtraConfigEvent(MqttCmdSetExtraConfigEvent event, Emitter<MqttState> emit) {
    String command = '{\"name\":\"CmdSetExtraConfig\",\"value\":{\"devT\":${event.device.code},\"devExtAddr\":\"${event.device.address}\",\"${event.param}\":${event.value}}}';
    add(PublishMessageEvent(command, event.device.topicCommand));
  }

  Future<bool> getAllMessageListDevice() async {
    List<Device> wifiDevices = _databaseHelper.getAllDevices();
    if (wifiDevices.isNotEmpty) {
      for (Device device in wifiDevices) {
        add(MqttGetWifiDeviceMessageEvent(device));
      }
    }
    return true;
  }
}
