import 'dart:async';

import 'package:fire_alarm_app/blocs/location_bloc/location_event.dart';
import 'package:fire_alarm_app/blocs/location_bloc/location_state.dart';
import 'package:fire_alarm_app/commons/error.dart';
import 'package:fire_alarm_app/pages/tab_bar/setting/user_setting/user_building_setting/user_building_address_setting_page.dart';
import 'package:fire_alarm_app/repositories/location_repo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LocationBloc extends Bloc<LocationEvent, LocationState> {
  final LocationRepo _userLocationRepo = LocationRepoImpl();

  LocationBloc() : super(InitialLocationState()) {
    on<GetListProvinceLocationEvent>(_onGetListProvinceLocationEvent);
    on<GetListDistrictLocationEvent>(_onGetListDistrictLocationEvent);
  }

  void _onGetListProvinceLocationEvent(GetListProvinceLocationEvent event, Emitter<LocationState> emit) async {
    final response = await _userLocationRepo.getListProvince();
    response.fold(
      (left) {
        emit(GetListProvinceLocationFailState());
      },
      (right) {
        if (right != null && right['code'] == StatusCode.SUCCESS && right['data'] != null) {
          List<ProvinceModel> listProvinces = List<ProvinceModel>.from(right['data'].map((x) => ProvinceModel.fromJson(x)));
          if (listProvinces.isNotEmpty) {
            emit(GetListProvinceLocationSuccessState(listProvinceModel: listProvinces));
          } else {
            emit(GetListProvinceLocationFailState());
          }
        } else {
          emit(GetListProvinceLocationFailState());
        }
      },
    );
  }

  void _onGetListDistrictLocationEvent(GetListDistrictLocationEvent event, Emitter<LocationState> emit) async {
    final response = await _userLocationRepo.getListDistrictByProvince(event.provinceId);
    response.fold(
      (left) {
        emit(GetListDistrictLocationFailState());
      },
      (right) {
        if (right != null && right['code'] == StatusCode.SUCCESS && right['data'] != null) {
          List<DistrictModel> listDistrictModel = List<DistrictModel>.from(right['data'].map((x) => DistrictModel.fromJson(x)));
          if (listDistrictModel.isNotEmpty) {
            emit(GetListDistrictLocationSuccessState(listDistrictModel: listDistrictModel));
          } else {
            emit(GetListDistrictLocationFailState());
          }
        } else {
          emit(GetListDistrictLocationFailState());
        }
      },
    );
  }
}
