import 'dart:async';

import 'package:fire_alarm_app/blocs/notification_bloc/notification_event.dart';
import 'package:fire_alarm_app/blocs/notification_bloc/notification_state.dart';
import 'package:fire_alarm_app/commons/error.dart';
import 'package:fire_alarm_app/model/notification_model.dart';
import 'package:fire_alarm_app/repositories/notification_repo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class NotificationBloc extends Bloc<NotificationEvent, NotificationState> {
  final NotificationRepo _deviceRepo = NotificationRepoImpl();

  NotificationBloc() : super(InitialNotificationState()) {
    on<GetListNotificationEvent>(_onGetListNotificationEvent);
  }

  void _onGetListNotificationEvent(GetListNotificationEvent event, Emitter<NotificationState> emit) async {
    final response = await _deviceRepo.getListNotification(event.typeAlert, event.start, event.total);
    if (response.isLeft) {
      emit(GetListNotificationFailedState());
      return;
    }
    final data = response.right;
    if (data != null && data['code'] == StatusCode.SUCCESS && data['data'] != null) {
      List<NotificationModel> listNotify = List<NotificationModel>.from(data['data'].map((x) => NotificationModel.fromBackEndMap(x)));
      emit(GetListNotificationSuccessState(listNotification: listNotify));
    } else {
      emit(GetListNotificationFailedState());
    }
  }
}
