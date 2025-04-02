import 'dart:math';

import 'package:equatable/equatable.dart';
import 'package:fire_alarm_app/model/floor_model.dart';

abstract class FloorState extends Equatable {
  const FloorState();
}

class InitialFloorState extends FloorState {
  @override
  List get props => [];
}

class GetListFloorSuccessState extends FloorState {
  final List<FloorModel> listFloorModels;

  const GetListFloorSuccessState({required this.listFloorModels});

  @override
  List get props => [Random().nextInt(9999)];
}

class GetListFloorFailState extends FloorState {
  @override
  List get props => [];
}

class UpdateInformationFloorSuccessState extends FloorState {
  final FloorModel floorModel;

  const UpdateInformationFloorSuccessState({required this.floorModel});

  @override
  List get props => [];
}

class UpdateInformationFloorFailState extends FloorState {
  @override
  List get props => [];
}

class AddListFloorsSuccessState extends FloorState {
  @override
  List get props => [];
}

class AddListFloorsFailState extends FloorState {
  @override
  List get props => [];
}

class RemoveFloorSuccessState extends FloorState {
  @override
  List get props => [Random().nextInt(9999)];
}
class RemoveFloorFailState extends FloorState {
  @override
  List get props => [Random().nextInt(9999)];
}
