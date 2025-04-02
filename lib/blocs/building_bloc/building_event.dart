
import 'package:equatable/equatable.dart';
import 'package:fire_alarm_app/model/building_location_model.dart';

abstract class BuildingEvent extends Equatable{
  const BuildingEvent();
}

class GetListBuildingEvent extends BuildingEvent{
  @override
  List get props => [];
}

class AddBuildingEvent extends BuildingEvent{
  final String buildingName;
  final BuildingLocationModel buildingLocationModel;
  final String? buildingImage;

  const AddBuildingEvent({required this.buildingName, required this.buildingLocationModel, required this.buildingImage});

  @override
  List get props => [];
}

class UpdateBuildingEvent extends BuildingEvent{
  final int buildingId;
  final String buildingName;
  final BuildingLocationModel buildingLocationModel;
  final String? buildingImage;

  const UpdateBuildingEvent({required this.buildingId, required this.buildingName, required this.buildingLocationModel, required this.buildingImage});

  @override
  List get props => [];
}