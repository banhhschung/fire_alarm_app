import 'package:equatable/equatable.dart';
import 'package:fire_alarm_app/model/floor_model.dart';

abstract class FloorEvent extends Equatable {
  const FloorEvent();
}

class InitialFloorEvent extends FloorEvent {
  @override
  List get props => [];
}

class GetListFloorEvent extends FloorEvent {
  @override
  List get props => [];
}

class UpdateInformationFloorEvent extends FloorEvent {
  final int floorId;
  final String floorName;

  const UpdateInformationFloorEvent({required this.floorId, required this.floorName});

  @override
  List get props => [];
}

class AddListFloorsEvent extends FloorEvent {
  final List<FloorModel> listFloor;

  const AddListFloorsEvent({required this.listFloor});

  @override
  List get props => [];
}

class RemoveFloorEvent extends FloorEvent {
  final int floorId;

  const RemoveFloorEvent({required this.floorId});

  @override
  List get props => [];
}
