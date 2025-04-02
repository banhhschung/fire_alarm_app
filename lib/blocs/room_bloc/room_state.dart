import 'dart:math';

import 'package:equatable/equatable.dart';
import 'package:fire_alarm_app/model/room_model.dart';

abstract class RoomState extends Equatable {
  const RoomState();
}

class InitialRoomState extends RoomState {
  @override
  List get props => [];
}

class GetListRoomByFloorIdState extends RoomState {
  final List<RoomModel> listRoomModels;

  const GetListRoomByFloorIdState({required this.listRoomModels});

  @override
  List get props => [];
}

class UpdateRoomInformationSuccessState extends RoomState {
  @override
  List get props => [Random().nextInt(9999)];
}

class UpdateRoomInformationFailState extends RoomState {
  @override
  List get props => [Random().nextInt(9999)];
}

class RemoveRoomByIdSuccessState extends RoomState {
  @override
  List get props => [Random().nextInt(9999)];
}

class RemoveRoomByIdFailState extends RoomState {
  @override
  List get props => [Random().nextInt(9999)];
}
