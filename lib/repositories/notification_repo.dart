
import 'package:either_dart/either.dart';
import 'package:fire_alarm_app/commons/error.dart';
import 'package:fire_alarm_app/provides/dio_provider.dart';

abstract interface class NotificationRepo{
  Future<Either<Failure, Map<String, dynamic>?>> getListNotification<T>(int? typeAlert, int start, int total);
}

const String LOAD_ALERTS = '/api/report/devices/getHistoryAlert';

class NotificationRepoImpl extends NotificationRepo{

  final DioProvider _dioProvider = DioProvider();

  @override
  Future<Either<Failure, Map<String, dynamic>?>> getListNotification<T>(int? typeAlert, int start, int total) async {
    try {
      Map<String, dynamic> data;
      if (typeAlert != null) {
        data = {'typeAlert': typeAlert, 'start': start, 'total': total};
      } else {
        data = {'typeAlert': -1, 'start': start, 'total': total};
      }
      final response = await _dioProvider.get(LOAD_ALERTS, data: data);
      return response.fold(
            (left) => Left(left),
            (right) => Right(right.data.cast<String, dynamic>()),
      );
    } catch (e) {
      return Left(UnknownException(e.toString()));
    }
  }

}