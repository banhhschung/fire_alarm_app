import 'dart:math';

import 'package:equatable/equatable.dart';
import 'package:fire_alarm_app/model/building_model.dart';

abstract class BuildingState extends Equatable {
  const BuildingState();
}

class InitialBuildingState extends BuildingState {
  @override
  List get props => [];
}

class GetListBuildingState extends BuildingState {
  final List<BuildingModel> listBuildingModel;

  const GetListBuildingState({required this.listBuildingModel});

  @override
  List get props => [listBuildingModel];
}

class AddBuildingSuccessState extends BuildingState {
  @override
  List get props => [];
}

class AddBuildingFailState extends BuildingState {
  @override
  List get props => [Random().nextInt(9999)];
}

class UpdateBuildingSuccessState extends BuildingState {
  @override
  List get props => [Random().nextInt(9999)];
}

class UpdateBuildingFailState extends BuildingState {
  @override
  List get props => [Random().nextInt(9999)];
}