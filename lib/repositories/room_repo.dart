import 'package:dio/src/response.dart';
import 'package:either_dart/either.dart';
import 'package:fire_alarm_app/commons/error.dart';
import 'package:fire_alarm_app/model/room_model.dart';
import 'package:fire_alarm_app/provides/dio_provider.dart';
import 'package:fire_alarm_app/utils/common_utils.dart';

abstract interface class RoomRepo {
  Future<Either<Failure, T?>> getListRoomByFloorId<T>(int? floorId);

  Future<Either<Failure, Map<String, dynamic>?>> updateRoomInformation<T>(RoomModel roomModel);

  Future<Either<Failure, Map<String, dynamic>?>> deleteRoomById<T>(int roomId);
}

const String API_FLOOR_BY_ROOM = '/api/rooms?floorId=';
const String API_ROOM = '/api/rooms/';
const String API_DELETE_ROOM = '/api/room/delete/';

class RoomRepoImpl extends RoomRepo {
  final _dioProvider = DioProvider();

  @override
  Future<Either<Failure, T?>> getListRoomByFloorId<T>(int? floorId) async {
    try {
      final Either<Failure, Response> response;
      if (floorId == null) {
        response = await _dioProvider.get(API_FLOOR_BY_ROOM);
      } else {
        response = await _dioProvider.get('$API_FLOOR_BY_ROOM$floorId');
      }
      return response.fold(
        (left) => Left(left),
        (right) => Right(right.data.cast<String, dynamic>()),
      );
    } catch (e) {
      return Left(UnknownException(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Map<String, dynamic>?>> updateRoomInformation<T>(RoomModel roomModel) async {
    try {
      Map<String, dynamic> map = {'name': roomModel.name};
      if (!Common.checkNullOrEmpty(roomModel.imageUrl)) {
        map['imageUrl'] = roomModel.imageUrl;
      }
      final response = await _dioProvider.put('$API_ROOM${roomModel.id}', data: map);
      return response.fold(
        (left) => Left(left),
        (right) => Right(right.data.cast<String, dynamic>()),
      );
    } catch (e) {
      return Left(UnknownException(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Map<String, dynamic>?>> deleteRoomById<T>(int roomId) async {
    try {
      final response = await _dioProvider.delete('$API_DELETE_ROOM$roomId');
      return response.fold(
        (left) => Left(left),
        (right) => Right(right.data.cast<String, dynamic>()),
      );
    } catch (e) {
      return Left(UnknownException(e.toString()));
    }
  }
}
