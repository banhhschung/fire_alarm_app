
import 'package:equatable/equatable.dart';
import 'package:fire_alarm_app/model/notification_model.dart';

abstract class NotificationState extends Equatable{
  const NotificationState();

  @override
  List get props => [];
}

class InitialNotificationState extends NotificationState{
  @override
  List get props => [];
}

class GetListNotificationSuccessState extends NotificationState{
  final List<NotificationModel> listNotification;

  const GetListNotificationSuccessState({required this.listNotification});

  @override
  List get props => [listNotification];
}

class GetListNotificationFailedState extends NotificationState{

  @override
  List get props => [];
}