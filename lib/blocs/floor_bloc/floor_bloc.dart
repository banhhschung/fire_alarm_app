import 'dart:async';

import 'package:fire_alarm_app/blocs/floor_bloc/floor_event.dart';
import 'package:fire_alarm_app/blocs/floor_bloc/floor_state.dart';
import 'package:fire_alarm_app/commons/error.dart';
import 'package:fire_alarm_app/model/floor_model.dart';
import 'package:fire_alarm_app/repositories/floor_repo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FloorBloc extends Bloc<FloorEvent, FloorState> {
  final FloorRepo _floorRepo = FloorRepoImpl();

  FloorBloc() : super(InitialFloorState()) {
    on<GetListFloorEvent>(_onGetListFloorEvent);
    on<UpdateInformationFloorEvent>(_onSaveInformationFloorEvent);
    on<AddListFloorsEvent>(_onAddListFloorsEvent);
    on<RemoveFloorEvent>(_onRemoveFloorEvent);
  }

  void _onGetListFloorEvent(GetListFloorEvent event, Emitter<FloorState> emit) async {
    final response = await _floorRepo.getListFloors();
    response.fold(
      (left) {
        emit(GetListFloorFailState());
      },
      (right) async {
        if (right != null && right['code'] == StatusCode.SUCCESS) {
          List<FloorModel> listFloor = List<FloorModel>.from(right['data'].map((x) => FloorModel.fromBackEndData(x)));
          emit(GetListFloorSuccessState(listFloorModels: listFloor));
        } else {
          emit(GetListFloorFailState());
        }
      },
    );
  }

  void _onSaveInformationFloorEvent(UpdateInformationFloorEvent event, Emitter<FloorState> emit) async {
    final response = await _floorRepo.updateFloorName(floorId: event.floorId, floorName: event.floorName);
    response.fold(
      (left) {
        emit(UpdateInformationFloorFailState());
      },
      (right) async {
        if (right != null && right['code'] == StatusCode.SUCCESS && right['data'] != null) {
          FloorModel floorModel = FloorModel.fromBackEndData(right['data']);
          // await _databaseHelper.updateFloor(floor);
          // await updateDeviceAndParamGroupFromFloor(event.floorId, event.floorName);
          emit(UpdateInformationFloorSuccessState(floorModel: floorModel));
        } else {
          emit(UpdateInformationFloorFailState());
        }
      },
    );
  }

  void _onAddListFloorsEvent(AddListFloorsEvent event, Emitter<FloorState> emit) async {
    final response = await _floorRepo.addListFloors(event.listFloor);
    response.fold(
      (left) {
        emit(AddListFloorsFailState());
      },
      (right) async {
        if (right != null && right['code'] == StatusCode.SUCCESS && right['data'] != null) {
          List<FloorModel> floors = List<FloorModel>.from(right['data'].map((x) => FloorModel.fromBackEndData(x)));
          /*if (floors.isNotEmpty) {
            await _databaseHelper.addListFloor(floors);
          }*/
          emit(AddListFloorsSuccessState());
        } else {
          emit(AddListFloorsFailState());
        }
      },
    );
  }

  void _onRemoveFloorEvent(RemoveFloorEvent event, Emitter<FloorState> emit) async {
    final response = await _floorRepo.removeFloor(event.floorId);
    response.fold(
      (left) {
        emit(RemoveFloorFailState());
      },
      (right) async {
        if (right != null && right['code'] == StatusCode.SUCCESS) {
          /*await _databaseHelper.deleteFloor(event.floorId);
          await deleteDeviceAndParamGroupFromFloor(event.floorId);*/
          emit(RemoveFloorSuccessState());
        } else {
          emit(RemoveFloorFailState());
        }
      },
    );
  }
}
