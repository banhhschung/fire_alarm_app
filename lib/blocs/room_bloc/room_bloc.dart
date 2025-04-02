import 'dart:async';

import 'package:fire_alarm_app/blocs/room_bloc/room_event.dart';
import 'package:fire_alarm_app/blocs/room_bloc/room_state.dart';
import 'package:fire_alarm_app/commons/error.dart';
import 'package:fire_alarm_app/model/room_model.dart';
import 'package:fire_alarm_app/repositories/room_repo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RoomBloc extends Bloc<RoomEvent, RoomState> {
  final RoomRepo _roomRepo = RoomRepoImpl();

  RoomBloc() : super(InitialRoomState()) {
    on<GetListRoomsByFloorIdEvent>(_onGetListRoomByFloorIdEvent);
    on<UpdateRoomInformationEvent>(_onUpdateInFormationRoomEvent);
    on<RemoveRoomByIdEvent>(_onRemoveRoomByIdEvent);
  }

  void _onGetListRoomByFloorIdEvent(GetListRoomsByFloorIdEvent event, Emitter<RoomState> emit) async {
    if (event.floorId == -1) {
      emit(const GetListRoomByFloorIdState(listRoomModels: []));
    } else {
      final response = await _roomRepo.getListRoomByFloorId(event.floorId);
      response.fold((left) {
        emit(const GetListRoomByFloorIdState(listRoomModels: []));
      }, (right) {
        if (right != null && right['code'] == StatusCode.SUCCESS && right['data'] != null) {
          List<RoomModel> listRoom = List<RoomModel>.from(right['data'].map((x) => RoomModel.fromBackEndData(x)));
          emit(GetListRoomByFloorIdState(listRoomModels: listRoom));
        } else {
          emit(const GetListRoomByFloorIdState(listRoomModels: []));
        }
      });
    }
  }

  void _onUpdateInFormationRoomEvent(UpdateRoomInformationEvent event, Emitter<RoomState> emit) async {
    final response = await _roomRepo.updateRoomInformation(event.roomModel);
    if (response.isLeft) {
      emit(UpdateRoomInformationFailState());
      return;
    }
    final data = response.right;
    if (data != null && data['code'] == StatusCode.SUCCESS) {
      // await _databaseHelper.updateRoom(event.room!);
      // await updateDeviceAndParamGroupFromRoom(event.room!.id, event.room!.name);
      emit(UpdateRoomInformationSuccessState());
    } else {
      emit(UpdateRoomInformationFailState());
    }
  }

  void _onRemoveRoomByIdEvent(RemoveRoomByIdEvent event, Emitter<RoomState> emit) async {
    final response = await _roomRepo.deleteRoomById(event.roomId);
    response.fold(
      (left) {
        emit(RemoveRoomByIdFailState());
      },
      (right) async {
        /*await _databaseHelper.deleteRoom(event.roomId!);
        await deleteDeviceAndParamGroupFromRoom(event.roomId!);*/
        emit(RemoveRoomByIdSuccessState());
      },
    );
  }
}
