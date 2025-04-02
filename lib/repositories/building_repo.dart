import 'package:either_dart/either.dart';
import 'package:fire_alarm_app/commons/error.dart';
import 'package:fire_alarm_app/provides/dio_provider.dart';

abstract interface class BuildingRepo {
  Future<Either<Failure, T?>> getListBuildings<T>();

  Future<Either<Failure, Map<String, dynamic>?>> addBuilding<T>(
      {String? name, String? provinceCode, double? latitude, double? longitude, String? address, int? districtId, int? provinceId, String? imageUrl});

  Future<Either<Failure, Map<String, dynamic>?>> updateBuilding<T>(int? homeId,
      {String? name, String? provinceCode, double? latitude, double? longitude, String? address, int? districtId, int? provinceId, String? imageUrl});
}

const String API_BUILDING = '/api/homes';

class BuildingRepoImpl extends BuildingRepo {
  final _dioProvider = DioProvider();

  @override
  Future<Either<Failure, T?>> getListBuildings<T>() async {
    try {
      final response = await _dioProvider.get(API_BUILDING);
      return response.fold(
        (left) => Left(left),
        (right) => Right(right.data.cast<String, dynamic>()),
      );
    } catch (e) {
      return Left(UnknownException(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Map<String, dynamic>?>> addBuilding<T>(
      {String? name, String? provinceCode, double? latitude, double? longitude, String? address, int? districtId, int? provinceId, String? imageUrl}) async {
    Map<String, dynamic> datas = {'name': name};
    if (provinceCode != null && provinceId != null) {
      datas['provinceCode'] = provinceCode;
      datas['provinceId'] = provinceId;
    }
    if (latitude != null && longitude != null) {
      datas['lat'] = latitude;
      datas['lon'] = longitude;
    }
    if (address != null) {
      datas['address'] = address;
    }
    if (districtId != null) {
      datas['districtId'] = districtId;
    }
    if (imageUrl != null) {
      datas['imageUrl'] = imageUrl;
    }

    try {
      final response = await _dioProvider.post(API_BUILDING, data: datas);
      return response.fold(
        (left) => Left(left),
        (right) => Right(right.data.cast<String, dynamic>()),
      );
    } catch (e) {
      return Left(UnknownException(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Map<String, dynamic>?>> updateBuilding<T>(int? homeId, {String? name, String? provinceCode, double? latitude, double? longitude, String? address, int? districtId, int? provinceId, String? imageUrl}) async {
    Map<String, dynamic> datas = {'name': name};
    if (provinceCode != null && provinceId != null) {
      datas['provinceCode'] = provinceCode;
      datas['provinceId'] = provinceId;
    }
    if (latitude != null && longitude != null) {
      datas['lat'] = latitude;
      datas['lon'] = longitude;
    }
    if (address != null) {
      datas['address'] = address;
    }

    if (districtId != null) {
      datas['districtId'] = districtId;
    }

    if (imageUrl != null) {
      datas['imageUrl'] = imageUrl;
    }
    try {
      final response = await _dioProvider.put('$API_BUILDING/$homeId', data: datas);
      return response.fold(
            (left) => Left(left),
            (right) => Right(right.data.cast<String, dynamic>()),
      );
    } catch (e) {
      return Left(UnknownException(e.toString()));
    }
  }
}
