import 'package:either_dart/either.dart';
import 'package:fire_alarm_app/commons/error.dart';
import 'package:fire_alarm_app/provides/dio_provider.dart';

abstract interface class ShareManagerRepo {
  Future<Either<Failure, Map<String, dynamic>?>> getListOfSharedAccounts<T>();

  Future<Either<Failure, Map<String, dynamic>?>> addShareAccount<T>({required String uuid, required int type});

  Future<Either<Failure, Map<String, dynamic>?>> removeBuildingShareAccount<T>({int? userId});

  Future<Either<Failure, Map<String, dynamic>?>> updateBuildingShareAccount<T>({int? sharedId, int? expiredTime, int? type});
}

const String SHARE_MANAGER_PATH = "/api/homes/shares";

class ShareManagerRepoImpl extends ShareManagerRepo {
  final _dioProvider = DioProvider();

  @override
  Future<Either<Failure, Map<String, dynamic>?>> getListOfSharedAccounts<T>() async {
    try {
      final response = _dioProvider.get(SHARE_MANAGER_PATH);
      return response.fold(
        (left) => Left(left),
        (right) => Right(right.data.cast<String, dynamic>()),
      );
    } catch (e) {
      return Left(UnknownException(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Map<String, dynamic>?>> addShareAccount<T>({required String uuid, required int type}) async {
    try {
      Map<String, dynamic> data = {"uuid": uuid};
      data['type'] = type;
      final response = _dioProvider.post(SHARE_MANAGER_PATH, data: data);
      return response.fold(
        (left) => Left(left),
        (right) => Right(right.data.cast<String, dynamic>()),
      );
    } catch (e) {
      return Left(UnknownException(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Map<String, dynamic>?>> removeBuildingShareAccount<T>({int? userId}) async {
    try {
      final response = _dioProvider.delete('$SHARE_MANAGER_PATH/$userId');
      return response.fold(
        (left) => Left(left),
        (right) => Right(right.data.cast<String, dynamic>()),
      );
    } catch (e) {
      return Left(UnknownException(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Map<String, dynamic>?>> updateBuildingShareAccount<T>({int? sharedId, int? expiredTime, int? type}) async {
    try {
      Map<String, dynamic> data = {};
      if (expiredTime != null) {
        data['expiredTime'] = expiredTime;
      }
      if (type != null) {
        data['type'] = type;
      }
      final response = _dioProvider.put('$SHARE_MANAGER_PATH/$sharedId', data: data);
      return response.fold(
        (left) => Left(left),
        (right) => Right(right.data.cast<String, dynamic>()),
      );
    } catch (e) {
      return Left(UnknownException(e.toString()));
    }
  }
}
