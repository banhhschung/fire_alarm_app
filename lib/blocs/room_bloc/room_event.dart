import 'package:equatable/equatable.dart';
import 'package:fire_alarm_app/model/room_model.dart';

abstract class RoomEvent extends Equatable {
  const RoomEvent();
}

class GetListRoomsByFloorIdEvent extends RoomEvent {
  final int? floorId;

  const GetListRoomsByFloorIdEvent(this.floorId);

  @override
  List get props => [];
}

class UpdateRoomInformationEvent extends RoomEvent {
  final RoomModel roomModel;

  const UpdateRoomInformationEvent({required this.roomModel});

  @override
  List get props => [];
}

class RemoveRoomByIdEvent extends RoomEvent {
  final int roomId;

  const RemoveRoomByIdEvent({required this.roomId});

  @override
  List get props => [];
}
