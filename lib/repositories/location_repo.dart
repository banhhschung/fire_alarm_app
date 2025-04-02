import 'package:either_dart/either.dart';
import 'package:fire_alarm_app/commons/error.dart';
import 'package:fire_alarm_app/provides/dio_provider.dart';

abstract interface class LocationRepo {
  Future<Either<Failure, Map<String, dynamic>?>> getListProvince<T>();

  Future<Either<Failure, Map<String, dynamic>?>> getListDistrictByProvince<T>(int provinceId);
}

const String GET_LIST_PROVINCE = '/api/weather/getListProvince';
const String GET_LIST_DISTRICT_BY_PROVINCE = '/api/weather/getListDistrictByProvinceId';

class LocationRepoImpl implements LocationRepo {
  final _dioProvider = DioProvider();

  @override
  Future<Either<Failure, Map<String, dynamic>?>> getListProvince<T>() async {
    try {
      final response = await _dioProvider.get(GET_LIST_PROVINCE);
      return response.fold(
            (left) => Left(left),
            (right) => Right(right.data.cast<String, dynamic>()),
      );
    } catch (e) {
      return Left(UnknownException(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Map<String, dynamic>?>> getListDistrictByProvince<T>(int provinceId) async {
    try {
      final response = await _dioProvider.get(GET_LIST_DISTRICT_BY_PROVINCE, param: {'provinceId': provinceId});
      return response.fold(
            (left) => Left(left),
            (right) => Right(right.data.cast<String, dynamic>()),
      );
    } catch (e) {
      return Left(UnknownException(e.toString()));
    }
  }
}
