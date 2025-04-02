import 'package:dio/dio.dart';
import 'package:either_dart/either.dart';
import 'package:fire_alarm_app/commons/error.dart';
import 'package:fire_alarm_app/model/alert_notification_model.dart';
import 'package:fire_alarm_app/model/device_model.dart';
import 'package:fire_alarm_app/provides/dio_provider.dart';
import 'package:geolocator/geolocator.dart';

abstract class DeviceRepo {
  Future<Either<Failure, T?>> getListDeviceType<T>();

  Future<Either<Failure, Map<String, dynamic>?>> addDeviceBySerial<T>(Device device);

  Future<Either<Failure, Map<String, dynamic>?>> activeDeviceBySerial<T>(String serial);

  Future<Either<Failure, Map<String, dynamic>?>> getAllDevicesInAccount<T>();

  Future<Either<Failure, Map<String, dynamic>?>> activeDeviceInBE<T>(String? address, String? version);

  Future<Either<Failure, Map<String, dynamic>?>> updateInformationDevice<T>(Device device);

  Future<Either<Failure, Map<String, dynamic>?>> addDeviceToBE<T>(Device device);

  Future<Either<Failure, bool>> removeDevice<T>(Device device);

  Future<Either<Failure, Map<String, dynamic>?>> getWarningSounds<T>(int deviceId);

  Future<Either<Failure, Map<String, dynamic>?>> saveWarningSoundByDevice<T>(AlertNotificationModel alertNotificationModel);
}

const String GET_LIST_DEVICE_TYPE = "/api/device-type/getList";
const String ADD_DEVICE_BY_SERIAL = "/api/device/serial";
const String ACTIVE_DEVICE_BY_SERIAL = "/api/device/active/serial";
const String DEVICE_LIST_PATH = "/api/device/list";
const String ACTIVE_DEVICE_PATH = "/api/device/active/";
const String DEVICE_PATH = "/api/device/";
const String DEVICE_WARNING_PATH = "/api/device/warning";

class DeviceRepoImpl extends DeviceRepo {
  final DioProvider _dioProvider = DioProvider();

  @override
  Future<Either<Failure, T?>> getListDeviceType<T>() async {
    try {
      final param = {'start': 0, 'total': 999, 'status': 1};

      final response = await _dioProvider.get(GET_LIST_DEVICE_TYPE, param: param);
      return response.fold(
        (left) => Left(left),
        (right) {
          return Right(right.data.cast<String, dynamic>());
        },
      );
    } catch (e) {
      return Left(UnknownException(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Map<String, dynamic>?>> addDeviceBySerial<T>(Device device) async {
    try {
      /*Position position = await Geolocator.getCurrentPosition();
     device.lat = position.latitude;
     device.lon = position.longitude;*/

      final response = await _dioProvider.post(ADD_DEVICE_BY_SERIAL, data: device.toBEJson());
      return response.fold(
        (left) => Left(left),
        (right) {
          return Right(right.data.cast<String, dynamic>());
        },
      );
    } catch (e) {
      return Left(UnknownException(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Map<String, dynamic>?>> activeDeviceBySerial<T>(String? serial) async {
    try {
      Map<String, dynamic> params = <String, dynamic>{};
      if (serial != null) {
        params['serial'] = serial;
      }
      final response = await _dioProvider.post(ACTIVE_DEVICE_BY_SERIAL, param: params);
      return response.fold(
        (left) => Left(left),
        (right) {
          return Right(right.data.cast<String, dynamic>());
        },
      );
    } catch (e) {
      return Left(UnknownException(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Map<String, dynamic>?>> getAllDevicesInAccount<T>() async {
    try {
      final response = await _dioProvider.get(DEVICE_LIST_PATH);
      return response.fold(
        (left) => Left(left),
        (right) => Right(right.data.cast<String, dynamic>()),
      );
    } catch (e) {
      return Left(UnknownException(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Map<String, dynamic>?>> activeDeviceInBE<T>(String? address, String? version) async {
    try {
      Map<String, dynamic> params = <String, dynamic>{};
      if (version != null) {
        params['version'] = version;
      }
      final response = await _dioProvider.post('$ACTIVE_DEVICE_PATH$address', param: params);
      return response.fold(
        (left) => Left(left),
        (right) => Right(right.data.cast<String, dynamic>()),
      );
    } catch (e) {
      return Left(UnknownException(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Map<String, dynamic>?>> updateInformationDevice<T>(Device device) async {
    try {
      final response = _dioProvider.put(DEVICE_PATH, data: device.toBEJson());
      return response.fold(
        (left) => Left(left),
        (right) => Right(right.data.cast<String, dynamic>()),
      );
    } catch (e) {
      return Left(UnknownException(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Map<String, dynamic>?>> addDeviceToBE<T>(Device device) async {
    try {
      final response = await _dioProvider.post(DEVICE_PATH, data: device.toBEJson());
      return response.fold(
        (left) => Left(left),
        (right) => Right(right.data.cast<String, dynamic>()),
      );
    } catch (e) {
      return Left(UnknownException(e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> removeDevice<T>(Device device) async {
    try {
      final response = await _dioProvider.delete('$DEVICE_PATH${device.id}');
      return response.fold(
        (left) => Left(left),
        (right) {
          final code = right.statusCode;
          bool isCodeAccept = code == StatusCode.STATUS_OK || code == StatusCode.STATUS_CREATED || code == StatusCode.STATUS_ACCEPTED;
          final data = right.data.cast<String, dynamic>();

          return Right(isCodeAccept && data != null && data['code'] == StatusCode.SUCCESS);
        },
      );
    } catch (e) {
      return Left(UnknownException(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Map<String, dynamic>?>> getWarningSounds<T>(int deviceId) async {
    try {
      final response = _dioProvider.get("/api/device/$deviceId/warning");
      return response.fold(
        (left) => Left(left),
        (right) => Right(right.data.cast<String, dynamic>()),
      );
    } catch (e) {
      return Left(UnknownException(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Map<String, dynamic>?>> saveWarningSoundByDevice<T>(AlertNotificationModel alertNotificationModel) async {
    try {
      final response = _dioProvider.post("$DEVICE_WARNING_PATH/${alertNotificationModel.id}", data: alertNotificationModel.toJson());
      return response.fold(
        (left) => Left(left),
        (right) => Right(right.data.cast<String, dynamic>()),
      );
    } catch (e) {
      return Left(UnknownException(e.toString()));
    }
  }
}
