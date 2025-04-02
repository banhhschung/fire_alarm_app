
import 'package:fire_alarm_app/blocs/building_bloc/building_event.dart';
import 'package:fire_alarm_app/blocs/building_bloc/building_state.dart';
import 'package:fire_alarm_app/commons/error.dart';
import 'package:fire_alarm_app/model/building_model.dart';
import 'package:fire_alarm_app/provides/database_provider.dart';
import 'package:fire_alarm_app/repositories/building_repo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BuildingBloc extends Bloc<BuildingEvent, BuildingState> {
  final DatabaseHelper _databaseHelper = DatabaseHelper.instance;
  final BuildingRepo _homeRepo = BuildingRepoImpl();

  BuildingBloc() : super(InitialBuildingState()) {
    on<GetListBuildingEvent>(_onGetListBuildingEvent);
    on<AddBuildingEvent>(_onAddBuildingEvent);
    on<UpdateBuildingEvent>(_onUpdateBuildingEvent);
  }

  void _onGetListBuildingEvent(GetListBuildingEvent event, Emitter<BuildingState> emit) async {
    final response = await _homeRepo.getListBuildings();
    response.fold(
      (left) {
        emit(const GetListBuildingState(listBuildingModel: []));
      },
      (right) {
        if (right != null && right['code'] == StatusCode.SUCCESS && right['data'] != null) {
          List<BuildingModel> listBuildings = List<BuildingModel>.from(right['data'].map((x) => BuildingModel.fromJson(x)));
          if (listBuildings.isNotEmpty) {
            emit(GetListBuildingState(listBuildingModel: listBuildings));
          }
        } else {
          emit(const GetListBuildingState(listBuildingModel: []));
        }
      },
    );
  }

  void _onAddBuildingEvent(AddBuildingEvent event, Emitter<BuildingState> emit) async {
    final response = await _homeRepo.addBuilding(
        name: event.buildingName,
        imageUrl: event.buildingImage,
        address: event.buildingLocationModel.address,
        provinceCode: event.buildingLocationModel.provinceCode,
        provinceId: event.buildingLocationModel.provinceId,
        districtId: event.buildingLocationModel.districtId);
    response.fold(
      (left) {
        emit(AddBuildingFailState());
      },
      (right) async {
        if (right != null && right['code'] == StatusCode.SUCCESS && right['data'] != null) {
          BuildingModel buildingModel = BuildingModel.fromJson(right['data']);
          // await _databaseHelper.addOrUpdateBuilding(buildingModel);
          emit(AddBuildingSuccessState());
        } else {
          emit(AddBuildingFailState());
        }
      },
    );
  }

  void _onUpdateBuildingEvent(UpdateBuildingEvent event, Emitter<BuildingState> emit) async {
    final response = await _homeRepo.updateBuilding(event.buildingId,
        name: event.buildingName,
        imageUrl: event.buildingImage,
        address: event.buildingLocationModel.address,
        provinceCode: event.buildingLocationModel.provinceCode,
        provinceId: event.buildingLocationModel.provinceId,
        districtId: event.buildingLocationModel.districtId);

    response.fold(
      (left) async {
        emit(UpdateBuildingFailState());
      },
      (right) async {
        if (right != null && right['code'] == StatusCode.SUCCESS && right['data'] != null) {
          BuildingModel buildingModel = BuildingModel.fromJson(right['data']);
          // await _databaseHelper.addOrUpdateBuilding(buildingModel);
          emit(UpdateBuildingSuccessState());
        } else {
          emit(UpdateBuildingFailState());
        }
      },
    );
  }
}
