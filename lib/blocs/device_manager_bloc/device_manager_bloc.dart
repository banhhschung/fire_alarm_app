import 'dart:async';
import 'dart:convert';

import 'package:fire_alarm_app/blocs/device_manager_bloc/device_manager_event.dart';
import 'package:fire_alarm_app/blocs/device_manager_bloc/device_manager_state.dart';
import 'package:fire_alarm_app/blocs/mqtt_bloc/mqtt_bloc.dart';
import 'package:fire_alarm_app/commons/error.dart';
import 'package:fire_alarm_app/configs/device_type_code.dart';
import 'package:fire_alarm_app/model/alert_notification_model.dart';
import 'package:fire_alarm_app/model/device_model.dart';
import 'package:fire_alarm_app/model/device_type_model.dart';
import 'package:fire_alarm_app/provides/database_provider.dart';
import 'package:fire_alarm_app/repositories/device_repo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DeviceManagerBloc extends Bloc<DeviceManagerEvent, DeviceManagerState> {
  final DeviceRepo _deviceRepo = DeviceRepoImpl();
  final DatabaseHelper _databaseHelper = DatabaseHelper.instance;
  late MqttBloc _mqttBloc;

  List<DeviceTypeModel> _listDeviceHashCodeType = [
    DeviceTypeModel(name: "Tủ trung tâm", code: DeviceTypeCode.PCCC_CENTER),
    DeviceTypeModel(name: "Tủ còi đèn", code: 4004),
    DeviceTypeModel(name: "Cảm biến khói (Lora/RS485)", code: 4001),
    DeviceTypeModel(name: "Cảm biến nhiệt (Lora/RS485)", code: 4002),
    DeviceTypeModel(name: "Cảm biến nhiệt gia tăng (Lora/RS485)", code: 4003),
    DeviceTypeModel(name: "Cảm biến khói + nhiệt (Lora/RS485)", code: 0),
    DeviceTypeModel(name: "Nút nhấn khẩn cấp tại chỗ (Lora/RS485)", code: 4006),
    DeviceTypeModel(name: "Đèn báo tại chỗ (Lora/RS4485)", code: 0),
  ];

  DeviceManagerBloc(this._mqttBloc) : super(InitialDeviceManagerState()) {
    on<GetListDeviceTypeEvent>(_onGetListDeviceTypeEvent);
    on<AddDeviceBySerialEvent>(_onAddDeviceBySerialEvent);
    on<ActiveDeviceBySerialEvent>(_onActiveDeviceBySerialEvent);
    on<GetListDeviceInAccountDeviceEvent>(_onGetListDeviceInAccountDeviceEvent);
    on<ActiveDeviceInBEEvent>(_onActiveDeviceInBEEvent);
    on<UpdateInformationDeviceEvent>(_onUpdateInformationDeviceEvent);
    on<AddDeviceToBEEvent>(_onAddDeviceToBEEvent);
    on<RemoveDeviceEvent>(_onRemoveDeviceEvent);
    on<GetWarningSoundsEvent>(_onGetWarningSoundsEvent);
    on<SaveWarningSoundByDeviceEvent>(_onSaveWarningSoundByDeviceEvent);
  }

  void _onGetListDeviceTypeEvent(GetListDeviceTypeEvent event, Emitter<DeviceManagerState> emit) async {
    final response = await _deviceRepo.getListDeviceType();
    response.fold(
      (left) {
        emit(GetListDeviceTypeState(const []));
        return;
      },
      (right) {
        if (right != null && right['data'] != null) {
          List<DeviceTypeModel> listDeviceType = List<DeviceTypeModel>.from(right['data'].map((x) => DeviceTypeModel.fromJson(x)));
          emit(GetListDeviceTypeState(_listDeviceHashCodeType));
        } else {
          emit(GetListDeviceTypeState(const []));
        }
      },
    );
  }

  void _onAddDeviceBySerialEvent(AddDeviceBySerialEvent event, Emitter<DeviceManagerState> emit) async {
    Device device = event.device;
    final response = await _deviceRepo.addDeviceBySerial(device);
    response.fold((l) {
      emit(AddDeviceBySerialFailState());
    }, (r) async {
      final data = response.right;
      if (data != null && data['code'] != null && data['code'] == StatusCode.SUCCESS) {
        Device device = Device.fromBEJson(data['data']);
        emit(AddDeviceBySerialSuccessState(device));
      } else {
        emit(AddDeviceBySerialFailState());
      }
    });
  }

  void _onActiveDeviceBySerialEvent(ActiveDeviceBySerialEvent event, Emitter<DeviceManagerState> emit) async {
    final response = await _deviceRepo.activeDeviceBySerial(event.serial);
    response.fold((left) {
      emit(ActiveDeviceBySerialFailState());
    }, (right) {
      final data = response.right;
      if (data != null && data['code'] != null && data['code'] == StatusCode.SUCCESS) {
        emit(ActiveDeviceBySerialSuccessState(data['code'], data['data']['deviceStatus']));
      } else {
        emit(ActiveDeviceBySerialFailState());
      }
    });
  }

  void _onGetListDeviceInAccountDeviceEvent(GetListDeviceInAccountDeviceEvent event, Emitter<DeviceManagerState> emit) async {
    final response = await _deviceRepo.getAllDevicesInAccount();
    response.fold((left) {
      emit(GetListDeviceInAccountDeviceFailState());
    }, (right) async {
      final data = response.right;
      if (data != null && data['data'] != null) {
        List<Device> listDevice = List<Device>.from(data['data'].map((x) => Device.fromBEJson(x)));
        Future.microtask(() async {
          bool value = await _databaseHelper.updateListDevices(listDevice);
          if (value != null && value) {
            print("save devices to hive done");
          }
        });
        emit(GetListDeviceInAccountDeviceSuccessState(listDevice: listDevice));
        _mqttBloc.getAllMessageListDevice();
      } else {
        emit(GetListDeviceInAccountDeviceFailState());
      }
    });
  }

  void _onActiveDeviceInBEEvent(ActiveDeviceInBEEvent event, Emitter<DeviceManagerState> emit) async {
    final response = await _deviceRepo.activeDeviceInBE(event.address, event.version);
    if (response.isLeft) {
      emit(ActiveDeviceInBEFailState());
      return;
    }
    final data = response.right;
    if (data != null && data['code'] == StatusCode.SUCCESS) {
      emit(ActiveDeviceInBESuccessState());
    } else {
      emit(ActiveDeviceInBEFailState());
    }
  }

  void _onUpdateInformationDeviceEvent(UpdateInformationDeviceEvent event, Emitter<DeviceManagerState> emit) async {
    final response = await _deviceRepo.updateInformationDevice(event.device);
    if (response.isLeft) {
      emit(UpdateInformationDeviceFailState());
      return;
    }
    final data = response.right;
    if (data != null && data['code'] == StatusCode.SUCCESS) {
      await _databaseHelper.updateDevice(event.device);
      emit(UpdateInformationDeviceSuccessState());
    } else {
      emit(UpdateInformationDeviceFailState());
    }
  }

  FutureOr<void> _onAddDeviceToBEEvent(AddDeviceToBEEvent event, Emitter<DeviceManagerState> emit) async {
    final response = await _deviceRepo.addDeviceToBE(event.device);
    if (response.isLeft) {
      emit(AddDeviceToBEFailState());
      return;
    }
    final data = response.right;
    if (data != null) {
      if (data['code'] == StatusCode.SUCCESS && data['data'] != null) {
        Device device = Device.fromBEJson(data['data']);
        emit(AddDeviceToBESuccessState());
      } else if (data['code'] == StatusCode.CONFILICT_CODE) {
        emit(AddDeviceToBEFailState());
      } else if (data['code'] == StatusCode.NOT_FOUND_BY_ID) {
        emit(AddDeviceToBEFailState());
      } else if (data['code'] == StatusCode.USER_NOT_PERMISSION) {
        emit(AddDeviceToBEFailState());
      }
    } else {
      emit(AddDeviceToBEFailState());
    }
  }

  FutureOr<void> _onRemoveDeviceEvent(RemoveDeviceEvent event, Emitter<DeviceManagerState> emit) async {
    final response = await _deviceRepo.removeDevice(event.device);
    if (response.isRight && response.right) {
      await _databaseHelper.removeDevice(event.device);
      emit(RemoveDeviceSuccessState());
    } else {
      emit(RemoveDeviceFailState());
      return;
    }
  }

  FutureOr<void> _onGetWarningSoundsEvent(GetWarningSoundsEvent event, Emitter<DeviceManagerState> emit) async {
    final response = await _deviceRepo.getWarningSounds(event.deviceId);
    if (response.isLeft) {
      emit(GetWarningSoundsFailState());
      return;
    }
    final data = response.right;
    if (data != null && data['code'] != null && data['code'] == StatusCode.SUCCESS && data['data'] != null) {
      AlertNotificationModel alertNotificationModel = AlertNotificationModel.fromJson(data['data']);
      emit(GetWarningSoundsSuccessState(alertNotificationModel: alertNotificationModel));
    } else {
      emit(GetWarningSoundsFailState());
    }
  }

  FutureOr<void> _onSaveWarningSoundByDeviceEvent(SaveWarningSoundByDeviceEvent event, Emitter<DeviceManagerState> emit) async {
    final response = await _deviceRepo.saveWarningSoundByDevice(event.alertNotificationModel);
    if (response.isLeft) {
      emit(SaveWarningSoundByDeviceFailState());
      return;
    }
    final data = response.right;
    if (data != null && data['code'] != null && data['code'] == StatusCode.SUCCESS) {
      emit(SaveWarningSoundByDeviceSuccessState());
    } else {
      emit(SaveWarningSoundByDeviceFailState());
    }
  }
}
