import 'package:equatable/equatable.dart';

abstract class NotificationEvent extends Equatable{
  const NotificationEvent();
  @override
  List get props => [];
}

class GetListNotificationEvent extends NotificationEvent {
  final int? typeAlert;
  final int start;
  final int total;

  const GetListNotificationEvent(this.typeAlert, this.start, this.total);

  @override
  List get props => [];
}