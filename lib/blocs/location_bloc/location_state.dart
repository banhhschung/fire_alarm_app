import 'dart:math';

import 'package:equatable/equatable.dart';
import 'package:fire_alarm_app/pages/tab_bar/setting/user_setting/user_building_setting/user_building_address_setting_page.dart';

abstract class LocationState extends Equatable {
  const LocationState();

  @override
  List get props => [];
}

class InitialLocationState extends LocationState {}

class GetListProvinceLocationSuccessState extends LocationState{
  final List<ProvinceModel> listProvinceModel;

  const GetListProvinceLocationSuccessState({required this.listProvinceModel});
  @override
  List get props => [listProvinceModel, Random().nextInt(9999)];
}

class GetListProvinceLocationFailState extends LocationState{
  @override
  List get props => [Random().nextInt(9999)];
}

class GetListDistrictLocationSuccessState extends LocationState{
  final List<DistrictModel> listDistrictModel;

  const GetListDistrictLocationSuccessState({required this.listDistrictModel});
  @override
  List get props => [listDistrictModel, Random().nextInt(9999)];
}

class GetListDistrictLocationFailState extends LocationState{
  @override
  List get props => [Random().nextInt(9999)];
}
