import 'package:either_dart/either.dart';
import 'package:fire_alarm_app/commons/error.dart';
import 'package:fire_alarm_app/model/floor_model.dart';
import 'package:fire_alarm_app/provides/dio_provider.dart';

abstract interface class FloorRepo {
  Future<Either<Failure, T?>> getListFloors<T>();

  Future<Either<Failure, Map<String, dynamic>?>> updateFloorName<T>({int floorId, String floorName});

  Future<Either<Failure, Map<String, dynamic>?>> addListFloors<T>(List<FloorModel> floors);

  Future<Either<Failure, Map<String, dynamic>?>> removeFloor<T>(int? floorId);
}

const String API_FLOOR = '/api/floors';

class FloorRepoImpl extends FloorRepo {
  final _dioProvider = DioProvider();

  @override
  Future<Either<Failure, T?>> getListFloors<T>() async {
    try {
      final response = await _dioProvider.get(API_FLOOR);
      return response.fold(
        (left) => Left(left),
        (right) => Right(right.data.cast<String, dynamic>()),
      );
    } catch (e) {
      return Left(UnknownException(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Map<String, dynamic>?>> updateFloorName<T>({int? floorId, String? floorName}) async {
    try {
      final response = await _dioProvider.put('$API_FLOOR/$floorId', data: {'name': floorName ?? ''});
      return response.fold(
        (left) => Left(left),
        (right) => Right(right.data.cast<String, dynamic>()),
      );
    } catch (e) {
      return Left(UnknownException(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Map<String, dynamic>?>> addListFloors<T>(List<FloorModel> floors) async {
    List<Map<String, dynamic>> listMap = [];
    for (FloorModel floor in floors) {
      listMap.add(floor.toMap());
    }
    Map<String, dynamic> param = {'floors': listMap};
    try {
      final response = await _dioProvider.post(API_FLOOR, data: param);
      return response.fold(
        (left) => Left(left),
        (right) => Right(right.data.cast<String, dynamic>()),
      );
    } catch (e) {
      return Left(UnknownException(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Map<String, dynamic>?>> removeFloor<T>(int? floorId) async {
    try {
      final response = await _dioProvider.delete('$API_FLOOR/$floorId');
      return response.fold(
        (left) => Left(left),
        (right) => Right(right.data.cast<String, dynamic>()),
      );
    } catch (e) {
      return Left(UnknownException(e.toString()));
    }
  }
}
