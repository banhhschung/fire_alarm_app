import 'dart:math';

import 'package:equatable/equatable.dart';
import 'package:fire_alarm_app/model/share_building_model.dart';

class ShareManagerState extends Equatable {
  @override
  List get props => [];
}

class InitialShareManagerState extends ShareManagerState {}

class GetListOfSharedAccountsSuccessState extends ShareManagerState {
  final List<ShareBuildingModel> listShareBuildingModel;

  GetListOfSharedAccountsSuccessState({required this.listShareBuildingModel});

  @override
  List get props => [Random().nextInt(9999)];
}

class GetListOfSharedAccountsFailState extends ShareManagerState {
  @override
  List get props => [Random().nextInt(9999)];
}

class AddShareAccountSuccessState extends ShareManagerState {
  @override
  List get props => [Random().nextInt(9999)];
}

class AddShareAccountFailState extends ShareManagerState {
  final int errorCode;

  AddShareAccountFailState({required this.errorCode});

  @override
  List get props => [Random().nextInt(9999)];
}

class RemoveBuildingShareAccountSuccessState extends ShareManagerState {
  @override
  List get props => [Random().nextInt(9999)];
}

class RemoveBuildingShareAccountFailState extends ShareManagerState {
  @override
  List get props => [Random().nextInt(9999)];
}

class UpdateBuildingShareAccountSuccessState extends ShareManagerState{
  @override
  List get props => [Random().nextInt(9999)];
}

class UpdateBuildingShareAccountFailState extends ShareManagerState{
  @override
  List get props => [Random().nextInt(9999)];
}
